//
//  QPPictureInPictureContext.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPPictureInPictureContext.h"
#import "QPPlayerController.h"
#import "QPPlaybackContext.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QPPictureInPictureContext () <AVPictureInPictureControllerDelegate>
@property (nonatomic, strong) AVPictureInPictureController *pipVC;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, strong) UIView *avPlayerLayerContainerView;
@property (nonatomic, assign) BOOL pipAlreadyStartedFlag;
@end

@implementation QPPictureInPictureContext

- (void)configPlayerModel:(QPPlayerModel *)model
{
    // 也可以将Model实现拷贝协议
    _playerModel = [[QPPlayerModel alloc] init];
    _playerModel.isLocalVideo = model.isLocalVideo;
    _playerModel.isZFPlayerPlayback = model.isZFPlayerPlayback;
    _playerModel.isIJKPlayerPlayback = model.isIJKPlayerPlayback;
    _playerModel.isMediaPlayerPlayback = model.isMediaPlayerPlayback;
    _playerModel.videoTitle = model.videoTitle;
    _playerModel.videoUrl = model.videoUrl;
    _playerModel.coverUrl = model.coverUrl;
    _playerModel.seekToTime = model.seekToTime;
}

#pragma mark - 画中画(PictureInPicture)

- (BOOL)isPictureInPictureValid
{
    return _pipVC != nil;
}

- (BOOL)isPictureInPicturePossible
{
    return [_pipVC isPictureInPicturePossible];
}

- (BOOL)isPictureInPictureActive
{
    return [_pipVC isPictureInPictureActive];
}

- (BOOL)isPictureInPictureSuspended
{
    return [_pipVC isPictureInPictureSuspended];
}

- (void)startPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled()) {
        [QPHudUtils showInfoMessage:@"请在设置中开启小窗播放功能！"];
        return;
    }
    // 设备是否支持画中画
    if (![AVPictureInPictureController isPictureInPictureSupported]) {
        [QPHudUtils showInfoMessage:@"当前设备不否支持画中画功能！"];
        return;
    }
    if (!_presenter || _pipVC) { return; }
    
    NSError *error = nil;
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    [AVAudioSession.sharedInstance setActive:YES error:&error];
    if (error) {
        QPLog(":: [AVAudioSession] 请求权限失败的原因 error=%@, %zi, %@"
              , error.domain
              , error.code
              , error.localizedDescription);
        return;
    }
    
    QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
    if (_playerModel.isMediaPlayerPlayback) {
        //KSYMediaPlayerManager *manager = (KSYMediaPlayerManager *)pt.player.currentPlayerManager;
        //AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] initWithLayer:manager.player.view.layer];
        //AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:playerLayer];
        //self.pipVC = pipVC;
    } else if (_playerModel.isIJKPlayerPlayback) {
        [self instantiateAvPlayerForIJKPlayer];
    } else {
        // _playerModel.isZFPlayerPlayback or others.
        ZFAVPlayerManager *manager = (ZFAVPlayerManager *)pt.player.currentPlayerManager;
        _playerModel.seekToTime = manager.currentTime;
        AVPlayerLayer *avPlayerLayer = manager.avPlayerLayer;
        AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:avPlayerLayer];
        self.pipVC = pipVC;
        [self startPipAfterDelay];
    }
}

- (void)startPipAfterDelay
{
    self.pipVC.delegate = self;
    [self delayToScheduleTask:2.0 completion:^{
        [self.pipVC startPictureInPicture];
    }];
}

- (void)stopPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    if (!_pipVC) { return; }
    [_pipVC stopPictureInPicture];
}

#pragma mark - ijkplayer

- (void)instantiateAvPlayerForIJKPlayer
{
    if (_avPlayer) { return; }
    QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
    ZFIJKPlayerManager *manager = (ZFIJKPlayerManager *)pt.player.currentPlayerManager;
    UIView *ijkContainerView = pt.player.containerView;
    UIView *superView = nil;
    if ([QPAppDelegate respondsToSelector:@selector(window)]) {
        superView = QPAppDelegate.window;
    } else if (ijkContainerView.window != nil) {
        superView = ijkContainerView.window;
    }
    
    // 将ijkplayer的frame转换为window的坐标体系
    CGRect ijkPlayerFrame = [superView convertRect:ijkContainerView.frame toView:superView];
    // 创建一个隐藏的AvPlayer
    _avPlayer = [[AVPlayer alloc] initWithURL:manager.assetURL];
    _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    
    // 将创建的player添加到window上
    _avPlayerLayerContainerView = [[UIView alloc] init];
    _avPlayerLayerContainerView.frame = ijkPlayerFrame;
    [superView addSubview:_avPlayerLayerContainerView];
    [_avPlayerLayerContainerView.layer addSublayer:_avPlayerLayer];
    _avPlayerLayer.frame = _avPlayerLayerContainerView.bounds;
    _avPlayerLayerContainerView.hidden = YES;
    
    // 将之前正在播放的ijkplayer暂停
    if(manager.isPlaying) {
        [manager pause];
    }
    _playerModel.seekToTime = manager.currentTime;
    
    // 只有ijkplayer进入才会有player
    [_avPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_avPlayer addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - destroy

- (void)destroy
{
    if (self.avPlayer) {
        [self.avPlayer removeObserver:self forKeyPath:@"status"];
        [self.avPlayer removeObserver:self forKeyPath:@"timeControlStatus"];
        [self.avPlayer pause];
        [self.avPlayerLayer removeFromSuperlayer];
        [self.avPlayerLayerContainerView removeFromSuperview];
        self.avPlayerLayerContainerView = nil;
        self.avPlayer = nil;
        self.avPlayerLayer = nil;
        self.pipAlreadyStartedFlag = NO;
    }
    self.pipVC = nil;
}

#pragma mark - Recover playback of original player

- (void)recoverPlaybackOfOriginalPlayer
{
    if (_presenter) {
        if (_avPlayer != nil) {
            // ijkplayer进入才需要恢复之前的播放时间
            NSTimeInterval currentPlayTime = CMTimeGetSeconds(_avPlayer.currentTime);
            _playerModel.seekToTime = currentPlayTime;
            QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
            @weakify(self)
            [pt.player seekToTime:currentPlayTime completionHandler:^(BOOL finished) {
                @strongify(self)
                QPPlayerPresenter *inPt = (QPPlayerPresenter *)self.presenter;
                if (self.avPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
                    [inPt.player.currentPlayerManager play];
                } else if (self.avPlayer.timeControlStatus == AVPlayerTimeControlStatusPaused) {
                    [inPt.player.currentPlayerManager play];
                    [inPt.player.currentPlayerManager pause];
                }
                // 销毁内容
                [self destroy];
            }];
        } else {
            // 如果是ZFPlayer的avplayer，则不做处理。
        }
    } else {
        // 销毁内容
        [self destroy];
    }
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: 即将开启画中画功能.");
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: 已经开启画中画功能.");
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: 即将停止画中画功能.");
    [self recoverPlaybackOfOriginalPlayer];
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: 已经停止画中画功能.");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error
{
    QPLog(":: 开启画中画功能失败. error=%@.", error);
    NSString *message = [NSString stringWithFormat:@"开启画中画失败(code=%zi, msg=%@)"
                         , error.code
                         , error.localizedDescription];
    [QPHudUtils showErrorMessage:message];
    [self destroy];
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    // 点击右上角，将画中画恢复成原生播放。
    Float64 seconds = CMTimeGetSeconds(_avPlayer.currentTime);
    QPLog(":: 画中画功能恢复成原生播放，currentTime: %.2f", seconds);
    if (!_presenter) {
        [self destroy];
        if (seconds > 0) {
            _playerModel.seekToTime = seconds;
        }
        QPPlaybackContext *context = QPPlaybackContext.alloc.init;
        [context playVideoWithModel:_playerModel];
    } else {
        [self recoverPlaybackOfOriginalPlayer];
    }
    completionHandler(YES);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        [self observeAVPlayerStatusChangeChange:change ofObject:object];
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
        [self observeAVPlayerTimeStatusChange:change ofObject:object];
    }
}

#pragma mark - player status change

- (void)observeAVPlayerStatusChangeChange:(NSDictionary<NSString *,id> *)change ofObject:(id)object
{
    switch (_avPlayer.status) {
        case AVPlayerStatusUnknown: {
            QPLog(@":: 未知状态，此时不能播放");
            break;
        }
        case AVPlayerStatusReadyToPlay: {
            QPLog(@":: 准备完毕，可以播放");
            [self syncPlaybackTimeOfOriginalPlayer];
            //_avPlayer.volume = 0.0;
            //_avPlayer.muted = YES;
            [_avPlayer play];
            break;
        }
        case AVPlayerStatusFailed: {
            AVPlayerItem *item = (AVPlayerItem *)object;
            QPLog(@":: 加载异常 error=%@", item.error);
            [self destroy];
            break;
        }
        default: break;
    }
}

- (void)observeAVPlayerTimeStatusChange:(NSDictionary<NSString *,id> *)change ofObject:(id)object
{
    if (@available(iOS 10.0, *)) {}
    else {
        [self destroy];
        return;
    }
    if (_avPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        // 这个可能会多次回调，所以判断一下，防止多次调用[self setupPip]
        if (!_pipAlreadyStartedFlag) {
            // 真正开始播放时候再seek一下, 使播放点更准确
            BOOL failed = [self syncPlaybackTimeOfOriginalPlayer];
            if (!failed) {
                // 等player开始播放后再开启pip
                [self setupPip];
                _pipAlreadyStartedFlag = YES;
            }
        }
    }
}

- (BOOL)syncPlaybackTimeOfOriginalPlayer
{
    // 获取当前创建的avplayer的时间
    int32_t timeScale = _avPlayer.currentItem.asset.duration.timescale;
    NSTimeInterval currentPlayTime;
    if (_presenter) {
        QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
        currentPlayTime = pt.player.currentTime;
    } else {
        currentPlayTime = _playerModel.seekToTime;
    }
    Float64 seekTo = currentPlayTime; // 真正开始画中画 大概在2秒之后
    CMTime time = CMTimeMakeWithSeconds(seekTo, timeScale);
    BOOL ret = NO;
    @try {
        // 将播放器的播放时间与原始ijkplayer的播放地方同步
        [_avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    } @catch (NSException *exception) {
        QPLog(@":: exception=%@", exception);
        ret = YES;
    }
    return ret;
}

- (void)setupPip
{
    AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.avPlayerLayer];
    self.pipVC = pipVC;
    // 要有延迟，否则可能开启不成功
    [self startPipAfterDelay];
}

@end

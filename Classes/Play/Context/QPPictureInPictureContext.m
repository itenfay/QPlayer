//
//  QPPictureInPictureContext.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPPictureInPictureContext.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QPPlayerController.h"
#import "QPPlaybackContext.h"
#import "EasyPlayer.h"

@interface QPPictureInPictureContext () <AVPictureInPictureControllerDelegate, EasyPlayerDelegate>
@property (nonatomic, strong) AVPictureInPictureController *pipVC;
@property (nonatomic, strong) EasyPlayer *player;
@property (nonatomic, assign) BOOL pipAlreadyStarted;
@property (nonatomic, assign) NSInteger avRetryCountToPlay;
@end

@implementation QPPictureInPictureContext

#pragma mark - Config PlayerModel

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
        [QPHudUtils showInfoMessage:@"当前设备不支持小窗播放功能！"];
        return;
    }
    if (!_presenter || _pipVC) { return; }
    if (!QPActiveAudioSession(YES)) {
        [QPHudUtils showErrorMessage:@"AudioSession出错啦~，不能小窗播放！"];
    }
    // _playerModel.isZFPlayerPlayback or others.
    if (_playerModel.isIJKPlayerPlayback ||
        _playerModel.isMediaPlayerPlayback) {
        _avRetryCountToPlay = 3;
        [self instantiateAVPlayer];
    } else {
        QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
        ZFAVPlayerManager *manager = (ZFAVPlayerManager *)pt.player.currentPlayerManager;
        _playerModel.seekToTime = manager.currentTime;
        AVPlayerLayer *avPlayerLayer = manager.avPlayerLayer;
        AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:avPlayerLayer];
        self.pipVC = pipVC;
        [self delayToStartPip];
    }
}

- (QPPlayerController *)playerVC {
    if (_presenter) {
        QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
        return (QPPlayerController *)pt.viewController;
    }
    return nil;
}

- (void)delayToStartPip
{
    QP_After_Dispatch(2.0, ^{
        [self.playerVC showOverlayLayer];
        [self.pipVC startPictureInPicture];
    });
}

- (void)stopPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    if (!_pipVC) { return; }
    [_pipVC stopPictureInPicture];
}

- (void)retryToPlay
{
    if (_avRetryCountToPlay <= 0) {
        _avRetryCountToPlay = 3;
        [QPHudUtils showErrorMessage:@"出错啦~，不能小窗播放！"];
        [self reset];
        return;
    }
    [self reset];
    _avRetryCountToPlay--;
    QP_After_Dispatch(0.5, ^{
        [self instantiateAVPlayer];
    });
}

#pragma mark - ijkplayer & KSYMediaPlayer

- (void)instantiateAVPlayer
{
    QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
    // 全屏不创建avplayer
    if (pt.player.orientationObserver.isFullScreen) {
        [QPHudUtils showErrorMessage:@"全屏不能小窗播放啦！"];
        return;
    }
    
    UIView *containerView = pt.player.containerView;
    UIView *superView = nil;
    if ([QPAppDelegate respondsToSelector:@selector(window)]) {
        superView = QPAppDelegate.window;
    } else if (containerView.window != nil) {
        superView = containerView.window;
    }
    
    // 将ijkplayer的frame转换为window的坐标体系
    CGRect playerFrame = [superView convertRect:containerView.frame toView:superView];
    // 创建一个隐藏的AvPlayer
    id<ZFPlayerMediaPlayback> manager = pt.player.currentPlayerManager;
    
    self.player = [EasyPlayer playerWithURL:manager.assetURL];
    self.player.delegate = self;
    [self.player showInView:superView withFrame:playerFrame];
    [self.player hidePlayerFrame:YES];
    
    if (manager.isPlaying) {
        [manager pause];
    }
    _playerModel.seekToTime = manager.currentTime;
}

#pragma mark - reset

- (void)reset
{
    [self.playerVC hideOverlayLayer];
    self.player = nil;
    self.pipAlreadyStarted = NO;
    self.pipVC = nil;
}

#pragma mark - Recover playback

- (void)recoverPlay
{
    if (!_presenter) {
        [self reset];
        return;
    }
    if (self.player != nil) {
        // ijkplayer进入才需要恢复之前的播放时间
        NSTimeInterval currentTime = CMTimeGetSeconds(self.player.player.currentTime);
        _playerModel.seekToTime = currentTime;
        if (currentTime > 0) {
            QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
            [pt seekToTime:currentTime completionHandler:^(BOOL finished) {
                [self handleControlStatus];
                [self reset];
            }];
        } else {
            [self handleControlStatus];
            [self reset];
        }
    } else {
        // 如果是ZFPlayer的avplayer，则不做处理进度和状态。
        [self reset];
    }
}

- (void)handleControlStatus {
    QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
    if (self.player.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [pt.player.currentPlayerManager play];
    } else if (self.player.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        [pt.player.currentPlayerManager play];
        [pt.player.currentPlayerManager pause];
    }
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("即将开启画中画功能.");
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("已经开启画中画功能.");
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("即将停止画中画功能.");
    [self recoverPlay];
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("已经停止画中画功能.");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error
{
    QPLog("开启画中画功能失败. error=%@.", error);
    [QPHudUtils showErrorMessage:@"出错啦~，不能小窗播放！"];
    [self reset];
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    // 点击右上角，将画中画恢复成原生播放。
    Float64 seconds = CMTimeGetSeconds(self.player.player.currentTime);
    QPLog("画中画功能恢复成原生播放，currentTime: %.2f", seconds);
    if (!_presenter) {
        [self reset];
        if (seconds > 0) {
            _playerModel.seekToTime = seconds;
        }
        QPPlaybackContext *context = QPPlaybackContext.alloc.init;
        [context playVideoWithModel:_playerModel];
    } else {
        [self recoverPlay];
    }
    completionHandler(YES);
}

#pragma mark - EasyPlayerDelegate

- (void)playerReadyToPlay:(EasyPlayer *)player {
    //self.player.volume = 0;
    //self.player.muted = YES;
}

- (void)player:(EasyPlayer *)player didFailWithError:(NSError *)error {
    QPLog(@"加载失败 error=%@", error);
    [self retryToPlay];
}

- (void)player:(EasyPlayer *)player currentSeconds:(float)currentSeconds totalSeconds:(float)totalSeconds {
    QPLog(@"[Progress] currentSeconds=%.2f, totalSeconds=%.2f", currentSeconds, totalSeconds);
    // 多次回调，加个判断，防止多次调用[self setupPipController]
    if (!_pipAlreadyStarted) {
        // 同步原始播放器播放时间, 使播放更准确
        BOOL success = [self syncPlayTime];
        // 多调用一次，减少同步播放时间失败率
        if (success) {
            _pipAlreadyStarted = YES;
            [self setupPipController];
        }
    }
}

- (void)player:(EasyPlayer *)player loadedBuffer:(float)buffer duration:(float)duration {
    QPLog(@"[Load] loadedBuffer=%.2f, duration=%.2f", buffer, duration);
    QPLog(@"[Load] current=%@, total=%@", [player formatMediaTime:buffer], [player formatMediaTime:duration]);
}

- (BOOL)syncPlayTime {
    NSTimeInterval currentTime = _presenter ? ({
        QPPlayerPresenter *pt = (QPPlayerPresenter *)_presenter;
        pt.player.currentTime;
    }) : _playerModel.seekToTime;
    Float64 seekTo = currentTime;
    if (seekTo > 0) {
        @try {
            // 将播放器的播放时间与原始player的播放时间进行同步
            [self.player seekToTime:seekTo];
        } @catch (NSException *exception) {
            QPLog(@"exception=%@", exception);
            return NO;
        }
    }
    return YES;
}

- (void)setupPipController {
    AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.player.playerLayer];
    self.pipVC = pipVC;
    self.pipVC.delegate = self;
    // 要有延迟，否则可能开启不成功
    [self delayToStartPip];
}

@end

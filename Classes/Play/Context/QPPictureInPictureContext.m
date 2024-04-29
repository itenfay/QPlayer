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
@property (nonatomic, strong) QPPlayerModel *playerModel;
@property (nonatomic, strong) AVPictureInPictureController *pipVC;
@property (nonatomic, strong) EasyPlayer *player;
@property (nonatomic, assign) BOOL pipRealStarting;
@end

@implementation QPPictureInPictureContext

#pragma mark - Config PlayerModel

- (void)configPlayerModel:(QPPlayerModel *)model
{
    // The model confirms to the `NSCopying` protocol.
    self.playerModel = [[QPPlayerModel alloc] init];
    self.playerModel.isLocalVideo = model.isLocalVideo;
    self.playerModel.isZFPlayerPlayback = model.isZFPlayerPlayback;
    self.playerModel.isIJKPlayerPlayback = model.isIJKPlayerPlayback;
    self.playerModel.isMediaPlayerPlayback = model.isMediaPlayerPlayback;
    self.playerModel.videoTitle = model.videoTitle;
    self.playerModel.videoUrl = model.videoUrl;
    self.playerModel.coverUrl = model.coverUrl;
    self.playerModel.seekToTime = model.seekToTime;
}

#pragma mark - 画中画(PictureInPicture)

- (BOOL)isPictureInPictureValid
{
    return self.pipVC != nil;
}

- (BOOL)isPictureInPicturePossible
{
    return [self.pipVC isPictureInPicturePossible];
}

- (BOOL)isPictureInPictureActive
{
    return [self.pipVC isPictureInPictureActive];
}

- (BOOL)isPictureInPictureSuspended
{
    return [self.pipVC isPictureInPictureSuspended];
}

- (void)check
{
    if (self.player && !self.pipVC) {
        [self reset];
    }
}

- (void)startPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled()) {
        [QPHudUtils showInfoMessage:@"请在设置中开启小窗播放！"];
        return;
    }
    // 设备是否支持画中画
    if (![AVPictureInPictureController isPictureInPictureSupported]) {
        [QPHudUtils showInfoMessage:@"当前设备不支持小窗播放！"];
        return;
    }
    
    if (!self.presenter || self.pipVC) { return; }
    if (self.pipRealStarting) { return; }
    
    if (!QPActiveAudioSession(YES)) {
        [QPHudUtils showErrorMessage:@"AudioSession出错啦~，不能小窗播放！"];
    }
    
    // self.playerModel.isZFPlayerPlayback or others.
    if (self.playerModel.isIJKPlayerPlayback ||
        self.playerModel.isMediaPlayerPlayback ||
        self.playerModel.isZFPlayerPlayback) {
        //self.retryCountToPlay = 3;
        [self instantiateAVPlayer];
    } else {
        // To other user interface, release zfplayer.
        //QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
        //ZFAVPlayerManager *manager = (ZFAVPlayerManager *)pt.player.currentPlayerManager;
        //self.playerModel.seekToTime = manager.currentTime;
        //AVPlayerLayer *avPlayerLayer = manager.avPlayerLayer;
        //AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:avPlayerLayer];
        //self.pipVC = pipVC;
        //[self prepareForPipAfterDelay:2.0];
    }
    self.pipRealStarting = YES;
}

- (QPPlayerController *)playerVC
{
    if (self.presenter) {
        QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
        return (QPPlayerController *)pt.viewController;
    }
    return nil;
}

- (void)prepareForPipAfterDelay:(NSTimeInterval)timeInterval
{
    self.pipVC.delegate = self;
    QP_After_Dispatch(timeInterval, ^{
        self.pipRealStarting = NO;
        [self.pipVC startPictureInPicture];
    });
}

- (void)stopPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    if (!self.pipVC) { return; }
    [self.pipVC stopPictureInPicture];
}

#pragma mark - ijkplayer & KSYMediaPlayer

- (void)instantiateAVPlayer
{
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    // 全屏不创建avplayer
    if (pt.player.orientationObserver.isFullScreen) {
        [QPHudUtils showErrorMessage:@"全屏不能小窗播放啦！"];
        return;
    }
    // Player已经实例化了，直接返回
    if (self.player) {
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
    id<ZFPlayerMediaPlayback> manager = pt.player.currentPlayerManager;
    
    // 创建一个隐藏的AvPlayer
    self.player = [EasyPlayer playerWithURL:manager.assetURL];
    self.player.delegate = self;
    [self.player showInView:superView withFrame:playerFrame];
    [self.player hidePlayerFrame:YES];
    
    if (manager.isPlaying) {
        [manager pause];
    }
    self.playerModel.seekToTime = manager.currentTime;
    [self.playerVC showOverlayLayer];
}

#pragma mark - Check

#pragma mark - Reset

- (void)reset
{
    [self.playerVC hideOverlayLayer];
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    self.pipRealStarting = NO;
    [self.pipVC stopPictureInPicture];
    self.pipVC = nil;
}

#pragma mark - Recover playback

- (void)recoverPlayer
{
    if (!self.player) {
        return;
    }
    // ijkplayer进入才需要恢复之前的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.player.currentTime);
    self.playerModel.seekToTime = currentTime;
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if (currentTime > 0 && pt) {
        [pt seekToTime:currentTime completionHandler:^(BOOL finished) {
            if (finished) {
                [self _recorver];
            }
        }];
    } else {
        [self _recorver];
    }
}

- (void)_recorver {
    QP_Run_OnMainThread(^{
        [self _handleControlStatus];
        [self reset];
    });
}

- (void)_handleControlStatus {
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if (!pt) return;
    if (self.player.isPlaying) {
        [pt.player.currentPlayerManager play];
    } else {
        [pt.player.currentPlayerManager pause];
    }
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("[I] The controller will start picture in picture.");
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("[I] The controller did start picture in picture.");
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("[I] The controller will stop picture in picture.");
    [self recoverPlayer];
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog("[I] The controller did stop picture in picture.");
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error
{
    QPLog("[E] error=%@.", error);
    [QPHudUtils showErrorMessage:@"出错啦~，不能小窗播放！"];
    [self reset];
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    QPLog("[I] restores user interface.");
    // 点击右上角，将画中画恢复成原生播放。
    if (!self.presenter) {
        [self reset];
        Float64 seconds = CMTimeGetSeconds(self.player.player.currentTime);
        if (seconds > 0) {
            self.playerModel.seekToTime = seconds;
        }
        QPPlaybackContext *context = QPPlaybackContext.alloc.init;
        [context playVideoWithModel:self.playerModel];
    } else {
        [self recoverPlayer];
    }
    completionHandler(YES);
}

#pragma mark - EasyPlayerDelegate

- (void)playerReadyToPlay:(EasyPlayer *)player {
    //self.player.volume = 0;
    //self.player.muted = YES;
    // 再次判断原播放器是否正在播放，如果在播放就暂停播放。
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    id<ZFPlayerMediaPlayback> currPlayerManager = pt.player.currentPlayerManager;
    if (currPlayerManager.isPlaying) {
        [currPlayerManager pause];
        self.playerModel.seekToTime = currPlayerManager.currentTime;
    }
    [self syncPlayTime];
}

- (void)player:(EasyPlayer *)player didFailWithError:(NSError *)error {
    QPLog(@"[E] error=%@", error);
    [QPHudUtils showErrorMessage:@"出错啦~，不能小窗播放！"];
    [self reset];
}

- (void)player:(EasyPlayer *)player currentSeconds:(float)currentSeconds totalSeconds:(float)totalSeconds {
    QPLog(@"[I] [Progress] currentSeconds=%.2f, totalSeconds=%.2f", currentSeconds, totalSeconds);
}

- (void)player:(EasyPlayer *)player loadedBuffer:(float)buffer duration:(float)duration {
    QPLog(@"[I] [Load] loadedBuffer=%.2f, duration=%.2f", buffer, duration);
    QPLog(@"[I] [Load] current=%@, total=%@", [player formatMediaTime:buffer], [player formatMediaTime:duration]);
}

- (void)syncPlayTime {
    NSTimeInterval currentTime = self.presenter ? ({
        QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
        pt.player.currentTime;
    }) : self.playerModel.seekToTime;
    Float64 seekTo = currentTime;
    if (seekTo > 0) {
        @QPWeakify(self);
        // 将播放器的播放时间与原始player的播放时间进行同步
        [self.player seekToTime:seekTo completionHandler:^(BOOL finished) {
            [weak_self _handleCallbckForSeekingToTime:finished];
        }];
    }
}

- (void)_handleCallbckForSeekingToTime:(BOOL)finished {
    if (finished) {
        QP_Run_OnMainThread(^{
            [self _setupPipController];
        });
    } else {
        QP_After_Dispatch(1.0, ^{
            [self syncPlayTime];
        });
    }
}

- (void)_setupPipController {
    AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.player.playerLayer];
    self.pipVC = pipVC;
    // 要有延迟，否则可能开启不成功
    [self prepareForPipAfterDelay:2.0];
}

@end

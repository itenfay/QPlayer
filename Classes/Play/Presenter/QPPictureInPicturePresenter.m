//
//  QPPictureInPicturePresenter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPPictureInPicturePresenter.h"
#import "QPPlayerController.h"
#import "QPPlaybackContext.h"

@interface QPPictureInPicturePresenter () <AVPictureInPictureControllerDelegate>
@property (nonatomic, strong) AVPictureInPictureController *pipVC;
@end

@implementation QPPictureInPicturePresenter

- (void)setViewController:(QPBaseViewController *)viewController
{
    _viewController = viewController;
    [self configPlayerModel];
}

- (void)configPlayerModel
{
    // 也可以将Model实现拷贝协议
    QPPlayerController *vc = (QPPlayerController *)_viewController;
    _playerModel = [[QPPlayerModel alloc] init];
    _playerModel.isLocalVideo = vc.model.isLocalVideo;
    _playerModel.isZFPlayerPlayback = vc.model.isZFPlayerPlayback;
    _playerModel.isIJKPlayerPlayback = vc.model.isIJKPlayerPlayback;
    _playerModel.isMediaPlayerPlayback = vc.model.isMediaPlayerPlayback;
    _playerModel.videoTitle = vc.model.videoTitle;
    _playerModel.videoUrl = vc.model.videoUrl;
    _playerModel.coverUrl = vc.model.coverUrl;
    _playerModel.seekToTime = vc.model.seekToTime;
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

- (void)startPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    // 设备是否支持画中画
    if (![AVPictureInPictureController isPictureInPictureSupported])
        return;
    if (!_viewController) { return; }
    QPPlayerController *vc = (QPPlayerController *)_viewController;
    QPPlayerPresenter *pt = (QPPlayerPresenter *)vc.presenter;
    if (vc.model.isZFPlayerPlayback) {
        ZFAVPlayerManager *manager = (ZFAVPlayerManager *)pt.player.currentPlayerManager;
        AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] initWithLayer:manager.view.playerView.layer];
        AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:playerLayer];
        self.pipVC = pipVC;
    } else if (vc.model.isMediaPlayerPlayback) {
        //KSYMediaPlayerManager *manager = (KSYMediaPlayerManager *)pt.player.currentPlayerManager;
        //AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] initWithLayer:manager.view.playerView.layer];
        //AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:playerLayer];
        //self.pipVC = pipVC;
    } else if (vc.model.isIJKPlayerPlayback) {
        ZFIJKPlayerManager *manager = (ZFIJKPlayerManager *)pt.player.currentPlayerManager;
        AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] initWithLayer:manager.view.playerView.layer];
        AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:playerLayer];
        self.pipVC = pipVC;
    }
    if (self.pipVC == nil) { return; }
    self.pipVC.delegate = self;
    @try {
        NSError *error = nil;
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
        [AVAudioSession.sharedInstance setActive:YES error:&error];
    } @catch (NSException *exception) {
        QPLog(":: [AVAudioSession] exception=%@, %@, %@"
              , exception.name
              , exception.callStackSymbols
              , exception.callStackReturnAddresses);
    } @finally {}
    [self.pipVC startPictureInPicture];
}

- (void)stopPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    if (!self.pipVC) { return; }
    [self.pipVC stopPictureInPicture];
    self.pipVC = nil;
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: WillStartPictureInPicture.");
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: DidStartPictureInPicture.");
}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: WillStopPictureInPicture.");
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController
{
    QPLog(":: DidStopPictureInPicture.");
    self.pipVC = nil;
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error
{
    QPLog(":: FailedToStartPictureInPicture. error=%@.", error);
    NSString *message = [NSString stringWithFormat:@"画中画开启失败(code=%zi, msg=%@)"
                         , error.code
                         , error.localizedDescription];
    [QPHudUtils showErrorMessage:message];
    self.pipVC = nil;
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler
{
    QPLog(":: restoreUserInterface.");
    if (!_viewController) {
        _playerModel.seekToTime = _currentTime;
        QPPlaybackContext *context = QPPlaybackContext.alloc.init;
        [context playVideoWithModel:_playerModel];
    }
    completionHandler(YES);
}

@end

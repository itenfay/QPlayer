//
//  QPPlaybackContext.m
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPPlaybackContext.h"
#import "QPPlayerController.h"

@interface QPPlaybackContext ()

@end

@implementation QPPlaybackContext

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString
{
    [self playVideoWithTitle:title urlString:urlString playerType:QPPlayerTypeZFPlayer];
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type
{
    [self playVideoWithTitle:title urlString:urlString playerType:type seekToTime:0];
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type seekToTime:(NSTimeInterval)time
{
    if (!QPPlayerIsPlaying() && QPDetermineWhetherToPlay()) {
        QPPictureInPictureContext *ctx = QPAppDelegate.pipContext;
        if ([ctx isPictureInPictureValid]) {
            [ctx stopPictureInPicture];
        }
        QPPlayerSavePlaying(YES);
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
            QPPlayerModel *model = [[QPPlayerModel alloc] init];
            model.isLocalVideo   = NO;
            model.videoTitle     = title;
            model.videoUrl       = urlString;
            switch (type) {
                case QPPlayerTypeZFPlayer:
                    model.isZFPlayerPlayback = YES;
                    break;
                case QPPlayerTypeIJKPlayer:
                    model.isIJKPlayerPlayback = YES;
                    break;
                case QPPlayerTypeKSYMediaPlayer:
                    model.isMediaPlayerPlayback = YES;
                    break;
                default:
                    model.isZFPlayerPlayback = YES;
                    break;
            }
            if (time > 0) {
                model.seekToTime = time;
            }
            QPPlayerController *qpc = [[QPPlayerController alloc] initWithModel:model];
            [self.yf_currentViewController.navigationController pushViewController:qpc animated:YES];
        }];
    } else {
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
        }];
    }
}

- (void)playVideoWithModel:(QPPlayerModel *)model
{
    if (!QPPlayerIsPlaying() && QPDetermineWhetherToPlay()) {
        QPPictureInPictureContext *ctx = QPAppDelegate.pipContext;
        if ([ctx isPictureInPictureValid]) {
            [ctx stopPictureInPicture];
        }
        QPPlayerSavePlaying(YES);
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
            QPPlayerModel *playerModel = [[QPPlayerModel alloc] init];
            playerModel.isLocalVideo = model.isLocalVideo;
            playerModel.videoTitle   = model.videoTitle;
            playerModel.videoUrl     = model.videoUrl;
            playerModel.coverUrl     = model.coverUrl;
            playerModel.isZFPlayerPlayback = model.isZFPlayerPlayback;
            playerModel.isIJKPlayerPlayback = model.isIJKPlayerPlayback;
            playerModel.isMediaPlayerPlayback = model.isMediaPlayerPlayback;
            playerModel.seekToTime = model.seekToTime;
            QPPlayerController *playerVC = [[QPPlayerController alloc] initWithModel:playerModel];
            playerVC.hidesBottomBarWhenPushed = YES;
            [self.yf_currentNavigationController pushViewController:playerVC animated:YES];
        }];
    } else {
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
        }];
    }
}

@end

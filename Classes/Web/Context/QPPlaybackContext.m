//
//  QPPlaybackContext.m
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPPlaybackContext.h"

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
        QPPictureInPicturePresenter *pt = QPAppDelegate.pipPresenter;
        if ([pt isPictureInPictureValid]) {
            [pt stopPictureInPicture];
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
        [self delayToScheduleTask:1.0 completion:^{ [QPHudUtils hideHUD]; }];
    }
}

- (void)playVideoWithModel:(QPPlayerModel *)model
{
    if (!QPPlayerIsPlaying() && QPDetermineWhetherToPlay()) {
        QPPictureInPicturePresenter *pt = QPAppDelegate.pipPresenter;
        if ([pt isPictureInPictureValid]) {
            [pt stopPictureInPicture];
        }
        QPPlayerSavePlaying(YES);
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
            QPPlayerModel *_model = [[QPPlayerModel alloc] init];
            _model.isLocalVideo = model.isLocalVideo;
            _model.videoTitle   = model.videoTitle;
            _model.videoUrl     = model.videoUrl;
            _model.coverUrl     = model.coverUrl;
            _model.isZFPlayerPlayback = model.isZFPlayerPlayback;
            _model.isIJKPlayerPlayback = model.isIJKPlayerPlayback;
            _model.isMediaPlayerPlayback = model.isMediaPlayerPlayback;
            _model.seekToTime = model.seekToTime;
            QPPlayerController *qpc = [[QPPlayerController alloc] initWithModel:_model];
            [self.yf_currentViewController.navigationController pushViewController:qpc animated:YES];
        }];
    } else {
        [self delayToScheduleTask:1.0 completion:^{ [QPHudUtils hideHUD]; }];
    }
}

@end

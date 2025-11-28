//
//  QPPlaybackContext.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/9.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPPlaybackContext.h"
#import "QPPlayerController.h"

@interface QPPlaybackContext ()

@end

@implementation QPPlaybackContext

- (void)playVideoWithTitle:(NSString *)title
                 urlString:(NSString *)urlString
{
    [self playVideoWithTitle:title urlString:urlString playerType:QPPlayerTypeZFPlayer];
}

- (void)playVideoWithTitle:(NSString *)title
                 urlString:(NSString *)urlString
                playerType:(QPPlayerType)type
{
    [self playVideoWithTitle:title urlString:urlString playerType:type seekToTime:0];
}

- (void)playVideoWithTitle:(NSString *)title
                 urlString:(NSString *)urlString
                playerType:(QPPlayerType)type
                seekToTime:(NSTimeInterval)time
{
    if (!QPPlayerIsPlaying() && QPDetermineWhetherToPlay()) {
        QPPictureInPictureContext *ctx = QPAppDelegate.pipContext;
        if ([ctx isPictureInPictureValid]) {
            [ctx reset];
        }
        QPPlayerSavePlaying(YES);
        QP_After_Dispatch(1.0, ^{
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
            QPPlayerController *playerVC = [[QPPlayerController alloc] initWithModel:model];
            UINavigationController *navController = self.tf_currentViewController.navigationController;
            if (navController) { [navController pushViewController:playerVC animated:YES]; };
        });
    } else {
        QP_After_Dispatch(1.0, ^{
            [QPHudUtils hideHUD];
        });
    }
}

- (void)playVideoWithModel:(QPPlayerModel *)model
{
    if (!QPPlayerIsPlaying() && QPDetermineWhetherToPlay()) {
        QPPictureInPictureContext *ctx = QPAppDelegate.pipContext;
        if ([ctx isPictureInPictureValid]) {
            [ctx reset];
        }
        QPPlayerSavePlaying(YES);
        QP_After_Dispatch(1.0, ^{
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
            UINavigationController *navController = self.tf_currentNavigationController;
            if (navController) { [navController pushViewController:playerVC animated:YES]; }
        });
    } else {
        QP_After_Dispatch(1.0, ^{
            [QPHudUtils hideHUD];
        });
    }
}

@end

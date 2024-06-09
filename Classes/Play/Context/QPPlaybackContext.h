//
//  QPPlaybackContext.h
//  QPlayer
//
//  Created by Tenfay on 2023/3/9.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "BaseContext.h"

typedef NS_ENUM(NSUInteger, QPPlayerType) {
    QPPlayerTypeZFPlayer, // zfplayer
    QPPlayerTypeIJKPlayer, // ijkplayer
    QPPlayerTypeKSYMediaPlayer, // ksymediaplayer
};

@class QPPlayerModel;

@interface QPPlaybackContext : BaseContext

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type seekToTime:(NSTimeInterval)time;
- (void)playVideoWithModel:(QPPlayerModel *)model;

@end

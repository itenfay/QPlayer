//
//  QPPlaybackContext.h
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBaseContext.h"

typedef NS_ENUM(NSUInteger, QPPlayerType) {
    QPPlayerTypeZFPlayer,
    QPPlayerTypeIJKPlayer,
    QPPlayerTypeKSYMediaPlayer,
};

@class QPPlayerModel;

@interface QPPlaybackContext : QPBaseContext

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type seekToTime:(NSTimeInterval)time;
- (void)playVideoWithModel:(QPPlayerModel *)model;

@end

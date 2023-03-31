//
//  QPPlayerModel.h
//  QPlayer
//
//  Created by chenxing on 2023/3/3.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPPlayerModel : QPBaseModel

/// Whether play the local video.
@property (nonatomic, assign) BOOL isLocalVideo;

/// Whether the ZFPlayer play back.
@property (nonatomic, assign) BOOL isZFPlayerPlayback;

/// Whether the ijkplayer play back.
@property (nonatomic, assign) BOOL isIJKPlayerPlayback;

/// Whether the media player play back.
@property (nonatomic, assign) BOOL isMediaPlayerPlayback;

/// The name for a video.
@property (nonatomic, copy) NSString *videoTitle;

/// The url for a video.
@property (nonatomic, copy) NSString *videoUrl;

/// The cover url for a video.
@property (nonatomic, copy) NSString *coverUrl;

/// The time to seek for a video.
@property (nonatomic, assign) NSTimeInterval seekToTime;

@end

NS_ASSUME_NONNULL_END

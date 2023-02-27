//
//  QPlayerController.h
//  QPlayer
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseViewController.h"

@interface QPlayerController : QPBaseViewController

// Whether play the local video.
@property (nonatomic, assign) BOOL isLocalVideo;

// Whether the ZFPlayer play back.
@property (nonatomic, assign) BOOL isZFPlayerPlayback;

// Whether the ijkplayer play back.
@property (nonatomic, assign) BOOL isIJKPlayerPlayback;

// Whether the media player play back.
@property (nonatomic, assign) BOOL isMediaPlayerPlayback;

// The url for a video.
@property (nonatomic, copy) NSString *videoUrl;

// The name for a video.
@property (nonatomic, copy) NSString *videoTitle;

// The cover url for a video.
@property (nonatomic, copy) NSString *coverUrl;

// The placeholder cover image for a video.
@property (nonatomic, strong) UIImage *placeholderCoverImage;

// The decoding for a video. 0: soft decoding, 1: hard decoding.
@property (nonatomic, assign) int videoDecoding;

@end

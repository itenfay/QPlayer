//
//  UIViewController+DYFAdd.m
//
//  Created by dyf on 2016/1/10. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2016 dyf. All rights reserved.
//

#import "UIViewController+DYFAdd.h"

@implementation UIViewController (DYFAdd)

- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height))yf_videoThumbnailImage {
    
    UIImage *(^ThumbnailBlock)(NSURL *url, NSTimeInterval seekTime, int width, int height) = ^UIImage *(NSURL *url, NSTimeInterval seekTime, int width, int height) {
        
#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
        KSYMediaInfoProber *prober = [[KSYMediaInfoProber alloc] initWithContentURL:url];
        UIImage *img = [prober getVideoThumbnailImageAtTime:seekTime width:width height:height];
        return img ?: QPImageNamed(@"default_thumbnail");
#else
        return nil;
#endif
        
    };
    
    return ThumbnailBlock;
}

- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate))yf_videoThumbnailImageX {
    
    UIImage *(^ThumbnailBlock)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate) = ^UIImage *(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate) {
        
#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
        KSYMediaInfoProber *prober = [[KSYMediaInfoProber alloc] initWithContentURL:url];
        UIImage *img = [prober getVideoThumbnailImageAtTime:seekTime width:width height:height accurate:accurate];
        return img ?: QPImageNamed(@"default_thumbnail");
#else
        return nil;
#endif
        
    };
    
    return ThumbnailBlock;
}

- (int (^)(NSURL *url))yf_videoDuration {
    
    int (^VideoDurationBlock)(NSURL *url) = ^int (NSURL *url) {
        
#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
        KSYMediaInfoProber *prober = [[KSYMediaInfoProber alloc] initWithContentURL:url];
        return (int)prober.ksyMediaInfo.duration;
#else
        return 0;
#endif
        
    };
    
    return VideoDurationBlock;
}

@end

//
//  NSObject+QPAdditions.m
//
//  Created by chenxing on 2015/6/18.
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "NSObject+QPAdditions.h"
#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
#import <KSYMediaPlayer/KSYMediaInfoProber.h>
#endif

@implementation NSObject (QPAdditions)

- (BOOL)isNull
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    } else {
        if ([self isKindOfClass:[NSNull class]]) {
            return YES;
        } else {
            if (self == nil) {
                return YES;
            }
        }
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"(null)"]) {
            return YES;
        }
    }
    return NO;
}

- (void)delayToScheduleTask:(NSTimeInterval)seconds completion:(void (^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        !completion ?: completion();
    });
}

- (void (^)(id target, SEL selector, id object, NSTimeInterval delayInSeconds))scheduleTask
{
    void (^taskBlock)(id target, SEL selector, id object, NSTimeInterval delayInSeconds)
    = ^(id target, SEL selector, id object, NSTimeInterval delayInSeconds) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (delayInSeconds > 0) {
            [target performSelector:selector withObject:object afterDelay:delayInSeconds];
        } else {
            [target performSelector:selector withObject:object];
        }
#pragma clang diagnostic pop
    };
    return taskBlock;
}

- (void (^)(id target, SEL selector, id object))cancelPerformingSelector
{
    void (^cancelBlock)(id target, SEL selector, id object) = ^(id target,
                                                                SEL selector,
                                                                id object) {
        [NSObject cancelPreviousPerformRequestsWithTarget:target
                                                 selector:selector
                                                   object:object];
    };
    return cancelBlock;
}

- (UIImage *)colorImage:(CGRect)rect cornerRadius:(CGFloat)cornerRadius backgroudColor:(UIColor *)backgroudColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *newImage  = nil;
    CGRect mRect       = rect;
    CGSize mSize       = mRect.size;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mRect cornerRadius:cornerRadius];
    
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:mSize];
        newImage = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            UIGraphicsImageRendererContext *ctx = rendererContext;
            CGContextSetFillColorWithColor  (ctx.CGContext, backgroudColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx.CGContext, borderColor.CGColor);
            CGContextSetLineWidth           (ctx.CGContext, borderWidth);
            [path addClip];
            CGContextAddPath (ctx.CGContext, path.CGPath);
            CGContextDrawPath(ctx.CGContext, kCGPathFillStroke);
        }];
    } else {
        UIGraphicsBeginImageContext(mSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor  (context, backgroudColor.CGColor);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth           (context, borderWidth);
        [path addClip];
        CGContextAddPath (context, path.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height))yf_videoThumbnailImage
{
    UIImage *(^ThumbnailBlock)(NSURL *url, NSTimeInterval seekTime, int width, int height)
    = ^UIImage *(NSURL *url, NSTimeInterval seekTime, int width, int height) {
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

- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate))yf_videoThumbnailImageX
{
    UIImage *(^ThumbnailBlock)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate)
    = ^UIImage *(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate) {
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

- (int (^)(NSURL *url))yf_videoDuration
{
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

- (UIImage *)xc:(NSString *)name  {
    UIImage *image = QPImageNamed(name);
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return newImage;
}

@end

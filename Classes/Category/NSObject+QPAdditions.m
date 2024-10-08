//
//  NSObject+QPAdditions.m
//
//  Created by Tenfay on 2015/6/18.
//  Copyright (c) 2015 Tenfay. All rights reserved.
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

- (void)delayToScheduleTask:(NSTimeInterval)timeInterval completion:(void (^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        !completion ?: completion();
    });
}

- (void (^)(id target, SEL selector, id object, NSTimeInterval timeInterval))scheduleTask
{
    void (^taskBlock)(id target, SEL selector, id object, NSTimeInterval timeInterval)
    = ^(id target, SEL selector, id object, NSTimeInterval timeInterval) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (timeInterval > 0) {
            [target performSelector:selector withObject:object afterDelay:timeInterval];
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

- (UIImage *)colorImage:(CGRect)rect
           cornerRadius:(CGFloat)cornerRadius
         backgroudColor:(UIColor *)backgroudColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
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

// Returns a new image with a specified image, corner radius, border width and border color.
- (UIImage *)clipImage:(UIImage *)image
          cornerRadius:(CGFloat)cornerRadius
           borderWidth:(CGFloat)borderWidth
           borderColor:(UIColor *)borderColor
{
    UIColor *bgColor = [UIColor colorWithPatternImage:image];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    return [self colorImage:rect cornerRadius:cornerRadius backgroudColor:bgColor borderWidth:borderWidth borderColor:borderColor];
}

- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height))tf_videoThumbnailImage
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

- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate))tf_videoThumbnailImageX
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

- (int (^)(NSURL *url))tf_videoDuration
{
    // int (^VideoDurationBlock)(NSURL *url) = ...;
    // return VideoDurationBlock;
    return ^int (NSURL *aURL) {
        #if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
        KSYMediaInfoProber *prober = [[KSYMediaInfoProber alloc] initWithContentURL:url];
        return (int)prober.ksyMediaInfo.duration;
        #else
        // 计算视频长度（秒）
        // 网络地址
        //NSURL *sourceURL = [NSURL URLWithString:urlString];
        // 本地文件
        //NSURL *sourceURL = [NSURL fileURLWithPath:filePath];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:aURL options:opts];
        CMTime time = [asset duration];
        int seconds = ceil(time.value/time.timescale);
        return seconds;
        #endif
    };
}

- (void)tf_takeThumbnailWithURL:(NSURL *)aURL completionHandler:(void (^)(UIImage *))completionHandler
{
    [self tf_takeThumbnailWithURL:aURL forTime:0.3 completionHandler:completionHandler];
}

- (void)tf_takeThumbnailWithURL:(NSURL *)aURL forTime:(Float64)time completionHandler:(void (^)(UIImage *))completionHandler
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset.alloc initWithURL:aURL options:opts];
    NSParameterAssert(asset); // 断言
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CMTime requestedTime = CMTimeMakeWithSeconds(time, 1);
    if (@available(iOS 16.0, *)) {
        [generator generateCGImageAsynchronouslyForTime:requestedTime completionHandler:^(CGImageRef _Nullable imageRef, CMTime actualTime, NSError * _Nullable error) {
            if (error) {
                QPLog("[Error] err=%zi, %@", error.code, error.localizedDescription);
            }
            if (completionHandler) {
                completionHandler(imageRef ? [UIImage.alloc initWithCGImage:imageRef] : nil);
            }
        }];
    } else {
        NSError *error = nil;
        CGImageRef imageRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&error];
        if (error) {
            QPLog("[Error] err=%zi, %@", error.code, error.localizedDescription);
        }
        if (completionHandler) {
            completionHandler(imageRef ? [UIImage.alloc initWithCGImage:imageRef] : nil);
        }
    }
}

- (UIImage *)tf_imageRenderingAlwaysTemplate:(NSString *)name
{
    UIImage *image = QPImageNamed(name);
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (UIImage *(^)(UIImage *image))tf_originalImage
{
    UIImage *(^block)(UIImage *image) = ^UIImage *(UIImage *image) {
        UIImageRenderingMode imgRenderingMode = UIImageRenderingModeAlwaysOriginal;
        return [image imageWithRenderingMode:imgRenderingMode];
    };
    return block;
}

- (UIImage *)tf_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    return [self tf_imageWithColor:color rect:rect];
}

- (UIImage *)tf_imageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)tf_drawImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage withRect:(CGRect)rect
{
    [backgroundImage drawInRect:rect];
    CGFloat fgw = foregroundImage.size.width;
    CGFloat fgh = foregroundImage.size.height;
    CGFloat fgx = (rect.size.width  - fgw)/2;
    CGFloat fgy = (rect.size.height - fgh)/2;
    [foregroundImage drawInRect:CGRectMake(fgx, fgy, fgw, fgh)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)tf_drawImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage withRect:(CGRect)rect atPoint:(CGPoint)point
{
    [backgroundImage drawInRect:rect];
    CGFloat fgw = foregroundImage.size.width;
    CGFloat fgh = foregroundImage.size.height;
    [foregroundImage drawInRect:CGRectMake(point.x, point.y, fgw, fgh)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSArray<UIWindow *> *)tf_activeWindows
{
    UIApplication *sharedApp = UIApplication.sharedApplication;
    if (@available(iOS 13.0, *)) {
        NSMutableArray<UIWindowScene *> *sceneArray = [NSMutableArray arrayWithCapacity:0];
        for (UIScene *scene in sharedApp.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:UIWindowScene.class]) {
                [sceneArray addObject:(UIWindowScene *)scene];
            }
        }
        UIWindowScene *scene = sceneArray.firstObject;
        return scene.windows;
    } else {
        return sharedApp.windows;
    }
}

- (UIWindow *)tf_mainWindow
{
    UIWindow *window;
    NSMutableArray<UIWindow *> *mWindows = [NSMutableArray arrayWithCapacity:0];
    NSArray<UIWindow *> *tWindows = [self tf_activeWindows];
    for (UIWindow *w in tWindows) {
        if (w.isKeyWindow) { [mWindows addObject:w]; }
    }
    window = mWindows.firstObject;
    return window;
}

- (UINavigationController *)tf_currentNavigationController
{
    return self.tf_currentViewController.navigationController;
}

- (UIViewController *)tf_currentViewController
{
    UIWindow *window = [self tf_mainWindow];
    return [self tf_queryCurrentViewControllerFrom:window.rootViewController];
}

- (UIViewController *)tf_queryCurrentViewControllerFrom:(UIViewController *)viewController
{
    UIViewController *vc = viewController;
    while (1) {
        if ([vc isKindOfClass:UITabBarController.class]) {
            vc = ((UITabBarController *)vc).selectedViewController;
        } else if ([vc isKindOfClass:UINavigationController.class]) {
            vc = ((UINavigationController *)vc).visibleViewController;
        } else if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            if (vc.childViewControllers.count > 0) {
                vc = vc.childViewControllers.lastObject;
            }
            break;
        }
    }
    return vc;
}

@end

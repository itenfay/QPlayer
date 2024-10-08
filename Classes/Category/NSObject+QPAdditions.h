//
//  NSObject+QPAdditions.h
//
//  Created by Tenfay on 2015/6/18.
//  Copyright (c) 2015 Tenfay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QPAdditions)

// Whether an object is null.
- (BOOL)isNull;

// Schedules a block for execution on a given queue at a specified time.
- (void)delayToScheduleTask:(NSTimeInterval)seconds completion:(void (^)(void))completion;

// Return a block with a target object, a selector, an object and a specified time, it schedules a task.
- (void (^)(id target, SEL selector, id object, NSTimeInterval delayInSeconds))scheduleTask;

// Return a block with a target object, a selector and an object, it cancels an execution selector.
- (void (^)(id target, SEL selector, id object))cancelPerformingSelector;

// Returns an image with a specified frame, corner radius, background color, border width and border color.
- (UIImage *)colorImage:(CGRect)rect
           cornerRadius:(CGFloat)cornerRadius
         backgroudColor:(UIColor *)backgroudColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor;

// Returns a new image with a specified image, corner radius, border width and border color.
- (UIImage *)clipImage:(UIImage *)image
          cornerRadius:(CGFloat)cornerRadius
           borderWidth:(CGFloat)borderWidth
           borderColor:(UIColor *)borderColor;
/**
 获取视频缩略图
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @param seekTime 指定的时间位置，单位为s, 小于0时无法截图
 @param width 缩略图的宽度
 @param height 缩略图的高度
 @return 返回UIImage对象的Block，执行即可得到缩略图
 */
- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height))tf_videoThumbnailImage;

/**
 精准获取视频缩略图
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @param seekTime 指定的时间位置，单位为s, 小于0时无法截图
 @param width 缩略图的宽度
 @param height 缩略图的高度
 @param accurate 指定是否使用精准获取缩略图
 @return 返回UIImage对象的Block，执行即可得到缩略图
 */
- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate))tf_videoThumbnailImageX;

/**
 获取视频总时长，单位是秒
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @return 返回int的Block，执行即可得到视频总时长
 */
- (int (^)(NSURL *url))tf_videoDuration;

- (void)tf_takeThumbnailWithURL:(NSURL *)aURL completionHandler:(void(^)(UIImage *))completionHandler;
- (void)tf_takeThumbnailWithURL:(NSURL *)aURL forTime:(Float64)time completionHandler:(void(^)(UIImage *))completionHandler;

/// Returns a new version of the image that uses always template mode.
- (UIImage *)tf_imageRenderingAlwaysTemplate:(NSString *)name;
- (UIImage *(^)(UIImage *image))tf_originalImage;

- (UIImage *)tf_imageWithColor:(UIColor *)color;
- (UIImage *)tf_imageWithColor:(UIColor *)color rect:(CGRect)rect;
- (UIImage *)tf_drawImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage withRect:(CGRect)rect;
- (UIImage *)tf_drawImage:(UIImage *)foregroundImage inBackgroundImage:(UIImage *)backgroundImage withRect:(CGRect)rect atPoint:(CGPoint)point;

- (NSArray<UIWindow *> *)tf_activeWindows;
/// Returns a main window.
- (UIWindow *)tf_mainWindow;

/// Returns the current navigation controller.
- (UINavigationController *)tf_currentNavigationController;

/// Returns the current view controller.
- (UIViewController *)tf_currentViewController;

/// Queries and returns the current view controller from the specified view controller.
- (UIViewController *)tf_queryCurrentViewControllerFrom:(UIViewController *)viewController;

@end

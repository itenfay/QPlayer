//
//  NSObject+QPAdditions.h
//
//  Created by chenxing on 2015/6/18.
//  Copyright (c) 2015 chenxing. All rights reserved.
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

/**
 获取视频缩略图
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @param seekTime 指定的时间位置，单位为s, 小于0时无法截图
 @param width 缩略图的宽度
 @param height 缩略图的高度
 @return 返回UIImage对象的Block，执行即可得到缩略图
 */
- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height))yf_videoThumbnailImage;

/**
 精准获取视频缩略图
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @param seekTime 指定的时间位置，单位为s, 小于0时无法截图
 @param width 缩略图的宽度
 @param height 缩略图的高度
 @param accurate 指定是否使用精准获取缩略图
 @return 返回UIImage对象的Block，执行即可得到缩略图
 */
- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate))yf_videoThumbnailImageX;

/**
 获取视频总时长，单位是秒
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @return 返回int的Block，执行即可得到视频总时长
 */
- (int (^)(NSURL *url))yf_videoDuration;

- (UIImage *)yf_supplyVideoCover:(NSString *)url;

/// Returns a new version of the image that uses always template mode.
- (UIImage *)yf_imageRenderingAlwaysTemplate:(NSString *)name;
- (UIImage *(^)(UIImage *image))yf_originalImage;

- (UIImage *)yf_imageWithColor:(UIColor *)color;
- (UIImage *)yf_imageWithColor:(UIColor *)color rect:(CGRect)rect;
- (UIImage *)yf_drawImage:(UIImage *)foregroundImage inBackgroundColor:(UIColor *)backgroundColor backgroundRect:(CGRect)rect;
- (UIImage *)yf_drawImage:(UIImage *)foregroundImage inBackgroundColor:(UIColor *)backgroundColor backgroundRect:(CGRect)rect atPoint:(CGPoint)point;

- (NSArray<UIWindow *> *)yf_activeWindows;
/// Returns a main window.
- (UIWindow *)yf_mainWindow;

/// Returns a current view controller.
- (UIViewController *)yf_currentViewController;

/// Queries and returns a current view controller from a view controller.
- (UIViewController *)yf_queryCurrentViewControllerFrom:(UIViewController *)viewController;

@end

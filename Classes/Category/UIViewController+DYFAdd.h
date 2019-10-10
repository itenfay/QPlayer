//
//  UIViewController+DYFAdd.h
//
//  Created by dyf on 2016/1/10.
//  Copyright © 2016 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<KSYMediaPlayer/KSYMediaPlayer.h>)
#import <KSYMediaPlayer/KSYMediaInfoProber.h>
#endif

@interface UIViewController (DYFAdd)

/**
 @abstract 获取视频缩略图
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @param seekTime 指定的时间位置，单位为s, 小于0时无法截图
 @param width 缩略图的宽度
 @param height 缩略图的高度
 @return 返回UIImage对象的Block，执行即可得到缩略图
 */
- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height))yf_videoThumbnailImage;

/**
 @abstract 精准获取视频缩略图
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @param seekTime 指定的时间位置，单位为s, 小于0时无法截图
 @param width 缩略图的宽度
 @param height 缩略图的高度
 @param accurate 指定是否使用精准获取缩略图
 @return 返回UIImage对象的Block，执行即可得到缩略图
 */
- (UIImage *(^)(NSURL *url, NSTimeInterval seekTime, int width, int height, BOOL accurate))yf_videoThumbnailImageX;

/**
 @abstract 获取视频总时长，单位是秒
 @param url 待探测格式的文件地址，该地址可以是本地地址或者服务器地址
 @return 返回int的Block，执行即可得到视频总时长
 */
- (int (^)(NSURL *url))yf_videoDuration;

@end

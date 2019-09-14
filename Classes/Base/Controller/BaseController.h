//
//  BaseController.h
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController <UIWebViewDelegate>

// 设置导航条显示/隐藏
- (void)setNavigationBarHidden:(BOOL)hidden;

// 导航返回按钮
- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector;

// 懒加载
- (UIWebView *)webView;
- (UIWebView *)layoutWebViewWithFrame:(CGRect)frame;

// 将进度条添加网页上
- (void)setProgressViewAddedToWebView;
// 将进度条添加导航条上
- (void)setProgressViewAddedToNavigationBar;
// 移除进度条
- (void)removeProgressView;

// 加载网页内容
- (void)loadWebContents:(NSString *)urlString;

// 加载网页请求
- (void)loadWebUrlRequest:(NSURLRequest *)urlRequest;

// 移除 cell.contentView 所有子视图
- (void)removeCellAllSubviews:(UITableViewCell *)cell;

// 自定义 toob bar
- (UIImageView *)buildCustomToolBar:(SEL)selector;

// 获取纯图像
- (UIImage *)pureImage:(CGRect)rect cornerRadius:(CGFloat)cornerRadius backgroudColor:(UIColor *)backgroudColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

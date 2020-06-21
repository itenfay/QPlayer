//
//  BaseViewController.h
//
//  Created by dyf on 2017/6/28. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

//###############################################################

#import <UIKit/UIKit.h>

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import <WebKit/WebKit.h>

#import "DYFWebProgressView.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

#import "DYFNetworkSniffer.h"

//###############################################################

@interface BaseViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

// The property determines whether the parsing button is required.
@property (nonatomic, assign) BOOL parsingButtonRequired;

// The property determines whether The dark interface style was truned on.
@property (nonatomic, assign) BOOL isDarkMode;

// Posts a notification when network reachability changes.
- (void)monitorNetworkChangesWithSelector:(SEL)selector;
// Removes a notification for changes in network reachability status.
- (void)stopMonitoringNetworkChanges;

// Adds manual theme style change observer.
- (void)addManualThemeStyleObserver;
// Removes manual theme style change observer.
- (void)removeManualThemeStyleObserver;
// Adjusts theme style when the notification is received.
- (void)adjustThemeStyle;

// Sets up a navigation bar whether it is hidden.
- (void)setNavigationBarHidden:(BOOL)hidden;

// Return a back button with a target and selector.
- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector;

// Return a navigation bar.
- (UINavigationBar *)navigationBar;

// A collection of properties used to initialize a web view.
- (WKWebViewConfiguration *)wk_webViewConfiguration;

// Initializes a web view with a specified frame.
- (void)initWebViewWithFrame:(CGRect)frame;

// Initializes a web view with a specified frame and configuration.
- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;

// Returns a web view.
- (WKWebView *)webView;

// Adds a progress view to a web view.
- (void)willAddProgressViewToWebView;
// Adds a progress view to a navigation bar.
- (void)willAddProgressViewToNavigationBar;

// Removes a progress view.
- (void)removeProgressView;

// Navigates to the back item in the back-forward list.
- (void)onGoBack;
// Navigates to the forward item in the back-forward list.
- (void)onGoForward;
// Reloads the current page.
- (void)onReload;
// Stops loading all resources on the current page.
- (void)onStopLoading;

// Releases a web view.
- (void)releaseWebView;

// Loads the contents of a web.
- (void)loadWebContents:(NSString *)urlString;
// Loads web url request.
- (void)loadWebUrlRequest:(NSURLRequest *)urlRequest;

// Removes the all subviews for cell's contentView.
- (void)removeCellAllSubviews:(UITableViewCell *)cell;

// Builds the custom tool bar.
- (UIImageView *)buildCustomToolBar;
// Builds the custom tool bar with a selector.
- (UIImageView *)buildCustomToolBar:(SEL)selector;

// Returns an image with a specified frame, corner radius,
// background color, border width and border color.
- (UIImage *)colorImage:(CGRect)rect
           cornerRadius:(CGFloat)cornerRadius
         backgroudColor:(UIColor *)backgroudColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor;

// Return a string that uses to show the duration of a video.
- (NSString *)formatVideoDuration:(int)duration;

// Returns total display time.
- (NSString *)totalTimeForVideo:(NSURL *)aUrl;

// Returns a thumbnail with a specific url.
- (UIImage *)thumbnailForVideo:(NSURL *)aUrl;

// Returns a new string made from the receiver by replacing all characters not in the allowedCharacters set with percent encoded characters. UTF-8 encoding is used to determine the correct percent encoded characters.
- (NSString *)urlEncode:(NSString *)string;

// Returns a new string made from the receiver by replacing all percent encoded sequences with the matching UTF-8 characters.
- (NSString *)urlDecode:(NSString *)string;

// Schedules a block for execution on a given queue at a specified time.
- (void)delayToScheduleTask:(NSTimeInterval)seconds completion:(void (^)(void))completion;

// Return a block with a target object, a selector, an object and a specified time, it schedules a task.
- (void (^)(id target, SEL selector, id object, NSTimeInterval delayInSeconds))scheduleTask;

// Return a block with a target object, a selector and an object, it cancels an execution selector.
- (void (^)(id target, SEL selector, id object))cancelPerformingSelector;

@end

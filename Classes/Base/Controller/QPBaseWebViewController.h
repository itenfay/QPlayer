//
//  QPBaseWebViewController.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import "QPBaseViewController.h"
#import "DYFWebProgressView.h"
#import "DYFNetworkSniffer.h"

@interface QPBaseWebViewController : QPBaseViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, assign) BOOL isAddedToNavBar;

// A collection of properties used to initialize a web view.
- (WKWebViewConfiguration *)wkWebViewConfiguration;

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

@end

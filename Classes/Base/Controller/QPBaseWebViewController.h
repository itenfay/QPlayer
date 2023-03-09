//
//  QPBaseWebViewController.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QPBaseViewController.h"
#import "QPWKWebViewAdapter.h"

@interface QPBaseWebViewController : QPBaseViewController

@property (nonatomic, strong) QPWKWebViewAdapter *adapter;

/// A collection of properties used to initialize a web view.
- (WKWebViewConfiguration *)webViewConfiguration;
/// An object for managing interactions between JavaScript code and your web view, and for filtering content in your web view.
- (WKUserContentController *)userContentController;

/// Initializes a web view with a specified frame.
- (void)initWebViewWithFrame:(CGRect)frame;
/// Initializes a web view with a specified frame and configuration.
- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;
/// Initializes a web view with a specified frame, configuration and adapter.
- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration adapter:(QPWKWebViewAdapter *)adapter;

/// Returns a web view.
- (WKWebView *)webView;
/// Releases a web view.
- (void)releaseWebView;

/// Navigates to the back item in the back-forward list.
- (void)onGoBack;
/// Navigates to the forward item in the back-forward list.
- (void)onGoForward;
/// Reloads the current page.
- (void)onReload;
/// Stops loading all resources on the current page.
- (void)onStopLoading;

/// Loads the contents of a web.
- (void)loadRequestWithUrl:(NSString *)urlString;
/// Loads web with url request.
- (void)loadRequest:(NSURLRequest *)urlRequest;

/// Builds a tool bar.
- (UIImageView *)buildToolBar;
/// Builds a tool bar with a selector.
- (UIImageView *)buildToolBar:(SEL)selector;
/// Builds a vertical tool bar.
- (UIImageView *)buildVerticalToolBar;
/// Builds a vertical tool bar with a selector.
- (UIImageView *)buildVerticalToolBar:(SEL)selector;

@end

//
//  QPBaseWebViewController.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QPBaseViewController.h"
#import "DYFWebProgressView.h"
#import "DYFNetworkSniffer.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@interface QPBaseWebViewController : QPBaseViewController <WKNavigationDelegate, WKUIDelegate>

/// Wether a progress bar is added to the navigation bar.
@property (nonatomic, assign, readonly) BOOL isAddedToNavBar;

/// A collection of properties used to initialize a web view.
- (WKWebViewConfiguration *)webViewConfiguration;
/// An object for managing interactions between JavaScript code and your web view, and for filtering content in your web view.
- (WKUserContentController *)userContentController;

/// Initializes a web view with a specified frame.
- (void)initWebViewWithFrame:(CGRect)frame;

/// Initializes a web view with a specified frame and configuration.
- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;

/// Returns a web view.
- (WKWebView *)webView;
/// Releases a web view.
- (void)releaseWebView;

/// Adds a progress view to a web view.
- (void)addProgressViewToWebView;
/// Adds a progress view to a navigation bar.
- (void)addProgressViewToNavigationBar;
/// Removes a progress view.
- (void)hideProgressView;

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

/// Builds the tool bar.
- (UIImageView *)buildToolBar;
/// Builds the tool bar with a selector.
- (UIImageView *)buildToolBar:(SEL)selector;

@end

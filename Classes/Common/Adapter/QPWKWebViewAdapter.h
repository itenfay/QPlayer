//
//  QPWKWebViewAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BaseAdapter.h"
#import "DYFWebProgressView.h"

typedef void(^ObserveUrlLinkBlock)(NSURL *url);

@interface QPWKWebViewAdapter : BaseWebAdapter <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIScrollViewDelegate>
@property (nonatomic, weak, readonly) WKWebView *webView;
@property (nonatomic, weak, readonly) UINavigationBar *navigationBar;
@property (nonatomic, weak, readonly) UIView *toolBar;
@property (nonatomic, copy, readonly) NSURL *requestURL;

@property (nonatomic, weak) id<WKWebViewAdapterDelegate> delegate;

- (instancetype)initWithNavigationBar:(UINavigationBar *)navigationBar;
- (instancetype)initWithNavigationBar:(UINavigationBar *)navigationBar toolBar:(UIView *)toolBar;

- (void)setupNavigationBar:(UINavigationBar *)navigationBar;
- (void)setupToolBar:(UIView *)toolBar;

/// Inspects the alpha of tool bar.
- (void)inspectToolBarAlpha;

/// Returns Wether a progress bar is added to the navigation bar.
- (BOOL)isAddedToNavBar;

/// Adds a progress view to a web view.
- (void)addProgressViewToWebView;
/// Adds a progress view to a navigation bar.
- (void)addProgressViewToNavigationBar;

/// Gets a web progress view.
- (DYFProgressView *)progressView;
/// Shows a web progress view.
- (void)showProgressView;
/// Hides a web progress view.
- (void)hideProgressView;
/// Hides a web progress view immediately.
- (void)hideProgressViewImmediately;

/// Override.
- (void)adaptThemeForWebView;

/// Observes the current url link.
- (void)observeUrlLink:(ObserveUrlLinkBlock)block;

@end

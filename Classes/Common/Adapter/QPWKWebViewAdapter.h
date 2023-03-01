//
//  QPWKWebViewAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QPBaseDelegate.h"
#import "DYFWebProgressView.h"

@protocol IQPWKWebViewAdapter <QPBaseDelegate>

/// Return Wether a progress bar is added to the navigation bar.
- (BOOL)isAddedToNavBar;

- (void)setDarkMode:(BOOL)mode;
- (BOOL)isDarkMode;

- (void)setWebView:(WKWebView *)webView;
- (WKWebView *)webView;

- (void)setNavigationBar:(UINavigationBar *)navigationBar;
- (UINavigationBar *)navigationBar;

/// Adds a progress view to a web view.
- (void)addProgressViewToWebView;
/// Adds a progress view to a navigation bar.
- (void)addProgressViewToNavigationBar;

/// Gets a web progress view.
- (DYFWebProgressView *)webProgressView;
/// Shows a web progress view.
- (void)showProgressView;
/// Hides a web progress view.
- (void)hideProgressView;
/// Hides a web progress view immediately.
- (void)hideProgressViewImmediately;

@end

@interface QPWKWebViewAdapter : NSObject <IQPWKWebViewAdapter, WKNavigationDelegate, WKUIDelegate>

@end

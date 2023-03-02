//
//  QPWKWebViewAdapter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPWKWebViewAdapter.h"

@interface QPWKWebViewAdapter ()
@property (nonatomic, strong) DYFWebProgressView *progressView;
@property (nonatomic, assign, readonly) BOOL mIsAddedToNavBar;
@end

@implementation QPWKWebViewAdapter

- (BOOL)isAddedToNavBar
{
    return _mIsAddedToNavBar;
}

- (DYFWebProgressView *)webProgressView
{
    return _progressView;
}

- (void)addProgressViewToWebView
{
    _mIsAddedToNavBar = NO;
}

- (void)addProgressViewToNavigationBar
{
    _mIsAddedToNavBar = YES;
}

- (DYFWebProgressView *)progressView
{
    if (!_progressView) {
        CGRect frame         = CGRectZero;
        frame.origin.x       = 0.f;
        frame.size.height    = 2.f;
        if (self.isAddedToNavBar) {
            frame.origin.y   = self.navigationBar.height - frame.size.height;
            frame.size.width = self.navigationBar.width;
            _progressView    = [[DYFWebProgressView alloc] initWithFrame:frame];
        } else {
            frame.origin.y   = 0;
            frame.size.width = self.webView.width;
            _progressView    = [[DYFWebProgressView alloc] initWithFrame:frame];
        }
    }
    return _progressView;
}

- (void)showProgressView
{
    if (!_progressView) {
        self.progressView.lineWidth = 2.f;
        self.progressView.lineColor = QPColorFromRGB(248, 125, 36);
        
        if (self.isAddedToNavBar) {
            [self.navigationBar addSubview:self.progressView];
        } else {
            [self.webView addSubview:self.progressView];
        }
        [self.progressView startLoading];
    }
}

- (void)hideProgressView
{
    if (_progressView) {
        [self.progressView endLoading];
        self.scheduleTask(self, @selector(releaseProgressView), nil, 0.3);
    }
}

- (void)hideProgressViewImmediately
{
    if (_progressView) {
        [self.progressView endLoadingImmediately];
        _progressView = nil;
    }
}

- (void)releaseProgressView
{
    _progressView = nil;
}

// Deprecated
- (void)adaptThemeForWebView
{
    //[self.webView evaluateJavaScript:@"document.body.style.backgroundColor" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //if (!error) {
    //    QPLog(@"result: %@", result);
    //} else {
    //    QPLog(@"error: %@, %@", @(error.code), error.localizedDescription);
    //}
    //}];
    NSString *bgColor   = @"";
    NSString *textColor = @"";
    
    BOOL bValue = [QPlayerExtractValue(kThemeStyleOnOff) boolValue];
    if (bValue && self.isDarkMode) {
        bgColor   = @"'#1E1E1E'";
        textColor = @"'#B4B4B4'";
    } else {
        bgColor   = @"'#F3F3F3'";
        textColor = @"'#303030'";
    }
    
    // document.getElementsByTagName('body')[0].style.backgroundColor
    // document.body.style.backgroundColor
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor=%@", bgColor] completionHandler:NULL];
    // document.getElementsByTagName('body')[0].style.webkitTextFillColor
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@", textColor] completionHandler:NULL];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    QPLog("::");
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    QPLog("::");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    //[self adaptThemeForWebView];
    [self showProgressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //[self adaptThemeForWebView];
    [self hideProgressView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self hideProgressView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self hideProgressView];
}

@end

//
//  QPWKWebViewAdapter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPWKWebViewAdapter.h"

@interface QPWKWebViewAdapter ()
@property (nonatomic, strong) DYFWebProgressView *mProgressView;
@property (nonatomic, assign, readonly) BOOL mIsAddedToNavBar;
@end

@implementation QPWKWebViewAdapter

- (instancetype)initWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar
{
    return [self initWithWebView:webView navigationBar:navigationBar toolBar:nil];
}

- (instancetype)initWithWebView:(WKWebView *)webView navigationBar:(UINavigationBar *)navigationBar toolBar:(UIView *)toolBar
{
    if (self = [super init]) {
        self.webView = webView;
        self.navigationBar = navigationBar;
        self.toolBar = toolBar;
    }
    return self;
}

- (DYFWebProgressView *)mProgressView
{
    if (!_mProgressView) {
        CGRect frame         = CGRectZero;
        frame.origin.x       = 0.f;
        frame.size.height    = 2.f;
        if (self.isAddedToNavBar) {
            frame.origin.y   = self.navigationBar.height - frame.size.height;
            frame.size.width = self.navigationBar.width;
            _mProgressView   = [[DYFWebProgressView alloc] initWithFrame:frame];
        } else {
            frame.origin.y   = 0;
            frame.size.width = self.webView.width;
            _mProgressView   = [[DYFWebProgressView alloc] initWithFrame:frame];
        }
    }
    return _mProgressView;
}

- (BOOL)isAddedToNavBar
{
    return _mIsAddedToNavBar;
}

- (void)setWebView:(WKWebView *)webView
{
    _webView = webView;
    _webView.scrollView.delegate = self;
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
    return self.mProgressView;
}

- (void)showProgressView
{
    if (!_mProgressView) {
        return;
    }
    self.mProgressView.lineWidth = 2.f;
    self.mProgressView.lineColor = QPColorFromRGB(248, 125, 36);
    if (self.isAddedToNavBar) {
        if (![self.navigationBar.subviews containsObject:self.mProgressView]) {
            [self.navigationBar addSubview:self.mProgressView];
        }
    } else {
        if (![self.webView.subviews containsObject:self.mProgressView]) {
            [self.webView addSubview:self.mProgressView];
        }
    }
    [self.mProgressView startLoading];
}

- (void)hideProgressView
{
    if (!_mProgressView) {
        return;
    }
    [self.mProgressView endLoading];
    self.scheduleTask(self, @selector(releaseProgressView), nil, 0.3);
}

- (void)hideProgressViewImmediately
{
    if (_mProgressView) {
        [self.mProgressView endLoadingImmediately];
        [_mProgressView removeFromSuperview];
        _mProgressView = nil;
    }
}

- (void)releaseProgressView
{
    [_mProgressView removeFromSuperview];
    _mProgressView = nil;
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
    NSString *url = webView.URL.absoluteString;
    QPLog(@":: url=%@", url);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    QPLog(":: url=%@", webView.URL);
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
    QPLog(":: url=%@", webView.URL);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self hideProgressView];
    if (error.code == NSURLErrorCancelled || error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    NSString *errMsg = [NSString stringWithFormat:@"加载出错了(%zi)", error.code];
    QPLog(":: errMsg=%@, desc=%@", errMsg, error.localizedDescription);
    [QPHudUtils showErrorMessage:errMsg];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self hideProgressView];
    if (error.code == NSURLErrorCancelled || error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    NSString *errMsg = [NSString stringWithFormat:@"加载出错了(%zi)", error.code];
    QPLog(":: errMsg=%@, desc=%@", errMsg, error.localizedDescription);
    [QPHudUtils showErrorMessage:errMsg];
}

//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    NSString *url = navigationAction.request.URL.absoluteString;
//    QPLog(@":: url=%@", url);
//    if (navigationAction.targetFrame == nil || !navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *url = navigationAction.request.URL.absoluteString;
    QPLog(@":: url=%@", url);
    
    // Method NO.1: resolve the problem about '_blank'.
    //if (navigationAction.targetFrame == nil) {
    //    [webView loadRequest:navigationAction.request];
    //}
    
    if ([url isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self showToolBar];
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewDidScroll:forAdapter:))) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView forAdapter:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewWillBeginDragging:forAdapter:))) {
        [self.scrollViewDelegate scrollViewWillBeginDragging:scrollView forAdapter:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:forAdapter:))) {
        [self.scrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset forAdapter:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self hideToolBarAfterDelay];
    }
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewDidEndDragging:willDecelerate:forAdapter:))) {
        [self.scrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate forAdapter:self];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self hideToolBarAfterDelay];
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewWillBeginDecelerating:forAdapter:))) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView forAdapter:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewDidEndDecelerating:forAdapter:))) {
        [self.scrollViewDelegate scrollViewDidEndDecelerating:scrollView forAdapter:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewDidEndScrollingAnimation:forAdapter:))) {
        [self.scrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView forAdapter:self];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewShouldScrollToTop:forAdapter:))) {
        return [self.scrollViewDelegate scrollViewShouldScrollToTop:scrollView forAdapter:self];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewDidScrollToTop:forAdapter:))) {
        [self.scrollViewDelegate scrollViewDidScrollToTop:scrollView forAdapter:self];
    }
}

- (void)hideToolBarAfterDelay
{
    self.scheduleTask(self, @selector(hideToolBar), nil, 8);
}

- (void)showToolBar
{
    [self cancelHidingToolBar];
    if (self.toolBar.alpha == 0.f) {
        [UIView animateWithDuration:0.5 animations:^{
            self.toolBar.alpha = 1.f;
        }];
    }
}

- (void)hideToolBar
{
    if (self.toolBar.alpha == 1.f) {
        [UIView animateWithDuration:0.5 animations:^{
            self.toolBar.alpha = 0.f;
        }];
    }
}

- (void)cancelHidingToolBar
{
    self.cancelPerformingSelector(self, @selector(hideToolBar), nil);
}

- (void)inspectToolBarAlpha
{
    if (self.toolBar.alpha > 0.f) {
        self.toolBar.alpha = 0.f;
        [self cancelHidingToolBar];
    }
}

@end

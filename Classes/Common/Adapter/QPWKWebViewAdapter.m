//
//  QPWKWebViewAdapter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPWKWebViewAdapter.h"

@interface QPWKWebViewAdapter ()
@property (nonatomic, strong) DYFProgressView *progressView;
@property (nonatomic, assign, readonly) BOOL mIsAddedToNavBar;
@property (nonatomic, copy) ObserveUrlLinkBlock linkBlock;
@property (nonatomic, assign) BOOL didScroll;
@end

@implementation QPWKWebViewAdapter

- (instancetype)init {
    return [self initWithNavigationBar:nil];
}

- (instancetype)initWithNavigationBar:(UINavigationBar *)navigationBar {
    return [self initWithNavigationBar:navigationBar toolBar:nil];
}

- (instancetype)initWithNavigationBar:(UINavigationBar *)navigationBar toolBar:(UIView *)toolBar {
    if (self = [super init]) {
        self->_navigationBar = navigationBar;
        self->_toolBar = toolBar;
    }
    return self;
}

- (void)setupNavigationBar:(UINavigationBar *)navigationBar {
    self->_navigationBar = navigationBar;
}

- (void)setupToolBar:(UIView *)toolBar {
    self->_toolBar = toolBar;
}

- (void)setIsDarkMode:(BOOL)isDarkMode
{
    self.isDarkMode = isDarkMode;
    [self updateToolBarAppearance];
    [self adaptThemeForWebView];
}

- (void)updateToolBarAppearance
{
    UIColor *customDarkColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    UIColor *customLightColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    BOOL ret = [QPExtractValue(kThemeStyleOnOff) boolValue];
    UIColor *bgColor = ret
    ? (self.isDarkMode ? customDarkColor : customLightColor)
    : customLightColor;
    if ([_toolBar isKindOfClass:UIImageView.class]) {
        UIImageView *tb = (UIImageView *)_toolBar;
        tb.image        = [self colorImage:tb.bounds
                              cornerRadius:15.f
                            backgroudColor:bgColor
                               borderWidth:0.f borderColor:nil];
    } else {
        _toolBar.backgroundColor = bgColor;
        _toolBar.layer.cornerRadius = 15.f;
        _toolBar.layer.masksToBounds = YES;
    }
}

- (BOOL)isAddedToNavBar
{
    return _mIsAddedToNavBar;
}

- (void)setupWebView:(WKWebView *)webView
{
    self->_webView = webView;
    [self setup];
}

- (void)addProgressViewToWebView
{
    _mIsAddedToNavBar = NO;
}

- (void)addProgressViewToNavigationBar
{
    _mIsAddedToNavBar = YES;
}

- (void)showProgressView
{
    if (_progressView) {
        return;
    }
    // Web progress view: self.progressView.lineWidth
    //self.progressView.lineWidth = 2.f;
    // Web progress view: self.progressView.lineColor
    //self.progressView.lineColor = QPColorFromRGB(248, 125, 36);
    self.progressView.progressColor = QPColorFromRGB(248, 125, 36);
    if (self.isAddedToNavBar) {
        if (![self.navigationBar.subviews containsObject:self.progressView]) {
            [self.navigationBar addSubview:self.progressView];
        }
    } else {
        if (![self.webView.subviews containsObject:self.progressView]) {
            [self.webView addSubview:self.progressView];
        }
    }
    // Web progress view: [self.progressView startLoading];
    //[self.progressView startLoading];
}

- (void)hideProgressView
{
    if (!_progressView) {
        return;
    }
    //[self.progressView endLoading];
    self.scheduleTask(self, @selector(resetProgressView), nil, 0.3);
}

- (void)onHandleImmediately {
    [self hideProgressViewImmediately];
}

- (void)hideProgressViewImmediately
{
    if (_progressView) {
        // Web progress view
        //[self.progressView endLoadingImmediately];
        //[_progressView removeFromSuperview];
        //_progressView = nil;
        [self resetProgressView];
    }
}

- (void)resetProgressView
{
    // Web progress view
    //[_progressView removeFromSuperview];
    //_progressView = nil;
    [_progressView setProgress:1.0 animated:NO];
}

- (void)observeUrlLink:(ObserveUrlLinkBlock)block
{
    self.linkBlock = block;
}

- (void)setup
{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    //[self.webView.configuration.userContentController addScriptMessageHandler:self name:@"xxx"];
    //[self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"xxx"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //QPLog("estimatedProgress: %.2f", self.webView.estimatedProgress);
        double estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        QPLog("estimatedProgress: %.2f", estimatedProgress);
        [_progressView setProgress:estimatedProgress animated:YES];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/// Adapt theme style for the web view.
- (void)adaptThemeForWebView
{
    //[self.webView evaluateJavaScript:@"document.body.style.backgroundColor" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //    if (!error) {
    //        QPLog(@"result=%@", result);
    //    } else {
    //        QPLog(@"error=%zi, %@", error.code, error.localizedDescription);
    //    }
    //}];
    NSString *backgroundColor = @"";
    NSString *textColor = @"";
    BOOL ret = [QPExtractValue(kThemeStyleOnOff) boolValue];
    if (ret && self.isDarkMode) {
        backgroundColor = @"'#1E1E1E'";
        textColor = @"'#B4B4B4'";
    } else {
        backgroundColor = @"'#F3F3F3'";
        textColor = @"'#303030'";
    }
    //[self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= %@", @"130%"] completionHandler:nil];
    //document.body.style.webkitTextFillColor
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@", textColor] completionHandler:nil];
    // document.body.style.backgroundColor
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background=%@", backgroundColor] completionHandler:nil];
}

#pragma make - WKNavigationDelegate, WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (!_webView) {
        [self setupWebView:webView];
    }
    NSURL *url = webView.URL;
    QPLog(@"url=%@", url);
    _requestURL = url.copy;
    !self.linkBlock ?: self.linkBlock(url);
    [self showProgressView];
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didStartProvisionalNavigation:))) {
        [self.delegate adapter:self didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSURL *url = webView.URL;
    QPLog("url=%@", url);
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didReceiveServerRedirectForProvisionalNavigation:))) {
        [self.delegate adapter:self didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSURL *url = webView.URL;
    QPLog("url=%@", url);
    _requestURL = url.copy;
    !self.linkBlock ?: self.linkBlock(url);
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didCommitNavigation:))) {
        [self.delegate adapter:self didCommitNavigation:navigation];
    }
}

// Gets the label of `video`.
//[webView evaluateJavaScript:@"document.querySelector('video').currentSrc;" completionHandler:^(id result, NSError *error) {
// result will contain the video url
//}];
//[self evaluateJavaScript:webView];
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSURL *url = webView.URL;
    QPLog("url=%@", url);
    _requestURL = url.copy;
    !self.linkBlock ?: self.linkBlock(url);
    [self hideProgressView];
    [self adaptThemeForWebView];
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didFinishNavigation:))) {
        [self.delegate adapter:self didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSURL *url = webView.URL;
    QPLog("url=%@", url);
    [self hideProgressView];
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didFailProvisionalNavigation:withError:))) {
        [self.delegate adapter:self didFailProvisionalNavigation:navigation withError:error];
        return;
    }
    if (error.code == NSURLErrorCancelled || error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    NSString *errMsg = [NSString stringWithFormat:@"加载出错了(%zi)", error.code];
    QPLog("errMsg=%@, desc=%@", errMsg, error.localizedDescription);
    [QPHudUtils showErrorMessage:errMsg];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSURL *url = webView.URL;
    QPLog("url=%@", url);
    [self hideProgressView];
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didFailNavigation:withError:))) {
        [self.delegate adapter:self didFailNavigation:navigation withError:error];
        return;
    }
    if (error.code == NSURLErrorCancelled || error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    NSString *errMsg = [NSString stringWithFormat:@"加载出错了(%zi)", error.code];
    QPLog("errMsg=%@, desc=%@", errMsg, error.localizedDescription);
    [QPHudUtils showErrorMessage:errMsg];
}

//WKWebView can't jump by clicking the internal link after loading the link, because the target = "_black "in < a href = "xxx" target = "_black" > is to open a new page, so it can't be opened on the current page, and the url needs to be reloaded on the current page.
//Target in a hyperlink:
//_blank - Opens the link in a new window.
//_parent - Opens the link in the parent form.
//_self - Opens the link in the current form, which is the default value.
//_top - Opens the link in the current form and replaces the current whole form (frame page).
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSURL *url = navigationAction.request.URL;
    QPLog("url=%@", url);
    
    // Method1: resolve the problem about '_blank'.
    if (navigationAction.targetFrame == nil || !navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    if (QPRespondsToSelector(self.delegate, @selector(adapter:createWebViewWithConfiguration:forNavigationAction:windowFeatures:))) {
        return [self.delegate adapter:self createWebViewWithConfiguration:configuration forNavigationAction:navigationAction windowFeatures:windowFeatures];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    QPLog("url=%@", url);
    
    // Method2: resolve the problem about '_blank'.
    //if (navigationAction.targetFrame == nil) {
    //    [webView loadRequest:navigationAction.request];
    //}
    
    if (QPRespondsToSelector(self.delegate, @selector(adapter:decidePolicyForNavigationAction:decisionHandler:))) {
        [self.delegate adapter:self decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if (QPRespondsToSelector(self.delegate, @selector(adapter:decidePolicyForNavigationResponse:decisionHandler:))) {
        [self.delegate adapter:self decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
        return;
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    QPLog(@"message=%@", message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alertController addAction:cancelAction];
    [self.yf_currentViewController presentViewController:alertController animated:true completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    QPLog(@"message=%@", message);
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    QPLog(@"prompt=%@, defaultText=%@", prompt, defaultText);
    if (QPRespondsToSelector(self.delegate, @selector(adapter:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:))) {
        [self.delegate adapter:self runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
        return;
    }
    completionHandler(defaultText);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if (QPRespondsToSelector(self.delegate, @selector(adapter:didReceiveAuthenticationChallenge:completionHandler:))) {
        [self.delegate adapter:self didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
        return;
    }
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    QPLog(@"message=%@", message);
    if (QPRespondsToSelector(self.delegate, @selector(adapter:userContentController:didReceiveScriptMessage:))) {
        [self.delegate adapter:self userContentController:userContentController didReceiveScriptMessage:message];
        return;
    }
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
    if (QPRespondsToSelector(self.scrollViewDelegate, @selector(scrollViewWillBeginDecelerating:forAdapter:))) {
        [self.scrollViewDelegate scrollViewWillBeginDecelerating:scrollView forAdapter:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self hideToolBarAfterDelay];
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
    self.scheduleTask(self, @selector(hideToolBar), nil, 6);
}

- (void)showToolBar
{
    _didScroll = YES;
    [self cancelHidingToolBar];
    [UIView animateWithDuration:0.5 animations:^{
        self.toolBar.alpha = 1.f;
    }];
}

- (void)hideToolBar
{
    _didScroll = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.toolBar.alpha = 0.f;
    }];
}

- (void)cancelHidingToolBar
{
    self.cancelPerformingSelector(self, @selector(hideToolBar), nil);
}

- (void)inspectToolBarAlpha
{
    if (_didScroll) { return; }
    if (self.toolBar.alpha > 0) {
        self.toolBar.alpha = 0.f;
        [self cancelHidingToolBar];
    }
}

- (DYFProgressView *)progressView
{
    if (!_progressView) {
        CGRect frame         = CGRectZero;
        frame.origin.x       = 0.f;
        frame.size.height    = 2.f;
        if (self.isAddedToNavBar) {
            frame.origin.y   = self.navigationBar.height - frame.size.height;
            frame.size.width = self.navigationBar.width;
        } else {
            frame.origin.y   = 0;
            frame.size.width = self.webView.width;
        }
        _progressView   = [[DYFProgressView alloc] initWithFrame:frame];
    }
    return _progressView;
}

- (void)dealloc
{
    [_progressView removeFromSuperview];
    _progressView = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    QPLog(@"[%@ dealloc]", NSStringFromClass(self.class));
}

@end

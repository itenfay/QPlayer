//
//  BaseWebViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()
@property (nonatomic, strong) WKWebView *webView; // Declares a web view object.
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
@property (nonatomic, strong) WKUserContentController *userContentController;
@end

@implementation BaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)releaseWebView
{
    if (_webView) {
        _webView = nil;
    }
}

- (void)loadRequestWithUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadRequest:(NSURLRequest *)urlRequest
{
    [self.webView loadRequest:urlRequest];
}

- (void)onGoBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)onGoForward
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)onReload
{
    [_adapter onHandleImmediately];
    [self.webView reload];
}

- (void)onStopLoading
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
}

- (void)adaptThemeStyle
{
    [super adaptThemeStyle];
    [self.adapter onUpdateDarkMode:self.isDarkMode];
}

#pragma mark - Lazy
#pragma mark - getters and setters

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.webViewConfiguration];
    }
    return _webView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.minimumFontSize = 0;
        preferences.javaScriptEnabled = YES;
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webViewConfiguration.preferences = preferences;
        //_webViewConfiguration.processPool = [[WKProcessPool alloc] init];
        _webViewConfiguration.userContentController = self.userContentController;
        _webViewConfiguration.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0, *)) {
            // The default value is YES.
            _webViewConfiguration.allowsAirPlayForMediaPlayback = YES;
            _webViewConfiguration.allowsPictureInPictureMediaPlayback = YES;
            if (@available(iOS 10.0, *)) {
                // WKAudiovisualMediaTypeNone
                _webViewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
            } else {
                //_webViewConfiguration.requiresUserActionForMediaPlayback = NO;
            }
        } else {
            // Fallback on earlier versions
            //_webViewConfiguration.mediaPlaybackAllowsAirPlay = YES;
            //_webViewConfiguration.mediaPlaybackRequiresUserAction = YES;
        }
    }
    return _webViewConfiguration;
}

- (WKUserContentController *)userContentController {
    if (!_userContentController) {
        _userContentController = WKUserContentController.alloc.init;
    }
    return _userContentController;
}

#pragma mark - dealloc

- (void)dealloc
{
    [self.userContentController removeAllUserScripts];
    if (@available(iOS 14.0, *)) {
        [self.userContentController removeAllScriptMessageHandlers];
    } else {
        // Unknow
        //[self.userContentController removeScriptMessageHandlerForName:@""];
    }
    [self releaseWebView];
    [self removeThemeStyleChangedObserver];
    QPLog(@"");
}

@end

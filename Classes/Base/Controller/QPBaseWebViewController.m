//
//  QPBaseWebViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseWebViewController.h"

@interface QPBaseWebViewController ()
/// Declares a web view object.
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) DYFWebProgressView *progressView;
@end

@implementation QPBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (WKWebViewConfiguration *)webViewConfiguration
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = 0;
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preferences;
    //conf.processPool = [[WKProcessPool alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    config.allowsInlineMediaPlayback = YES;
    if (@available(iOS 9.0, *)) {
        // The default value is YES.
        config.allowsAirPlayForMediaPlayback = YES;
        config.allowsPictureInPictureMediaPlayback = YES;
        if (@available(iOS 10.0, *)) {
            // WKAudiovisualMediaTypeNone
            config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
        } else {
            //config.requiresUserActionForMediaPlayback = NO;
        }
    } else {
        // Fallback on earlier versions
        //config.mediaPlaybackAllowsAirPlay = YES;
        //config.mediaPlaybackRequiresUserAction = YES;
    }
    return config;
}

- (WKUserContentController *)userContentController {
    return [[WKUserContentController alloc] init];
}

- (void)initWebViewWithFrame:(CGRect)frame
{
    [self initWebViewWithFrame:frame configuration:self.webViewConfiguration];
}

- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    }
}

- (WKWebView *)webView {
    [self addObserver:_wkWebView forKeyPath:@"" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    return _wkWebView;
}

- (void)willAddProgressViewToWebView
{
    self.isAddedToNavBar = NO;
}

- (void)willAddProgressViewToNavigationBar
{
    self.isAddedToNavBar = YES;
}

- (void)loadWebContents:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadWebUrlRequest:(NSURLRequest *)urlRequest
{
    [self.webView loadRequest:urlRequest];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    // didStartProvisionalNavigation.
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    // didReceiveServerRedirectForProvisionalNavigation.
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    //[self adjustThemeForWebView:webView];
    [self buildProgressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //[self adjustThemeForWebView:webView];
    [self removeProgressView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self removeProgressView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self removeProgressView];
}

- (void)buildProgressView
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

- (void)removeProgressView
{
    if (_progressView) {
        [self.progressView endLoading];
        self.scheduleTask(self, @selector(releaseProgressView), nil, 0.3);
    }
}

- (void)releaseProgressView
{
    _progressView = nil;
}

- (void)adjustThemeForWebView:(WKWebView *)webView
{
    //[webView evaluateJavaScript:@"document.body.style.backgroundColor" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //if (!error) {
    //    QPLog(@"result: %@", result);
    //} else {
    //QPLog(@"error: %@, %@", @(error.code), error.localizedDescription);
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
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor=%@", bgColor] completionHandler:NULL];
    // document.getElementsByTagName('body')[0].style.webkitTextFillColor
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@", textColor] completionHandler:NULL];
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
    if (_progressView) {
        [self.progressView endLoading];
        _progressView = nil;
    }
    [self.webView reload];
}

- (void)onStopLoading
{
    if ([self.webView isLoading]) {
        [self.webView stopLoading];
    }
}

- (void)releaseWebView
{
    if (_wkWebView) {
        _wkWebView = nil;
    }
}

- (DYFWebProgressView *)progressView
{
    if (!_progressView) {
        CGRect frame         = CGRectZero;
        frame.origin.x       = 0.f;
        frame.size.height    = 2.f;
        
        if (self.isAddedToNavBar) {
            frame.origin.y   = self.navigationBar.height - 2.f;
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

- (UIImageView *)buildCustomToolBar
{
    return [self buildCustomToolBar:@selector(toolBarItemClicked:)];
}

- (UIImageView *)buildCustomToolBar:(SEL)selector
{
    NSArray *tempArray = @[@"web_reward_13x21", @"web_forward_13x21",
                           @"web_refresh_24x21", @"web_stop_21x21",
                           @"parse_button_blue"];
    NSMutableArray *imgNames = [tempArray mutableCopy];
    
    if (!self.parsingButtonRequired){
        [imgNames removeLastObject];
    }
    
    NSUInteger count = imgNames.count;
    CGFloat hSpace   = 10.f;
    CGFloat vSpace   = 5.f;
    CGFloat btnW     = 30.f;
    CGFloat btnH     = 30.f;
    
    BOOL    bVar     = self.parsingButtonRequired || !self.hidesBottomBarWhenPushed;
    CGFloat offset   = bVar ? QPTabBarHeight : 3*vSpace;
    CGFloat tlbW     = btnW + 2*hSpace;
    CGFloat tlbH     = count*btnH + (count+1)*vSpace + 3*vSpace;
    CGFloat tlbX     = QPScreenWidth - tlbW - hSpace;
    CGFloat tlbY     = self.view.height - offset - tlbH - 3*vSpace;
    CGRect  tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
    
    UIImageView *toolBar    = [[UIImageView alloc] initWithFrame:tlbFrame];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.image           = [self colorImage:toolBar.bounds
                                  cornerRadius:15.f
                                backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                                   borderWidth:0.f
                                   borderColor:nil];
    
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame     = CGRectMake(hSpace, (i+1)*vSpace+i*btnH, btnW, btnH);
        button.tag       = 100 + i;
        button.showsTouchWhenHighlighted = YES;
        [button setImage:QPImageNamed(imgNames[i]) forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
    }
    
    toolBar.userInteractionEnabled = YES;
    toolBar.autoresizingMask       = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleWidth      |
                                      UIViewAutoresizingFlexibleTopMargin  |
                                      UIViewAutoresizingFlexibleHeight);
    
    return toolBar;
}

- (void)toolBarItemClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag - 100;
    switch (index) {
        case 0: { [self onGoBack]; }
            break;
        case 1: { [self onGoForward]; }
            break;
        case 2: { [self onReload]; }
            break;
        case 3: { [self onStopLoading]; }
            break;
        case 4: { QPLog(); }
            break;
        default:
            break;
    }
}

@end

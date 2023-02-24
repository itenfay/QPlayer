//
//  QPBaseWebViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseWebViewController.h"

@interface QPBaseWebViewController ()

// Declares a web view object.
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) DYFWebProgressView *progressView;

@end

@implementation QPBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (WKWebViewConfiguration *)wkWebViewConfiguration
{
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = 0;
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = NO;
    conf.preferences = preferences;
    conf.processPool = [[WKProcessPool alloc] init];
    conf.userContentController = [[WKUserContentController alloc] init];
    conf.allowsInlineMediaPlayback = YES;
    if (@available(iOS 9.0, *)) {
        if (@available(iOS 10.0, *)) {
            conf.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        } else {
            conf.requiresUserActionForMediaPlayback = NO;
        }
        // The default value is YES.
        conf.allowsAirPlayForMediaPlayback = YES;
        conf.allowsPictureInPictureMediaPlayback = YES;
    } else {
        // Fallback on earlier versions
        conf.mediaPlaybackAllowsAirPlay = YES;
        conf.mediaPlaybackRequiresUserAction = YES;
    }
    return conf;
}

- (void)initWebViewWithFrame:(CGRect)frame
{
    [self initWebViewWithFrame:frame configuration:self.wkWebViewConfiguration];
}

- (void)initWebViewWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    }
}

- (WKWebView *)webView {
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
        self.scheduleTask(self,
                          @selector(releaseProgressView),
                          nil,
                          0.3);
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

// Navigates to the back item in the back-forward list.
- (void)onGoBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

// Navigates to the forward item in the back-forward list.
- (void)onGoForward
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

// Reloads the current page.
- (void)onReload
{
    if (_progressView) {
        [self.progressView endLoading];
        _progressView = nil;
    }
    [self.webView reload];
}

// Stops loading all resources on the current page.
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

- (void)removeCellAllSubviews:(UITableViewCell *)cell
{
    while (cell.contentView.subviews.lastObject != nil) {
        [(UIView *)cell.contentView.subviews.lastObject removeFromSuperview];
    }
}

- (UIImageView *)buildCustomToolBar
{
    return [self buildCustomToolBar:@selector(toolBarItemClicked:)];
}

- (UIImageView *)buildCustomToolBar:(SEL)selector
{
    NSArray *tempArray = @[@"web_reward_13x21",
                           @"web_forward_13x21",
                           @"web_refresh_24x21",
                           @"web_stop_21x21",
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

- (UIImage *)colorImage:(CGRect)rect cornerRadius:(CGFloat)cornerRadius backgroudColor:(UIColor *)backgroudColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *newImage  = nil;
    CGRect mRect       = rect;
    CGSize mSize       = mRect.size;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mRect cornerRadius:cornerRadius];
    
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:mSize];
        newImage = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            UIGraphicsImageRendererContext *ctx = rendererContext;
            CGContextSetFillColorWithColor  (ctx.CGContext, backgroudColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx.CGContext, borderColor.CGColor);
            CGContextSetLineWidth           (ctx.CGContext, borderWidth);
            [path addClip];
            CGContextAddPath (ctx.CGContext, path.CGPath);
            CGContextDrawPath(ctx.CGContext, kCGPathFillStroke);
        }];
    } else {
        UIGraphicsBeginImageContext(mSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor  (context, backgroudColor.CGColor);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth           (context, borderWidth);
        [path addClip];
        CGContextAddPath (context, path.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newImage;
}

- (NSString *)formatVideoDuration:(int)duration
{
    int seconds = duration;
    int hour    = 0;
    int minute  = 0;
    
    int secondsPerHour = 60 * 60;
    if (seconds >= secondsPerHour) {
        int delta = seconds / secondsPerHour;
        hour = delta;
        seconds -= delta * secondsPerHour;
    }
    int secondsPerMinute = 60;
    if (seconds >= secondsPerMinute) {
        int delta = seconds / secondsPerMinute;
        minute = delta;
        seconds -= delta * secondsPerMinute;
    }
    if (hour == 0 && minute == 0 && seconds == 0) {
        return [NSString stringWithFormat:@"--:--"];
    }
    if (hour == 0) {
        return [NSString stringWithFormat:@"%02d:%02d", minute, seconds];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, seconds];
}

- (NSString *)totalTimeForVideo:(NSURL *)aUrl
{
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:aUrl];
    CMTime time = playerItem.asset.duration;
    //Float64 sec = CMTimeGetSeconds(time);
    int duration = (int)time.value / time.timescale;
    return [self formatVideoDuration:duration];
}

- (UIImage *)thumbnailForVideo:(NSURL *)aUrl
{
    AVAsset *asset = [AVAsset assetWithURL:aUrl];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(2, 1);
    CMTime actualTime;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:NULL];
    if (imageRef) {
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return thumbnail;
    }
    return QPImageNamed(@"default_thumbnail");
}

@end

//
//  QPBaseViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseViewController.h"

@interface QPBaseViewController ()

@end

@implementation QPBaseViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)needsStatusBarAppearanceUpdate
{
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)needsUpdateOfSupportedInterfaceOrientations
{
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
    } else {
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateNaviBarAppearance:NO];
    [self identifyMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self needsStatusBarAppearanceUpdate];
    [self needsUpdateOfSupportedInterfaceOrientations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)monitorNetworkChangesWithSelector:(SEL)selector
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:selector name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)stopMonitoringNetworkChanges
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)addThemeStyleChangedObserver
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adaptThemeStyle) name:kThemeStyleDidChangeNotification object:nil];
}

- (void)removeThemeStyleChangedObserver
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:kThemeStyleDidChangeNotification object:nil];
}

- (void)adaptThemeStyle
{
    [self identifyMode];
}

- (void)updateNaviBarAppearance:(BOOL)isDark
{
    UINavigationController *navi = self.navigationController;
    if (navi == nil) { return; }
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        /// 背景色
        appearance.backgroundColor = isDark ? QPColorFromRGB(20, 20, 20) : QPColorFromRGB(39, 220, 203);
        /// 去掉半透明效果
        appearance.backgroundEffect = nil;
        /// 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
        appearance.shadowColor = UIColor.clearColor;
        appearance.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: UIColor.whiteColor};
        navi.navigationBar.standardAppearance = appearance;
        navi.navigationBar.scrollEdgeAppearance = appearance;
    }
}

- (void)identifyMode
{
    BOOL bValue = [QPlayerExtractValue(kThemeStyleOnOff) boolValue];
    if (bValue) {
        if (@available(iOS 13.0, *)) {
            UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
            if (mode == UIUserInterfaceStyleDark) {
                // Dark Mode
                [self adjustDarkTheme];
            } else if (mode == UIUserInterfaceStyleLight) {
                // Light Mode or unspecified Mode
                [self adjustLightTheme];
            }
        } else {
            [self adjustLightTheme];
        }
    } else {
        [self adjustLightTheme];
    }
}

- (void)adjustLightTheme
{
    [self setNavigationBarLightStyle];
    [self updateNaviBarAppearance:NO];
    self.view.backgroundColor = QPColorFromRGB(243, 243, 243);
    self.isDarkMode = NO;
}

- (void)adjustDarkTheme
{
    [self setNavigationBarDarkStyle];
    [self updateNaviBarAppearance:YES];
    self.view.backgroundColor = QPColorFromRGB(30, 30, 30);
    self.isDarkMode = YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [self identifyMode];
}

- (UINavigationBar *)navigationBar
{
    if (self.navigationController) {
        return self.navigationController.navigationBar;
    }
    return nil;
}

- (void)setNavigationBarLightStyle
{
    [self.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)setNavigationBarDarkStyle
{
    [self.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBlackBg") forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //[self.navigationBar setBarTintColor:QPColorFromRGB(20, 20, 20)];
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = hidden;
    }
}

- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 36);
    UIImage *x = QPImageNamed(@"back_normal_white");
    [x imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [button setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    return button;
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

- (NSString *)urlEncode:(NSString *)string
{
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

- (NSString *)urlDecode:(NSString *)string
{
    NSString *_string = [string stringByRemovingPercentEncoding];
    if (_string) { return _string; }
    return [string copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

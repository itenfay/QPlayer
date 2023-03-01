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
    [self needsStatusBarAppearanceUpdate];
    [self needsUpdateOfSupportedInterfaceOrientations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self needsStatusBarAppearanceUpdate];
    [self needsUpdateOfSupportedInterfaceOrientations];
    [self adaptThemeStyle];
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [self adaptThemeStyle];
}

- (void)adaptThemeStyle
{
    BOOL ret = [QPlayerExtractValue(kThemeStyleOnOff) boolValue];
    if (ret) {
        if (@available(iOS 13.0, *)) {
            UIUserInterfaceStyle style = UITraitCollection.currentTraitCollection.userInterfaceStyle;
            if (style == UIUserInterfaceStyleDark) {
                // Dark Mode
                [self adaptDarkTheme];
            } else if (style == UIUserInterfaceStyleLight) {
                // Light Mode or unspecified Mode
                [self adaptLightTheme];
            }
        } else {
            [self adaptLightTheme];
        }
    } else {
        [self adaptLightTheme];
    }
}

- (void)adaptLightTheme
{
    [self adaptNavigationBarAppearance:NO];
    [self setupNavigationBarLightStyle];
    self.view.backgroundColor = QPColorFromRGB(243, 243, 243);
    _isDarkMode = NO;
}

- (void)adaptDarkTheme
{
    [self adaptNavigationBarAppearance:YES];
    [self setupNavigationBarDarkStyle];
    self.view.backgroundColor = QPColorFromRGB(30, 30, 30);
    _isDarkMode = YES;
}

- (void)adaptNavigationBarAppearance:(BOOL)isDark
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
        appearance.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: UIColor.whiteColor};
        navi.navigationBar.standardAppearance = appearance;
        navi.navigationBar.scrollEdgeAppearance = appearance;
    }
}

- (UINavigationBar *)navigationBar
{
    if (self.navigationController) {
        return self.navigationController.navigationBar;
    }
    return nil;
}

- (void)configNavigaitonBar:(UIImage *)backgroundImage titleTextAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleTextAttributes
{
    [self configNavigaitonBar:backgroundImage shadowImage:[[UIImage alloc] init] titleTextAttributes:titleTextAttributes];
}

- (void)configNavigaitonBar:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage titleTextAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleTextAttributes
{
    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:shadowImage];
    [self.navigationBar setTitleTextAttributes:titleTextAttributes];
}

- (void)setupNavigationBarLightStyle
{
    id titleTextAttrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self configNavigaitonBar:QPImageNamed(@"NavigationBarBg") titleTextAttributes:titleTextAttrs];
}

- (void)setupNavigationBarDarkStyle
{
    id titleTextAttrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self configNavigaitonBar:QPImageNamed(@"NavigationBarBlackBg") titleTextAttributes:titleTextAttrs];
}

- (void)setupNavigationBarHidden:(BOOL)hidden
{
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = hidden;
    }
}

- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 36);
    [button setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    return button;
}

- (void)addLeftNavigationBarButton:(UIButton *)button
{
    NSMutableArray *items = self.navigationItem.leftBarButtonItems.mutableCopy;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (items == nil) {
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
        items = @[spaceItem, item].mutableCopy;
    } else {
        [items addObject:item];
    }
    self.navigationItem.leftBarButtonItems = items;
}

- (void)addRightNavigationBarButton:(UIButton *)button
{
    NSMutableArray *items = self.navigationItem.rightBarButtonItems.mutableCopy;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (items == nil) {
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = 10;
        items = @[item, spaceItem].mutableCopy;
    } else {
        [items addObject:item];
    }
    self.navigationItem.rightBarButtonItems = items;
}

- (void)setNavigationBarTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    QPLog(@"::");
}

- (void)dealloc
{
    QPLog(@"::");
}

@end

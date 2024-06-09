//
//  QPTabBarController.m
//
//  Created by Tenfay on 2017/12/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPTabBarController.h"
#import "BaseNavigationController.h"
#import "QPHomeViewController.h"
#import "QPSearchViewController.h"
#import "QPSettingsViewController.h"

@interface QPTabBarController ()

@end

@implementation QPTabBarController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self needsStatusBarAppearanceUpdate];
    [self needsUpdateOfSupportedInterfaceOrientations];
    [self adaptThemeStyle];
}

- (void)setup
{
    UIImage *htbItemImage = QPImageNamed(@"tabbar_item_home_00");
    UIImage *htbItemSelectedImage = self.yf_originalImage(QPImageNamed(@"tabbar_item_home_01"));
    
    QPHomeViewController *homeVC = [[QPHomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"本地资源"
                                                      image:htbItemImage
                                              selectedImage:htbItemSelectedImage];
    BaseNavigationController *hnc = [self supplyNavigationController:homeVC];
    
    UIImage *stbItemImage = QPImageNamed(@"tabbar_item_browser_00");
    UIImage *stbItemSelectedImage = self.yf_originalImage(QPImageNamed(@"tabbar_item_browser_01"));
    
    QPSearchViewController *searchVC = [[QPSearchViewController alloc] init];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"打开网址"
                                                        image:stbItemImage
                                                selectedImage:stbItemSelectedImage];
    BaseNavigationController *snc = [self supplyNavigationController:searchVC];
    
    UIImage *settbItemImage = QPImageNamed(@"tabbar_item_setting_00");
    UIImage *settbItemSelectedImage = self.yf_originalImage(QPImageNamed(@"tabbar_item_setting_01"));
    
    QPSettingsViewController *settingsVC = [[QPSettingsViewController alloc] init];
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                          image:settbItemImage
                                                  selectedImage:settbItemSelectedImage];
    BaseNavigationController *setnc = [self supplyNavigationController:settingsVC];
    
    self.viewControllers = @[hnc, snc, setnc];
    self.selectedIndex   = 0;
}

- (BaseNavigationController *)supplyNavigationController:(UIViewController *)viewController
{
    return [[BaseNavigationController alloc] initWithRootViewController:viewController];
}

- (void)adaptTabBarAppearance:(BOOL)isDark
{
    UIColor *backgroundColor = isDark ? QPColorFromRGB(20, 20, 20) : UIColor.whiteColor;
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [UITabBarAppearance new];
        /// 背景色
        appearance.backgroundColor = backgroundColor;
        /// 去掉半透明效果
        appearance.backgroundEffect = nil;
        /// 去一条阴影线
        appearance.shadowColor = UIColor.clearColor;
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    } else {
        [self.tabBar setBackgroundImage:[self yf_imageWithColor:backgroundColor]];
        [self.tabBar setShadowImage:[self yf_imageWithColor:UIColor.clearColor]];
    }
}

- (void)adaptThemeStyle
{
    BOOL ret = [QPExtractValue(kThemeStyleOnOff) boolValue];
    if (!ret) {
        _isDarkMode = NO;
    } else {
        if (@available(iOS 13.0, *)) {
            UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
            if (mode == UIUserInterfaceStyleDark) { // Dark Mode
                _isDarkMode = YES;
            } else if (mode == UIUserInterfaceStyleLight) { // Light Mode
                _isDarkMode = NO;
            }
        } else { // unspecified Mode
            _isDarkMode = NO;
        }
    }
    [self updateThemeStyle];
}

- (void)updateThemeStyle
{
    [self adaptTabBarAppearance:_isDarkMode];
    
    UIColor *normalColor = _isDarkMode ? QPColorFromRGB(200, 200, 200) : [UIColor grayColor];
    UIColor *selectedColor = _isDarkMode ? QPColorFromRGB(240, 240, 240) : QPColorFromRGB(58, 60, 66);
    //if (_isDarkMode) { //selectedColor = QPColorFromRGB(39, 220, 203); }
    UIImage *bgImage;
    if (_isDarkMode) {
        bgImage = [self yf_imageWithColor:QPColorFromRGB(88, 88, 88)];
    } else {
        bgImage = [self yf_imageWithColor:QPColorFromRGB(188, 188, 188)];
    }
    UIImage *shadowImage = [self yf_imageWithColor:UIColor.clearColor];
    
    UIFont *font = [UIFont boldSystemFontOfSize:13.f];
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    BOOL bValue = [QPExtractValue(kThemeStyleOnOff) boolValue];
    if (bValue) {
        if (@available(iOS 10.0, *)) {
            self.tabBar.unselectedItemTintColor = normalColor;
            self.tabBar.tintColor = selectedColor;
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : font}
                                      forState:UIControlStateNormal];
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : font}
                                      forState:UIControlStateSelected];
        } else {
            [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : normalColor,
                                                 NSFontAttributeName : font}
                                      forState:UIControlStateNormal];
            [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedColor,
                                                 NSFontAttributeName : font}
                                      forState:UIControlStateSelected];
        }
        if (@available(iOS 13.0, *)) {
            UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
            appearance.backgroundImage = bgImage;
            appearance.shadowImage = shadowImage;
            [appearance configureWithTransparentBackground];
            self.tabBar.standardAppearance = appearance;
        } else {
            [self.tabBar setBackgroundImage:[self yf_imageWithColor:QPColorFromRGB(188, 188, 188)]];
            [self.tabBar setShadowImage:[self yf_imageWithColor:UIColor.clearColor]];
        }
    } else {
        if (@available(iOS 10.0, *)) {
            self.tabBar.unselectedItemTintColor = normalColor;
            self.tabBar.tintColor = selectedColor;
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : font}
                                      forState:UIControlStateNormal];
            [tabBarItem setTitleTextAttributes:@{NSFontAttributeName : font}
                                      forState:UIControlStateSelected];
        } else {
            [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : normalColor,
                                                 NSFontAttributeName : font}
                                      forState:UIControlStateNormal];
            [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedColor,
                                                 NSFontAttributeName : font}
                                      forState:UIControlStateSelected];
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [self adaptThemeStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    QPLog(@"");
}

@end

//
//  QPTabBarController.m
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPTabBarController.h"
#import "QPBaseNavigationController.h"
#import "QPHomeViewController.h"
#import "QPSearchViewController.h"
#import "QPSettingsViewController.h"

@interface QPTabBarController ()

// The property determines whether The dark interface style was truned on.
@property (nonatomic, assign) BOOL isDarkMode;

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
    [self updateTabBarAppearance:NO];
    [self setup];
    [self identifyMode];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self needsStatusBarAppearanceUpdate];
    [self needsUpdateOfSupportedInterfaceOrientations];
}

- (void)updateTabBarAppearance:(BOOL)isDark
{
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [UITabBarAppearance new];
        /// 背景色
        appearance.backgroundColor = isDark ? QPColorFromRGB(20, 20, 20) : UIColor.whiteColor;
        /// 去掉半透明效果
        appearance.backgroundEffect = nil;
        /// 去一条阴影线
        appearance.shadowColor = UIColor.clearColor;
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    }
}

- (void)setup
{
    UIImage *htbItemImage = QPImageNamed(@"tabbar_item_home_00");
    UIImage *htbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_home_01"));
    
    QPHomeViewController *homeVC = [[QPHomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"本地资源"
                                                      image:htbItemImage
                                              selectedImage:htbItemSelectedImage];
    QPBaseNavigationController *hnc = [self tbc_navigationController:homeVC];
    
    UIImage *stbItemImage = QPImageNamed(@"tabbar_item_browser_00");
    UIImage *stbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_browser_01"));
    
    QPSearchViewController *searchVC = [[QPSearchViewController alloc] init];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"打开网址"
                                                        image:stbItemImage
                                                selectedImage:stbItemSelectedImage];
    QPBaseNavigationController *snc = [self tbc_navigationController:searchVC];
    
    UIImage *settbItemImage = QPImageNamed(@"tabbar_item_setting_00");
    UIImage *settbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_setting_01"));
    
    QPSettingsViewController *settingsVC = [[QPSettingsViewController alloc] init];
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                          image:settbItemImage
                                                  selectedImage:settbItemSelectedImage];
    QPBaseNavigationController *setnc = [self tbc_navigationController:settingsVC];
    
    self.viewControllers = @[hnc, snc, setnc];
    self.selectedIndex   = 0;
}

- (BaseNavigationController *)tbc_navigationController:(UIViewController *)viewController
{
    return [[BaseNavigationController alloc] initWithRootViewController:viewController];
}

- (void)identifyMode
{
    if (@available(iOS 13.0, *)) {
        
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        
        if (mode == UIUserInterfaceStyleDark) {
            // Dark Mode
            self.isDarkMode = YES;
        } else if (mode == UIUserInterfaceStyleLight) {
            // Light Mode or unspecified Mode
            self.isDarkMode = NO;
        }
        
    } else {
        
        self.isDarkMode = NO;
    }
    
    [self adjustTabBarThemeStyle];
}

- (void)adjustTabBarThemeStyle
{
    [self updateTabBarAppearance:self.isDarkMode];
    
    UIColor *normalColor = self.isDarkMode ? QPColorFromRGB(200, 200, 200) : [UIColor grayColor];
    
    UIColor *selectedColor = QPColorFromRGB(58, 60, 66);
    if (self.isDarkMode) {
        selectedColor = QPColorFromRGB(39, 220, 203);
    }
    
    UIImage *bgImage = [self imageWithColor:QPColorFromRGB(188, 188, 188)];
    if (self.isDarkMode) {
        bgImage = [self imageWithColor:QPColorFromRGB(88, 88, 88)];
    }
    UIImage *shadowImage = [self imageWithColor:UIColor.clearColor];
    
    UIFont *font = [UIFont boldSystemFontOfSize:13.f];
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    BOOL bValue = [QPlayerExtractValue(kThemeStyleOnOff) boolValue];
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
            
            [self.tabBar setBackgroundImage:[self imageWithColor:QPColorFromRGB(188, 188, 188)]];
            [self.tabBar setShadowImage:[self imageWithColor:UIColor.clearColor]];
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
    [self identifyMode];
}

- (UIImage *(^)(UIImage *image))originalImage
{
    
    UIImage *(^block)(UIImage *image) = ^UIImage *(UIImage *image) {
        UIImageRenderingMode imgRenderingMode = UIImageRenderingModeAlwaysOriginal;
        return [image imageWithRenderingMode:imgRenderingMode];
    };
    
    return block;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

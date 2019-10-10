//
//  TabBarController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

+ (void)initialize {
    // 通过 appearance 统一设置所有 UITabBarItem 的文字属性
    // 带有 UI_APPEARANCE_SELECTOR 的方法, 都可以通过 appearance 对象来统一设置
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttributes = [NSMutableDictionary dictionary];
    selectedAttributes[NSFontAttributeName] = attributes[NSFontAttributeName];
    selectedAttributes[NSForegroundColorAttributeName] = QPColorFromRGB(58, 60, 66);
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    UIImage *htbItemImage = QPImageNamed(@"tabbar_item_home_00");
    UIImage *htbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_home_01"));
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"本地资源"
                                                      image:htbItemImage
                                              selectedImage:htbItemSelectedImage];
    BaseNavigationController *hnc = [self tbc_navigationController:homeVC];
    
    UIImage *stbItemImage = QPImageNamed(@"tabbar_item_browser_00");
    UIImage *stbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_browser_01"));
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"打开网址"
                                                        image:stbItemImage
                                                selectedImage:stbItemSelectedImage];
    BaseNavigationController *snc = [self tbc_navigationController:searchVC];
    
    UIImage *settbItemImage = QPImageNamed(@"tabbar_item_setting_00");
    UIImage *settbItemSelectedImage = self.originalImage(QPImageNamed(@"tabbar_item_setting_01"));
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                          image:settbItemImage
                                                  selectedImage:settbItemSelectedImage];
    BaseNavigationController *setnc = [self tbc_navigationController:settingsVC];
    
    self.viewControllers = @[hnc, snc, setnc];
    self.selectedIndex   = 0;
}

- (UIImage *(^)(UIImage *image))originalImage {
    UIImage *(^block)(UIImage *image) = ^UIImage *(UIImage *image) {
        UIImageRenderingMode imgRenderingMode = UIImageRenderingModeAlwaysOriginal;
        return [image imageWithRenderingMode:imgRenderingMode];
    };
    return block;
}

- (BaseNavigationController *)tbc_navigationController:(UIViewController *)viewController {
    return [[BaseNavigationController alloc] initWithRootViewController:viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

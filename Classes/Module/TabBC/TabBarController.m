//
//  TabBarController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "HomeController.h"
#import "SearchController.h"
#import "SettingsController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabBar];
}

+ (void)initialize {
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = QPColorRGB(58, 60, 66);
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setupTabBar {
    HomeController *hc = [[HomeController alloc] init];
    hc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"本地资源" image:QPImageNamed(@"tab_button_1_home_00") selectedImage:[QPImageNamed(@"tab_button_1_home_01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *nc1 = [[BaseNavigationController alloc] initWithRootViewController:hc];
    
    SearchController *sc = [[SearchController alloc] init];
    sc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"打开网址" image:QPImageNamed(@"tab_button_2_browser_00") selectedImage:[QPImageNamed(@"tab_button_2_browser_01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *nc2 = [[BaseNavigationController alloc] initWithRootViewController:sc];
    
    SettingsController *ssc = [[SettingsController alloc] init];
    ssc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:QPImageNamed(@"tab_button_3_setting_00") selectedImage:[QPImageNamed(@"tab_button_3_setting_01") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    BaseNavigationController *nc3 = [[BaseNavigationController alloc] initWithRootViewController:ssc];
    
    self.viewControllers = @[nc1, nc2, nc3];
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

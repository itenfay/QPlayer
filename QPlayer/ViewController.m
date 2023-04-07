//
//  ViewController.m
//
//  Created by chenxing on 2017/6/29. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "ViewController.h"
#import "QPTabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    QPLog(@"::");
    [self prepareToRenderScreen];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    QPLog(@"::");
    self.view.backgroundColor = QPColorFromRGB(243, 243, 243);
}

- (void)prepareToRenderScreen
{
    QPTabBarController *tabBarController = [[QPTabBarController alloc] init];
    [QPAppDelegate.window setRootViewController:tabBarController];
}

@end

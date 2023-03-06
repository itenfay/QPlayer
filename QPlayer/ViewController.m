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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    QPLog(@"::");
}

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
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QPLog(@"::");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    QPLog(@"::");
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    QPLog(@"::");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    QPLog(@"::");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QPLog(@"::");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    QPLog(@"::");
}

- (void)prepareToRenderScreen
{
    QPTabBarController *tabBarController = [[QPTabBarController alloc] init];
    [QPAppDelegate.window setRootViewController:tabBarController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

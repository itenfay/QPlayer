//
//  ViewController.m
//
//  Created by dyf on 2017/6/29.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "ViewController.h"
#import "TabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        QPLog(@" >>>>>>>>>> ");
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    QPLog(@" >>>>>>>>>> ");
}

- (void)loadView {
    [super loadView];
    QPLog(@" >>>>>>>>>> ");
    [self prepareToRenderScreen];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    QPLog(@" >>>>>>>>>> ");
    self.view.backgroundColor = QPColorFromRGB(243, 243, 243);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    QPLog(@" >>>>>>>>>> ");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    QPLog(@" >>>>>>>>>> ");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    QPLog(@" >>>>>>>>>> ");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    QPLog(@" >>>>>>>>>> ");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    QPLog(@" >>>>>>>>>> ");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    QPLog(@" >>>>>>>>>> ");
}

- (void)prepareToRenderScreen {
    TabBarController *tabBarController = [[TabBarController alloc] init];
    [QPAppDelegate.window setRootViewController:tabBarController];
}

- (BOOL)prefersStatusBarHidden {
    QPLog(@" >>>>>>>>>> ");
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    QPLog(@" >>>>>>>>>> ");
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    QPLog(@" >>>>>>>>>> ");
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    QPLog(@" >>>>>>>>>> ");
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    QPLog(@" >>>>>>>>>> ");
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    QPLog(@" >>>>>>>>>> ");
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    QPLog(@" >>>>>>>>>> ");
}

@end

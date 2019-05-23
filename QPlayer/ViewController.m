//
//  ViewController.m
//
//  Created by dyf on 2017/6/29.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "ViewController.h"
#import "TabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(showViewController) withObject:nil afterDelay:0.1];
}

- (void)showViewController {
    TabBarController *tbc = [[TabBarController alloc] init];
    [self setRootViewController:tbc];
}

- (void)setRootViewController:(UIViewController *)viewController {
    [QPAppDelegate.window setRootViewController:viewController];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

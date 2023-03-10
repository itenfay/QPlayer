//
//  QPHomeViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPHomeViewController.h"
#import "QPLiveViewController.h"

@interface QPHomeViewController ()

@end

@implementation QPHomeViewController

- (void)loadView
{
    CGRect frame = CGRectMake(0, 0, QPScreenWidth, QPScreenHeight - QPStatusBarAndNavigationBarHeight);
    self.homeView = [[QPHomeView alloc] initWithFrame:frame];
    self.view = self.homeView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavigationBar];
    
    self.homeView.adapter = [[QPHomeListViewAdapter alloc] init];
    [self.homeView buildView];
    
    QPHomePresenter *presenter = [[QPHomePresenter alloc] init];
    self.presenter = presenter;
    [presenter loadData];
}

- (void)configureNavigationBar
{
    [super configureNavigationBar];
    [self setNavigationBarTitle:@"本地资源"];
    
    UIButton *liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    liveButton.frame = CGRectMake(0, 0, 30, 30);
    [liveButton setTitle:@"Live" forState:UIControlStateNormal];
    [liveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [liveButton addTarget:self action:@selector(showLiveViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self addRightNavigationBarButton:liveButton];
}

- (void)showLiveViewController:(UIButton *)sender
{
    QPLiveViewController *liveVC = [[QPLiveViewController alloc] init];
    liveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)adaptThemeStyle
{
    [super adaptThemeStyle];
    [self.homeView reloadUI];
}

@end

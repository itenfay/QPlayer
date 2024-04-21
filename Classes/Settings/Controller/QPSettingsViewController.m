//
//  QPSettingsViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPSettingsViewController.h"
#import "QPSettingsPresenter.h"
#import "QPAboutMeViewController.h"

@interface QPSettingsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QPSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat tabW = QPScreenWidth;
        CGFloat tabH = self.view.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tabW, tabH);
        _tableView   = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (void)configureNavigationBar
{
    [self setNavigationBarTitle:@"设置"];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    infoBtn.frame = CGRectMake(0, 0, 20, 20);
    infoBtn.tintColor = UIColor.whiteColor;
    [infoBtn addTarget:self action:@selector(viewMyInfor:) forControlEvents:UIControlEventTouchUpInside];
    infoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [self addRightNavigationBarButton:infoBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavigationBar];
    [self monitorNetworkChangesWithSelector:@selector(networkStatusDidChange:)];
    
    QPSettingsPresenter *presenter = [[QPSettingsPresenter alloc] init];
    presenter.view = self.tableView;
    presenter.viewController = self;
    presenter.mPort = 52013;
    self.presenter = presenter;
    
    self.adapter = [QPListViewAdapter new];
    self.adapter.listViewDelegate = presenter;
    [self setupTableView];
    
    [presenter loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)networkStatusDidChange:(NSNotification *)noti
{
    [self.tableView reloadData];
}

- (void)viewMyInfor:(UIButton *)sender
{
    QPAboutMeViewController *aboutVC = [[QPAboutMeViewController alloc] init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)setupTableView
{
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.dataSource       = _adapter;
    self.tableView.delegate         = _adapter;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight        = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.f;
    self.tableView.estimatedSectionHeaderHeight = 30.f;
    self.tableView.estimatedSectionFooterHeight = 50.f;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.tableView autoresizing];
    [self.view addSubview:self.tableView];
}

- (void)adaptThemeStyle
{
    [super adaptThemeStyle];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [self removeThemeStyleChangedObserver];
    [self stopMonitoringNetworkChanges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

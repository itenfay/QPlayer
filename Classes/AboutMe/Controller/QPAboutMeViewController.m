//
//  QPAboutMeViewController.m
//
//  Created by Tenfay on 2017/6/28.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPAboutMeViewController.h"
#import "QPAboutMePresenter.h"

@interface QPAboutMeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@end

@implementation QPAboutMeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)configureNavigationBar
{
    [self setNavigationBarTitle:@"关于我"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.width     = 30.f;
    backButton.height    = 30.f;
    backButton.left      = 0.f;
    backButton.top       = 0.f;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self addLeftNavigationBarButton:backButton];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavigationBar];
    
    QPAboutMePresenter *presenter = [[QPAboutMePresenter alloc] init];
    presenter.view = self.m_tableView;
    presenter.viewController = self;
    self.presenter = presenter;
    
    self.adapter = [[QPAboutMeListViewAdapter alloc] init];
    self.adapter.listViewDelegate = presenter;
    [self setupTableView];
    
    [presenter loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableInteractivePopGesture:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.m_tableViewBottom.constant = QPViewSafeBottomMargin;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateTableViewHeaderFooter];
}

- (void)setupTableView
{
    self.m_tableView.backgroundColor = UIColor.clearColor;
    self.m_tableView.delegate = _adapter;
    self.m_tableView.dataSource = _adapter;
    self.m_tableView.rowHeight = UITableViewAutomaticDimension;
    self.m_tableView.estimatedRowHeight = 46.f;
    self.m_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (void)adaptThemeStyle
{
    [super adaptThemeStyle];
    [self.m_tableView reloadData];
    [self updateTableViewHeaderFooter];
}

- (void)updateTableViewHeaderFooter
{
    QPAboutMePresenter *presenter = (QPAboutMePresenter *)self.presenter;
    [presenter configTableViewHeaderFooter];
}

@end

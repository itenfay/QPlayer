//
//  QPAboutMeViewController.m
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPAboutMeViewController.h"
#import "QPTitleView.h"
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
    self.navigationItem.hidesBackButton = YES;
    QPTitleView *titleView = [[QPTitleView alloc] init];
    //titleView.backgroundColor = UIColor.redColor;
    titleView.left   = 0.f;
    titleView.top    = 0.f;
    titleView.width  = self.view.width;
    titleView.height = 36.f;
    titleView.userInteractionEnabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.width     = 30.f;
    backButton.height    = 30.f;
    backButton.left      = 0.f;
    backButton.top       = (titleView.height - backButton.height)/2;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 12);
    [titleView addSubview:backButton];
    
    UILabel *titleLabel        = [[UILabel alloc] init];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textColor       = UIColor.whiteColor;
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.tag             = 668;
    titleLabel.height = 30.f;
    titleLabel.left   = backButton.right - 12.f;
    titleLabel.top    = (titleView.height - titleLabel.height)/2;
    titleLabel.width  = titleView.right - titleLabel.left - 2*16.f;
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    [self setupTextForTitleLabel:@"关于我"];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTextForTitleLabel:(NSString *)text
{
    UILabel *titleLabel = [self.navigationItem.titleView viewWithTag:668];
    titleLabel.text = text;
}

- (NSString *)textForTitleLabel
{
    UILabel *titleLabel = [self.navigationItem.titleView viewWithTag:668];
    return titleLabel.text;
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

- (void)setupTableView
{
    self.m_tableView.backgroundColor = UIColor.clearColor;
    self.m_tableView.delegate = _adapter;
    self.m_tableView.dataSource = _adapter;
    //self.m_tableView.rowHeight = UITableViewAutomaticDimension;
    //self.m_tableView.estimatedRowHeight = 40.f;
}

- (void)adaptThemeStyle
{
    [self.m_tableView reloadData];
    [super adaptThemeStyle];
}

@end

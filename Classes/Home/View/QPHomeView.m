//
//  QPHomeView.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPHomeView.h"

@interface QPHomeView ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QPHomeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (UITableView *)mTableView
{
    return _tableView;
}

- (void)buildView
{
    [self setupTableView:_adapter];
    [self setupRefreshHeader];
}

- (void)setupTableView:(QPBaseAdapter *)adapter
{
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.dataSource       = (QPListViewAdapter *)adapter;
    self.tableView.delegate         = (QPListViewAdapter *)adapter;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self.tableView autoresizing];
    [self addSubview:self.tableView];
}

- (void)setupRefreshHeader
{
    @QPWeakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self loadNewData];
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mj_header;
}

- (void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self reloadUI];
    });
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tW   = QPScreenWidth;
        CGFloat tH   = self.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tW, tH);
        _tableView   = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    }
    return _tableView;
}

- (void)reloadUI
{
    [self.tableView reloadData];
}

@end

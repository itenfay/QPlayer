//
//  QPHomeView.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPHomeView.h"

@interface QPHomeView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) HomeReloadDataBlock reloadDataBlock;
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

- (void)buildView
{
    [self setupTableView:_adapter];
    [self setupRefreshHeader];
}

- (void)setupTableView:(QPBaseAdapter *)adapter
{
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource      = (QPListViewAdapter *)adapter;
    self.tableView.delegate        = (QPListViewAdapter *)adapter;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.f;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView autoresizing];
    [self addSubview:self.tableView];
}

- (void)setupRefreshHeader
{
    @QPWeakify(self)
    [self.tableView setupRefreshHeader:^{
        [weak_self loadNewData];
    }];
}

- (void)reloadData:(HomeReloadDataBlock)block
{
    _reloadDataBlock = block;
}

- (void)loadNewData
{
    [self delayToScheduleTask:1.2 completion:^{
        [self endRefreshing];
    }];
    !_reloadDataBlock ?: _reloadDataBlock();
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat tW   = QPScreenWidth;
        CGFloat tH   = self.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tW, tH);
        _tableView   = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    }
    return _tableView;
}

- (void)endRefreshing
{
    if ([self.tableView isRefreshing:QPRefreshPositionHeader]) {
        [self.tableView endRefreshing:QPRefreshPositionHeader];
    }
}

- (void)reloadUI
{
    [self.tableView reloadData];
}

@end

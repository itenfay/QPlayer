//
//  QPHomeView.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPHomeView.h"

@interface QPHomeView ()
@property (nonatomic, strong) UITableView *mTableView;
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

- (UITableView *)tableView
{
    return self.mTableView;
}

- (void)buildView
{
    [self setupTableView:_adapter];
    [self setupRefreshHeader];
}

- (void)setupTableView:(QPBaseAdapter *)adapter
{
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.dataSource      = (QPListViewAdapter *)adapter;
    self.mTableView.delegate        = (QPListViewAdapter *)adapter;
    self.mTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.mTableView.rowHeight       = UITableViewAutomaticDimension;
    self.mTableView.estimatedRowHeight = 60.f;
    self.mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.mTableView autoresizing];
    [self addSubview:self.mTableView];
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

- (void)reloadData:(HomeReloadDataBlock)block
{
    _reloadDataBlock = block;
}

- (void)loadNewData
{
    !_reloadDataBlock ?: _reloadDataBlock();
}

- (UITableView *)mTableView
{
    if (!_mTableView) {
        CGFloat tW   = QPScreenWidth;
        CGFloat tH   = self.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tW, tH);
        _mTableView   = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    }
    return _mTableView;
}

- (void)reloadUI
{
    [self.mTableView reloadData];
}

@end

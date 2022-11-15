//
//  QPHomeView.m
//
//  Created by dyf on 2017/6/28. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import "QPHomeView.h"

@implementation QPHomeView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)buildHomeView:(QPBaseAdapter *)adapter {
    [self buildTableView:adapter];
    [self buildMJRefreshHeader];
}

- (void)buildTableView:(QPBaseAdapter *)adapter {
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.dataSource       = (QPListViewAdapter *)adapter;
    self.tableView.delegate         = (QPListViewAdapter *)adapter;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleTopMargin  |
                                       UIViewAutoresizingFlexibleWidth      |
                                       UIViewAutoresizingFlexibleHeight);
    
    [self addSubview:self.tableView];
}

- (void)buildMJRefreshHeader {
    @QPWeakify(self)
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self loadNewData];
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = mj_header;
}

- (void)loadNewData {
    //[self loadFileList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self reloadData];
    });
}

- (void)reloadData {
    [self.tableView reloadData];
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

@end

//
//  UIScrollView+QPAdditions.m
//
//  Created by Tenfay on 2016/1/10. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2016 Tenfay. All rights reserved.
//

#import "UIScrollView+QPAdditions.h"

@implementation UIScrollView (QPAdditions)

- (void)setupRefreshHeaderWithTarget:(id)target aciton:(SEL)action
{
    [self setupRefreshHeaderWithTarget:target aciton:action updatedTimeHidden:YES automaticallyChangeAlpha:YES];
}

- (void)setupRefreshHeaderWithTarget:(id)target aciton:(SEL)action updatedTimeHidden:(BOOL)hidden automaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = hidden;
    header.automaticallyChangeAlpha = automaticallyChangeAlpha;
    self.mj_header = header;
}

- (void)setupRefreshHeader:(void(^)(void))refreshingBlock
{
    [self setupRefreshHeader:refreshingBlock updatedTimeHidden:YES automaticallyChangeAlpha:YES];
}

- (void)setupRefreshHeader:(void(^)(void))refreshingBlock updatedTimeHidden:(BOOL)hidden automaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refreshingBlock();
    }];
    header.lastUpdatedTimeLabel.hidden = hidden;
    header.automaticallyChangeAlpha = automaticallyChangeAlpha;
    self.mj_header = header;
}

- (void)setupRefreshFooterWithTarget:(id)target aciton:(SEL)action
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setTitle:@"-- 我是有底线的 --" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = QPColorFromHex(999999);
    self.mj_footer = footer;
}

- (void)setupRefreshFooter:(void(^)(void))refreshingBlock
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:refreshingBlock];
    [footer setTitle:@"-- 我是有底线的 --" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = QPColorFromHex(999999);
    self.mj_footer = footer;
}

- (BOOL)isRefreshing:(QPRefreshPosition)position
{
    BOOL isRefreshing = NO;
    switch (position) {
        case QPRefreshPositionHeader:
            isRefreshing = [self.mj_header isRefreshing];
            break;
        case QPRefreshPositionFooter:
            isRefreshing = [self.mj_footer isRefreshing];
            break;
        default:
            break;
    }
    return isRefreshing;
}

- (void)beginRefreshing:(QPRefreshPosition)position
{
    switch (position) {
        case QPRefreshPositionHeader:
            [self.mj_header beginRefreshing];
            break;
        case QPRefreshPositionFooter:
            [self.mj_footer beginRefreshing];
            break;
        default:
            break;
    }
}

- (void)endRefreshing:(QPRefreshPosition)position
{
    switch (position) {
        case QPRefreshPositionHeader:
            [self.mj_header endRefreshing];
            break;
        case QPRefreshPositionFooter:
            [self.mj_header endRefreshing];
            break;
        default:
            break;
    }
}

- (void)noticeNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    [self.mj_footer resetNoMoreData];
}

@end

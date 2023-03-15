//
//  UIScrollView+QPAdditions.h
//
//  Created by chenxing on 2016/1/10. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2016 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QPRefreshPosition) {
    QPRefreshPositionHeader,
    QPRefreshPositionFooter,
};

@interface UIScrollView (QPAdditions)

- (void)setupRefreshHeaderWithTarget:(id)target aciton:(SEL)action;
- (void)setupRefreshHeaderWithTarget:(id)target aciton:(SEL)action updatedTimeHidden:(BOOL)hidden automaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha;
- (void)setupRefreshHeader:(void(^)(void))refreshingBlock;
- (void)setupRefreshHeader:(void(^)(void))refreshingBlock updatedTimeHidden:(BOOL)hidden automaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha;
- (void)setupRefreshFooterWithTarget:(id)target aciton:(SEL)action;
- (void)setupRefreshFooter:(void(^)(void))refreshingBlock;
- (BOOL)isRefreshing:(QPRefreshPosition)position;
- (void)beginRefreshing:(QPRefreshPosition)position;
- (void)endRefreshing:(QPRefreshPosition)position;
- (void)resetNoMoreData;
- (void)noticeNoMoreData;

@end

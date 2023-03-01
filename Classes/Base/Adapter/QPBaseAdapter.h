//
//  QPBaseAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPBaseDelegate.h"
#import "QPBaseModel.h"

@class QPListViewAdapter;

@protocol QPListViewAdapterDelegate <QPBaseDelegate>

@optional
/// The number of sections in tableView.
/// @param adapter The adapter for tableView.
- (NSInteger)numberOfSectionsForAdapter:(QPListViewAdapter *)adapter;

/// Returns a nonnegative floating-point value that specifies the height (in points) of the header for section.
/// @param section An index number identifying a section of tableView.
/// @param adapter The adapter for tableView.
- (CGFloat)heightForHeaderInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

/// Returns the view object to display at the top of the specified section
/// @param section The index number of the section containing the header view.
/// @param adapter The adapter for tableView.
- (UIView *)viewForHeaderInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

- (CGFloat)heightForFooterInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

- (UIView *)viewForFooterInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;
- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)selectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath;
- (void)deselectCell:(QPBaseModel *)model AtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)deleteCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol QPScrollViewAdapterDelegate <QPBaseDelegate>

@optional
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

@end

@interface QPBaseAdapter : NSObject

@property (nonatomic, weak) id<QPScrollViewAdapterDelegate> scrollViewDelegate;
@property (nonatomic, weak) id<QPListViewAdapterDelegate> listViewDelegate;

@end

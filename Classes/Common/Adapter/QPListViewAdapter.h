//
//  QPListViewAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPBaseAdapter.h"
#import "QPBaseListViewCell.h"
#import "QPBaseModel.h"
#import "QPBaseDelegate.h"

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

@end

@interface QPListViewAdapter : QPBaseAdapter <UITableViewDelegate, UITableViewDataSource>

/// The data source.
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

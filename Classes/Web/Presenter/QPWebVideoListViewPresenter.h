//
//  QPWebVideoListViewPresenter.h
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "BasePresenter.h"
#import "QPWebVideoListViewAdapter.h"
#import "QPWebVideoListModel.h"

// When a closed action is performed, it's called.
typedef void (^WebVideoListViewOnCloseHandler)(void);

// When a cell row has been selected, it's called.
typedef void (^WebVideoListViewOnSelectRowHandler)(NSInteger selectedRow, NSString *title, NSString *content);

@interface QPWebVideoListViewPresenter : BasePresenter <QPPresenterDelegate, ListViewAdapterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) WebVideoListViewOnCloseHandler onCloseHandler;
@property (nonatomic, copy) WebVideoListViewOnSelectRowHandler onSelectRowHandler;

- (void)loadData:(NSArray *)urls;

@end

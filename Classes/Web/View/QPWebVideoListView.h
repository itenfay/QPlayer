//
//  QPWebVideoListView.h
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseView.h"
#import "QPWebVideoListViewPresenter.h"
#import "QPWebVideoListViewAdapter.h"

@interface QPWebVideoListView : BaseView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

// A view that presents data using rows arranged in a single column.
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// A control that executes your custom code in response to user interactions.
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, assign, readonly) BOOL isDarkMode;

@property (nonatomic, strong) QPWebVideoListViewAdapter *adapter;

- (QPWebVideoListViewPresenter *)presenter;

// Carries out a action for closing with a `WebVideoListViewOnCloseHandler` handler.
- (void)onCloseAction:(WebVideoListViewOnCloseHandler)completionHandler;

// Carries out a action for selecting row with a `WebVideoListViewOnSelectRowHandler` handler.
- (void)onSelectRow:(WebVideoListViewOnSelectRowHandler)completionHandler;

- (void)refreshUI;

@end

//
//  BaseView.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseView.h"
#import "QPListViewAdapter.h"
#import "QPModularDelegate.h"
#import "QPHomeListViewAdapter.h"

typedef void(^HomeReloadDataBlock)(void);

@protocol QPHomeViewDelegate <BaseDelegate>

@optional
- (void)reloadUI;

@end

@interface QPHomeView : BaseView <QPHomeViewDelegate>

@property (nonatomic, strong) QPHomeListViewAdapter *adapter;

- (UITableView *)tableView;

- (void)buildView;
- (void)reloadData:(HomeReloadDataBlock)block;

@end

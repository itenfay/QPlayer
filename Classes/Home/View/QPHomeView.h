//
//  QPBaseView.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseView.h"
#import "QPListViewAdapter.h"
#import "QPModularDelegate.h"
#import "QPHomeListViewAdapter.h"

typedef void(^HomeReloadDataBlock)();

@interface QPHomeView : QPBaseView <QPHomeViewDelegate>

@property (nonatomic, strong) QPListViewAdapter *adapter;

- (UITableView *)tableView;

- (void)buildView;
- (void)reloadData:(HomeReloadDataBlock)block;

@end

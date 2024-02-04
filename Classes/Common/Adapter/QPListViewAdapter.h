//
//  QPListViewAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "BaseAdapter.h"
#import "BaseModel.h"
#import "BaseAdapter.h"

@interface QPListViewAdapter : BaseListViewAdapter <UITableViewDelegate, UITableViewDataSource>

/// The data source.
@property (nonatomic, strong) NSMutableArray *dataSource;

- (UITableView *)tableView;

- (BaseModel *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateModel:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (UIView *)viewForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForFooterInSection:(NSInteger)section;
- (UIView *)viewForFooterInSection:(NSInteger)section;

@end

//
//  QPListViewAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPBaseAdapter.h"
#import "QPBaseModel.h"
#import "QPBaseAdapter.h"

@interface QPListViewAdapter : QPBaseAdapter <UITableViewDelegate, UITableViewDataSource>

/// The data source.
@property (nonatomic, strong) NSMutableArray *dataSource;

- (QPBaseModel *)modelWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end

//
//  QPListViewAdapter.m
//
//  Created by dyf on 2015/6/18. ( https://github.com/dgynfi/QPlayer )
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "QPListViewAdapter.h"

@interface QPListViewAdapter ()

@end

@implementation QPListViewAdapter

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return  0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.numberOfSections > 1) {
        
        NSMutableArray *models = self.dataArray[section];
        return models.count;
        
    }
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QPBaseModel *model = nil;
    
    if (tableView.numberOfSections > 1) {
        
        NSMutableArray *modelArray = self.dataArray[indexPath.section];
        model = modelArray[indexPath.row];
    } else {
        
        model = self.dataArray[indexPath.row];
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // [weak_self deleteRowAtIndexPath:indexPath];
    }];
    
    return @[deleteRowAction];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        FileModel *fileModel = self.localFileList[indexPath.row];
//
//        if ([FileHelper removeLocalFile:fileModel.name]) {
//            // Delete data for datasource, delete row from table.
//            [self.localFileList removeObjectAtIndex:indexPath.row];
//
//            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        }
//    }
//}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end

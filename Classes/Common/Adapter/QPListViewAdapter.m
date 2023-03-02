//
//  QPListViewAdapter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPListViewAdapter.h"

@interface QPListViewAdapter ()

@end

@implementation QPListViewAdapter

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(numberOfSectionsForAdapter:))) {
        return [self.listViewDelegate numberOfSectionsForAdapter:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.numberOfSections > 1 && section < self.dataSource.count) {
        id obj = self.dataSource[section];
        if ([obj isKindOfClass:NSArray.class]) {
            NSArray *models = (NSArray *)obj;
            return models.count;
        }
        return 1;
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(heightForHeaderInSection:forAdapter:))) {
        return [self.listViewDelegate heightForHeaderInSection:section forAdapter:self];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(viewForHeaderInSection:forAdapter:))) {
        return [self.listViewDelegate viewForHeaderInSection:section forAdapter:self];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(heightForFooterInSection:forAdapter:))) {
        [self.listViewDelegate heightForFooterInSection:section forAdapter:self];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(viewForFooterInSection:forAdapter:))) {
        return [self.listViewDelegate viewForFooterInSection:section forAdapter:self];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(heightForRowAtIndexPath:forAdapter:))) {
        return [self.listViewDelegate heightForRowAtIndexPath:indexPath forAdapter:self];
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(cellForRowAtIndexPath:forAdapter:))) {
        return [self.listViewDelegate cellForRowAtIndexPath:indexPath forAdapter:self];
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(willDisplayCell:atIndexPath:forAdapter:))) {
        [self.listViewDelegate willDisplayCell:cell atIndexPath:indexPath forAdapter:self];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(didEndDisplayingCell:atIndexPath:forAdapter:))) {
        [self.listViewDelegate didEndDisplayingCell:cell atIndexPath:indexPath forAdapter:self];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    QPBaseModel *model = [self modelWithTableView:tableView atIndexPath:indexPath];
    if (QPRespondsToSelector(self.listViewDelegate, @selector(selectCell:atIndexPath:forAdapter:))) {
        [self.listViewDelegate selectCell:model atIndexPath:indexPath forAdapter:self];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QPBaseModel *model = [self modelWithTableView:tableView atIndexPath:indexPath];
    if (QPRespondsToSelector(self.listViewDelegate, @selector(deselectCell:atIndexPath:forAdapter:))) {
        [self.listViewDelegate deselectCell:model atIndexPath:indexPath forAdapter:self];
    }
}

- (QPBaseModel *)modelWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    QPBaseModel *model = nil;
    if (tableView.numberOfSections > 1 && indexPath.section < self.dataSource.count) {
        id obj = self.dataSource[indexPath.section];
        if ([obj isKindOfClass:NSArray.class]) {
            NSArray *array = (NSArray *)obj;
            if (indexPath.row < array.count) {
                model = array[indexPath.row];
            }
        } else {
            model = obj;
        }
    } else {
        model = self.dataSource[indexPath.row];
    }
    return model;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end

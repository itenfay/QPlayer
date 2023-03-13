//
//  QPListViewHeaderFooterAdapter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/13.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPListViewHeaderFooterAdapter.h"

@implementation QPListViewHeaderFooterAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self viewForFooterInSection:section];
}

@end

@implementation QPListViewHeaderAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self viewForHeaderInSection:section];
}

@end

@implementation QPListViewFooterAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self viewForFooterInSection:section];
}

@end

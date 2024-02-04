//
//  QPHomeListViewAdapter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPHomeListViewAdapter.h"

@interface QPHomeListViewAdapter ()

@end

@implementation QPHomeListViewAdapter

- (void)bindModelTo:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withViewController:(BaseViewController *)viewController
{
    QPFileTableViewCell *_cell = (QPFileTableViewCell *)cell;
    QPFileModel *model = (QPFileModel *)[self modelAtIndexPath:indexPath];
    [_cell.presenter presentWithModel:model viewController:viewController];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @QPWeakify(self);
    UIContextualAction *deleteAciton = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weak_self deleteRowWithTableView:tableView atIndexPath:indexPath];
    }];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAciton]];
    config.performsFirstActionWithFullSwipe = NO; // YES: 允许侧滑删除
    return config;
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    @QPWeakify(self);
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [weak_self deleteRowWithTableView:tableView atIndexPath:indexPath];
//    }];
//    return @[deleteRowAction];
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self deleteRowWithTableView:tableView atIndexPath:indexPath];
//    }
//}

- (void)deleteRowWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (QPRespondsToSelector(self.listViewDelegate, @selector(deleteCell:atIndexPath:forAdapter:))) {
        BaseModel *model = [self modelAtIndexPath:indexPath];
        if ([self.listViewDelegate deleteCell:model atIndexPath:indexPath forAdapter:self]) {
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end

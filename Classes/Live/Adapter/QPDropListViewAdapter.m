//
//  QPDropListViewAdapter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPDropListViewAdapter.h"
#import "QPDropListViewCell.h"
#import "QPDropListModel.h"
#import "QPDropListView.h"

@interface QPDropListViewAdapter () <UITextFieldDelegate>
@property (nonatomic, weak) QPDropListView *dropListView;
@end

@implementation QPDropListViewAdapter

- (void)bindModelTo:(QPDropListViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withView:(UIView *)view
{
    QPDropListModel *model = (QPDropListModel *)[self modelAtIndexPath:indexPath];
    self.dropListView = (QPDropListView *)view;
    
    cell.m_titleLabel.text = model.m_title;
    cell.m_titleLabel.textColor = _dropListView.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(50, 50, 50);
    cell.m_titleLabel.font = [UIFont systemFontOfSize:13];
    //cell.m_titleLabel.numberOfLines = 2;
    
    cell.m_detailLabel.text = model.m_content;
    cell.m_detailLabel.textColor = _dropListView.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(50, 50, 50);
    cell.m_detailLabel.font = [UIFont systemFontOfSize:13];
    //cell.m_detailLabel.numberOfLines = 2;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @QPWeakify(self);
    UIContextualAction *editAciton = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"编辑" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [weak_self showEditAlertWithIndexPath:indexPath];
    }];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[editAciton]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (void)showEditAlertWithIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"编辑" message:@"是否更新播放URL？" preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.placeholder = @"请输入或拷贝新的播放URL";
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        QPLog(@"Action.title=%@", action.title);
    }];
    [vc addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        QPLog(@"Action.title=%@", action.title);
        [self updateURL:vc.textFields.firstObject.text atIndexPath:indexPath];
    }];
    [vc addAction:confirmAction];
    
    [self.tf_currentViewController presentViewController:vc animated:YES completion:^{}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)updateURL:(NSString *)url atIndexPath:(NSIndexPath *)indexPath
{
    if (url == nil || [url isEqualToString:@""]) {
        [_dropListView refreshUI];
        return;
    }
    UITableView *tableView = _dropListView.m_tableView;
    
    QPDropListViewCell *cell = (QPDropListViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.m_detailLabel.text = url;
    
    QPDropListModel *model = QPDropListModel.alloc.init;
    model.m_title = cell.m_titleLabel.text;
    model.m_content = url;
    [self updateModel:model atIndexPath:indexPath];
    
    [_dropListView.presenter updateValue:url atIndex:indexPath.row];
    [_dropListView refreshUI];
}

@end

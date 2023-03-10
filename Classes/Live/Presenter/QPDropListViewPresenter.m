//
//  QPDropListViewPresenter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPDropListViewPresenter.h"
#import "QPDropListViewCell.h"
#import "QPDropListView.h"

NSString *const kResourceBundle   = @"QPDropListView.bundle";
NSString *const kDropListDataFile = @"DropListViewData.plist";

// Transforms two objects's title to pinying and sorts them.
NSInteger sortObjects(QPDropListModel *obj1, QPDropListModel *obj2, void *context)
{
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:obj1.m_title];
    if (CFStringTransform((__bridge CFMutableStringRef)str1,
                          0,
                          kCFStringTransformMandarinLatin, NO)) {
    }
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:obj2.m_title];
    if (CFStringTransform((__bridge CFMutableStringRef)str2,
                          0,
                          kCFStringTransformMandarinLatin, NO)) {
    }
    return [str1 localizedCompare:str2];
}

@implementation QPDropListViewPresenter

- (QPDropListView *)dropListView
{
    return (QPDropListView*)_view;
}

- (void)loadData
{
    [QPHudUtils showActivityMessageInWindow:@"正在加载数据..."];
    [[self dropListView].adapter.dataSource removeAllObjects];
    
    // QPDropListView.bundle -> DropListViewData.plist
    NSString *path       = [NSBundle.mainBundle pathForResource:kResourceBundle ofType:nil];
    NSString *bundlePath = [NSBundle bundleWithPath:path].bundlePath;
    NSString *filePath   = [bundlePath stringByAppendingPathComponent:kDropListDataFile];
    QPLog(@":: filePath=%@", filePath);
    
    //NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    //NSEnumerator *enumerator = [dict keyEnumerator];
    //id key;
    //while ((key = [enumerator nextObject]) != nil) {
    //    NSString *content = [dict objectForKey:key];
    //    QPDropListModel *model = [[QPDropListModel alloc] init];
    //    model.m_title = key;
    //    model.m_content = content;
    //    [[self dropListView].adapter.dataSource addObject:model];
    //}
    
    NSArray *tvList = [NSArray arrayWithContentsOfFile:filePath];
    NSEnumerator *enumerator = [tvList objectEnumerator];
    id obj;
    while ((obj = [enumerator nextObject]) != nil) {
        NSDictionary *dict = (NSDictionary *)obj;
        QPDropListModel *model = [[QPDropListModel alloc] init];
        model.m_title = dict.allKeys.firstObject;
        model.m_content = dict.allValues.firstObject;
        [[self dropListView].adapter.dataSource addObject:model];
    }
    [[self dropListView].adapter.dataSource sortUsingFunction:sortObjects context:NULL];
    
    [self delayToScheduleTask:0.5 completion:^{
        [QPHudUtils hideHUD];
        [[self dropListView] refreshUI];
    }];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    static NSString *cellID = @"DropListViewCellIdentifier";
    
    QPDropListView *dropListView = [self dropListView];
    QPDropListViewCell *cell = [dropListView.m_tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QPDropListViewCell class]) bundle:nil];
        cell = [nib instantiateWithOwner:nil options:nil].firstObject;
    }
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle  = UITableViewCellSelectionStyleGray;
    
    [[self dropListView].adapter bindModelTo:cell
                                 atIndexPath:indexPath
                                 inTableView:dropListView.m_tableView
                                    withView:_view];
    return cell;
}

- (void)selectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    QPDropListModel *_model = (QPDropListModel *)model;
    QPLog(@":: title=%@, content=%@", _model.m_title, _model.m_content);
    !self.onSelectRowHandler ?:
    self.onSelectRowHandler(indexPath.row, _model.m_title, _model.m_content);
}

@end

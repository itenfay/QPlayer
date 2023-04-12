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

@implementation QPDropListViewPresenter

- (QPDropListView *)dropListView
{
    return (QPDropListView*)_view;
}

- (NSString *)customBundleFilePath
{
    NSString *path = [NSBundle.mainBundle pathForResource:kResourceBundle ofType:nil];
    NSString *bundlePath = [NSBundle bundleWithPath:path].bundlePath;
    return [bundlePath stringByAppendingPathComponent:kDropListDataFile];
}

- (void)updateValue:(NSString *)value atIndex:(NSInteger)index
{
    NSString *filePath = [self customBundleFilePath];
    QPLog(@":: filePath=%@", filePath);
    NSMutableArray *list = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (index > 0 && index < list.count) {
        NSMutableDictionary *dict = ((NSDictionary *)[list objectAtIndex:index]).mutableCopy;
        [dict setValue:value forKey:dict.allKeys.firstObject];
        [list replaceObjectAtIndex:index withObject:dict];
        if (@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)) {
            [list writeToURL:[NSURL fileURLWithPath:filePath] error:nil];
        } else {
            [list writeToFile:filePath atomically:YES];
        }
    }
}

- (void)loadData
{
    [QPHudUtils showActivityMessageInWindow:@"加载中，请稍等..."];
    [self fetchDataSource];
    [self delayToScheduleTask:0.5 completion:^{
        [QPHudUtils hideHUD];
        [[self dropListView] refreshUI];
    }];
}

- (void)fetchDataSource
{
    [[self dropListView].adapter.dataSource removeAllObjects];
    
    NSString *filePath = [self customBundleFilePath];
    QPLog(@":: filePath=%@", filePath);
    
    NSArray *tvList;
    if (@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)) {
        tvList = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    } else {
        tvList = [NSArray arrayWithContentsOfFile:filePath];
    }
    NSEnumerator *enumerator = [tvList objectEnumerator];
    id obj;
    while ((obj = [enumerator nextObject]) != nil) {
        NSDictionary *dict = (NSDictionary *)obj;
        QPDropListModel *model = [[QPDropListModel alloc] init];
        model.m_title = dict.allKeys.firstObject;
        model.m_content = dict.allValues.firstObject;
        model.sortName = model.m_title;
        [[self dropListView].adapter.dataSource addObject:model];
    }
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

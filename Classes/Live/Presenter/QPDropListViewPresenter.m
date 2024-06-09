//
//  QPDropListViewPresenter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPDropListViewPresenter.h"
#import "QPDropListViewCell.h"
#import "QPDropListView.h"

NSString *const kResourceBundle   = @"QPDropListView.bundle";
NSString *const kDropListDataFile = @"DropListViewData.dat";

@implementation QPDropListViewPresenter

- (QPDropListView *)dropListView
{
    return (QPDropListView*)_view;
}

- (NSString *)customBundlePath
{
    // QPDropListView.bundle
    NSString *path = [NSBundle.mainBundle pathForResource:kResourceBundle ofType:nil];
    NSString *bundlePath = [NSBundle bundleWithPath:path].bundlePath;
    return bundlePath;
}

- (NSString *)customTVFilePath
{
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:kDropListDataFile];
    if (![fileManager fileExistsAtPath:filePath]) {
        /// 沙箱根目录下文件无写入权限
        NSString *srcPath = [NSBundle.mainBundle pathForResource:kDropListDataFile ofType:nil];
        [self writeData:srcPath toFile:filePath];
    }
    return filePath;
}

- (BOOL)writeData:(NSString *)srcPath toFile:(NSString *)filePath
{
    NSMutableArray *tvList = [NSMutableArray arrayWithContentsOfFile:srcPath];
    BOOL ret = NO;
    if (@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)) {
        NSError *error = nil;
        ret = [tvList writeToURL:[NSURL fileURLWithPath:filePath] error:&error];
        if (error) {
            QPLog(@"[writeToURL] error=%zi, %@", error.code, error.localizedDescription);
        }
    } else {
        ret = [tvList writeToFile:filePath atomically:YES];
        if (!ret) {
            QPLog(@"[writeToFile] ret=%d", ret);
        }
    }
    return ret;
}

- (void)updateValue:(NSString *)value atIndex:(NSInteger)index
{
    NSString *filePath = [self customTVFilePath];
    QPLog(@"filePath=%@", filePath);
    
    /// 设置访问权限
    //NSFileManager *fileManager = NSFileManager.defaultManager;
    //NSDictionary *attributes = @{NSFilePosixPermissions : @(666)};
    //NSError *permissionsError = nil;
    //[fileManager setAttributes:attributes ofItemAtPath:filePath error:&permissionsError];
    //if (permissionsError) {
    //    QPLog(@"[setAttributes] error=%zi, %@", permissionsError.code, permissionsError.localizedDescription);
    //}
    
    NSMutableArray *tvList = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (index >= 0 && index < tvList.count) {
        NSMutableDictionary *dict = ((NSDictionary *)tvList[index]).mutableCopy;
        [dict setValue:value forKey:dict.allKeys.firstObject];
        [tvList replaceObjectAtIndex:index withObject:dict];
        BOOL ret = NO;
        if (@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)) {
            NSError *error = nil;
            ret = [tvList writeToURL:[NSURL fileURLWithPath:filePath] error:&error];
            if (error) {
                QPLog(@"[writeToURL] error=%zi, %@", error.code, error.localizedDescription);
            }
        } else {
            ret = [tvList writeToFile:filePath atomically:YES];
            if (!ret) {
                QPLog(@"[writeToFile] ret=%d", ret);
            }
        }
    }
}

- (void)loadData
{
    [QPHudUtils showActivityMessageInWindow:@"加载中，请稍等"];
    [self fetchDataSource];
    [self delayToScheduleTask:0.3 completion:^{
        [QPHudUtils hideHUD];
        [[self dropListView] refreshUI];
    }];
}

- (void)fetchDataSource
{
    [[self dropListView].adapter.dataSource removeAllObjects];
    
    NSString *filePath = [self customTVFilePath];
    QPLog(@"filePath=%@", filePath);
    
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
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    [[self dropListView].adapter bindModelTo:cell
                                 atIndexPath:indexPath
                                    withView:_view];
    
    return cell;
}

- (void)selectCell:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    QPDropListModel *_model = (QPDropListModel *)model;
    QPLog(@"title=%@, content=%@", _model.m_title, _model.m_content);
    !self.onSelectRowHandler ?:
    self.onSelectRowHandler(indexPath.row, _model.m_title, _model.m_content);
}

@end

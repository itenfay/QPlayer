//
//  QPWebVideoListViewPresenter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPWebVideoListViewPresenter.h"
#import "QPWebVideoListViewCell.h"
#import "QPWebVideoListView.h"

@implementation QPWebVideoListViewPresenter

- (QPWebVideoListView *)videoListView
{
    return (QPWebVideoListView*)_view;
}

- (void)loadData:(NSArray *)urls;
{
    [[self videoListView].adapter.dataSource removeAllObjects];
    for (int i = 0; i < urls.count; i++) {
        NSString *url = urls[i];
        QPWebVideoListModel *model = [[QPWebVideoListModel alloc] init];
        model.m_title = [NSString stringWithFormat:@"视频%d", i + 1];
        model.m_content = [url stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        model.sortName = [NSString stringWithFormat:@"%d", i];
        [[self videoListView].adapter.dataSource addObject:model];
    }
    [[self videoListView] refreshUI];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    static NSString *cellID = @"WebVideoListViewCellIdentifier";
    
    QPWebVideoListView *listView = [self videoListView];
    QPWebVideoListViewCell *cell = [listView.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([QPWebVideoListViewCell class]) bundle:nil];
        cell = [nib instantiateWithOwner:nil options:nil].firstObject;
    }
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.backgroundColor = UIColor.clearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[self videoListView].adapter bindModelTo:cell atIndexPath:indexPath withView:_view];
    
    return cell;
}

- (void)selectCell:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    QPWebVideoListModel *_model = (QPWebVideoListModel *)model;
    QPLog(@"title=%@, content=%@", _model.m_title, _model.m_content);
    !self.onSelectRowHandler ?: self.onSelectRowHandler(indexPath.row, _model.m_title, _model.m_content);
}

@end

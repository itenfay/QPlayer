//
//  QPDropListViewAdapter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPDropListViewAdapter.h"
#import "QPDropListViewCell.h"
#import "QPDropListModel.h"
#import "QPDropListView.h"

@implementation QPDropListViewAdapter

- (void)bindModelTo:(QPDropListViewCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView withView:(UIView *)view
{
    QPDropListModel *model = (QPDropListModel *)[self modelWithTableView:tableView atIndexPath:indexPath];
    QPDropListView *dropListView = (QPDropListView *)view;
    cell.m_titleLabel.text = model.m_title;
    cell.m_titleLabel.textColor = dropListView.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(50, 50, 50);
    cell.m_titleLabel.font = [UIFont systemFontOfSize:13];
    //cell.m_titleLabel.numberOfLines = 2;
    
    cell.m_detailLabel.text = model.m_content;
    cell.m_detailLabel.textColor = dropListView.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(50, 50, 50);
    cell.m_detailLabel.font = [UIFont systemFontOfSize:13];
    //cell.m_detailLabel.numberOfLines = 2;
}

@end

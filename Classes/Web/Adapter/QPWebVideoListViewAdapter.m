//
//  QPWebVideoListViewAdapter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPWebVideoListViewAdapter.h"
#import "QPWebVideoListViewCell.h"
#import "QPWebVideoListModel.h"
#import "QPWebVideoListView.h"

@interface QPWebVideoListViewAdapter () <UITextFieldDelegate>
@property (nonatomic, weak) QPWebVideoListView *videoListView;
@end

@implementation QPWebVideoListViewAdapter

- (void)bindModelTo:(QPWebVideoListViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withView:(UIView *)view
{
    QPWebVideoListModel *model = (QPWebVideoListModel *)[self modelAtIndexPath:indexPath];
    _videoListView = (QPWebVideoListView *)view;
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%@：%@", model.m_title, model.m_content];
    cell.contentLabel.textColor = _videoListView.isDarkMode ? QPColorFromHex(0x333333) : QPColorFromHex(0xFFFFFF);
    cell.contentLabel.font = [UIFont systemFontOfSize:14];
    //cell.contentLabel.numberOfLines = 2;
    
    cell.divider.backgroundColor = _videoListView.isDarkMode ? QPColorFromHex(0x999999) : QPColorFromHex(0xFFFFFF);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return false;
}

@end

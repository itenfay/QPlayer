//
//  QPAboutMeListViewAdapter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPAboutMeListViewAdapter.h"
#import "QPAboutModel.h"

@implementation QPAboutMeListViewAdapter

- (void)bindModelTo:(UITableViewCell *)cell
        atIndexPath:(NSIndexPath *)indexPath
        inTableView:(UITableView *)tableView
 withViewController:(QPBaseViewController *)viewController
{
    QPAboutModel *model = (QPAboutModel *)[self modelWithTableView:tableView atIndexPath:indexPath];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.rValue;
    cell.textLabel.textColor  = viewController.isDarkMode ?  QPColorFromRGB(220, 220, 220) : QPColorFromRGB(100, 100, 100);
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
}

@end

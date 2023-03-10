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
    cell.backgroundColor = viewController.isDarkMode ? QPColorFromRGB(20, 20, 20) : QPColorFromRGB(246, 246, 246);
    cell.selectionStyle = viewController.isDarkMode ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleDefault;
    cell.textLabel.textColor = viewController.isDarkMode ? QPColorFromRGB(220, 220, 220) : QPColorFromRGB(100, 100, 100);
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.textColor = viewController.isDarkMode ? QPColorFromRGB(220, 220, 220) : QPColorFromRGB(100, 100, 100);
    QPAboutModel *model = (QPAboutModel *)[self modelWithTableView:tableView atIndexPath:indexPath];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.rValue;
}

@end

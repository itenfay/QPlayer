//
//  QPAboutMePresenter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPAboutMePresenter.h"
#import "QPAboutMeViewController.h"
#import "QPAboutModel.h"
#import "QPAboutMeTableHeader.h"
#import "QPAboutMeTableFooter.h"

#define AboutMeTableHeaderHeight 300.f
#define AboutMeTableCellHeight    46.f

@implementation QPAboutMePresenter

- (QPAboutMeViewController *)aboutMeController
{
    return (QPAboutMeViewController *)_viewController;
}

- (void)loadData
{
    QPAboutMeViewController *vc = [self aboutMeController];
    [vc.adapter.dataSource removeAllObjects];
    
    NSString *vString = [NSString stringWithFormat:@"%@.%@", QPAppVersion, QPBuildVersion];
    QPAboutModel *vModel = [QPAboutModel new];
    vModel.title = @"版本";
    vModel.rValue = vString;
    [vc.adapter.dataSource addObject:vModel];
    
    NSString *gString = [NSString stringWithFormat:@" ★ "];
    QPAboutModel *gModel = [QPAboutModel new];
    gModel.title = @"Star";
    gModel.rValue = gString;
    [vc.adapter.dataSource addObject:gModel];
    
    NSString *hString = [NSString stringWithFormat:@"Home"];
    QPAboutModel *hModel = [QPAboutModel new];
    hModel.title = @"GitHub";
    hModel.rValue = hString;
    [vc.adapter.dataSource addObject:hModel];
    
    NSString *rString = [NSString stringWithFormat:@"Repositories"];
    QPAboutModel *rModel = [QPAboutModel new];
    rModel.title = @"GitHub";
    rModel.rValue = rString;
    [vc.adapter.dataSource  addObject:rModel];
    
    NSString *eString = [QPInfoDictionary objectForKey:@"MyEmail"];
    QPAboutModel *eModel = [QPAboutModel new];
    eModel.title = @"Email";
    eModel.rValue = eString;
    [vc.adapter.dataSource  addObject:eModel];
    
    [_view reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat headerH = AboutMeTableHeaderHeight;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    //QPLog(@"%f, %f", scrollView.contentOffset.x, offsetY);
//    if (scrollView == self.m_tableView) {
//        if (offsetY <= headerH &&
//            offsetY >= -QPStatusBarAndNavigationBarHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
//        } else if (offsetY >= headerH) {
//            scrollView.contentInset = UIEdgeInsetsMake(-headerH, 0, 0, 0);
//        }
//    }
//}

- (void)configTableViewHeaderFooter
{
    UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([QPAboutMeTableHeader class]) bundle:NSBundle.mainBundle];
    QPAboutMeTableHeader *header = [headerNib instantiateWithOwner:nil options:nil].firstObject;
    header.left = header.top = 0.f;
    header.width = self.view.width;
    header.height = AboutMeTableHeaderHeight;
    header.logoBgImgView.backgroundColor = UIColor.clearColor;
    UIImage *cornerImage = [self colorImage:CGRectMake(0, 0, 120, 120)
                               cornerRadius:15
                             backgroudColor:QPColorFromRGB(39, 220, 203)
                                borderWidth:0
                                borderColor:nil];
    header.logoBgImgView.image = cornerImage;
    
    NSString *intro = [QPInfoDictionary objectForKey:@"QPlyerDesc"];
    header.briefIntroLabel.textAlignment = NSTextAlignmentLeft;
    header.briefIntroLabel.textColor = [self aboutMeController].isDarkMode ? QPColorFromRGB(160, 160, 160) : QPColorFromRGB(96, 96, 96);
    header.briefIntroLabel.text = intro;
    _view.tableHeaderView = header;
    
    NSUInteger count = [self aboutMeController].adapter.dataSource.count;
    UINib *footerNib = [UINib nibWithNibName:NSStringFromClass([QPAboutMeTableFooter class]) bundle:NSBundle.mainBundle];
    QPAboutMeTableFooter *footer = [footerNib instantiateWithOwner:nil options:nil].firstObject;
    CGFloat cellH    = AboutMeTableCellHeight;
    footer.left      = 0.f;
    footer.top       = 0.f;
    footer.width     = self.view.width;
    footer.height    = self.view.height - header.height - count*cellH - 10;
    _view.tableFooterView = footer;
    @QPWeakify(self)
    [footer onAct:^(AMFooterActionType type) {
        if (type == AMFooterActionTypeJianShu) {
            NSString *url = [QPInfoDictionary objectForKey:@"MyJianShuUrl"];
            [weak_self presentWebViewWithUrl:url];
        } else {
            NSString *url = [QPInfoDictionary objectForKey:@"MyBlogUrl"];
            [weak_self presentWebViewWithUrl:url];
        }
    }];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    if (indexPath.section != 0) {
        return nil;
    }
    static NSString *cellID = @"AboutMeCellIdentifier";
    UITableViewCell *cell = [_view dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    } else {
        [cell removeAllSubviews];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = _viewController.isDarkMode ? QPColorFromRGB(20, 20, 20) : QPColorFromRGB(246, 246, 246);
    
    [[self aboutMeController].adapter bindModelTo:cell atIndexPath:indexPath inTableView:_view withViewController:_viewController];
    
    return cell;
}

- (void)selectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    if (indexPath.row == 1) {
        NSString *str = QPInfoDictionary[@"QPlayerGithubUrl"];
        [self presentWebViewWithUrl:str];
    } else if (indexPath.row == 2) {
        NSString *str = QPInfoDictionary[@"MyGithubUrl"];
        [self presentWebViewWithUrl:str];
    } else if (indexPath.row == 3) {
        NSString *str = QPInfoDictionary[@"MyGithubUrl"];
        str = [NSString stringWithFormat:@"%@?tab=repositories", str];
        [self presentWebViewWithUrl:str];
    } else if (indexPath.row == 4) {
        QPAboutModel *_model = (QPAboutModel *)model;
        NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Hello!", _model.rValue];
        NSString *body  = [NSString stringWithFormat:@"&body=  "];
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        [self openUrl:[ApplicationHelper urlEncode:email]];
    }
}

- (void)presentWebViewWithUrl:(NSString *)anUrl
{
    if (@available(iOS 9.0, *)) {
        NSURL *anURL = [NSURL URLWithString:anUrl];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:anURL];
        safariVC.delegate = self;
        [self.viewController presentViewController:safariVC animated:YES completion:NULL];
    } else {
        [self openUrl:anUrl];
    }
}

- (void)openUrl:(NSString *)anUrl {
    NSURL *anURL = [NSURL URLWithString:anUrl];
    if (@available(iOS 10.0, *)) {
        [QPSharedApp openURL:anURL options:@{} completionHandler:NULL];
    } else {
        //[QPSharedApp openURL:anURL];
    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(NSString *)title
{
    return @[];
}

@end

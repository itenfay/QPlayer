//
//  AboutMeViewController.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "AboutMeViewController.h"
#import "AboutMeTableHeader.h"
#import "AboutMeTableFooter.h"
#import "QPTitleView.h"

#define AboutMeTableHeaderHeight 280.f
#define AboutMeTableCellHeight    50.f

@interface AboutMeViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end

@implementation AboutMeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        QPLog(@" >>>>>>>>>> ");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItems];
    [self setupTextForTitleLabel:@"关于我"];
    
    [self setupMtableView];
    [self preload];
}

- (void)setupNavigationItems {
    self.navigationItem.hidesBackButton = YES;
    
    QPTitleView *titleView = [[QPTitleView alloc] init];
    //titleView.backgroundColor = UIColor.redColor;
    titleView.left   = 0.f;
    titleView.top    = 0.f;
    titleView.width  = self.view.width;
    titleView.height = 36.f;
    titleView.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleView;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.width     = 30.f;
    backButton.height    = 30.f;
    backButton.left      = 0.f;
    backButton.top       = (titleView.height - backButton.height)/2;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 12);
    [titleView addSubview:backButton];
    
    UILabel *titleLabel        = [[UILabel alloc] init];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont boldSystemFontOfSize:17.f];
    titleLabel.textColor       = UIColor.whiteColor;
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.tag             = 668;
    
    titleLabel.height = 30.f;
    titleLabel.left   = backButton.right - 12.f;
    titleLabel.top    = (titleView.height - titleLabel.height)/2;
    titleLabel.width  = titleView.right - titleLabel.left - 2*16.f;
    [titleView addSubview:titleLabel];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTextForTitleLabel:(NSString *)text {
    UILabel *titleLabel = [self.navigationItem.titleView viewWithTag:668];
    titleLabel.text = text;
}

- (NSString *)textForTitleLabel {
    UILabel *titleLabel = [self.navigationItem.titleView viewWithTag:668];
    return titleLabel.text;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self interactivePopGestureAction];
}

- (void)interactivePopGestureAction {
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.m_tableViewBottom.constant = QPViewSafeBottomMargin;
}

- (void)setupMtableView {
    [self.m_tableView setBackgroundColor:UIColor.clearColor];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (void)preload {
    [self.dataArray removeAllObjects];
    [self onLoadData];
}

- (void)onLoadData {
    NSString *vString = [NSString stringWithFormat:@"%@.%@", QPAppVersion, QPBuildVersion];
    NSDictionary *vDict = @{@"版本": vString};
    [self.dataArray addObject:vDict];
    
    NSString *gString = [NSString stringWithFormat:@"★ Star"];
    NSDictionary *gDict = @{@"Github": gString};
    [self.dataArray addObject:gDict];
    
    NSString *eString = [QPInfoDictionary objectForKey:@"MyEmail"];
    NSDictionary *eDict = @{@"Email": eString};
    [self.dataArray addObject:eDict];
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerH = AboutMeTableHeaderHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //QPLog(@"%f, %f", scrollView.contentOffset.x, offsetY);
    if (scrollView == self.m_tableView) {
        if (offsetY <= headerH &&
            offsetY >= -QPStatusBarAndNavigationBarHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
        }
        else if (offsetY >= headerH) {
            scrollView.contentInset = UIEdgeInsetsMake(-headerH, 0, 0, 0);
        }
    }
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return AboutMeTableHeaderHeight;
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([AboutMeTableHeader class]) bundle:NSBundle.mainBundle];
        AboutMeTableHeader *header = [nib instantiateWithOwner:nil options:nil].firstObject;
        
        CGFloat headerH = AboutMeTableHeaderHeight;
        header.left     = 0.f;
        header.top      = 0.f;
        header.width    = self.view.width;
        header.height   = headerH;
        
        header.logoBgImgView.backgroundColor = UIColor.clearColor;
        UIImage *cornerImage = [self colorImage:header.logoBgImgView.bounds
                                   cornerRadius:15
                                 backgroudColor:QPColorFromRGB(39, 220, 203)
                                    borderWidth:0
                                    borderColor:nil];
        header.logoBgImgView.image = cornerImage;
        
        NSString *intro = [QPInfoDictionary objectForKey:@"QPlyerBriefIntro"];
        UILabel *label  = header.briefIntroLabel;
        UIFont  *font   = [UIFont systemFontOfSize:13.5f];
        CGFloat labH    = label.yf_heightToFit(intro,
                                               label.width,
                                               font);
        label.textAlignment = NSTextAlignmentLeft;
        
        header.briefIntroLabelHeight.constant = labH;
        CGFloat bgImgVH = header.logoBgImgViewHeight.constant;
        header.logoBgImgViewTop.constant = (headerH - bgImgVH - labH - 20)/2;
        
        return header;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        NSUInteger nums = self.dataArray.count;
        CGFloat headerH = AboutMeTableHeaderHeight;
        CGFloat cellH   = AboutMeTableCellHeight;
        return self.m_tableView.height - headerH - nums*cellH;
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([AboutMeTableFooter class]) bundle:NSBundle.mainBundle];
        AboutMeTableFooter *footer = [nib instantiateWithOwner:nil options:nil].firstObject;
        
        NSUInteger nums = self.dataArray.count;
        CGFloat headerH = AboutMeTableHeaderHeight;
        CGFloat cellH   = AboutMeTableCellHeight;
        footer.left     = 0.f;
        footer.top      = 0.f;
        footer.width    = self.view.width;
        footer.height   = self.m_tableView.height - headerH - nums*cellH;
        
        @QPWeakObject(self)
        
        [footer onAct:^(AMFooterActionType type) {
            if (type == AMFooterActionTypeJianShu) {
                
                NSString *myJSUrl = [QPInfoDictionary objectForKey:@"MyJianShuUrl"];
                [weak_self openWebPageWithUrl:myJSUrl];
            }
            else {
                
                NSString *blogUrl = [QPInfoDictionary objectForKey:@"MyBlogUrl"];
                [weak_self openWebPageWithUrl:blogUrl];
            }
        }];
        
        return footer;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        return nil;
    }
    
    static NSString *cellID = @"AboutMeTableCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict.allKeys.firstObject;
    cell.textLabel.textColor  = QPColorFromRGB(48, 48, 48);
    cell.detailTextLabel.text = dict.allValues.firstObject;
    
    if (indexPath.row == 0) {
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    if (indexPath.row == 1) {
        
        NSString *gValue = QPInfoDictionary[@"QPlayerGithubUrl"];
        [self openWebPageWithUrl:gValue];
        
    }
    else if (indexPath.row == 2) {
        
        NSString *eValue = dict.allValues.firstObject;
        NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Hello!", eValue];
        NSString *body  = [NSString stringWithFormat:@"&body=  "];
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        
        [self openUrl:[self urlEncode:email]];
        
    }
    else {}
}

- (void)openWebPageWithUrl:(NSString *)aUrl {
    QPLog(@" >>>>>>>>>> %@", aUrl);
    
    if (@available(iOS 9.0, *)) {
        
        NSURL *aURL = [NSURL URLWithString:aUrl];
        
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:aURL];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:YES completion:NULL];
        
    } else {
        
        [self openUrl:aUrl];
    }
}

- (void)openUrl:(NSString *)aUrl {
    NSURL *aURL = [NSURL URLWithString:aUrl];
    QPLog(@" >>>>>>>>>> %@", aURL);
    
    if (@available(iOS 10.0, *)) {
        [QPSharedApp openURL:aURL options:@{} completionHandler:NULL];
    } else {
        [QPSharedApp openURL:aURL];
    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    QPLog(@" >>>>>>>>>> ");
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(NSString *)title {
    QPLog(@" >>>>>>>>>> ");
    return @[];
}

@end

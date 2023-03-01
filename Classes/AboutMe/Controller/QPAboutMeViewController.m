//
//  QPAboutMeViewController.m
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPAboutMeViewController.h"
#import "QPAboutMeTableHeader.h"
#import "QPAboutMeTableFooter.h"
#import "QPTitleView.h"

#define AboutMeTableHeaderHeight 280.f
#define AboutMeTableCellHeight    46.f

@interface QPAboutMeViewController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end

@implementation QPAboutMeViewController

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
    [self loadData];
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

- (void)loadData {
    [self.dataArray removeAllObjects];
    
    NSString *vString = [NSString stringWithFormat:@"%@.%@", QPAppVersion, QPBuildVersion];
    NSDictionary *vDict = @{@"版本": vString};
    [self.dataArray addObject:vDict];
    
    NSString *gString = [NSString stringWithFormat:@" ★ "];
    NSDictionary *gDict = @{@"Star": gString};
    [self.dataArray addObject:gDict];
    
    NSString *hString = [NSString stringWithFormat:@"Home"];
    NSDictionary *hDict = @{@"GitHub": hString};
    [self.dataArray addObject:hDict];
    
    NSString *rString = [NSString stringWithFormat:@"Repositories"];
    NSDictionary *rDict = @{@"GitHub": rString};
    [self.dataArray addObject:rDict];
    
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
        
        NSString *intro = [QPInfoDictionary objectForKey:@"QPlyerDesc"];
        UILabel *label  = header.briefIntroLabel;
        UIFont  *font   = [UIFont systemFontOfSize:13.5f];
        CGFloat labH    = label.yf_heightToFit(intro,
                                               label.width,
                                               font);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = self.isDarkMode ? QPColorFromRGB(160, 160, 160) : QPColorFromRGB(96, 96, 96);
        label.lineBreakMode = NSLineBreakByCharWrapping;
        
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
        
        NSUInteger count = self.dataArray.count;
        CGFloat headerH  = AboutMeTableHeaderHeight;
        CGFloat cellH    = AboutMeTableCellHeight;
        footer.left      = 0.f;
        footer.top       = 0.f;
        footer.width     = self.view.width;
        footer.height    = self.m_tableView.height - headerH - count*cellH;
        
        @QPWeakify(self)
        
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
    } else {
        [self removeCellAllSubviews:cell];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.backgroundColor = self.isDarkMode ? QPColorFromRGB(20, 20, 20) : QPColorFromRGB(246, 246, 246);
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    cell.textLabel.text = dict.allKeys.firstObject;
    cell.detailTextLabel.text = dict.allValues.firstObject;
    cell.textLabel.textColor  = self.isDarkMode ?  QPColorFromRGB(220, 220, 220) : QPColorFromRGB(100, 100, 100);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (indexPath.row == 0) {
        cell.accessoryType  = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    if (indexPath.row == 1) {
        
        NSString *str = QPInfoDictionary[@"QPlayerGithubUrl"];
        [self openWebPageWithUrl:str];
        
    } else if (indexPath.row == 2) {
        
        NSString *str = QPInfoDictionary[@"MyGithubUrl"];
        [self openWebPageWithUrl:str];
        
    } else if (indexPath.row == 3) {
        
        NSString *str = QPInfoDictionary[@"MyGithubUrl"];
        str = [NSString stringWithFormat:@"%@?tab=repositories", str];
        [self openWebPageWithUrl:str];
        
    } else if (indexPath.row == 4) {
        
        NSString *eValue = dict.allValues.firstObject;
        NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=Hello!", eValue];
        NSString *body  = [NSString stringWithFormat:@"&body=  "];
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        
        [self openUrl:[self urlEncode:email]];
    } else {}
}

- (void)openWebPageWithUrl:(NSString *)anUrl {
    QPLog(@" >>>>>>>>>> %@", anUrl);
    
    if (@available(iOS 9.0, *)) {
        
        NSURL *anURL = [NSURL URLWithString:anUrl];
        
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:anURL];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:YES completion:NULL];
        
    } else {
        
        [self openUrl:anUrl];
    }
}

- (void)openUrl:(NSString *)anUrl {
    NSURL *anURL = [NSURL URLWithString:anUrl];
    QPLog(@" >>>>>>>>>> %@", anURL);
    
    if (@available(iOS 10.0, *)) {
        [QPSharedApp openURL:anURL options:@{} completionHandler:NULL];
    } else {
        [QPSharedApp openURL:anURL];
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.m_tableView reloadData];
}

@end

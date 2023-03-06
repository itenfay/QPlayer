//
//  QPAdvancedSearchController.m
//  QPlayer
//
//  Created by chenxing on 2023/3/3.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPAdvancedSearchController.h"

@interface QPAdvancedSearchController ()

@end

@implementation QPAdvancedSearchController

- (void)loadView
{
    [super loadView];
    self.webView.height = self.view.height;
}

- (void)configureNavigationBar
{
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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.width     = 30.f;
    rightBtn.height    = 30.f;
    rightBtn.right     = titleView.right - 12.f; // The margin is 12.
    rightBtn.top       = (titleView.height - rightBtn.height)/2;
    rightBtn.showsTouchWhenHighlighted = YES;
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightBtn];
    
    UIView *tfLeftView         = [[UIView alloc] init];
    tfLeftView.frame           = CGRectMake(0, 0, 26, 26);
    UIImageView *searchImgView = [[UIImageView alloc] init];
    searchImgView.frame        = CGRectMake(5, 5, 16, 16);
    searchImgView.image        = QPImageNamed(@"search_gray");
    searchImgView.contentMode  = UIViewContentModeScaleToFill;
    [tfLeftView addSubview:searchImgView];
    
    UITextField *textField    = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    textField.borderStyle     = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType   = UIReturnKeyGo;
    textField.delegate        = self;
    textField.font            = [UIFont systemFontOfSize:15.f];
    textField.leftView        = tfLeftView;
    textField.leftViewMode    = UITextFieldViewModeAlways;
    textField.tag             = 66;
    
    textField.height = 30.f;
    textField.left   = backButton.right - 8.f;
    textField.top    = (titleView.height - textField.height)/2;
    textField.width  = rightBtn.left - textField.left;
    [titleView addSubview:textField];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)titleView
{
    return (UITextField *)[self.navigationItem.titleView viewWithTag:66];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    QPAdvancedSearchPresenter *presenter = [[QPAdvancedSearchPresenter alloc] init];
    presenter.view = self.view;
    presenter.viewController = self;
    self.presenter = presenter;
    self.adapter.scrollViewDelegate = presenter;
    
    [self loadDefaultRequest];
    [self delayToScheduleTask:2 completion:^{
        [self.adapter inspectToolBarAlpha];
    }];
}

- (void)configureWebViewAdapter
{
    self.adapter = [[QPAdvancedSearchWebViewAdapter alloc] init];
    self.adapter.webView = self.webView;
    self.adapter.navigationBar = self.navigationBar;
    self.adapter.toolBar = self.webToolBar;
    [self.adapter addProgressViewToWebView];
    @QPWeakify(self)
    [self.adapter observeUrlLink:^(NSString *url) {
        weak_self.titleView.text = url;
    }];
}

- (void)loadDefaultRequest
{
    NSString *aUrl = [QPInfoDictionary objectForKey:@"TecentVideoUrl"];
    self.titleView.text = aUrl;
    [self loadRequestWithUrl:aUrl];
}

- (void)loadWebContents
{
    NSString *text = self.titleView.text;
    [self.titleView resignFirstResponder];
    if (text.length > 0) {
        NSString *tempStr = [text lowercaseString];
        NSString *url = @"";
        if (QPlayerCanSupportAVFormat(tempStr)) {
            self.titleView.text = url = text;
            QPAdvancedSearchPresenter *presenter = (QPAdvancedSearchPresenter *)self.presenter;
            [presenter playVideoWithUrl:url];
        } else if ([tempStr hasPrefix:@"https"] || [tempStr hasPrefix:@"http"]) {
            url = text;
        } else if ([tempStr hasPrefix:@"www."] || [tempStr hasPrefix:@"m."]   ||
                   [tempStr hasSuffix:@".com"] || [tempStr hasSuffix:@".cc"]) {
            url = [NSString stringWithFormat:@"https://%@", text];
        } else {
            NSString *bdUrl = @"https://www.baidu.com/";
            url = [url stringByAppendingFormat:@"%@s?wd=%@&cl=3", bdUrl, text];
        }
        self.titleView.text = url;
        [self loadRequestWithUrl:[ApplicationHelper urlEncode:url]];
    }
}

- (void)onSearch:(UIButton *)sender
{
    QPAdvancedSearchPresenter *presenter = (QPAdvancedSearchPresenter *)self.presenter;
    [presenter presentSearchViewController:@[@"https://m.v.qq.com/",
                                             @"https://m.mgtv.com/",
                                             @"https://m.iqiyi.com/",
                                             @"https://www.youku.com/",
                                             @"https://m.tv.sohu.com/",
                                             @"https://m.pptv.com/",
                                             @"https://m.le.com/",
                                             @"https://m.mtime.cn/",
                                             
                                             @"https://m.ixigua.com/",
                                             @"https://v.ifeng.com/",
                                             @"https://haokan.baidu.com/",
                                             @"https://www.pearvideo.com/?from=intro",
                                             @"http://ten.budejie.com/video/",
                                             @"https://m.ku6.com/index",
                                             
                                             @"https://www.y80s.net/",
                                             
                                             @"https://xw.qq.com/m/sports/index.htm",
                                             @"https://m.live.qq.com/",
                                             @"https://sports.sina.cn/?from=wap",
                                             @"https://m.sohu.com/z/"]];
}

//- (void)addObserver {
//    // 进入全屏监听
//    [QPNotiDefaultCenter addObserver:self selector:@selector(onBeginFullScreen:) name:UIWindowDidBecomeVisibleNotification object:nil];
//    // 退出全屏监听
//    [QPNotiDefaultCenter addObserver:self selector:@selector(onEndFullScreen:) name:UIWindowDidBecomeHiddenNotification object:nil];
//}

//- (void)removeObserver {
//    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
//    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeHiddenNotification  object:nil];
//}

// 进入全屏
//- (void)onBeginFullScreen:(NSNotification *)noti {
//    QPLog("::");
//    if (@available(iOS 9.0, *)) {}
//    [self setNeedsStatusBarAppearanceUpdate];
//}

//  退出全屏
//- (void)onEndFullScreen:(NSNotification *)noti {
//    QPLog("::");
//    if (@available(iOS 9.0, *)) {}
//    [QPSharedApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [self setNeedsStatusBarAppearanceUpdate];
//}

@end

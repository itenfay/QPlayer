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
    [self setNavigationTitleView:textField];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.width     = 30.f;
    backButton.height    = 30.f;
    backButton.left      = 0.f;
    backButton.top       = 0.f;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self addLeftNavigationBarButton:backButton];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.width     = 30.f;
    rightBtn.height    = 30.f;
    rightBtn.left      = 0.f;
    rightBtn.top       = 0.f;
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self addRightNavigationBarButton:rightBtn];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupPlayerType
{
    QPAdvancedSearchPresenter *pt = (QPAdvancedSearchPresenter *)self.presenter;
    pt.playbackContext.playerType = QPPlayerTypeZFPlayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    QPAdvancedSearchPresenter *presenter = [[QPAdvancedSearchPresenter alloc] init];
    presenter.view = self.view;
    presenter.viewController = self;
    self.presenter = presenter;
    self.adapter.scrollViewDelegate = presenter;
    ((QPWKWebViewAdapter *)self.adapter).delegate = presenter;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableInteractivePopGesture:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self enableInteractivePopGesture:YES];
}

- (void)loadDefaultRequest
{
    NSString *url = [QPInfoDictionary objectForKey:@"TecentVideoUrl"];
    self.titleView.text = url;
    [self loadRequestWithUrl:url];
}

- (void)loadWebContents
{
    NSString *text = self.titleView.text;
    [self.titleView resignFirstResponder];
    if (text.length > 0) {
        NSString *tempStr = [text lowercaseString];
        NSString *url = @"";
        if (QPPlayerCanSupportAVFormat(tempStr)) {
            self.titleView.text = url = text;
            QPAdvancedSearchPresenter *presenter = (QPAdvancedSearchPresenter *)self.presenter;
            [presenter.playbackContext playVideoWithTitle:text urlString:url playerType:QPPlayerTypeZFPlayer];
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
        [self loadRequestWithUrl:[AppHelper urlEncode:url]];
    }
}

- (void)onSearch:(UIButton *)sender
{
    QPAdvancedSearchPresenter *presenter = (QPAdvancedSearchPresenter *)self.presenter;
    [presenter presentSearchViewController:@[@"https://m.v.qq.com/",
                                             @"https://m.mgtv.com/",
                                             @"https://m.iqiyi.com/",
                                             @"https://www.youku.com/",
                                             @"https://m.pptv.com/",
                                             @"https://m.ixigua.com/",
                                             @"https://v.ifeng.com/",
                                             @"https://haokan.baidu.com/",
                                             @"https://y80s.net/"]
                                 cachePath:VIDEO_SEARCH_HISTORY_CACHE_PATH];
}

//- (void)addObserver
//{
//    [QPNotiDefaultCenter addObserver:self selector:@selector(enterFullScreen:) name:UIWindowDidBecomeVisibleNotification object:nil];
//    [QPNotiDefaultCenter addObserver:self selector:@selector(exitFullScreen:) name:UIWindowDidBecomeHiddenNotification object:nil];
//}

//- (void)removeObserver
//{
//    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
//    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeHiddenNotification  object:nil];
//}

//- (void)enterFullScreen:(NSNotification *)noti
//{
//    QPLog("");
//    if (@available(iOS 9.0, *)) {}
//}

//- (void)exitFullScreen:(NSNotification *)noti
//{
//    QPLog("");
//    if (@available(iOS 9.0, *)) {}
//}

@end

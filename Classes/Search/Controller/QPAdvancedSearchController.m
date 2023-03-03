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

- (void)configureNavigationBar {
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
    textField.font            = [UIFont systemFontOfSize:16.f];
    textField.leftView        = tfLeftView;
    textField.leftViewMode    = UITextFieldViewModeAlways;
    [self setNavigationTitleView:textField];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    rightBtn.showsTouchWhenHighlighted = YES;
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self addRightNavigationBarButton:rightBtn];
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
        } else if ([tempStr hasPrefix:@"https"] ||
                   [tempStr hasPrefix:@"http"]) {
            url = text;
        } else if ([tempStr hasPrefix:@"www."] ||
                   [tempStr hasPrefix:@"m."]   ||
                   [tempStr hasSuffix:@".com"] ||
                   [tempStr hasSuffix:@".cc"]) {
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
    [presenter presentSearchViewController];
}

@end

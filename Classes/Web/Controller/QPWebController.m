//
//  QPWebController.m
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPWebController.h"

@interface QPWebController ()

@end

@implementation QPWebController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setParsingButtonRequired:NO];
    }
    return self;
}

- (UITextField *)titleView
{
    return (UITextField *)self.navigationItem.titleView;
}

- (void)loadView
{
    [super loadView];
    [self configureNavigationBar];
    [self addWebView];
    [self addWebToolBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureWebViewAdapter];
    [self setWebViewDelegate];
    [self loadDefaultRequest];
    [self delayToScheduleTask:2 completion:^{
        [self.adapter inspectToolBarAlpha];
    }];
}

- (void)configureWebViewAdapter
{
    self.adapter = [[QPWKWebViewAdapter alloc] initWithWebView:self.webView navigationBar:self.navigationBar];
    self.adapter.toolBar = [self webToolBar];
    [self.adapter addProgressViewToWebView];
    @QPWeakify(self)
    [self.adapter observeUrlLink:^(NSString *url) {
        weak_self.titleView.text = url;
    }];
}

- (void)adaptTitleViewStyle:(BOOL)isDark
{
    self.titleView.backgroundColor = isDark ? UIColor.blackColor : UIColor.whiteColor;
    self.titleView.textColor = isDark ? UIColor.whiteColor : UIColor.blackColor;
    self.titleView.font = [UIFont systemFontOfSize:15.f];
    NSString *title = @"请输入要搜索的内容或网址";
    UIFont *font = [UIFont systemFontOfSize:15.f];
    if (isDark) {
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    } else {
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor grayColor]}];
    }
}

- (void)adaptThemeStyle
{
    [super adaptThemeStyle];
    [self adaptTitleViewStyle:self.isDarkMode];
}

- (void)loadDefaultRequest
{
    NSString *url = @"https://www.baidu.com";
    self.titleView.text = url;
    [self loadRequestWithUrl:url];
}

- (void)addWebView {
    CGFloat kH   = self.view.height - QPTabBarHeight;
    CGRect frame = CGRectMake(0, 0, QPScreenWidth, kH);
    [self initWebViewWithFrame:frame];
    
    self.webView.backgroundColor = UIColor.clearColor; //QPColorFromRGB(243, 243, 243);
    self.webView.opaque          = NO;
    
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.webView autoresizing];
    [self.view addSubview:self.webView];
}

- (void)setWebViewDelegate
{
    self.webView.navigationDelegate  = self.adapter;
    self.webView.UIDelegate          = self.adapter;
    self.webView.scrollView.delegate = self.adapter;
}

- (void)addWebToolBar {
    UIImageView *toolBar = [self buildToolBar];
    toolBar.tag = 9999;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (UIImageView *)webToolBar {
    return (UIImageView *)[self.view viewWithTag:9999];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyGo) {
        [self loadWebContents];
    }
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loadWebContents
{
    NSString *text = self.titleView.text;
    [self.titleView resignFirstResponder];
    if (text.length > 0) {
        NSString *tempStr = [text lowercaseString];
        NSString *url = @"";
        if ([tempStr hasPrefix:@"https"] || [tempStr hasPrefix:@"http"]) {
            url = text;
        } else if ([tempStr hasPrefix:@"www."] || [tempStr hasPrefix:@"m."] ||
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

@end

//
//  BaseController.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "BaseController.h"

#define BCProgressViewTag     10

@interface BaseController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL isAddedToNavBar;

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QPColorRGB(240, 240, 240);
}

- (void)setNavigationBarHidden:(BOOL)hidden {
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = hidden;
    }
}

- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 34);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [button setImage:QPImageNamed(@"back_button_normal_white") forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UINavigationBar *)navigationBar {
    if (self.navigationController) {
        return self.navigationController.navigationBar;
    }
    return nil;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (UIWebView *)layoutWebViewWithFrame:(CGRect)frame {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:frame];
    }
    return _webView;
}

- (void)setProgressViewAddedToWebView {
    self.isAddedToNavBar = NO;
}

- (void)setProgressViewAddedToNavigationBar {
    self.isAddedToNavBar = YES;
}

- (void)loadWebContents:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadWebUrlRequest:(NSURLRequest *)urlRequest {
    [self.webView loadRequest:urlRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self addProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeProgressView];
}

- (void)addProgressView {
    if (self.isAddedToNavBar) {
        DYFWebProgressView *progressView = [[DYFWebProgressView alloc] initWithFrame:CGRectMake(0, self.navigationBar.height - 3.f, self.navigationBar.width, 3.f)];
        progressView.tag = BCProgressViewTag;
        progressView.lineWidth = 3.f;
        progressView.lineColor = QPColorRGB(248, 125, 36);
        
        [self.navigationBar addSubview:progressView];
        
        [progressView startLoading];
    } else {
        DYFWebProgressView *progressView = [[DYFWebProgressView alloc] initWithFrame:CGRectMake(0, 0, self.webView.width, 3.f)];
        progressView.tag = BCProgressViewTag;
        progressView.lineWidth = 3.f;
        progressView.lineColor = QPColorRGB(248, 125, 36);
        
        [self.webView addSubview:progressView];
        
        [progressView startLoading];
    }
}

- (void)removeProgressView {
    if (self.isAddedToNavBar) {
        DYFWebProgressView *progressView = [self.navigationBar viewWithTag:BCProgressViewTag];
        [progressView endLoading];
    } else {
        DYFWebProgressView *progressView = [self.webView viewWithTag:BCProgressViewTag];
        [progressView endLoading];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

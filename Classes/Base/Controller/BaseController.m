//
//  BaseController.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL isAddedToNavBar;
@property (nonatomic, strong) DYFWebProgressView *progressView;
@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QPColorFromRGB(246, 246, 246);
}

- (void)setNavigationBarHidden:(BOOL)hidden {
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = hidden;
    }
}

- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector {
    UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame           = CGRectMake(0, 0, 40, 34);
    [button setImage:QPImageNamed(@"back_button_normal_white") forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);

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
    [self buildProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeProgressView];
}

- (void)buildProgressView {
    if (!_progressView) {
        self.progressView.lineWidth = 3.f;
        self.progressView.lineColor = QPColorFromRGB(248, 125, 36);
        
        if (self.isAddedToNavBar) {
            [self.navigationBar addSubview:self.progressView];
        } else {
            [self.webView addSubview:self.progressView];
        }
        
        [self.progressView startLoading];
    }
}

- (void)removeProgressView {
    if (_progressView) {
        [self.progressView endLoading];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(0.3 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self releaseProgressView];
                       });
    }
}

- (void)releaseProgressView {
    _progressView = nil;
}

- (DYFWebProgressView *)progressView {
    if (!_progressView) {
        if (self.isAddedToNavBar) {
            _progressView = [[DYFWebProgressView alloc] initWithFrame:CGRectMake(0, self.navigationBar.height - 3.f, self.navigationBar.width, 3.f)];
        } else {
            _progressView = [[DYFWebProgressView alloc] initWithFrame:CGRectMake(0, 0, self.webView.width, 3.f)];
        }
    }
    return _progressView;
}

- (void)removeCellAllSubviews:(UITableViewCell *)cell {
    while (cell.contentView.subviews.lastObject != nil) {
        [(UIView *)cell.contentView.subviews.lastObject removeFromSuperview];
    }
}

- (UIImageView *)buildCustomToolBar:(SEL)selector {
    NSArray *imgNames = @[@"ic_browser_reward_13x21", @"ic_browser_forward_13x21", @"ic_browser_refresh_24x21", @"ic_browser_stop_21x21"];
    NSUInteger count  = imgNames.count;
    
    CGFloat fixedSpace = 5.f;
    CGFloat btnW       = 30.f;
    CGFloat btnH       = 30.f;
    
    CGFloat tlbW     = btnW + 4*fixedSpace;
    CGFloat tlbH     = count*btnH + (count+1)*fixedSpace + 3*fixedSpace;
    CGFloat tlbX     = QPScreenWidth - tlbW - 2*fixedSpace;
    CGFloat tlbY     = self.view.height - QPTabBarHeight - tlbH - 4*fixedSpace;
    CGRect  tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
    
    UIImageView *toolBar    = [[UIImageView alloc] initWithFrame:tlbFrame];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.image           = [self pureImage:toolBar.bounds
                                 cornerRadius:5.f
                               backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                                  borderWidth:0.f
                                  borderColor:nil];
    
    toolBar.userInteractionEnabled = YES;
    
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame     = CGRectMake(2*fixedSpace, (i+1)*fixedSpace+i*btnH, btnW, btnH);
        button.tag       = 100 + i;
        button.showsTouchWhenHighlighted = YES;
        [button setImage:QPImageNamed(imgNames[i]) forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
    }
    
    toolBar.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                UIViewAutoresizingFlexibleWidth      |
                                UIViewAutoresizingFlexibleTopMargin  |
                                UIViewAutoresizingFlexibleHeight);
    
    return toolBar;
}

- (UIImage *)pureImage:(CGRect)rect cornerRadius:(CGFloat)cornerRadius backgroudColor:(UIColor *)backgroudColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIImage *mImage    = nil;
    
    CGRect mRect       = rect;
    CGSize mSize       = mRect.size;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mRect cornerRadius:cornerRadius];
    
    if (@available(iOS 10.0, *)) {
        
        UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:mSize];
        
        mImage = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            UIGraphicsImageRendererContext *ctx = rendererContext;
            
            CGContextSetFillColorWithColor  (ctx.CGContext, backgroudColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx.CGContext, borderColor.CGColor);
            CGContextSetLineWidth           (ctx.CGContext, borderWidth);
            
            [path addClip];
            
            CGContextAddPath (ctx.CGContext, path.CGPath);
            CGContextDrawPath(ctx.CGContext, kCGPathFillStroke);
        }];
        
    } else {
        
        UIGraphicsBeginImageContext(mSize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor  (context, backgroudColor.CGColor);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth           (context, borderWidth);
        
        [path addClip];
        
        CGContextAddPath (context, path.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        mImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return mImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

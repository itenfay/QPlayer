//
//  QPWebController.m
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPWebController.h"

@interface QPWebController ()
@property (nonatomic, strong) UIView *settingPanel;
@end

@implementation QPWebController

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter {
    if (self = [super init]) {
        [self setupAdapter:adapter];
    }
    return self;
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
    [self injectLocalUserScript];
    [self loadDefaultRequest];
    [self delayToScheduleTask:2 completion:^{
        [(QPWKWebViewAdapter *)self.adapter inspectToolBarAlpha];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideSettingPanel:NO];
}

#pragma mark - public methods

- (void)makeUI {
    [self makeInnerSettingView];
}

- (void)makeLayout {
    
}

- (void)makeAction {
    
}

- (void)setupAdapter:(QPWKWebViewAdapter *)adapter {
    self.adapter = adapter;
    self.webView.UIDelegate = adapter;
    self.webView.navigationDelegate = adapter;
    self.webView.scrollView.delegate = adapter;
}

- (void)configureWebViewAdapter
{
    QPWKWebViewAdapter *webAdapter = [[QPWKWebViewAdapter alloc] initWithNavigationBar:self.navigationBar toolBar:[self webToolBar]];
    [self setupAdapter:webAdapter];
    [webAdapter addProgressViewToWebView];
    @QPWeakify(self);
    [webAdapter observeUrlLink:^(NSURL *url) {
        weak_self.titleView.text = url.absoluteString;
    }];
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
        [self loadRequestWithUrl:[AppHelper urlEncode:url]];
    }
}

#pragma mark - 构建工具条

- (UIImageView *)buildToolBar
{
    return [self buildToolBar:@selector(tbItemClicked:)];
}

- (UIImageView *)buildToolBar:(SEL)selector
{
    return [self buildAndLayoutToolBar:selector isVertical:NO];
}

- (UIImageView *)buildVerticalToolBar
{
    return [self buildVerticalToolBar:@selector(tbItemClicked:)];
}

- (UIImageView *)buildVerticalToolBar:(SEL)selector
{
    return [self buildAndLayoutToolBar:selector isVertical:YES];
}

- (UIImageView *)buildAndLayoutToolBar:(SEL)selector isVertical:(BOOL)isVertical
{
    NSMutableArray *items = @[@"web_reward_13x21", @"web_forward_13x21",
                              @"web_refresh_24x21", @"web_stop_21x21"].mutableCopy;
    BOOL bVal = !self.hidesBottomBarWhenPushed;
    
    NSUInteger count = items.count;
    CGFloat hSpace   = 10.f;
    CGFloat vSpace   = isVertical ? 5.f : 8.f;
    CGFloat btnW     = 30.f;
    CGFloat btnH     = 30.f;
    CGFloat offset   = bVal ? QPTabBarHeight : (QPIsPhoneXAll ? 4 : 2)*vSpace;
    CGFloat tlbW     = btnW + 2*hSpace;
    CGFloat tlbH     = count*btnH + (count+1)*vSpace + 4*vSpace;
    CGFloat tlbX     = QPScreenWidth - tlbW - hSpace;
    CGFloat tlbY     = self.view.height - offset - tlbH - 2*vSpace;
    CGRect  tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
    
    if (!isVertical) {
        tlbX = 1.5*hSpace;
        tlbW = self.view.width - 2*tlbX;
        tlbH = btnH + 3*vSpace;
        tlbY = self.view.height - offset - tlbH - (bVal ? 2*vSpace : 0) + 5.f;
        tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
        btnW = (tlbW - (count+1)*hSpace)/count;
    }
    
    UIImageView *toolBar    = [[UIImageView alloc] initWithFrame:tlbFrame];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.image           = [self colorImage:toolBar.bounds
                                  cornerRadius:15.f
                                backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                                   borderWidth:0.f
                                   borderColor:nil];
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isVertical) {
            button.frame = CGRectMake(hSpace, (i+1)*vSpace+i*btnH, btnW, btnH);
        } else {
            button.frame = CGRectMake((i+1)*vSpace+i*btnW, 1.5*vSpace, btnW, btnH);
        }
        button.tag = 100 + i;
        button.showsTouchWhenHighlighted = YES;
        [button setImage:QPImageNamed(items[i]) forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
    }
    toolBar.userInteractionEnabled = YES;
    [toolBar autoresizing];
    
    return toolBar;
}

#pragma mark - 系统控件的Protocol

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

#pragma mark - 自定义控件的Protocol

#pragma mark - Event response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - private method

- (void)addWebView {
    CGFloat kH   = self.view.height - QPTabBarHeight;
    CGRect frame = CGRectMake(0, 0, QPScreenWidth, kH);
    self.webView.frame = frame;
    
    self.webView.backgroundColor = UIColor.clearColor; //QPColorFromRGB(243, 243, 243);
    self.webView.opaque          = NO;
    self.webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.webView autoresizing];
    
    [self.view addSubview:self.webView];
}

- (void)addWebToolBar {
    UIImageView *toolBar = [self buildToolBar];
    toolBar.tag = 9999;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (void)injectLocalUserScript
{
    //NSString *jsPath = [NSBundle.mainBundle pathForResource:@"jsquery_video_src" ofType:@"js"];
    //NSData *jsData = [NSData dataWithContentsOfFile:jsPath];
    //NSString *jsString = [NSString.alloc initWithData:jsData encoding:NSUTF8StringEncoding];
    //QPLog(@"jsString=%@", jsString);
    //WKUserScript *userScript = [WKUserScript.alloc initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    //[self.userContentController addUserScript:userScript];
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

- (void)tbItemClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag - 100;
    switch (index) {
        case 0: [self onGoBack]; break;
        case 1: [self onGoForward]; break;
        case 2: [self onReload]; break;
        case 3: [self onStopLoading]; break;
        case 4: QPLog(""); break;
        default: break;
    }
}

#pragma mark - Setting Panel

- (void)makeInnerSettingView {
    NSArray *clsNameArr = @[@"QPSearchViewController", @"QPPlayerController"];
    
    UIView *settingView = [[UIView alloc] init];
    settingView.tag = 8689;
    settingView.userInteractionEnabled = YES;
    settingView.clipsToBounds = YES;
    [self.view addSubview:settingView];
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.view).offset(-QPStatusBarAndNavigationBarHeight/2);
        make.left.equalTo(@0);
    }];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingView addSubview:settingBtn];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [settingBtn setBackgroundColor:QPColorFromRGBAlp(20, 20, 20, 0.5)];
    [settingBtn setTitle:@"    ⚙︎" forState:UIControlStateNormal];
    [settingBtn setTitleColor:QPColorFromRGB(252, 252, 252) forState:UIControlStateNormal];
    settingBtn.layer.cornerRadius = 25;
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerY.equalTo(settingView);
        make.left.equalTo(@0).offset(-25);
    }];
    [settingBtn addTarget:self action:@selector(onSettingAction) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSString *clsName in clsNameArr) {
        Class cls = NSClassFromString(clsName);
        if (cls && cls == self.class) {
            settingView.hidden = YES;
            break;
        }
    }
}

- (void)onSettingAction {
    if (_settingPanel) return;
    [self showSettingPanel];
}

- (void)showSettingPanel {
    if (!_settingPanel) {
        _settingPanel = [[UIView alloc] init];
        _settingPanel.backgroundColor = QPColorFromRGBAlp(20, 20, 20, 0.8);
        _settingPanel.layer.cornerRadius = 15;
        [self.view addSubview:_settingPanel];
        [self.settingPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view).offset(-QPStatusBarAndNavigationBarHeight/2);
            make.left.equalTo(@50);
            make.right.equalTo(@-50);
            make.height.equalTo(@230);
        }];
        
        UIImage *closeImg = [QPImageNamed(@"droplistview_close") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:closeImg forState:UIControlStateNormal];
        closeBtn.tintColor = [UIColor whiteColor];
        [closeBtn addTarget:self action:@selector(onClosePanel:) forControlEvents:UIControlEventTouchUpInside];
        [self.settingPanel addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.settingPanel).offset(5);
            make.right.equalTo(self.settingPanel).offset(-5);
            make.width.height.equalTo(@30);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"解析网页视频";
        label1.textColor = UIColor.whiteColor;
        label1.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(closeBtn.mas_bottom).offset(10);
            make.height.equalTo(@30);
        }];
        UISwitch *sw1 = [[UISwitch alloc] init];
        sw1.tag = 88;
        [self.settingPanel addSubview:sw1];
        sw1.on = QPPlayerParsingWebVideo();
        [sw1 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.settingPanel).offset(-15);
            make.centerY.equalTo(label1);
            make.height.equalTo(@30);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"使用IJKPlayer播放器";
        label2.textColor = UIColor.whiteColor;
        label2.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(label1.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        UISwitch *sw2 = [[UISwitch alloc] init];
        sw2.tag= 89;
        [self.settingPanel addSubview:sw2];
        sw2.on = QPPlayerUseIJKPlayer();
        [sw2 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sw1.mas_right);
            make.centerY.equalTo(label2);
            make.height.equalTo(@30);
        }];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = @"使用硬解码播放";
        label3.textColor = UIColor.whiteColor;
        label3.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(label2.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        UISwitch *sw3 = [[UISwitch alloc] init];
        sw3.tag= 90;
        [self.settingPanel addSubview:sw3];
        sw3.on = QPPlayerHardDecoding() == 1 ? YES : NO;
        [sw3 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sw2.mas_right);
            make.centerY.equalTo(label3);
            make.height.equalTo(@30);
        }];
        
        UILabel *label4 = [[UILabel alloc] init];
        label4.text = @"允许运营商网络播放";
        label4.textColor = UIColor.whiteColor;
        label4.font = [UIFont boldSystemFontOfSize:14];
        [self.settingPanel addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(label3.mas_bottom).offset(15);
            make.height.equalTo(@30);
        }];
        UISwitch *sw4 = [[UISwitch alloc] init];
        sw4.tag= 91;
        [self.settingPanel addSubview:sw4];
        sw4.on = QPCarrierNetworkAllowed();
        [sw4 addTarget:self action:@selector(onSWAction:) forControlEvents:UIControlEventValueChanged];
        [sw4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sw3.mas_right);
            make.centerY.equalTo(label4);
            make.height.equalTo(@30);
        }];
        
        self.settingPanel.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.settingPanel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            self.settingPanel.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)hideSettingPanel:(BOOL)animated {
    if (_settingPanel) {
        if (!animated) {
            [self removeSettingPanel];
            return;
        }
        self.settingPanel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.settingPanel.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [self removeSettingPanel];
        }];
    }
}

- (void)onClosePanel:(UIButton *)sender {
    [self hideSettingPanel:YES];
}

- (void)removeSettingPanel {
    [self.settingPanel removeFromSuperview];
    self.settingPanel = nil;
}

- (void)onSWAction:(UISwitch *)sw {
    if (sw.tag == 88) {
        QPPlayerSetParingWebVideo(sw.isOn);
    } else if (sw.tag == 89) {
        QPPlayerSetUsingIJKPlayer(sw.isOn);
    } else if (sw.tag == 90) {
        QPPlayerSetHardDecoding(sw.isOn ? 1 : 0);
    } else if (sw.tag == 91) {
        QPSetCarrierNetworkAllowed(sw.isOn);
    }
    [QPHudUtils showTipMessageInWindow:sw.isOn ? @"已开启" : @"已关闭" duration:1.0];
}

#pragma mark - Setting Panel End

#pragma mark - Lazy
#pragma mark - getters and setters

- (UITextField *)titleView {
    return (UITextField *)self.navigationItem.titleView;
}

- (UIImageView *)webToolBar {
    return (UIImageView *)[self.view viewWithTag:9999];
}

@end

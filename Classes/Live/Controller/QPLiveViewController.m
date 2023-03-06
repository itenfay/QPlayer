//
//  QPLiveViewController.m
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPLiveViewController.h"
#import "QPPlayerController.h"
#import "QPTitleView.h"
#import "DYFDropListView.h"
#import "QPLivePresenter.h"
#import "QPLiveWebViewAdapter.h"

@interface QPLiveViewController ()

@end

@implementation QPLiveViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setParsingButtonRequired:NO];
    }
    return self;
}

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
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.width     = 30.f;
    historyButton.height    = 30.f;
    historyButton.right     = titleView.right - 12.f; // The margin is 12.
    historyButton.top       = (titleView.height - historyButton.height)/2;
    historyButton.showsTouchWhenHighlighted = YES;
    [historyButton setImage:QPImageNamed(@"history_white") forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    //historyButton.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 6);
    [titleView addSubview:historyButton];
    
    UIView *tfLeftView         = [[UIView alloc] init];
    tfLeftView.frame           = CGRectMake(0, 0, 26, 26);
    UIImageView *searchImgView = [[UIImageView alloc] init];
    searchImgView.frame        = CGRectMake(5, 5, 16, 16);
    searchImgView.image        = QPImageNamed(@"search_gray");
    searchImgView.contentMode  = UIViewContentModeScaleToFill;
    [tfLeftView addSubview:searchImgView];
    
    UITextField *textField    = [[UITextField alloc] init];
    textField.borderStyle     = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType   = UIReturnKeyGo;
    textField.delegate        = self;
    textField.font            = [UIFont systemFontOfSize:16.f];
    textField.leftView        = tfLeftView;
    textField.leftViewMode    = UITextFieldViewModeAlways;
    textField.tag             = 68;
    
    textField.height = 30.f;
    textField.left   = backButton.right - 8.f;
    textField.top    = (titleView.height - textField.height)/2;
    textField.width  = historyButton.left - textField.left;
    [titleView addSubview:textField];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)titleView
{
    return (UITextField *)[self.navigationItem.titleView viewWithTag:68];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    QPLivePresenter *presenter = [[QPLivePresenter alloc] init];
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
    self.adapter = [[QPLiveWebViewAdapter alloc] init];
    self.adapter.webView = self.webView;
    self.adapter.navigationBar = self.navigationBar;
    self.adapter.toolBar = self.webToolBar;
    [self.adapter addProgressViewToWebView];
    @QPWeakify(self)
    [self.adapter observeUrlLink:^(NSString *url) {
        weak_self.titleView.text = url;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableInteractivePopGesture:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)adaptTitleViewStyle:(BOOL)isDark
{
    self.titleView.backgroundColor = isDark ? UIColor.blackColor : UIColor.whiteColor;
    self.titleView.textColor = isDark ? UIColor.whiteColor : UIColor.blackColor;
    self.titleView.font = [UIFont systemFontOfSize:15.f];
    NSString *title = @"请输入网址或RTMP/M3U8等直播流地址";
    UIFont *font = [UIFont systemFontOfSize:15.f];
    if (isDark) {
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
    } else {
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor grayColor]}];
    }
}

- (void)addPlayButton {
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.width  = 60;
    playBtn.height = 60;
    playBtn.left   = -20;
    playBtn.top    = (self.webView.height - playBtn.height - QPStatusBarAndNavigationBarHeight)/2;
    playBtn.backgroundColor = UIColor.clearColor;
    playBtn.tag    = 10;
    playBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
    playBtn.titleLabel.numberOfLines = 2;
    playBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    UIImage *bgImage = [self colorImage:playBtn.bounds
                           cornerRadius:15.0
                         backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                            borderWidth:0
                            borderColor:nil];
    [playBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [playBtn setTitle:@"电视\n TV" forState:UIControlStateNormal];
    [playBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [playBtn setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
    [playBtn setTitleShadowColor:UIColor.brownColor forState:UIControlStateNormal];
    [playBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
    [playBtn addTarget:self action:@selector(showDropListView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
}

- (UIButton *)playButton
{
    return (UIButton *)[self.view viewWithTag:10];
}

- (void)loadDefaultRequest
{
    NSString *url = [QPInfoDictionary objectForKey:@"InkeHotLiveUrl"];
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
        if ([tempStr hasPrefix:@"rtmp"] || [tempStr hasPrefix:@"rtsp"] ||
            [tempStr hasPrefix:@"mms"] || QPlayerCanSupportAVFormat(tempStr)) {
            if (QPlayerDetermineWhetherToPlay()) {
                self.titleView.text = url = text;
                NSString *title = [self titleMatchingWithUrl:url];
                //[self playVideoWithTitle:title urlString:url];
            }
            return;
        } else if ([tempStr hasPrefix:@"https"] || [tempStr hasPrefix:@"http"]) {
            url = text;
        } else {
            NSString *bdUrl = @"https://www.baidu.com/";
            url = [url stringByAppendingFormat:@"%@s?wd=%@&cl=3", bdUrl, text];
        }
        [self loadRequestWithUrl:[ApplicationHelper urlEncode:url]];
        self.titleView.text = url;
    }
}

- (void)onSearch:(UIButton *)sender
{
    QPLivePresenter *presenter = (QPLivePresenter *)self.presenter;
    [presenter presentSearchViewController:@[@"https://h5.inke.cn/app/home/hotlive",
                                             @"https://h.huajiao.com/",
                                             @"https://wap.yy.com/",
                                             @"https://m.yizhibo.com/",
                                             @"https://m.v.6.cn/",
                                             @"https://h5.9xiu.com/",
                                             @"https://www.95.cn/mobile?channel=ai00011",
                                             @"http://tv.cctv.com/live/m/",
                                             @"https://cdn.egame.qq.com/pgg-play/module/livelist.html",
                                             @"https://m.douyu.com/",
                                             @"https://m.huya.com/",
                                             @"https://h5.cc.163.com/",
                                             @"https://m.tv.bingdou.net/",
                                             @"http://m.66zhibo.net/",
                                             @"http://m.migu123.com/"]];
}

- (void)showDropListView:(UIButton *)sender
{
    sender.enabled = NO;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([DYFDropListView class]) bundle:nil];
    DYFDropListView *dropListView = [nib instantiateWithOwner:nil options:nil].firstObject;
    dropListView.left   = 5.f;
    dropListView.top    = 5.f;
    dropListView.width  = self.view.width - 2*dropListView.left;
    dropListView.height = self.webView.height - 2*dropListView.top;
    [dropListView autoresizing];
    [self.view addSubview:dropListView];
    [self.view bringSubviewToFront:dropListView];
    
    //dropListView.alpha = 0.f;
    dropListView.left = -self.view.width;
    [UIView animateWithDuration:0.5 animations:^{
        //dropListView.alpha = 1.f;
        dropListView.left = 5.f;
    } completion:^(BOOL finished) {}];
    
    @QPWeakify(self)
    [dropListView onSelectRow:^(NSInteger selectedRow, NSString *title, NSString *content) {
        @QPStrongify(self)
        strong_self.playButton.enabled = YES;
        if (QPlayerDetermineWhetherToPlay()) {
            NSString *aUrl = [content copy];
            strong_self.titleView.text = [content copy];
            //[strong_self playVideoWithTitle:[title copy] urlString:aUrl];
        }
    }];
    
    [dropListView onCloseAction:^{
        weak_self.playButton.enabled = YES;
    }];
}

- (NSString *)titleMatchingWithUrl:(NSString *)url
{
    // DYFDropListView.bundle -> DropListViewData.plist
    NSString *path       = [NSBundle.mainBundle pathForResource:kResourceBundle ofType:nil];
    NSString *bundlePath = [NSBundle bundleWithPath:path].bundlePath;
    NSString *filePath   = [bundlePath stringByAppendingPathComponent:kDropListDataFile];
    QPLog(@":: filePath=%@", filePath);
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    for (NSString *key in dict) {
        NSString *value = dict[key];
        if ([value isEqualToString:url]) {
            return key;
        }
    }
    
    return url;
}

@end

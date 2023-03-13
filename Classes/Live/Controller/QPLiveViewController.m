//
//  QPLiveViewController.m
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPLiveViewController.h"
#import "QPPlayerController.h"
#import "QPDropListView.h"
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
    [self addPlayButton];
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
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.width     = 30.f;
    historyButton.height    = 30.f;
    historyButton.right     = 0.f;
    historyButton.top       = 0.f;
    historyButton.showsTouchWhenHighlighted = YES;
    [historyButton setImage:QPImageNamed(@"history_white") forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    historyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    [self addRightNavigationBarButton:historyButton];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    QPLivePresenter *presenter = [[QPLivePresenter alloc] init];
    presenter.view = self.view;
    presenter.viewController = self;
    self.presenter = presenter;
    self.adapter.scrollViewDelegate = presenter;
}

- (void)configureWebViewAdapter
{
    self.adapter = [[QPLiveWebViewAdapter alloc] init];
    self.adapter.webView = self.webView;
    self.adapter.navigationBar = self.navigationBar;
    self.adapter.toolBar = self.webToolBar;
    [self.adapter addProgressViewToWebView];
    @QPWeakify(self)
    [self.adapter observeUrlLink:^(NSURL *url) {
        weak_self.titleView.text = url.absoluteString;
    }];
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
    playBtn.width  = 30; //60;
    playBtn.height = 30; //60;
    playBtn.left   = 0; //-20;
    playBtn.top    = 0; //(self.webView.height - playBtn.height - QPStatusBarAndNavigationBarHeight)/2;
    playBtn.backgroundColor = UIColor.clearColor;
    playBtn.tag    = 10;
    playBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    //playBtn.titleLabel.numberOfLines = 2;
    //playBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    //UIImage *bgImage = [self colorImage:playBtn.bounds
    //                       cornerRadius:15.0
    //                     backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
    //                        borderWidth:0
    //                        borderColor:nil];
    //[playBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [playBtn setTitle:@"TV" forState:UIControlStateNormal];
    [playBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [playBtn setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
    [playBtn setTitleShadowColor:UIColor.brownColor forState:UIControlStateNormal];
    [playBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    //[playBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 10)];
    [playBtn addTarget:self action:@selector(showDropListView:) forControlEvents:UIControlEventTouchUpInside];
    [self addRightNavigationBarButton:playBtn];
}

- (UIButton *)playButton
{
    return (UIButton *)[self.navigationBar viewWithTag:10];
}

- (void)loadDefaultRequest
{
    NSString *url = [QPInfoDictionary objectForKey:@"InkeHotLiveUrl"];
    self.titleView.text = url;
    [self loadRequestWithUrl:@"https://www.baidu.com"];
}

- (void)loadWebContents
{
    NSString *text = self.titleView.text;
    [self.titleView resignFirstResponder];
    if (text.length > 0) {
        NSString *tempStr = [text lowercaseString];
        NSString *url = @"";
        if ([tempStr hasPrefix:@"rtmp"] || [tempStr hasPrefix:@"rtsp"] ||
            [tempStr hasPrefix:@"mms"] || QPPlayerCanSupportAVFormat(tempStr)) {
            self.titleView.text = url = text;
            NSString *title = [self titleMatchingWithUrl:url];
            QPLivePresenter *presenter = (QPLivePresenter *)self.presenter;
            [presenter.playbackContext playVideoWithTitle:title urlString:url usingMediaPlayer:YES];
            return;
        } else if ([tempStr hasPrefix:@"https"] || [tempStr hasPrefix:@"http"]) {
            url = text;
        } else {
            NSString *bdUrl = @"https://www.baidu.com/";
            url = [url stringByAppendingFormat:@"%@s?wd=%@&cl=3", bdUrl, text];
        }
        [self loadRequestWithUrl:[AppHelper urlEncode:url]];
        self.titleView.text = url;
    }
}

- (void)onSearch:(UIButton *)sender
{
    QPLivePresenter *presenter = (QPLivePresenter *)self.presenter;
    [presenter presentSearchViewController:@[@"https://h5.inke.cn/app/home/hotlive",
                                             @"https://h.huajiao.com/",
                                             @"https://wap.yy.com/",
                                             @"https://m.v.6.cn/",
                                             @"https://h5.9xiu.com/",
                                             @"https://www.95.cn/mobile?channel=ai00011",
                                             @"https://cdn.egame.qq.com/pgg-play/module/livelist.html",
                                             @"https://m.douyu.com/",
                                             @"https://m.huya.com/",
                                             @"https://h5.cc.163.com/",
                                             @"http://tv.cctv.com/live/m/",
                                             @"https://m.tv.bingdou.net/",
                                             @"http://m.66zhibo.net/",
                                             @"http://m.migu123.com/"]
                                 cachePath:LIVE_SEARCH_HISTORY_CACHE_PATH];
}

- (void)showDropListView:(UIButton *)sender
{
    sender.enabled = NO;
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([QPDropListView class]) bundle:nil];
    QPDropListView *dropListView = [nib instantiateWithOwner:nil options:nil].firstObject;
    dropListView.left   = 10.f;
    dropListView.top    = 10.f;
    dropListView.width  = self.view.width - 2*dropListView.left;
    dropListView.height = self.webView.height - 2*dropListView.top;
    [dropListView autoresizing];
    [self.view addSubview:dropListView];
    [self.view bringSubviewToFront:dropListView];
    
    //dropListView.alpha = 0.f;
    [UIView animateWithDuration:0.5 animations:^{
        //dropListView.alpha = 1.f;
        dropListView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        dropListView.transform = CGAffineTransformIdentity;
    }];
    
    @QPWeakify(self)
    [dropListView onSelectRow:^(NSInteger selectedRow, NSString *title, NSString *content) {
        @QPStrongify(self)
        NSString *urlString = [content copy];
        strong_self.playButton.enabled = YES;
        strong_self.titleView.text = urlString;
        QPLivePresenter *presenter = (QPLivePresenter *)strong_self.presenter;
        [presenter.playbackContext playVideoWithTitle:title urlString:urlString usingMediaPlayer:YES];
    }];
    
    [dropListView onCloseAction:^{
        weak_self.playButton.enabled = YES;
    }];
}

- (NSString *)titleMatchingWithUrl:(NSString *)url
{
    // QPDropListView.bundle -> DropListViewData.plist
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

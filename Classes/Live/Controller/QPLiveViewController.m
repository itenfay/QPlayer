//
//  QPLiveViewController.m
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPLiveViewController.h"
#import "QPlayerController.h"
#import "QPTitleView.h"
#import "DYFDropListView.h"

@interface QPLiveViewController () <UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property (nonatomic, copy) NSString *requestUrl;
@end

@implementation QPLiveViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setParsingButtonRequired:NO];
        QPLog(@" >>>>>>>>>> ");
    }
    return self;
}

- (void)loadView {
    [super loadView];
    QPLog(@" >>>>>>>>>> ");
    [self setupNavigationItems];
    
    [self initWebView];
    [self willAddProgressViewToWebView];
    
    [self addPlayButton];
    [self buildWebToolBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    QPLog(@" >>>>>>>>>> ");
    
    self.scheduleTask(self,
                      @selector(inspectWebToolBarAlpha),
                      nil,
                      1.0);
    [self.view setClipsToBounds:YES];
    
    [self addObserver];
    [self loadDefaultRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self interactivePopGestureAction];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self inspectWebToolBarAlpha];
}

- (void)interactivePopGestureAction {
    if (self.navigationController ) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    }
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
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.width     = 30.f;
    historyButton.height    = 30.f;
    historyButton.right     = titleView.right - 2*12.f; // The margin is 12.
    historyButton.top       = (titleView.height - historyButton.height)/2;
    historyButton.showsTouchWhenHighlighted = YES;
    [historyButton setImage:QPImageNamed(@"history_white") forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(presentSearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    historyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
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
    
    [self adjustTitleViewColor];
}

- (void)adjustTitleViewColor {
    
    BOOL bValue = [QPlayerExtractValue(kThemeStyleOnOff) boolValue];
    if (bValue) {
        
        if (@available(iOS 13.0, *)) {
            
            UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
            
            if (mode == UIUserInterfaceStyleDark) {
                // Dark Mode
                [self matchTitleViewStyle:YES];
            } else if (mode == UIUserInterfaceStyleLight) {
                // Light Mode or unspecified Mode
                [self matchTitleViewStyle:NO];
            }
            
        } else {
            
            [self matchTitleViewStyle:NO];
        }
        
    } else {
        
        [self matchTitleViewStyle:NO];
    }
}

- (void)matchTitleViewStyle:(BOOL)isDark {
    self.titleView.backgroundColor = isDark ? UIColor.blackColor : UIColor.whiteColor;
    self.titleView.textColor = isDark ? UIColor.whiteColor : UIColor.blackColor;
    self.titleView.font = [UIFont systemFontOfSize:16.f];
    
    NSString *title = @"请输入网址或RTMP/M3U8等直播流地址";
    UIFont *font = [UIFont systemFontOfSize:14.f];
    
    if (isDark) {
        
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
    } else {
        
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor grayColor]}];
    }
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)titleView {
    return (UITextField *)[self.navigationItem.titleView viewWithTag:68];
}

- (void)addPlayButton {
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    playBtn.width  = 60;
    playBtn.height = 60;
    playBtn.left   = -20;
    playBtn.top    = (self.webView.height - playBtn.height - QPStatusBarAndNavigationBarHeight)/2;
    
    playBtn.backgroundColor = UIColor.clearColor;
    playBtn.tag             = 10;
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
    
    [playBtn addTarget:self action:@selector(showDropListViewWithFade:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:playBtn];
}

- (UIButton *)playButton {
    return (UIButton *)[self.view viewWithTag:10];
}

- (void)showDropListViewWithFade:(UIButton *)sender {
    sender.enabled = NO;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([DYFDropListView class]) bundle:nil];
    DYFDropListView *dropListView = [nib instantiateWithOwner:nil options:nil].firstObject;
    
    dropListView.left   = 5.f;
    dropListView.top    = 5.f;
    dropListView.width  = self.view.width - 2*dropListView.left;
    dropListView.height = self.webView.height - 2*dropListView.top;
    
    dropListView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleTopMargin  |
                                     UIViewAutoresizingFlexibleWidth      |
                                     UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:dropListView];
    [self.view bringSubviewToFront:dropListView];
    
    dropListView.alpha = 0.f;
    [UIView animateWithDuration:0.5 animations:^{
        dropListView.alpha = 1.f;
    } completion:^(BOOL finished) {}];
    
    @QPWeakify(self)
    
    [dropListView onSelectRow:^(NSInteger selectedRow, NSString *title, NSString *content) {
        @QPStrongify(self)
        strong_self.playButton.enabled = YES;
        
        if (QPlayerDetermineWhetherToPlay()) {
            NSString *aUrl = [content copy];
            strong_self.titleView.text = [content copy];
            
            [strong_self playVideoWithTitle:[title copy] urlString:aUrl];
        }
    }];
    
    [dropListView onCloseAction:^{
        weak_self.playButton.enabled = YES;
    }];
}

- (void)loadDefaultRequest {
    NSString *aUrl = [QPInfoDictionary objectForKey:@"InkeHotLiveUrl"];
    self.titleView.text = aUrl;
    [self loadRequest:aUrl];
}

- (void)initWebView {
    CGFloat kH   = self.view.height;
    CGRect frame = CGRectMake(0, 0, QPScreenWidth, kH);
    [self initWebViewWithFrame:frame];
    
    self.webView.backgroundColor     = UIColor.clearColor; //QPColorFromRGB(243, 243, 243);
    self.webView.opaque              = NO;
    self.webView.navigationDelegate  = self;
    self.webView.UIDelegate          = self;
    self.webView.scrollView.delegate = self;
    
    self.webView.autoresizingMask    = (UIViewAutoresizingFlexibleLeftMargin |
                                        UIViewAutoresizingFlexibleTopMargin  |
                                        UIViewAutoresizingFlexibleWidth      |
                                        UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:self.webView];
}

- (void)buildWebToolBar {
    UIImageView *toolBar = [self buildCustomToolBar];
    toolBar.tag = 999;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (UIImageView *)webToolBar {
    return (UIImageView *)[self.view viewWithTag:999];
}

- (void)inspectWebToolBarAlpha {
    if (self.webToolBar.alpha > 0.f) {
        self.webToolBar.alpha = 0.f;
        self.scheduleTask(self,
                          @selector(cancelHidingToolBar),
                          nil,
                          0);
    }
}

- (void)loadRequest:(NSString *)url {
    NSURL *aURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:aURL];
    [self.webView loadRequest:request];
}

- (void)onLoadData {
    NSString *text = self.titleView.text;
    [self.titleView resignFirstResponder];
    
    if (text.length > 0) {
        NSString *tempStr = [text lowercaseString];
        NSString *url = @"";
        
        if ([tempStr hasPrefix:@"rtmp"]        ||
            [tempStr hasPrefix:@"rtsp"]        ||
            [tempStr hasPrefix:@"mms"]         ||
            QPlayerCanSupportAVFormat(tempStr)) {
            
            if (QPlayerDetermineWhetherToPlay()) {
                self.titleView.text = url = text;
                NSString *title = [self titleMatchingWithUrl:url];
                [self playVideoWithTitle:title urlString:url];
            }
            return;
            
        } else if ([tempStr hasPrefix:@"https"] ||
                   [tempStr hasPrefix:@"http"]) {
            
            url = text;
            
        } else {
            
            NSString *bdUrl = @"https://www.baidu.com/";
            url = [url stringByAppendingFormat:@"%@s?wd=%@&cl=3", bdUrl, text];
        }
        
        [self loadRequest:[self urlEncode:url]];
        self.titleView.text = url;
    }
}

- (NSString *)titleMatchingWithUrl:(NSString *)url {
    // DYFDropListView.bundle -> DropListViewData.plist
    NSString *path       = [NSBundle.mainBundle pathForResource:kResourceBundle ofType:nil];
    NSString *bundlePath = [NSBundle bundleWithPath:path].bundlePath;
    NSString *filePath   = [bundlePath stringByAppendingPathComponent:kDropListDataFile];
    QPLog(@" >>>>>>>>>> filePath: %@", filePath);
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    for (NSString *key in dict) {
        NSString *value = dict[key];
        if ([value isEqualToString:url]) {
            return key;
        }
    }
    
    return url;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyGo) {
        [self onLoadData];
    }
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma make - WKNavigationDelegate, WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // didStartProvisionalNavigation.
    
    NSURL *aURL = [webView.URL copy];
    self.requestUrl = aURL.absoluteString;
    QPLog(@"webView.url: %@", self.requestUrl);
    
    self.titleView.text = self.requestUrl;
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    // didReceiveServerRedirectForProvisionalNavigation.
    QPLog(@"[redirect] webView.url: %@", webView.URL);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [super webView:webView didCommitNavigation:navigation];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    QPLog(@"url: %@", webView.URL);
    [self evaluateJavaScript:webView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailProvisionalNavigation:navigation withError:error];
    
    if (!error || error.code == NSURLErrorCancelled ||
        error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    
    NSString *errMessage = [NSString stringWithFormat:@"%zi, %@", error.code, error.localizedDescription];
    QPLog(@"[error]: %@", errMessage);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailNavigation:navigation withError:error];
    
    if (!error || error.code == NSURLErrorCancelled ||
        error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    
    NSString *errMessage = [NSString stringWithFormat:@"%zi, %@", error.code, error.localizedDescription];
    QPLog(@"[error]: %@", errMessage);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // decidePolicyForNavigationAction.
    
    NSURL *aURL = [navigationAction.request.URL copy];
    NSString *aUrl = aURL.absoluteString;
    QPLog(@"url: %@", aUrl);
    
    // Method NO.1: resolve the problem about '_blank'.
    //if (navigationAction.targetFrame == nil) {
    //    QPLog(@"- [webView loadRequest:navigationAction.request]");
    //    [webView loadRequest:navigationAction.request];
    //}
    
    if ([aUrl isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else {
        self.requestUrl = aUrl;
        self.titleView.text = aUrl;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // createWebViewWithConfiguration.
    
    NSURL *aURL = [navigationAction.request.URL copy];
    NSString *aUrl = aURL.absoluteString;
    QPLog(@"url: %@", aUrl);
    
    if (!navigationAction.targetFrame.isMainFrame) {
        QPLog(@"- [webView loadRequest:navigationAction.request]");
        [webView loadRequest:navigationAction.request];
    }
    
    //self.requestUrl = aUrl;
    //self.titleView.text = aUrl;
    
    return nil;
}

- (void)evaluateJavaScript:(WKWebView *)webView {
    
    NSString *jsStr = @"document.getElementsByTagName('video')[0].src";
    
    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        if(![response isEqual:[NSNull null]] && response != nil){
            
            // 截获到视频地址
            NSString *videoUrl = (NSString *)response;
            QPLog(@"videoUrl: %@", videoUrl);
            [self attemptToPlayVideo:videoUrl];
            
        } else {
            // 没有视频链接
        }
        
    }];
}

- (void)attemptToPlayVideo:(NSString *)url {
    QPLog(@"videoUrl: %@", url);
    
    if (!QPlayerDetermineWhetherToPlay()) {
        return;
    }
    
    [QPHudObject showActivityMessageInView:@"正在解析..."];
    
    NSString *videoTitle = self.webView.title;
    QPLog(@"videoTitle: %@", videoTitle);
    
    if (url && url.length > 0 && [url hasPrefix:@"http"]) {
        
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudObject hideHUD];
            [self playVideoWithTitle:videoTitle urlString:url];
        }];
        
    } else {
        
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudObject hideHUD];
        }];
    }
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)url {
    
    if (!QPlayerIsPlaying()) {
        QPlayerSavePlaying(YES);
        
        QPlayerController *qpc    = [[QPlayerController alloc] init];
        qpc.isMediaPlayerPlayback = YES;
        qpc.videoDecoding         = 1; // 硬解码
        qpc.videoTitle            = title;
        qpc.videoUrl              = url;
        
        [self.navigationController pushViewController:qpc animated:YES];
    }
}

#pragma make - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showToolBarWithAnimation];
    [self cancelHidingToolBar];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self delayToHideToolBar];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self delayToHideToolBar];
    }
}

- (void)delayToHideToolBar {
    self.scheduleTask(self,
                      @selector(hideToolBar),
                      nil,
                      6);
}

- (void)hideToolBar {
    [self hideToolBarWithAnimation];
}

- (void)showToolBarWithAnimation {
    UIImageView *toolBar = self.webToolBar;
    if (toolBar.alpha == 0.f) {
        [UIView animateWithDuration:0.5 animations:^{
            toolBar.alpha = 1.f;
        }];
    }
}

- (void)hideToolBarWithAnimation {
    UIImageView *toolBar = self.webToolBar;
    if (toolBar.alpha == 1.f) {
        [UIView animateWithDuration:0.5 animations:^{
            toolBar.alpha = 0.f;
        }];
    }
}

- (void)cancelHidingToolBar {
    self.cancelPerformingSelector(self, @selector(hideToolBar), nil);
}

- (void)addObserver {
    // 进入全屏监听
    [QPNotiDefaultCenter addObserver:self selector:@selector(onBeginFullScreen:) name:UIWindowDidBecomeVisibleNotification object:nil];
    // 退出全屏监听
    [QPNotiDefaultCenter addObserver:self selector:@selector(onEndFullScreen:) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)removeObserver {
    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeHiddenNotification  object:nil];
}

// 进入全屏
- (void)onBeginFullScreen:(NSNotification *)noti {
    QPLog();
    if (@available(iOS 9.0, *)) {}
    else {}
    [self setNeedsStatusBarAppearanceUpdate];
}

//  退出全屏
- (void)onEndFullScreen:(NSNotification *)noti {
    QPLog();
    if (@available(iOS 9.0, *)) {}
    else {}
    [QPSharedApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)presentSearchViewController:(UIButton *)sender {
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"请输入要搜索的内容或网址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //QPLog(@"searchText: %@", searchText);
    }];
    
    searchViewController.delegate    = self;
    searchViewController.dataSource  = self;
    // @"https://www.chushou.tv/",
    // @"https://live.bilibili.com/h5/",
    // @"https://m-x.pps.tv/",
    // @"https://now.qq.com/",
    // @"http://m.azhibo.com/",
    searchViewController.hotSearches = @[@"https://h5.inke.cn/app/home/hotlive",
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
                                         @"http://m.migu123.com/"];
    
    searchViewController.searchBar.tintColor = UIColor.blueColor;
    searchViewController.searchHistoriesCachePath = LIVE_SEARCH_HISTORY_CACHE_PATH;
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nc.navigationBar setShadowImage:[UIImage new]];
    if (self.isDarkMode) {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBlackBg") forBarMetrics:UIBarMetricsDefault];
    } else {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    }
    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    [nc.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)onLoadData:(NSString *)searchText
searchViewController:(PYSearchViewController *)searchViewController {
    if (searchText.length > 0) {
        self.titleView.text = searchText;
        
        [self searchSuggestionsWithSearchText:searchText];
        [self didClickCancel:searchViewController];
        
        [self onLoadData];
    }
}

#pragma mark - PYSearchViewControllerDelegate

// Called when search begain
- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
    
    [self onLoadData:searchText searchViewController:searchViewController];
}

// Called when popular search is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
    
    [self onLoadData:searchText searchViewController:searchViewController];
}

// Called when search history is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
    
    [self onLoadData:searchText searchViewController:searchViewController];
}

// Called when search suggestion is selected, the method support more custom of search suggestion view
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {
    QPLog(@"search indexPath: %zi", indexPath.row);
}

// Called when search text did change, you can reload data of suggestion view thought this method
- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
}

// Called when cancel item did press, default execute `[self dismissViewControllerAnimated:YES completion:nil]`
- (void)didClickCancel:(PYSearchViewController *)searchViewController {
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchSuggestionsWithSearchText:(NSString *)searchText {
    //Send request to get a search suggestions
    
    //NSMutableArray *searchSuggestionsM = [NSMutableArray array];
    
    // Refresh and display the search suggustions
    //self.searchSuggestions = searchSuggestionsM;
}

// Inherits the implementations of its superclass

//- (BOOL)prefersStatusBarHidden {
//    return NO;
//}

//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
//    return UIStatusBarAnimationNone;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self adjustTitleViewColor];
}

- (void)dealloc {
    QPLog(@" >>>>>>>>>> ");
    [self releaseWebView];
    [self removeObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

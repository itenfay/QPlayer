//
//  SearchViewController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "SearchViewController.h"
#import "QPlayerController.h"

// Video searching history cache path.
#define VIDEO_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"VideoSearchHistories.plist"]

@interface SearchViewController () <UITextFieldDelegate, UIScrollViewDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property (nonatomic, copy) NSString *requestUrl;
@end

@implementation SearchViewController

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
    [self setupNavigationItems];
    
    [self initWebView];
    [self willAddProgressViewToWebView];
    
    [self buildWebToolBar];
    [self addManualThemeStyleObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    QPLog(@" >>>>>>>>>> ");
    self.scheduleTask(self,
                      @selector(inspectWebToolBarAlpha),
                      nil,
                      1);
    
    [self addObserver];
    [self loadDefaultRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self inspectWebToolBarAlpha];
}

- (void)setupNavigationItems {
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
    
    self.navigationItem.titleView = textField;
    
    [self adjustTitleViewColor];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    rightBtn.showsTouchWhenHighlighted = YES;
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(presentSearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 15;
    
    self.navigationItem.rightBarButtonItems = @[rightItem, spaceItem];
}

- (void)adjustTitleViewColor {
    
    BOOL bValue = [QPlayerExtractFlag(kThemeStyleOnOff) boolValue];
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
    
    if (isDark) {
        
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入要搜索的内容或网址" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
    } else {
        
        self.titleView.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入要搜索的内容或网址" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: [UIColor grayColor]}];
    }
}

- (void)adjustThemeStyle {
    [super adjustThemeStyle];
    [self adjustTitleViewColor];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self adjustTitleViewColor];
}

- (UITextField *)titleView {
    return (UITextField *)self.navigationItem.titleView;
}

- (void)loadDefaultRequest {
    NSString *aUrl = [QPInfoDictionary objectForKey:@"TecentVideoUrl"];
    self.titleView.text = aUrl;
    [self loadRequest:aUrl];
}

- (void)initWebView {
    CGFloat kH   = self.view.height - QPTabBarHeight;
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
    toolBar.tag = 9999;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (UIImageView *)webToolBar {
    return (UIImageView *)[self.view viewWithTag:9999];
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
        NSString *aUrl = @"";
        NSString *lowercaseString = [text lowercaseString];
        
        if ([lowercaseString hasPrefix:@"https"] ||
            [lowercaseString hasPrefix:@"http"]) {
            aUrl = text;
        }
        else if ([lowercaseString hasPrefix:@"www."] ||
                 [lowercaseString hasPrefix:@"m."]) {
            aUrl = [NSString stringWithFormat:@"https://%@", text];
        }
        else {
            NSString *bdUrl = @"https://www.baidu.com/";
            aUrl = [aUrl stringByAppendingFormat:@"%@s?wd=%@&cl=3", bdUrl, text];
        }
        
        self.titleView.text = aUrl;
        [self loadRequest:[self urlEncode:aUrl]];
    }
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
    
    errMessage = [NSString stringWithFormat:@"An error occurred. Code is %zi", error.code];
    [QPHudObject showErrorMessage:errMessage];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailNavigation:navigation withError:error];
    
    if (!error || error.code == NSURLErrorCancelled ||
        error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    
    NSString *errMessage = [NSString stringWithFormat:@"%zi, %@", error.code, error.localizedDescription];
    QPLog(@"[error]: %@", errMessage);
    
    errMessage = [NSString stringWithFormat:@"An error occurred. Code is %zi", error.code];
    [QPHudObject showErrorMessage:errMessage];
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
    
    if ([self canAllowNavigationAction:aURL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
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

- (BOOL)canAllowNavigationAction:(NSURL *)aURL {
    NSURL *newURL  = [aURL copy];
    NSString *aUrl = newURL.absoluteString;
    
    NSString *host = [newURL host];
    QPLog(@"host: %@", host);
    
    if ([host containsString:@"zuida.com"] ||
        [host containsString:@".zuida"]    ||
        [host containsString:@"zuida"]) {
        
        if ([aUrl containsString:@"?url="]) { // host is zuidajiexi.net
            
            NSString *videoUrl = [aUrl componentsSeparatedByString:@"?url="].lastObject;
            [self attemptToPlayVideo:videoUrl];
            return NO;
            
        } else {
            
            if (![self parse80sHtmlString:aURL]) {
                [self delayToScheduleTask:1.0 completion:^{
                    [QPHudObject hideHUD];
                }];
            }
            return NO;
        }
        
    } else if ([host isEqualToString:@"jx.yingdouw.com"]) {
        
        NSString *videoUrl = [aUrl componentsSeparatedByString:@"?id="].lastObject;
        [self attemptToPlayVideo:videoUrl];
        return YES;
        
    } else if ([host isEqualToString:@"www.boqudy.com"]) {
        
        if ([aUrl containsString:@"?videourl="]) {
            NSString *tempStr = [aUrl componentsSeparatedByString:@"?videourl="].lastObject;
            NSString *videoUrl = [tempStr componentsSeparatedByString:@","].lastObject;
            [self attemptToPlayVideo:videoUrl];
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)parse80sHtmlString:(NSURL *)aURL {
    [QPHudObject showActivityMessageInView:@"正在解析..."];
    
    BOOL shouldPlay = NO;
    NSURL *newURL = [aURL copy];
    NSString *htmlString = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:NULL];
    //QPLog(@"htmlString: %@", htmlString);
    
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    if (document) {
        OCGumboNode *titleElement = document.Query(@"head").find(@"title").first();
        NSString *title = titleElement.html();
        QPLog(@"title: %@", title);
        
        OCQueryObject *objArray = document.Query(@"body").find(@"script");
        for (OCGumboNode *e in objArray) {
            NSString *text = e.html();
            //QPLog(@"e.text: %@", text);
            
            NSString *keywords = @"var main";
            
            if (text && text.length > 0 && [text containsString:keywords]) {
                NSArray *argArray = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";\""]];
                
                for (int i = 0; i < argArray.count; i++) {
                    NSString *arg = [argArray objectAtIndex:i];
                    //QPLog(@"arg: %@", arg);
                    
                    if ([arg containsString:keywords]) {
                        shouldPlay = YES;
                        
                        int index = (i+1);
                        
                        if (index < argArray.count) {
                            NSString *tempUrl  = [argArray objectAtIndex:index];
                            
                            NSString *videoUrl = [tempUrl componentsSeparatedByString:@"?"].firstObject;
                            videoUrl = [NSString stringWithFormat:@"%@://%@%@", newURL.scheme, newURL.host, videoUrl];
                            QPLog(@"videoUrl: %@", videoUrl);
                            
                            [self playVideoWithTitle:title urlString:videoUrl];
                        }
                        
                        break;
                    }
                }
            }
        }
    }
    
    return shouldPlay;
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
    
    [QPHudObject showActivityMessageInView:@"正在解析..."];
    
    NSString *videoTitle = self.webView.title;
    QPLog(@"videoTitle: %@", videoTitle);
    
    if (url && url.length > 0 && [url hasPrefix:@"http"]) {
        
        [self playVideoWithTitle:videoTitle urlString:url];
        
    } else {
        
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudObject hideHUD];
        }];
    }
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)aUrl {
    
    if (!QPlayerIsPlaying()) {
        QPlayerSavePlaying(YES);
        
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudObject hideHUD];
            
            QPlayerController *qpc = [[QPlayerController alloc] init];
            qpc.videoTitle         = title;
            qpc.videoUrl           = aUrl;
            
            [self.navigationController pushViewController:qpc animated:YES];
        }];
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
    [QPSharedApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)presentSearchViewController:(UIButton *)sender {
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"请输入要搜索的内容或网址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //QPLog(@"searchText: %@", searchText);
    }];
    
    searchViewController.delegate    = self;
    searchViewController.dataSource  = self;
    searchViewController.hotSearches = @[@"https://www.baidu.com/",
                                         @"https://wap.sogou.com/",
                                         @"https://m.so.com/",
                                         @"https://m.sm.cn/",
                                         
                                         @"https://m.v.qq.com/",
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
                                         @"http://www.boqudy.com/",
                                         
                                         @"https://xw.qq.com/m/sports/index.htm",
                                         @"https://m.live.qq.com/",
                                         @"https://sports.sina.cn/?from=wap",
                                         @"https://m.sohu.com/z/",
                                         
                                         @"https://translate.google.cn/",
                                         @"https://fanyi.baidu.com/",
                                         @"https://fanyi.youdao.com/",
                                         
                                         @"https://m.imooc.com/",
                                         @"https://m.study.163.com/",
                                         @"https://www.jikexueyuan.com/"];
    
    searchViewController.searchBar.tintColor = UIColor.blueColor;
    searchViewController.searchHistoriesCachePath = VIDEO_SEARCH_HISTORY_CACHE_PATH;
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nc.navigationBar setShadowImage:[UIImage new]];
    if (self.isDarkMode) {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBlackBg") forBarMetrics:UIBarMetricsDefault];
    } else {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    }
    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    [nc.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
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

- (BOOL)prefersStatusBarHidden {
    // override
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    // override
    return UIStatusBarAnimationSlide;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // override
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    QPLog(@" >>>>>>>>>> ");
    [self releaseWebView];
    [self removeObserver];
    [self removeManualThemeStyleObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

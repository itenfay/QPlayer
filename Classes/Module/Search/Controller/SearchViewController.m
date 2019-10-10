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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    QPLog(@" >>>>>>>>>> ");
    self.scheduleTask(self,
                      @selector(inspectWebToolBarAlpha),
                      nil,
                      1.0);
    
    [self addObserver];
    [self loadDefaultRequest];
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
    textField.textColor       = UIColor.blackColor;
    textField.leftView        = tfLeftView;
    textField.leftViewMode    = UITextFieldViewModeAlways;
    
    textField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入要搜索的内容或网址" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName: [UIColor grayColor]}];
    
    self.navigationItem.titleView = textField;
    
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
    
    self.webView.backgroundColor     = QPColorFromRGB(243, 243, 243);
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
        
        [self loadRequest:[self urlEncode:aUrl]];
        self.titleView.text = aUrl;
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
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailProvisionalNavigation:navigation withError:error];
    
    if (!error) { return; }
    
    NSString *errMessage = [NSString stringWithFormat:@"%zi, %@", error.code, error.localizedDescription];
    QPLog(@"[error]: %@", errMessage);
    
    errMessage = [NSString stringWithFormat:@"An error occurred. Code is %zi", error.code];
    [QPHudObject showErrorMessage:errMessage];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailNavigation:navigation withError:error];
    
    if (!error) { return; }
    
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
    
    if (![aUrl isEqualToString:@"about:blank"]) {
        self.requestUrl = aUrl;
        self.titleView.text = aUrl;
    }
    
    // Method NO.1: resolve the problem about '_blank'.
    //if (navigationAction.targetFrame == nil) {
        //QPLog(@"- [webView loadRequest:navigationAction.request]");
        //[webView loadRequest:navigationAction.request];
    //}
    
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
    
    //self.requestUrl = aUrl;
    //self.titleView.text = aUrl;
    
    if (!navigationAction.targetFrame.isMainFrame) {
        QPLog(@"- [webView loadRequest:navigationAction.request]");
        [webView loadRequest:navigationAction.request];
    }
    
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
        }
        else {
            if (![self parse80sLaHtmlString:aURL]) {
                [self delayToScheduleTask:2.0 completion:^{
                    [QPHudObject hideHUD];
                }];
            }
            return NO;
        }
        
    }
    else if ([host isEqualToString:@"jx.yingdouw.com"]) {
        
        NSString *videoUrl = [aUrl componentsSeparatedByString:@"?id="].lastObject;
        [self attemptToPlayVideo:videoUrl];
        return YES;
        
    }
    else if ([host isEqualToString:@"www.boqudy.com"]) {
        
        if ([aUrl containsString:@"?videourl="]) {
            NSString *tempStr  = [aUrl componentsSeparatedByString:@"?videourl="].lastObject;
            NSString *videoUrl = [tempStr componentsSeparatedByString:@","].lastObject;
            [self attemptToPlayVideo:videoUrl];
            return NO;
        }
        
    }
    else {}
    
    return NO;
}

- (BOOL)parse80sLaHtmlString:(NSURL *)aURL {
    BOOL _isPlaying = NO;
    
    [QPHudObject showActivityMessageInView:@"正在解析..."];
    
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
                        _isPlaying = YES;
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
    
    return _isPlaying;
}

- (void)runJavaScript:(NSString *)aUrl {
    NSString *videoUrl        = @"";
    __block NSString *tempUrl = @"";
    NSString *v_jsString      = nil;
    
    // Occurs javescript error.
    if ([aUrl containsString:@"haoa.haozuida.com"]) {
        
        v_jsString = @"document.getElementsByTagName('video')[0].attribute['src'].value";
        [self.webView evaluateJavaScript:v_jsString completionHandler:^(id _Nullable url, NSError * _Nullable error) {
            if (!error) {
                tempUrl = url;
            } else {
                QPLog(@"error: %@", error);
            }
        }];
        videoUrl = [tempUrl componentsSeparatedByString:@"?"].firstObject;
   
    }
    else {
        
        v_jsString = @"document.getElementsByTagName('video')[0].attribute['poster'].value";
        [self.webView evaluateJavaScript:v_jsString completionHandler:^(id _Nullable url, NSError * _Nullable error) {
            if (!error) {
                tempUrl = url;
            } else {
                QPLog(@"error: %@", error);
            }
        }];
        videoUrl = [tempUrl stringByReplacingOccurrencesOfString:@"/1.jpg" withString:@"/index.m3u8"];
    
    }
    
    QPLog(@"v_jsString: %@", v_jsString);
    QPLog(@"videoUrl: %@", videoUrl);
    
    [self attemptToPlayVideo:videoUrl];
}

- (void)attemptToPlayVideo:(NSString *)url {
    [QPHudObject showActivityMessageInView:@"正在解析..."];
    QPLog(@"videoUrl: %@", url);
    
    NSString *videoTitle = self.webView.title;
    QPLog(@"videoTitle: %@", videoTitle);
    
    if (url && url.length > 0 && [url hasPrefix:@"http"]) {
        [self playVideoWithTitle:videoTitle urlString:url];
    } else {
        [self delayToScheduleTask:2.5 completion:^{
            [QPHudObject hideHUD];
        }];
    }
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)aUrl {
    @QPWeakObject(self)
    [self delayToScheduleTask:2.5 completion:^{
        [QPHudObject hideHUD];
        
        if (!QPlayerIsPlaying()) {
            QPlayerSetPlaying(YES);
            
            QPlayerController *qpc = [[QPlayerController alloc] init];
            qpc.videoTitle         = title;
            qpc.videoUrl           = aUrl;
            
            [weak_self.navigationController pushViewController:qpc animated:YES];
        }
    }];
}

#pragma make - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showToolBarWithAnimation];
    self.scheduleTask(self,
                      @selector(cancelHidingToolBar),
                      nil,
                      0.0);
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
                      8.0);
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
    if (@available(iOS 9.0, *)) {} else {}
}

//  退出全屏
- (void)onEndFullScreen:(NSNotification *)noti {
    QPLog();
    if (@available(iOS 9.0, *)) {} else {}
    [QPSharedApp setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)presentSearchViewController:(UIButton *)sender {
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"请输入要搜索的内容或网址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //QPLog(@"searchText: %@", searchText);
    }];
    
    searchViewController.delegate   = self;
    searchViewController.dataSource = self;
    
    searchViewController.hotSearches = @[@"https://www.baidu.com/",
                                         @"https://wap.sogou.com/",
                                         @"https://m.so.com/",
                                         @"https://m.sm.cn/",
                                         @"https://www.google.com.hk/",
                                         @"https://www.yahoo.com/",
                                         
                                         @"https://m.v.qq.com/",
                                         @"https://m.iqiyi.com/",
                                         @"https://m.mgtv.com/",
                                         @"https://www.youku.com/",
                                         @"https://m.tv.sohu.com/",
                                         @"https://v.ifeng.com/",
                                         @"https://m.pptv.com/",
                                         @"https://m.le.com/",
                                         @"https://compaign.tudou.com/",
                                         @"https://m.mtime.cn/",
                                         
                                         @"https://m.ixigua.com/",
                                         @"https://www.pearvideo.com/?from=intro",
                                         @"https://www.meipai.com/",
                                         @"https://m.ku6.com/index",
                                         @"https://haokan.baidu.com/",
                                         @"http://ten.budejie.com/video/",
                                         
                                         @"https://www.y80s.net/",
                                         @"https://m.80s.la/",
                                         @"http://www.boqudy.com/",
                                         
                                         @"https://m.imooc.com/",
                                         @"https://m.study.163.com/",
                                         @"https://www.jikexueyuan.com/"];
    
    searchViewController.searchBar.tintColor = UIColor.blueColor;
    searchViewController.searchHistoriesCachePath = VIDEO_SEARCH_HISTORY_CACHE_PATH;
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    [nc.navigationBar setShadowImage:[UIImage new]];
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
    return [super prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    // overwrite
    return UIStatusBarAnimationSlide;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [super preferredStatusBarStyle];
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

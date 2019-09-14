//
//  SearchController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "SearchController.h"
#import "DYFWebProgressView.h"
#import "VideoPlayerController.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

#define SCToobBarHeight    50.f

@interface SearchController () <UITextFieldDelegate, UIWebViewDelegate, UIScrollViewDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *requestURL;
@end

@implementation SearchController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
    [self setNavigationItems];
    
    [self initWebView];
    [self setProgressViewAddedToNavigationBar];
    
    [self loadDefaultRequest];
    [self buildWebToolBar];
}

- (void)setNavigationItems {
    UITextField *tf  = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    //tf.placeholder = [NSString stringWithFormat:@"请输入要搜索的内容或网址"];
    tf.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入要搜索的内容或网址" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor grayColor]}];
    tf.borderStyle     = UITextBorderStyleRoundedRect;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.returnKeyType   = UIReturnKeyGo;
    tf.delegate        = self;
    tf.font            = [UIFont systemFontOfSize:16.f];
    tf.textColor       = UIColor.blackColor;
    self.navigationItem.titleView = tf;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    rightBtn.showsTouchWhenHighlighted = YES;
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(presentSearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 15;
    
    self.navigationItem.rightBarButtonItems = @[rightItem, spaceItem];
}

- (void)loadDefaultRequest {
    NSString *urlStr = @"https://www.baidu.com";
    
    UITextField *tf = (UITextField *)self.navigationItem.titleView;
    tf.text = urlStr;
    
    [self loadRequest:urlStr];
}

- (void)initWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, self.view.height - QPTabBarHeight)];
    self.webView.backgroundColor = QPColorFromRGB(243, 243, 243);
    self.webView.opaque = NO;
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.allowsInlineMediaPlayback = YES;
    self.webView.scrollView.delegate = self;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleWidth      |
                                     UIViewAutoresizingFlexibleTopMargin  |
                                     UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:self.webView];
}

- (void)buildWebToolBar {
    UIImageView *toolBar = [self buildCustomToolBar:@selector(controlWebNavigation:)];
    toolBar.tag = 999;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (UIImageView *)webToolBar {
    return [self.view viewWithTag:999];
}

- (void)loadRequest:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)executeSearching {
    UITextField *tf = (UITextField *)self.navigationItem.titleView;
    [tf resignFirstResponder];
    
    if (tf.text.length > 0) {
        NSString *url = @"https://www.baidu.com";
        NSString *lowercaseString = [tf.text lowercaseString];
        
        if ([lowercaseString hasPrefix:@"http"] ||
            [lowercaseString hasPrefix:@"https"]) {
            url = tf.text;
        }
        else if ([lowercaseString hasPrefix:@"www"]) {
            url = [NSString stringWithFormat:@"https://%@", tf.text];
        }
        else {
            url = [url stringByAppendingFormat:@"/s?wd=%@&cl=3", tf.text];
        }
        
        [self loadRequest:[self stringByAddingPercentEncoding:url]];
        
        tf.text = url;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyGo) {
        [self executeSearching];
    }
    return [textField resignFirstResponder];
}

- (NSString *)stringByAddingPercentEncoding:(NSString *)string {
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

#pragma make - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL allowsAccess = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    self.requestURL = request.URL;
    
    UITextField *tf = (UITextField *)self.navigationItem.titleView;
    tf.text = self.requestURL.absoluteString;
    
    return allowsAccess;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [super webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [super webView:webView didFailLoadWithError:error];
}

- (void)parseHtmlToGrabVideoUrl {
    NSString *urlString  = self.requestURL.absoluteString;
    QPLog(@"urlString: %@", urlString);
    
    //    NSError *error       = nil;
    //    NSString *htmlString = [[NSString stringWithContentsOfURL:self.requestURL encoding:NSUTF8StringEncoding error:&error] copy];
    //
    //    if (htmlString.length > 0) {
    //
    //        OCGumboDocument *document  = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    //        OCGumboElement *title_elem = (OCGumboElement *)document.Query(@"head").find(@"title").first();
    //        NSString *title = title_elem.html();
    //
    //        OCGumboElement *src_elem   = (OCGumboElement *)document.Query(@"body").find(@"iframe").first();
    //        NSString *src   = src_elem.attr(@"src");
    //
    //        if (src.length > 0) {
    //            [self playVideo:title ?: @"" url:src];
    //        }
    //    }
}

- (void)playVideo:(NSString *)title url:(NSString *)urlString {
    [self webGoBack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        VideoPlayerController *vpc = [[VideoPlayerController alloc] init];
        vpc.video_name   = title;
        vpc.video_urlstr = urlString;
        vpc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vpc animated:YES];
    });
}

#pragma make - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *toolBar = [self webToolBar];
    if (toolBar.alpha == 0.f) {
        [UIView animateWithDuration:0.5 animations:^{
            toolBar.alpha = 1.f;
        }];
    }
    [self cancelPerformRequestForHidingToolBar];
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
    [self performSelector:@selector(hideToolBar) withObject:nil afterDelay:10.0];
}

- (void)hideToolBar {
    UIView *toolBar = [self webToolBar];
    if (toolBar.alpha == 1.f) {
        [UIView animateWithDuration:0.5 animations:^{
            toolBar.alpha = 0.f;
        }];
    }
}

- (void)cancelPerformRequestForHidingToolBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToolBar) object:nil];
}

- (void)webGoBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)webGoForward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)webReload {
    [self.webView reload];
}

- (void)webStopLoading {
    [self.webView stopLoading];
}

- (void)controlWebNavigation:(UIButton *)sender {
    NSUInteger index = sender.tag - 100;
    
    switch (index) {
        case 0: {
            [self webGoBack];
            break;
        }
            
        case 1: {
            [self webGoForward];
            break;
        }
            
        case 2: {
            [self webReload];
            break;
        }
            
        case 3: {
            [self parseHtmlToGrabVideoUrl];
            break;
        }
            
        default:
            break;
    }
}

- (void)addObserver {
    [QPNotiDefaultCenter addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil]; // 进入全屏
    [QPNotiDefaultCenter addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];  // 退出全屏
}

- (void)removeObserver {
    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [QPNotiDefaultCenter removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
}

// 进入全屏
- (void)beginFullScreen {
    if (@available(iOS 9.0, *)) {} else {
        QPSharedApp.statusBarHidden = NO;
    }
}

//  退出全屏
- (void)endFullScreen {
    if (@available(iOS 9.0, *)) {} else {
        QPSharedApp.statusBarHidden = NO;
    }
}

- (void)presentSearchViewController:(UIButton *)sender {
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入要搜索的内容或网址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        QPLog(@"searchText: %@", searchText);
    }];
    
    searchViewController.hotSearchStyle     = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    searchViewController.delegate   = self;
    searchViewController.dataSource = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - PYSearchViewControllerDelegate

// Called when search begain
- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
    
    if (searchBar.text.length > 0) {
        [self searchSuggestionsWithSearchText:searchBar.text];
    }
}

// Called when popular search is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
}

// Called when search history is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    QPLog(@"searchText: %@", searchText);
    
    if (searchText.length > 0) {
        UITextField *tf = (UITextField *)self.navigationItem.titleView;
        tf.text = searchText;
        
        [self searchSuggestionsWithSearchText:searchText];
        [self didClickCancel:searchViewController];
        
        [self executeSearching];
    }
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
    QPLog();
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchSuggestionsWithSearchText:(NSString *)searchText {
    //Send request to get a search suggestions
    
    //NSMutableArray *searchSuggestionsM = [NSMutableArray array];
    
    // Refresh and display the search suggustions
    //self.searchSuggestions = searchSuggestionsM;
}

- (void)dealloc {
    [self removeObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

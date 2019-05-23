//
//  SearchController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "SearchController.h"
#import "DYFWebProgressView.h"

#define SCToobBarHeight 50.f

@interface SearchController () <UITextFieldDelegate, UIWebViewDelegate, PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItems];
    [self addWebToolbar];
    
    [self initWebView];
    
    [self setProgressViewAddedToWebView];
}

- (void)setNavigationItems {
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    tf.placeholder = [NSString stringWithFormat:@"请输入要搜索的内容或网址"];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.returnKeyType = UIReturnKeyGo;
    tf.delegate = self;
    self.navigationItem.titleView = tf;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(wbSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 15;
    
    self.navigationItem.rightBarButtonItems = @[item, spaceItem];
}

- (void)addWebToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.height - QPTabbarHeight - SCToobBarHeight, self.view.width, SCToobBarHeight)];
    toolbar.tag = 20;
    [toolbar setBarStyle:UIBarStyleDefault];
    
    NSArray *imgNames = @[@"ic_browser_reward_13x21", @"ic_browser_forward_13x21", @"ic_browser_refresh_24x21", @"ic_browser_stop_21x21"];
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 30;
    NSUInteger count = imgNames.count;
    CGFloat itemFixedSpace = (toolbar.width - (btnWidth*count)) / (count + 1) - 5;
    
    NSMutableArray *mItems = [NSMutableArray arrayWithCapacity:0];
    for (NSUInteger i = 0; i < count; i++) {
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = itemFixedSpace;
        [mItems addObject:space];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10 + i;
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
        [btn setImage:QPImageNamed(imgNames[i]) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(webControlAtcion:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [mItems addObject:item];
    }
    
    [toolbar setItems:mItems];
    
    toolbar.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:toolbar];
}

- (void)initWebView {
    UIToolbar *bar = [self.view viewWithTag:20];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, bar.width, bar.top + 5)];
    self.webView.backgroundColor = QPColorRGB(243, 243, 243);
    self.webView.opaque = NO;
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.allowsInlineMediaPlayback = YES;
    
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.webView];
}

- (void)loadRequest:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)wbSearch {
    UITextField *tf = (UITextField *)self.navigationItem.titleView;
    [tf resignFirstResponder];
    
    if (tf.text.length > 0) {
        NSString *url = @"https://www.baidu.com";
        
        NSString *lows = [tf.text lowercaseString];
        if ([lows hasPrefix:@"http"]) {
            url = tf.text;
        }
        else if ([lows hasPrefix:@"www"]) {
            url = [NSString stringWithFormat:@"http://%@", tf.text];
        }
        else {
            url = [url stringByAppendingFormat:@"/s?wd=%@&cl=3", tf.text];
        }
        
        [self loadRequest:[self stringByAddingPercentEncoding:url]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self search];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyGo) {
        [self wbSearch];
    }
    return [textField resignFirstResponder];
}

- (NSString *)stringByAddingPercentEncoding:(NSString *)string {
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL allowsAccess = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
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

- (void)wbGoBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)wbGoForward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)wbReload {
    [self.webView reload];
}

- (void)wbStopLoading {
    [self.webView stopLoading];
}

- (void)webControlAtcion:(UIButton *)sender {
    NSUInteger index = sender.tag - 10;
    
    switch (index) {
        case 0: {
            [self wbGoBack];
            break;
        }
            
        case 1: {
            [self wbGoForward];
            break;
        }
            
        case 2: {
            [self wbReload];
            break;
        }
            
        case 3: {
            [self wbStopLoading];
            break;
        }
            
        default:
            break;
    }
}

- (void)addObserver {
    [QPNotiDefaultCenter addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil]; //进入全屏
    [QPNotiDefaultCenter addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil]; //退出全屏
}

- (void)removeObserver {
    [QPNotiDefaultCenter removeObserver:self];
}

#pragma - mark 进入全屏

- (void)beginFullScreen {
    QPSharedApp.statusBarHidden = NO;
}

#pragma - mark 退出全屏

- (void)endFullScreen {
    QPSharedApp.statusBarHidden = NO;
}

- (void)search {
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入要搜索的内容或网址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        QPLog(@"searchText: %@", searchText);
    }];
    
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nav.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
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
        
        [self wbSearch];
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

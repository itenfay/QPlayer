//
//  QPWebPresenter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPWebPresenter.h"
#import "QPWebController.h"

typedef void (^LoadDidFinishBlock)(BOOL);

@interface QPWebPresenter () <PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>
@property (nonatomic, copy) LoadDidFinishBlock finishBlock;
@end

@implementation QPWebPresenter

- (void)setViewController:(BaseWebViewController *)viewController
{
    _viewController = viewController;
    QPWKWebViewAdapter *webAdapter = (QPWKWebViewAdapter *)_viewController.adapter;
    _playbackContext = [[QPWebPlaybackContext alloc] initWithAdapter:webAdapter viewController:_viewController];
}

- (void)presentSearchViewController:(NSArray<NSString *> *)hotSearches cachePath:(NSString *)cachePath
{
    //searchViewController.hotSearches = @[@"https://www.baidu.com/",
    //                                     @"https://wap.sogou.com/",
    //                                     @"https://m.so.com/",
    //                                     @"https://m.sm.cn/",
    //
    //                                     @"https://m.v.qq.com/",
    //                                     @"https://m.mgtv.com/",
    //                                     @"https://m.iqiyi.com/",
    //                                     @"https://www.youku.com/",
    //                                     @"https://m.tv.sohu.com/",
    //                                     @"https://m.pptv.com/",
    //                                     @"https://m.le.com/",
    //                                     @"https://m.mtime.cn/",
    //
    //                                     @"https://m.ixigua.com/",
    //                                     @"https://v.ifeng.com/",
    //                                     @"https://haokan.baidu.com/",
    //                                     @"https://www.pearvideo.com/?from=intro",
    //                                     @"http://ten.budejie.com/video/",
    //                                     @"https://m.ku6.com/index",
    //
    //                                     @"https://www.y80s.net/",
    //
    //                                     @"https://xw.qq.com/m/sports/index.htm",
    //                                     @"https://m.live.qq.com/",
    //                                     @"https://sports.sina.cn/?from=wap",
    //                                     @"https://m.sohu.com/z/",
    //
    //                                     @"https://translate.google.cn/",
    //                                     @"https://fanyi.baidu.com/",
    //                                     @"https://fanyi.youdao.com/",
    //
    //                                     @"https://m.imooc.com/",
    //                                     @"https://m.study.163.com/",
    //                                     @"https://www.jikexueyuan.com/"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"请输入要搜索的内容或网址"];
    searchViewController.delegate    = self;
    searchViewController.dataSource  = self;
    searchViewController.hotSearches = hotSearches;
    searchViewController.searchBar.tintColor = UIColor.blueColor;
    searchViewController.searchHistoriesCachePath = cachePath;
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModeModal;
    
    BOOL darkMode = _viewController.isDarkMode;
    UIColor *bgColor = darkMode ? QPColorFromRGB(20, 20, 20) : QPColorFromRGB(240, 240, 240);
    searchViewController.view.backgroundColor = bgColor;
    //[_viewController presentViewController:searchViewController animated:YES completion:nil];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nc.navigationBar setShadowImage:[UIImage new]];
    if (darkMode) {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBlackBg") forBarMetrics:UIBarMetricsDefault];
    } else {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    }
    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    [nc.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
           NSForegroundColorAttributeName: [UIColor whiteColor]}
    ];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        /// 背景色
        appearance.backgroundColor = QPColorFromRGB(39, 220, 203);
        /// 去掉半透明效果
        appearance.backgroundEffect = nil;
        /// 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
        appearance.shadowColor = UIColor.clearColor;
        appearance.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName: UIColor.whiteColor};
        nc.navigationBar.standardAppearance = appearance;
        nc.navigationBar.scrollEdgeAppearance = appearance;
    }
    //nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //nc.modalPresentationStyle = UIModalPresentationFullScreen;
    [_viewController presentViewController:nc animated:YES completion:^{
        [self changeSearchControllerCancelButtonWidth];
    }];
}

- (void)changeSearchControllerCancelButtonWidth
{
    UIViewController *vc = [self tf_currentViewController];
    vc = vc.parentViewController;
    if ([vc isKindOfClass:PYSearchViewController.class]) {
        PYSearchViewController *searchVC = (PYSearchViewController *)vc;
        searchVC.cancelButton.width = 50.f;
        searchVC.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (void)loadData:(NSString *)searchText searchViewController:(PYSearchViewController *)searchViewController {
    if (searchText.length > 0) {
        QPWebController *vc = (QPWebController *)self.viewController;
        vc.titleView.text = searchText;
        [self searchSuggestionsWithSearchText:searchText];
        [self didClickCancel:searchViewController];
        [vc loadWebContents];
    }
}

#pragma mark - PYSearchViewControllerDelegate

/// Called when search begain
- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText
{
    QPLog(@"searchText=%@", searchText);
    [self loadData:searchText searchViewController:searchViewController];
}

/// Called when popular search is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText
{
    QPLog(@"searchText=%@", searchText);
    [self loadData:searchText searchViewController:searchViewController];
}

/// Called when search history is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText
{
    QPLog(@"searchText=%@", searchText);
    [self loadData:searchText searchViewController:searchViewController];
}

/// Called when search suggestion is selected, the method support more custom of search suggestion view
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar
{
    QPLog(@"searchIndex=%zi", indexPath.row);
}

/// Called when search text did change, you can reload data of suggestion view thought this method
- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText
{
    QPLog(@"searchText=%@", searchText);
}

/// Called when cancel item did press, default execute `[self dismissViewControllerAnimated:YES completion:nil]`
- (void)didClickCancel:(PYSearchViewController *)searchViewController
{
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchSuggestionsWithSearchText:(NSString *)searchText
{
    QPLog(@"searchText=%@", searchText);
    //Send request to get a search suggestions
    //NSMutableArray *searchSuggestions = [NSMutableArray array];
    // Refresh and display the search suggustions
    //self.searchSuggestions = searchSuggestions;
}

#pragma mark - WKWebViewAdapterDelegate

- (void)adapter:(QPWKWebViewAdapter *)adapter didStartProvisionalNavigation:(WKNavigation *)navigation
{
    QPLog(@"");
}

- (void)adapter:(QPWKWebViewAdapter *)adapter didFinishNavigation:(WKNavigation *)navigation
{
    QPLog(@"");
    !_finishBlock ?: _finishBlock(YES);
    if (!QPPlayerParsingWebVideo()) return;
    [_playbackContext queryVideoUrlByCustomJavaScript];
}

- (void)adapter:(QPWKWebViewAdapter *)adapter decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    QPLog(@"");
    //[_playbackContext canAllowNavigation:adapter.webView.URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)loadDidFinish:(void (^)(BOOL))completionHandler
{
    _finishBlock = completionHandler;
}

@end

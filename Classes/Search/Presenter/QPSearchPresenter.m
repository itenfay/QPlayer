//
//  QPSearchPresenter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPSearchPresenter.h"
#import "QPPlayerController.h"
#import "QPSearchViewController.h"

@interface QPSearchPresenter () <PYSearchViewControllerDelegate, PYSearchViewControllerDataSource>

@end

@implementation QPSearchPresenter

- (void)playVideoWithUrl:(NSString *)url
{
    if (!QPlayerIsPlaying()) {
        QPPlayerModel *model = [[QPPlayerModel alloc] init];
        model.isZFPlayerPlayback = YES;
        model.videoTitle         = url;
        model.videoUrl           = url;
        QPPlayerController *qpc  = [[QPPlayerController alloc] initWithModel:model];
        [self.viewController.navigationController pushViewController:qpc animated:YES];
    }
}

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
//                                     @"http://www.boqudy.com/",
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
- (void)presentSearchViewController:(NSArray<NSString *> *)hotSearches
{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"请输入要搜索的内容或网址" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //QPLog(@":: searchText=%@", searchText);
    }];
    searchViewController.delegate    = self;
    searchViewController.dataSource  = self;
    searchViewController.hotSearches = hotSearches;
    searchViewController.searchBar.tintColor = UIColor.blueColor;
    searchViewController.searchHistoriesCachePath = VIDEO_SEARCH_HISTORY_CACHE_PATH;
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleDefault;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [nc.navigationBar setShadowImage:[UIImage new]];
    if (_viewController.isDarkMode) {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBlackBg") forBarMetrics:UIBarMetricsDefault];
    } else {
        [nc.navigationBar setBackgroundImage:QPImageNamed(@"NavigationBarBg") forBarMetrics:UIBarMetricsDefault];
    }
    [nc.navigationBar setTintColor:[UIColor whiteColor]];
    [nc.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName: [UIFont systemFontOfSize:15.f],
           NSForegroundColorAttributeName: [UIColor whiteColor]}
    ];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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
    [_viewController presentViewController:nc animated:YES completion:nil];
}

- (void)loadData:(NSString *)searchText searchViewController:(PYSearchViewController *)searchViewController {
    if (searchText.length > 0) {
        QPSearchViewController *vc = (QPSearchViewController *)self.viewController;
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
    QPLog(@":: searchText=%@", searchText);
    [self loadData:searchText searchViewController:searchViewController];
}

/// Called when popular search is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText
{
    QPLog(@":: searchText=%@", searchText);
    [self loadData:searchText searchViewController:searchViewController];
}

/// Called when search history is selected
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText
{
    QPLog(@":: searchText=%@", searchText);
    [self loadData:searchText searchViewController:searchViewController];
}

/// Called when search suggestion is selected, the method support more custom of search suggestion view
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar
{
    QPLog(@":: search index: %zi", indexPath.row);
}

/// Called when search text did change, you can reload data of suggestion view thought this method
- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText
{
    QPLog(@":: searchText=%@", searchText);
}

/// Called when cancel item did press, default execute `[self dismissViewControllerAnimated:YES completion:nil]`
- (void)didClickCancel:(PYSearchViewController *)searchViewController
{
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchSuggestionsWithSearchText:(NSString *)searchText
{
    QPLog(@":: searchText=%@", searchText);
    //Send request to get a search suggestions
    //NSMutableArray *searchSuggestions = [NSMutableArray array];
    // Refresh and display the search suggustions
    //self.searchSuggestions = searchSuggestions;
}

@end

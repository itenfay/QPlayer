//
//  BaseAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BaseDelegate.h"
#import "BaseModel.h"

@class BaseListViewAdapter;
@class BaseAdapter;

@protocol ListViewAdapterDelegate <BaseDelegate>

@optional
/// The number of sections in tableView.
/// @param adapter The adapter for tableView.
- (NSInteger)numberOfSectionsForAdapter:(BaseListViewAdapter *)adapter;

/// Returns a nonnegative floating-point value that specifies the height (in points) of the header for section.
/// @param section An index number identifying a section of tableView.
/// @param adapter The adapter for tableView.
- (CGFloat)heightForHeaderInSection:(NSInteger)section forAdapter:(BaseListViewAdapter *)adapter;

/// Returns the view object to display at the top of the specified section
/// @param section The index number of the section containing the header view.
/// @param adapter The adapter for tableView.
- (UIView *)viewForHeaderInSection:(NSInteger)section forAdapter:(BaseListViewAdapter *)adapter;

- (CGFloat)heightForFooterInSection:(NSInteger)section forAdapter:(BaseListViewAdapter *)adapter;

- (UIView *)viewForFooterInSection:(NSInteger)section forAdapter:(BaseListViewAdapter *)adapter;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;
- (void)willDisplayCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;;
- (void)didEndDisplayingCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;;

- (void)selectCell:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;;
- (void)deselectCell:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;;
- (BOOL)deleteCell:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(BaseListViewAdapter *)adapter;;

@end

@protocol ScrollViewAdapterDelegate <BaseDelegate>

@optional
/// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;
/// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;
/// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset forAdapter:(BaseAdapter *)adapter;
/// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate forAdapter:(BaseAdapter *)adapter;
/// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;
/// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;
/// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;
/// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView forAdapter:(BaseAdapter *)adapter;

@end

@class BaseWebAdapter;

@protocol WKWebViewAdapterDelegate <BaseDelegate>

@optional
- (void)adapter:(BaseWebAdapter *)adapter didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)adapter:(BaseWebAdapter *)adapter didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;
- (void)adapter:(BaseWebAdapter *)adapter didCommitNavigation:(WKNavigation *)navigation;
- (void)adapter:(BaseWebAdapter *)adapter didFinishNavigation:(WKNavigation *)navigation;
- (void)adapter:(BaseWebAdapter *)adapter didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (void)adapter:(BaseWebAdapter *)adapter didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (WKWebView *)adapter:(BaseWebAdapter *)adapter createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;
- (void)adapter:(BaseWebAdapter *)adapter decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)adapter:(BaseWebAdapter *)adapter didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler;
- (void)adapter:(BaseWebAdapter *)adapter decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
- (void)adapter:(BaseWebAdapter *)adapter runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler;
- (void)adapter:(BaseWebAdapter *)adapter userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@protocol ListViewDataBindingProcotol <BaseDelegate>

@optional
- (void)bindModelTo:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withViewController:(UIViewController *)viewController;
- (void)bindModelTo:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withView:(UIView *)view;

@end

@interface BaseAdapter : NSObject
@property (nonatomic, assign) BOOL isDarkMode;
@end

@interface BaseListViewAdapter : BaseAdapter

@property (nonatomic, weak) id<ScrollViewAdapterDelegate> scrollViewDelegate;
@property (nonatomic, weak) id<ListViewAdapterDelegate> listViewDelegate;

@end

@interface BaseWebAdapter : BaseAdapter

@property (nonatomic, weak) id<ScrollViewAdapterDelegate> scrollViewDelegate;

- (void)onHandleImmediately;

@end

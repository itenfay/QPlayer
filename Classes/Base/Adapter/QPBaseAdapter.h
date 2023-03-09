//
//  QPBaseAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QPBaseDelegate.h"
#import "QPBaseModel.h"

@class QPListViewAdapter;
@class QPBaseAdapter;

@protocol QPListViewAdapterDelegate <QPBaseDelegate>

@optional
/// The number of sections in tableView.
/// @param adapter The adapter for tableView.
- (NSInteger)numberOfSectionsForAdapter:(QPListViewAdapter *)adapter;

/// Returns a nonnegative floating-point value that specifies the height (in points) of the header for section.
/// @param section An index number identifying a section of tableView.
/// @param adapter The adapter for tableView.
- (CGFloat)heightForHeaderInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

/// Returns the view object to display at the top of the specified section
/// @param section The index number of the section containing the header view.
/// @param adapter The adapter for tableView.
- (UIView *)viewForHeaderInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

- (CGFloat)heightForFooterInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

- (UIView *)viewForFooterInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;
- (void)willDisplayCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;;
- (void)didEndDisplayingCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;;

- (void)selectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;;
- (void)deselectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;;
- (BOOL)deleteCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter;;

@end

@protocol QPScrollViewAdapterDelegate <QPBaseDelegate>

@optional
/// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;
/// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;
/// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset forAdapter:(QPBaseAdapter *)adapter;
/// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate forAdapter:(QPBaseAdapter *)adapter;
/// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;
/// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;
/// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;
/// return a yes if you want to scroll to the top. if not defined, assumes YES
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView forAdapter:(QPBaseAdapter *)adapter;

@end

@class QPWKWebViewAdapter;

@protocol QPWKWebViewAdapterDelegate <QPBaseDelegate>

@optional
- (void)adapter:(QPWKWebViewAdapter *)adapter didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)adapter:(QPWKWebViewAdapter *)adapter didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;
- (void)adapter:(QPWKWebViewAdapter *)adapter didCommitNavigation:(WKNavigation *)navigation;
- (void)adapter:(QPWKWebViewAdapter *)adapter didFinishNavigation:(WKNavigation *)navigation;
- (void)adapter:(QPWKWebViewAdapter *)adapter didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (void)adapter:(QPWKWebViewAdapter *)adapter didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (WKWebView *)adapter:(QPWKWebViewAdapter *)adapter createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;
- (void)adapter:(QPWKWebViewAdapter *)adapter decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)adapter:(QPWKWebViewAdapter *)adapter didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler;
- (void)adapter:(QPWKWebViewAdapter *)adapter decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
- (void)adapter:(QPWKWebViewAdapter *)adapter runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler;
- (void)adapter:(QPWKWebViewAdapter *)adapter userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@protocol QPListViewDataBindingProcotol <QPBaseDelegate>

@optional
- (void)bindModelTo:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView withViewController:(UIViewController *)viewController;

@end

@interface QPBaseAdapter : NSObject

@end

@interface QPBaseListViewAdapter : QPBaseAdapter

@property (nonatomic, weak) id<QPScrollViewAdapterDelegate> scrollViewDelegate;
@property (nonatomic, weak) id<QPListViewAdapterDelegate> listViewDelegate;

@end

@interface QPBaseWebAdapter : QPBaseAdapter

@property (nonatomic, weak) id<QPScrollViewAdapterDelegate> scrollViewDelegate;

@end

//
//  QPWebPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "BasePresenter.h"
#import "BaseAdapter.h"
#import "QPWebPlaybackContext.h"

@interface QPWebPresenter : BasePresenter <QPPresenterDelegate, ScrollViewAdapterDelegate, WKWebViewAdapterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) BaseWebViewController *viewController;

@property (nonatomic, strong) QPWebPlaybackContext *playbackContext;

- (void)presentSearchViewController:(NSArray<NSString *> *)hotSearches cachePath:(NSString *)cachePath;

- (void)loadDidFinish:(void (^)(BOOL))completionHandler;

@end

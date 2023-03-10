//
//  QPWebPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPBaseAdapter.h"
#import "QPWebPlaybackContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPWebPresenter : QPBasePresenter <QPPresenterDelegate, QPScrollViewAdapterDelegate, QPWKWebViewAdapterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

@property (nonatomic, strong) QPWebPlaybackContext *playbackContext;

- (void)presentSearchViewController:(NSArray<NSString *> *)hotSearches cachePath:(NSString *)cachePath
- (void)playVideoWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

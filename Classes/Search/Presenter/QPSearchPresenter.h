//
//  QPSearchPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPSearchPresenter : QPBasePresenter <QPPresenterDelegate, QPScrollViewAdapterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (void)playVideoWithUrl:(NSString *)url;
- (void)presentSearchViewController:(NSArray<NSString *> *)hotSearches;

@end

NS_ASSUME_NONNULL_END

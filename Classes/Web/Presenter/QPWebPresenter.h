//
//  QPWebPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPWebPresenter : QPBasePresenter <QPPresenterDelegate, QPScrollViewAdapterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (void)presentSearchViewController:(NSArray<NSString *> *)hotSearches;
- (void)playVideoWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

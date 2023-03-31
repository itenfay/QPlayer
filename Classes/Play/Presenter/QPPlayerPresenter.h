//
//  QPPlayerPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPPlayerPresenter : QPBasePresenter <QPPresenterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (ZFPlayerController *)player;
- (void)prepareToPlay;
- (void)seekToTime:(NSTimeInterval)time;
- (void)enterPortraitFullScreen;

@end

NS_ASSUME_NONNULL_END

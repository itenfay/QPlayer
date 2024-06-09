//
//  QPPlayerPresenter.h
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "BasePresenter.h"
#import "QPPlayerModel.h"

@class BaseViewController, ZFPlayerController;

@interface QPPlayerPresenter : BasePresenter <QPPresenterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) BaseViewController *viewController;

- (ZFPlayerController *)player;

- (void)prepareToPlay;

- (void)seekToTime:(NSTimeInterval)time;
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completionHandler;

- (void)enterPortraitFullScreen;

@end

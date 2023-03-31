//
//  QPPictureInPicturePresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBaseViewController.h"
#import "QPBasePresenter.h"
#import "QPPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPPictureInPicturePresenter : QPBasePresenter <QPPresenterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, strong, readonly) QPPlayerModel *playerModel;

- (BOOL)isPictureInPictureValid;
- (BOOL)isPictureInPicturePossible;
- (BOOL)isPictureInPictureActive;
- (BOOL)isPictureInPictureSuspended;

- (void)startPictureInPicture;
- (void)stopPictureInPicture;

@end

NS_ASSUME_NONNULL_END

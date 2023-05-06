//
//  QPPictureInPictureContext.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBaseContext.h"

NS_ASSUME_NONNULL_BEGIN

@class QPBasePresenter, QPPlayerModel;

@interface QPPictureInPictureContext : QPBaseContext
@property (nonatomic, weak) QPBasePresenter *presenter;
@property (nonatomic, strong, readonly) QPPlayerModel *playerModel;

- (void)configPlayerModel:(QPPlayerModel *)model;

- (BOOL)isPictureInPictureValid;
- (BOOL)isPictureInPicturePossible;
- (BOOL)isPictureInPictureActive;
- (BOOL)isPictureInPictureSuspended;

- (void)startPictureInPicture;
- (void)stopPictureInPicture;

@end

NS_ASSUME_NONNULL_END

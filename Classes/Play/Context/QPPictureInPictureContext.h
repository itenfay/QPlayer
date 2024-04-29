//
//  QPPictureInPictureContext.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "BaseContext.h"

@class BasePresenter, QPPlayerModel;

@interface QPPictureInPictureContext : BaseContext
@property (nonatomic, weak) BasePresenter *presenter;
@property (nonatomic, strong, readonly) QPPlayerModel *playerModel;
@property (nonatomic, assign) NSTimeInterval playerCurrentTime;

- (void)configPlayerModel:(QPPlayerModel *)model;

- (BOOL)isPictureInPictureValid;
- (BOOL)isPictureInPicturePossible;
- (BOOL)isPictureInPictureActive;
- (BOOL)isPictureInPictureSuspended;

- (void)check;
- (void)startPictureInPicture;
- (void)stopPictureInPicture;

@end

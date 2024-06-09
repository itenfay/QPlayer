//
//  QPlayerController.h
//  QPlayer
//
//  Created by Tenfay on 2017/12/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPWebController.h"
#import "QPPlayerModel.h"
#import "QPPlayerPresenter.h"

@interface QPPlayerController : QPWebController

@property (nonatomic, strong) QPPlayerModel *model;

- (instancetype)initWithModel:(QPPlayerModel *)model;

- (UIImageView *)containerView;
- (ZFPlayerControlView *)controlView;

- (void)showOverlayLayer;
- (void)hideOverlayLayer;

@end

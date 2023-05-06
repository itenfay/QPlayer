//
//  QPlayerController.h
//  QPlayer
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseWebViewController.h"
#import "QPPlayerModel.h"
#import "QPPlayerPresenter.h"

@interface QPPlayerController : QPBaseWebViewController

@property (nonatomic, strong) QPPlayerModel *model;

- (instancetype)initWithModel:(QPPlayerModel *)model;

- (UIImageView *)containerView;
- (ZFPlayerControlView *)controlView;

- (void)showOverlayLayer;
- (void)hideOverlayLayer;

@end

//
//  QPSettingsPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 dyf. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPModularDelegate.h"
#import "QPBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface QPSettingsPresenter : QPBasePresenter <QPPresenterDelegate, QPListViewAdapterDelegate>
@property (nonatomic, assign) UInt16 mPort;
@property (nonatomic, weak) UITableView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END

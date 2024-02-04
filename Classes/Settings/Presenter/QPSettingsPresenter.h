//
//  QPSettingsPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 dyf. All rights reserved.
//

#import "BasePresenter.h"
#import "QPModularDelegate.h"
#import "BaseAdapter.h"

@interface QPSettingsPresenter : BasePresenter <QPPresenterDelegate, ListViewAdapterDelegate>
@property (nonatomic, assign) UInt16 mPort;
@property (nonatomic, weak) UITableView *view;
@property (nonatomic, weak) BaseViewController *viewController;

- (void)loadData;

@end

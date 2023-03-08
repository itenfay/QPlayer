//
//  QPAboutMePresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPModularDelegate.h"
#import "QPAboutMeListViewAdapter.h"
#if __has_include(<SafariServices/SafariServices.h>)
#import <SafariServices/SafariServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPAboutMePresenter : QPBasePresenter <QPPresenterDelegate, QPListViewAdapterDelegate, SFSafariViewControllerDelegate>
#else
@interface QPAboutMePresenter : QPBasePresenter <QPPresenterDelegate, QPListViewAdapterDelegate>
#endif
@property (nonatomic, weak) UITableView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (void)loadData;
- (void)configTableViewHeaderFooter;

@end

NS_ASSUME_NONNULL_END

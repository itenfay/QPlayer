//
//  QPAboutMePresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "BasePresenter.h"
#import "QPModularDelegate.h"
#import "QPAboutMeListViewAdapter.h"
#if __has_include(<SafariServices/SafariServices.h>)
#import <SafariServices/SafariServices.h>

@interface QPAboutMePresenter : BasePresenter <QPPresenterDelegate, ListViewAdapterDelegate, SFSafariViewControllerDelegate>
#else
@interface QPAboutMePresenter : BasePresenter <QPPresenterDelegate, ListViewAdapterDelegate>
#endif
@property (nonatomic, weak) UITableView *view;
@property (nonatomic, weak) BaseViewController *viewController;

- (void)loadData;
- (void)configTableViewHeaderFooter;

@end

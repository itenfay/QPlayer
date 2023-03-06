//
//  QPHomePresenter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPWifiManager.h"
#import "QPFileHelper.h"
#import "QPHomeViewController.h"

// Transforms two objects's title to pinying and sorts them.
FOUNDATION_EXTERN NSInteger qp_sortObjects(QPFileModel *o1, QPFileModel *o2, void *context);

@interface QPHomePresenter : QPBasePresenter <WebFileResourceDelegate, QPPresenterDelegate>
@property (nonatomic, weak) QPHomeView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (instancetype)initWithViewController:(QPBaseViewController *)viewController;

- (void)loadData;

@end

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

@interface QPHomePresenter : QPBasePresenter <WebFileResourceDelegate, QPPresenterDelegate>
@property (nonatomic, weak) QPHomeView *view;
@property (nonatomic, weak) QPBaseViewController *viewController;

- (instancetype)initWithViewController:(QPBaseViewController *)viewController;

- (void)loadData;

@end

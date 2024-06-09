//
//  QPHomePresenter.h
//
//  Created by Tenfay on 2015/6/18. ( https://github.com/itenfay/QPlayer )
//  Copyright (c) 2015 Tenfay. All rights reserved.
//

#import "BasePresenter.h"
#import "QPWifiManager.h"
#import "QPFileHelper.h"
#import "QPHomeViewController.h"

@interface QPHomePresenter : BasePresenter <WebFileResourceDelegate, QPPresenterDelegate>
@property (nonatomic, weak) QPHomeView *view;
@property (nonatomic, weak) BaseViewController *viewController;

- (instancetype)initWithViewController:(BaseViewController *)viewController;

- (void)loadData;

@end

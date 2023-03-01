//
//  QPHomeViewController.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseViewController.h"
#import "QPHomeView.h"
#import "QPListViewAdapter.h"
#import "QPHomePresenter.h"

@interface QPHomeViewController : QPBaseViewController
@property (nonatomic, strong) QPHomeView *homeView;
@end

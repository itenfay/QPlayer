//
//  QPModularDelegate.h
//
//  Created by dyf on 2017/6/27. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import "QPBaseDelegate.h"

@class QPHomePresenter;

@protocol QPModularDelegate <QPBaseDelegate>

@optional

- (void)loadHomeViewData:(QPHomePresenter *)presenter;

@end


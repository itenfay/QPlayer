//
//  QPModularDelegate.h
//
//  Created by chenxing on 2017/6/27. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseDelegate.h"

@class QPHomePresenter;

@protocol QPModularDelegate <QPBaseDelegate>

@optional

- (void)loadHomeViewData:(QPHomePresenter *)presenter;

@end


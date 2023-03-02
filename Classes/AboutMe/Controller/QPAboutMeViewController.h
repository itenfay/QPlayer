//
//  QPAboutMeViewController.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseViewController.h"
#import "QPAboutMeListViewAdapter.h"

@interface QPAboutMeViewController : QPBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_tableViewBottom;
@property (strong, nonatomic) QPAboutMeListViewAdapter *adapter;

@end

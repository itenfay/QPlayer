//
//  QPAboutMeViewController.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseViewController.h"
#import "QPAboutMeListViewAdapter.h"

@interface QPAboutMeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_tableViewBottom;
@property (strong, nonatomic) QPAboutMeListViewAdapter *adapter;

@end

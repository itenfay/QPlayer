//
//  QPAboutMeViewController.h
//
//  Created by Tenfay on 2017/6/28.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseViewController.h"
#import "QPAboutMeListViewAdapter.h"

@interface QPAboutMeViewController : BaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_tableViewBottom;
@property (strong, nonatomic) QPAboutMeListViewAdapter *adapter;

@end

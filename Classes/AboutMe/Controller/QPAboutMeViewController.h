//
//  AboutMeViewController.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseViewController.h"
#if __has_include(<SafariServices/SafariServices.h>)
#import <SafariServices/SafariServices.h>

@interface AboutMeViewController : BaseViewController <SFSafariViewControllerDelegate>
#else

@interface AboutMeViewController : BaseViewController
#endif

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_tableViewBottom;

@end

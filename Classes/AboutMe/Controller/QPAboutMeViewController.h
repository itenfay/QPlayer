//
//  QPAboutMeViewController.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseViewController.h"
#if __has_include(<SafariServices/SafariServices.h>)
#import <SafariServices/SafariServices.h>

@interface QPAboutMeViewController : QPBaseViewController <SFSafariViewControllerDelegate>
#else

@interface QPAboutMeViewController : QPBaseViewController
#endif

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_tableViewBottom;

@end

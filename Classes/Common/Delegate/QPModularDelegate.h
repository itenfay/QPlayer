//
//  QPModularDelegate.h
//
//  Created by Tenfay on 2017/6/27. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseDelegate.h"

@protocol QPPresenterDelegate <BaseDelegate>
- (void)setView:(NSObject *)view;
- (void)setViewController:(UIViewController *)viewController;
@optional
- (void)present;
- (void)presentWithModel:(id)model viewController:(UIViewController *)viewController;
@end

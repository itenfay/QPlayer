//
//  QPTabBarController.h
//
//  Created by Tenfay on 2017/12/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QPTabBarController : UITabBarController

// Whether The dark interface style was truned on.
@property (nonatomic, assign, readonly) BOOL isDarkMode;

- (void)adaptThemeStyle;

@end

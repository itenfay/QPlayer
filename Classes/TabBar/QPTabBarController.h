//
//  QPTabBarController.h
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QPTabBarController : UITabBarController

// Whether The dark interface style was truned on.
@property (nonatomic, assign, readonly) BOOL isDarkMode;

- (void)adaptThemeStyle;

@end

//
//  QPHudObject.h
//
//  Created by dyf on 2017/9/1.
//  Copyright © 2017 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+JDragon.h"

@interface QPHudObject : NSObject

+ (void)showActivityMessageInWindow:(NSString *)message;
+ (void)showActivityMessageInView:(NSString *)message;
+ (void)showActivityMessageInWindow:(NSString *)message duration:(int)duration;
+ (void)showActivityMessageInView:(NSString *)message duration:(int)duration;

+ (void)showSuccessMessage:(NSString *)message;
+ (void)showErrorMessage:(NSString *)message;
+ (void)showInfoMessage:(NSString *)message;
+ (void)showWarnMessage:(NSString *)message;

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;

+ (void)showTipMessageInWindow:(NSString *)message;
+ (void)showTipMessageInView:(NSString *)message;
+ (void)showTipMessageInWindow:(NSString *)message duration:(int)duration;
+ (void)showTipMessageInView:(NSString *)message duration:(int)duration;

+ (void)hideHUD;

@end

//
//  QPHudObject.m
//
//  Created by dyf on 2017/9/1.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "QPHudObject.h"

@implementation QPHudObject

+ (void)showActivityMessageInWindow:(NSString *)message {
    [MBProgressHUD showActivityMessageInWindow:message];
}

+ (void)showActivityMessageInView:(NSString *)message {
    [MBProgressHUD showActivityMessageInView:message];
}

+ (void)showActivityMessageInWindow:(NSString *)message duration:(int)duration {
    [MBProgressHUD showActivityMessageInWindow:message timer:duration];
}

+ (void)showActivityMessageInView:(NSString *)message duration:(int)duration {
    [MBProgressHUD showActivityMessageInView:message timer:duration];
}

+ (void)showSuccessMessage:(NSString *)message {
    [MBProgressHUD showSuccessMessage:message];
}

+ (void)showErrorMessage:(NSString *)message {
    [MBProgressHUD showErrorMessage:message];
}

+ (void)showInfoMessage:(NSString *)message {
    [MBProgressHUD showInfoMessage:message];
}

+ (void)showWarnMessage:(NSString *)message {
    [MBProgressHUD showWarnMessage:message];
}

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message {
    [MBProgressHUD showCustomIconInWindow:iconName message:message];
}

+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message {
    [MBProgressHUD showCustomIconInView:iconName message:message];
}

+ (void)showTipMessageInWindow:(NSString *)message {
    [MBProgressHUD showTipMessageInWindow:message];
}

+ (void)showTipMessageInView:(NSString *)message {
    [MBProgressHUD showTipMessageInView:message];
}

+ (void)showTipMessageInWindow:(NSString *)message duration:(int)duration {
    [MBProgressHUD showTipMessageInWindow:message timer:duration];
}

+ (void)showTipMessageInView:(NSString *)message duration:(int)duration {
    [MBProgressHUD showTipMessageInView:message timer:duration];
}

+ (void)hideHUD {
    [MBProgressHUD hideHUD];
}

@end

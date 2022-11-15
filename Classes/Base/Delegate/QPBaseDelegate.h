//
//  QPBaseDelegate.h
//
//  Created by dyf on 2017/6/27. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QPBaseDelegate <NSObject>

@optional

// Navigates to the back item in the back-forward list.
- (void)onGoBack;
// Navigates to the forward item in the back-forward list.
- (void)onGoForward;
// Reloads the current page.
- (void)onReload;
// Stops loading all resources on the current page.
- (void)onStopLoading;

@end

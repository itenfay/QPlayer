//
//  QPBaseDelegate.h
//
//  Created by chenxing on 2017/6/27. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
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

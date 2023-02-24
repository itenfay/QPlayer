//
//  QPBaseViewController.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@interface QPBaseViewController : UIViewController

/// The property determines whether the parsing button is required.
@property (nonatomic, assign) BOOL parsingButtonRequired;

/// The property determines whether The dark interface style was truned on.
@property (nonatomic, assign) BOOL isDarkMode;

/// Indicates to the system that the view controller status bar attributes have changed.
- (void)needsStatusBarAppearanceUpdate;
/// Notifies the view controller about a change in supported interface orientations or preferred interface orientation for presentation.
- (void)needsUpdateOfSupportedInterfaceOrientations;

/// Posts a notification when network reachability changes.
- (void)monitorNetworkChangesWithSelector:(SEL)selector;
/// Removes a notification for changes in network reachability status.
- (void)stopMonitoringNetworkChanges;

/// Adds theme style changed observer.
- (void)addThemeStyleChangedObserver;
/// Removes theme style changed observer.
- (void)removeThemeStyleChangedObserver;
/// Adapts theme style when the notification is received.
- (void)adaptThemeStyle;

/// Sets up a navigation bar whether it is hidden.
- (void)setNavigationBarHidden:(BOOL)hidden;

/// Return a back button with a target and selector.
- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector;

/// Return a navigation bar.
- (UINavigationBar *)navigationBar;

/// Return a string that uses to show the duration of a video.
- (NSString *)formatVideoDuration:(int)duration;

/// Returns total display time.
- (NSString *)totalTimeForVideo:(NSURL *)aUrl;

/// Returns a thumbnail with a specific url.
- (UIImage *)thumbnailForVideo:(NSURL *)aUrl;

/// Returns a new string made from the receiver by replacing all characters not in the allowedCharacters set with percent encoded characters. UTF-8 encoding is used to determine the correct percent encoded characters.
- (NSString *)urlEncode:(NSString *)string;

/// Returns a new string made from the receiver by replacing all percent encoded sequences with the matching UTF-8 characters.
- (NSString *)urlDecode:(NSString *)string;

@end

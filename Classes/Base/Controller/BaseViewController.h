//
//  BaseViewController.h
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePresenter.h"
#import "BaseDelegate.h"

@protocol IThemeAdaptable <BaseDelegate>
/// Adds theme style changed observer.
- (void)addThemeStyleChangedObserver;
/// Removes theme style changed observer.
- (void)removeThemeStyleChangedObserver;

/// Adapts theme style when the notification is received.
- (void)adaptThemeStyle;
/// Can override this method.
- (void)adaptLightTheme;
/// Can override this method.
- (void)adaptDarkTheme;

/// Can override this method.
- (void)adaptNavigationBarAppearance:(BOOL)isDark;
@end

@protocol INavigable <BaseDelegate>
/// Return a navigation bar.
- (UINavigationBar *)navigationBar;
/// Configure a navigation bar.
- (void)configureNavigationBar;
/// Configure a navigation bar.
- (void)configNavigaitonBar:(UIImage *)backgroundImage titleTextAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleTextAttributes;
/// Configure a navigation bar.
- (void)configNavigaitonBar:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage titleTextAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleTextAttributes;
/// Sets up a navigation bar whether it is hidden.
- (void)setupNavigationBarHidden:(BOOL)hidden;

/// Return a back button with a target and selector.
- (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector;

- (void)setNavigationTitleView:(UIView *)titleView;
- (void)addLeftNavigationBarButton:(UIButton *)button;
- (void)addRightNavigationBarButton:(UIButton *)button;
- (void)setNavigationBarTitle:(NSString *)title;
@end

@interface BaseViewController : UIViewController <UIGestureRecognizerDelegate, IThemeAdaptable, INavigable>

/// Declares a base presenter.
@property (nonatomic, strong) BasePresenter *presenter;

/// The property determines whether The dark interface style was truned on.
@property (nonatomic, assign, readonly) BOOL isDarkMode;

/// Indicates to the system that the view controller status bar attributes have changed.
- (void)needsStatusBarAppearanceUpdate;
/// Notifies the view controller about a change in supported interface orientations or preferred interface orientation for presentation.
- (void)needsUpdateOfSupportedInterfaceOrientations;

/// Posts a notification when network reachability changes.
- (void)monitorNetworkChangesWithSelector:(SEL)selector;
/// Removes a notification for changes in network reachability status.
- (void)stopMonitoringNetworkChanges;

/// Whether to enable the gesture recognizer responsible for popping the top view controller off the navigation stack.
- (void)enableInteractivePopGesture:(BOOL)enabled;

/// Makes UI.
- (void)makeUI;
/// Makes the layouts of the views.
- (void)makeLayout;
/// Makes the actions of the some views.
- (void)makeAction;

@end

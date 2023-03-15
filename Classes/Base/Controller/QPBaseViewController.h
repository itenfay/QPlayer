//
//  QPBaseViewController.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPBasePresenter.h"

@interface QPBaseViewController : UIViewController <UIGestureRecognizerDelegate>

/// Declares a base presenter.
@property (nonatomic, strong) QPBasePresenter *presenter;

/// The property determines whether the parsing button is required.
@property (nonatomic, assign) BOOL parsingRequired;

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

/// Whether to enable the gesture recognizer responsible for popping the top view controller off the navigation stack.
- (void)enableInteractivePopGesture:(BOOL)enabled;

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

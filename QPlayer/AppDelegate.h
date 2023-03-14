//
//  AppDelegate.h
//
//  Created by chenxing on 2017/6/29. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPPlayerController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

/// A root window for the app.
@property (strong, nonatomic) UIWindow *window;

/// Allow to rotate user interface orentitaion.
@property (nonatomic, assign) BOOL allowOrentitaionRotation;

/// A player controller.
@property (nonatomic, weak) QPPlayerController *playerController;

@end

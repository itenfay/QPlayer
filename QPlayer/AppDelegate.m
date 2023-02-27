//
//  AppDelegate.m
//
//  Created by chenxing on 2017/6/29. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "AppDelegate.h"
#import <ZFPlayer/ZFPlayer.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self extendSplashDisplayTime];
    [self controlLog];
    [self setupConfiguration];
    
    if (!DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer start];
    }
    
    return YES;
}

- (void)extendSplashDisplayTime {
    // sleep 2 seconds.
    [NSThread sleepForTimeInterval:2];
}

- (void)controlLog
{
#ifdef DEBUG
    [ZFPlayerLogManager setLogEnable:YES];
#else
    [ZFPlayerLogManager setLogEnable:NO];
#endif
}

- (void)setupConfiguration
{
    BOOL result = [QPlayerExtractValue(kWriteThemeStyleFlagOnceOnly) boolValue];
    
    if (!result) {
        QPlayerStoreValue(kThemeStyleOnOff, [NSNumber numberWithBool:YES]);
        QPlayerStoreValue(kWriteThemeStyleFlagOnceOnly, [NSNumber numberWithBool:YES]);
    }
}

// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowOrentitaionRotation) {
        ZFInterfaceOrientationMask orientationMask = ZFInterfaceOrientationMaskUnknow;
        if (@available(iOS 16.0, *)) {
            orientationMask = [ZFLandscapeRotationManager_iOS16 supportedInterfaceOrientationsForWindow:window];
        } else if (@available(iOS 15.0, *)) {
            orientationMask = [ZFLandscapeRotationManager_iOS15 supportedInterfaceOrientationsForWindow:window];
        } else {
            orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
        }
        
        if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
            return (UIInterfaceOrientationMask)orientationMask;
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    QPlayerSavePlaying(NO);
    
    if (DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer stop];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (!DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer start];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    QPlayerSavePlaying(NO);
    
    if (DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer stop];
    }
}

@end

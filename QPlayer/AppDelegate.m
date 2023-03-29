//
//  AppDelegate.m
//
//  Created by chenxing on 2017/6/29. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "AppDelegate.h"
#import "QPPlayerController.h"
#import <ZFPlayer/ZFPlayer.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self onDisplaySplash];
    [self controlLog];
    [self configure];
    [self startSniffingNetworkStatus];
    return YES;
}

- (void)onDisplaySplash
{
    // sleep 2 seconds.
    [NSThread sleepForTimeInterval:1.2];
}

- (void)controlLog
{
#ifdef DEBUG
    [ZFPlayerLogManager setLogEnable:YES];
#else
    [ZFPlayerLogManager setLogEnable:NO];
#endif
}

- (void)configure
{
    BOOL result = [QPExtractValue(kWriteThemeStyleFlagOnceOnly) boolValue];
    if (!result) {
        QPStoreValue(kThemeStyleOnOff, [NSNumber numberWithBool:YES]);
        QPStoreValue(kWriteThemeStyleFlagOnceOnly, [NSNumber numberWithBool:YES]);
    }
}

- (void)startSniffingNetworkStatus
{
    if (!DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer start];
    }
}

- (void)stopSniffingNetworkStatus
{
    if (DYFNetworkSniffer.sharedSniffer.isStarted) {
        [DYFNetworkSniffer.sharedSniffer stop];
    }
}

//******************************************************************************
//* ZFInterfaceOrientationMask orientationMask = ZFInterfaceOrientationMaskUnknow;
//* if (@available(iOS 16.0, *)) {
//*    orientationMask = [ZFLandscapeRotationManager_iOS16 supportedInterfaceOrientationsForWindow:window];
//* } else if (@available(iOS 15.0, *)) {
//*     orientationMask = [ZFLandscapeRotationManager_iOS15 supportedInterfaceOrientationsForWindow:window];
//* } else {
//*     orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
//* }
//******************************************************************************
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowOrentitaionRotation) {
        ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
        if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
            return (UIInterfaceOrientationMask)orientationMask;
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startSniffingNetworkStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (_playerController) {
        //QPPlayerPresenter *pt = (QPPlayerPresenter *)_playerController.presenter;
        //[pt stopPictureInPicture];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    QPPlayerSavePlaying(NO);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self stopSniffingNetworkStatus];
    if (_playerController) {
        //QPPlayerPresenter *pt = (QPPlayerPresenter *)_playerController.presenter;
        //[pt startPictureInPicture];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    QPPlayerSavePlaying(NO);
    [self stopSniffingNetworkStatus];
}

@end

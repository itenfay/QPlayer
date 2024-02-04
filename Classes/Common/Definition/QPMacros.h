//
//  QPMacros.h
//
//  Created by chenxing on 2017/6/27. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#ifndef QPMacros_h
#define QPMacros_h

// Return screen width.
#ifndef QPScreenWidth
#define QPScreenWidth  UIScreen.mainScreen.bounds.size.width
#endif

// Return screen height.
#ifndef QPScreenHeight
#define QPScreenHeight UIScreen.mainScreen.bounds.size.height
#endif

// Judge iPhone.
#ifndef QPIsPhone
#define QPIsPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#endif

// Judge iPad.
#ifndef QPIsPad
#define QPIsPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#endif

// Judge iPhone X series.
#ifndef QPIsPhoneXAll
#define QPIsPhoneXAll ({BOOL isPhoneXAll = NO; if (@available(iOS 11.0, *)) { isPhoneXAll = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom > 0.0; } isPhoneXAll;})
#endif

// Judge iPhoneX，XS
#ifndef QPIsPhoneX
#define QPIsPhoneX (!QPIsPad && ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), UIScreen.mainScreen.currentMode.size): NO))
#endif

// Judge iPhoneXR
#ifndef QPIsPhoneXR
#define QPIsPhoneXR (!QPIsPad && ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), UIScreen.mainScreen.currentMode.size) : NO))
#endif

// Judge iPhoneXS Max
#ifndef QPIsPhoneXSMax
#define QPIsPhoneXSMax (!QPIsPad && ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), UIScreen.mainScreen.currentMode.size): NO))
#endif

// Status bar height.
#ifndef QPStatusBarHeight
#define QPStatusBarHeight                 (QPIsPhoneXAll ? 44.f : 20.f)
#endif

// Navigation bar height.
#ifndef QPNavigationBarHeight
#define QPNavigationBarHeight              44.f
#endif

// Status bar & navigation bar height.
#ifndef QPStatusBarAndNavigationBarHeight
#define QPStatusBarAndNavigationBarHeight (QPIsPhoneXAll ? 88.f : 64.f)
#endif

// TabBar height.
#ifndef QPTabBarHeight
#define QPTabBarHeight                    (QPIsPhoneXAll ? (49.f+34.f) : 49.f)
#endif

// View safe bottom margin.
#ifndef QPViewSafeBottomMargin
#define QPViewSafeBottomMargin            (QPIsPhoneXAll ? 34.f : 0.f)
#endif

// View safe insets.
#ifndef QPViewSafeAreaInsets
#define QPViewSafeAreaInsets(view)        ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
#endif

// NSFileManager's singleton.
#ifndef QPFileMgr
#define QPFileMgr           [NSFileManager defaultManager]
#endif

// UIApplication's singleton.
#ifndef QPSharedApp
#define QPSharedApp         [UIApplication sharedApplication]
#endif

// App delegate.
#ifndef QPAppDelegate
#define QPAppDelegate       ((AppDelegate *)QPSharedApp.delegate)
#endif

// NSNotificationCenter's singleton.
#ifndef QPNotiDefaultCenter
#define QPNotiDefaultCenter [NSNotificationCenter defaultCenter]
#endif

// NSUserDefaults's singleton.
#ifndef QPUserDefaults
#define QPUserDefaults      [NSUserDefaults standardUserDefaults]
#endif

// System Versioning Preprocessor Macros.
#ifndef QP_SYSTEM_VERSION_EQUAL_TO
#define QP_SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#endif
#ifndef QP_SYSTEM_VERSION_GREATER_THAN
#define QP_SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#endif
#ifndef QP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO
#define QP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#endif
#ifndef QP_SYSTEM_VERSION_LESS_THAN
#define QP_SYSTEM_VERSION_LESS_THAN(v)				  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif
#ifndef QP_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO
#define QP_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#endif

// Judge iOS8 or later.
#ifndef QPIOS8OrLater
#define QPIOS8OrLater      QP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#endif

// App configuration information.
#ifndef QPInfoDictionary
#define QPInfoDictionary   [[NSBundle mainBundle] infoDictionary]
#endif

// App version.
#ifndef QPAppVersion
#define QPAppVersion       [QPInfoDictionary objectForKey:@"CFBundleShortVersionString"]
#endif

// App build version.
#ifndef QPBuildVersion
#define QPBuildVersion     [QPInfoDictionary objectForKey:(NSString *)kCFBundleVersionKey]
#endif

// App bundle identifier.
#ifndef QPBundleIdentifier
#define QPBundleIdentifier [QPInfoDictionary objectForKey:@"CFBundleIdentifier"]
#endif

// App document path in sandbox.
#ifndef QPDocumentDirectoryPath
#define QPDocumentDirectoryPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#endif
// App caches path in sandbox.
#ifndef QPCachesDirectoryPath
#define QPCachesDirectoryPath   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#endif

// Appending string.
#ifndef QPAppendingString
#define QPAppendingString(s1, s2)        [(s1) stringByAppendingString:(s2)]
#endif
// Appending path.
#ifndef QPAppendingPathComponent
#define QPAppendingPathComponent(s1, s2) [(s1) stringByAppendingPathComponent:(s2)]
#endif
// Resource path.
#ifndef QPPathForResource
#define QPPathForResource(name, ext)     [[NSBundle mainBundle] pathForResource:(name) ofType:(ext)]
#endif

// Get image with contents Of file.
#ifndef QPLoadImage
#define QPLoadImage(name)  [UIImage imageWithContentsOfFile:QPPathForResource(name, nil)]
#endif
// Get image from memory.
#ifndef QPImageNamed
#define QPImageNamed(name) [UIImage imageNamed:(name)]
#endif

// RGB and alpha
#ifndef QPColorFromRGBAlp
#define QPColorFromRGBAlp(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#endif
// RGB
#ifndef QPColorFromRGB
#define QPColorFromRGB(r, g, b)       QPColorFromRGBAlp(r, g, b, 1.0)
#endif
// Sets rgb by hexadecimal value
#ifndef QPColorFromHex
#define QPColorFromHex(hex)           [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef QPRespondsToSelector
#define QPRespondsToSelector(target, selector) ((target) && [(target) respondsToSelector:selector])
#endif

#ifndef QPSuppressPerformSelectorLeakWarning
#define QPSuppressPerformSelectorLeakWarning(Stuff)                 \
do {                                                                \
_Pragma("clang diagnostic push")                                    \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff;                                                              \
_Pragma("clang diagnostic pop")                                     \
} while (0)
#endif

// Resolving block circular reference: __weak(arc)/__block
#ifndef QPWeakify
#if DEBUG
#if __has_feature(objc_arc)
#define QPWeakify(o) autoreleasepool{} __weak __typeof__(o) weak##_##o = o
#else
#define QPWeakify(o) autoreleasepool{} __block __typeof__(o) weak##_##o = o
#endif
#else
#if __has_feature(objc_arc)
#define QPWeakify(o) try{} @finally{} __weak __typeof__(o) weak##_##o = o
#else
#define QPWeakify(o) try{} @finally{} __block __typeof__(o) weak##_##o = o
#endif
#endif
#endif

// Resolving block circular reference: __strong(arc)/-
#ifndef QPStrongify
#if DEBUG
#if __has_feature(objc_arc)
#define QPStrongify(o) autoreleasepool{} __strong __typeof__(o) strong##_##o = weak##_##o
#else
#define QPStrongify(o) autoreleasepool{} __typeof__(o) strong##_##o = weak##_##o
#endif
#else
#if __has_feature(objc_arc)
#define QPStrongify(o) try{} @finally{} __strong __typeof__(o) strong##_##o = weak##_##o
#else
#define QPStrongify(o) try{} @finally{} __typeof__(o) strong##_##o = weak##_##o
#endif
#endif
#endif

// Logs
#if DEBUG
#define QPLog(fmt, ...) NSLog((@"[L: %d] %s " fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define QPLog(...)      while(0){}
#endif

#endif /* QPMacros_h */

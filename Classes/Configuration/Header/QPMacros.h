//
//  QPMacros.h
//
//  Created by dyf on 2017/6/27. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#ifndef QPMacros_h
#define QPMacros_h

// Return screen width.
#define QPScreenWidth  UIScreen.mainScreen.bounds.size.width
// Return screen height.
#define QPScreenHeight UIScreen.mainScreen.bounds.size.height


// Judge iPhone.
#define QPIsPhone      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// Judge iPad.
#define QPIsPad        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// Judge iPhone X series.
#define QPIsPhoneXAll  ({BOOL isPhoneXAll = NO; if (@available(iOS 11.0, *)) { isPhoneXAll = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom > 0.0; } isPhoneXAll;})
// Judge iPhoneX，XS
#define QPIsPhoneX     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), UIScreen.mainScreen.currentMode.size) && !QPIsPad : NO)
// Judge iPhoneXR
#define QPIsPhoneXR    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), UIScreen.mainScreen.currentMode.size) && !QPIsPad : NO)
// Judge iPhoneXS Max
#define QPIsPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), UIScreen.mainScreen.currentMode.size) && !QPIsPad : NO)


// Status bar height.
#define QPStatusBarHeight                 (QPIsPhoneXAll ? 44.f : 20.f)
// Navigation bar height.
#define QPNavigationBarHeight              44.f
// Status bar & navigation bar height.
#define QPStatusBarAndNavigationBarHeight (QPIsPhoneXAll ? 88.f : 64.f)
// TabBar height.
#define QPTabBarHeight                    (QPIsPhoneXAll ? (49.f+34.f) : 49.f)
// View safe bottom margin.
#define QPViewSafeBottomMargin            (QPIsPhoneXAll ? 34.f : 0.f)
// View safe insets.
#define QPViewSafeAreaInsets(view)        ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})


// NSFileManager's singleton.
#define QPFileMgr                         [NSFileManager defaultManager]
// UIApplication's singleton.
#define QPSharedApp                       [UIApplication sharedApplication]
// App delegate.
#define QPAppDelegate                     ((AppDelegate *)QPSharedApp.delegate)
// NSNotificationCenter's singleton.
#define QPNotiDefaultCenter               [NSNotificationCenter defaultCenter]
// NSUserDefaults's singleton.
#define QPUserDefaults                    [NSUserDefaults standardUserDefaults]


// System Versioning Preprocessor Macros.
#define QP_SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define QP_SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define QP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define QP_SYSTEM_VERSION_LESS_THAN(v)				  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define QP_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// Judge iOS8 or later.
#define QPIOS8OrLater           QP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
// App configuration information.
#define QPInfoDictionary        [[NSBundle mainBundle] infoDictionary]
// App version.
#define QPAppVersion            [QPInfoDictionary objectForKey:@"CFBundleShortVersionString"]
// App build version.
#define QPBuildVersion          [QPInfoDictionary objectForKey:(NSString *)kCFBundleVersionKey]
// App bundle identifier.
#define QPBundleIdentifier      [QPInfoDictionary objectForKey:@"CFBundleIdentifier"]

// App document path in sandbox.
#define QPDocumentDirectoryPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
// App caches path in sandbox.
#define QPCachesDirectoryPath   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

// Appending string.
#define QPAppendingString(s1, s2)        [(s1) stringByAppendingString:(s2)]
// Appending path.
#define QPAppendingPathComponent(s1, s2) [(s1) stringByAppendingPathComponent:(s2)]
// Resource path.
#define QPPathForResource(name, ext)     [[NSBundle mainBundle] pathForResource:(name) ofType:(ext)]

// Get image with contents Of file.
#define QPLoadImage(name)                [UIImage imageWithContentsOfFile:QPPathForResource(name, nil)]
// Get image from memory.
#define QPImageNamed(name)               [UIImage imageNamed:(name)]

// RGB and alpha
#define QPColorFromRGBAlp(r, g, b, a)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// RGB
#define QPColorFromRGB(r, g, b)          QPColorFromRGBAlp(r, g, b, 1.0)
// Sets rgb by hexadecimal value
#define QPColorFromHex(hex)              [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 \
                                          green:((float)((hex & 0xFF00) >> 8))/255.0                   \
                                          blue:((float)(hex & 0xFF))/255.0 alpha:1.0]


// Resolving block circular reference - __weak(arc)/__block
#ifndef QPWeakObject
    #if __has_feature(objc_arc)
        #define QPWeakObject(o) try {} @finally {} __weak __typeof(o) weak##_##o = o;
    #else
        #define QPWeakObject(o) try {} @finally {} __block __typeof(o) weak##_##o = o;
    #endif
#endif

// Resolving block circular reference - __strong(arc)/
#ifndef QPStrongObject
    #if __has_feature(objc_arc)
        #define QPStrongObject(o) try {} @finally {} __strong __typeof(o) strong##_##o = weak##_##o;
    #else
        #define QPStrongObject(o) try {} @finally {} __typeof(o) strong##_##o = weak##_##o;
    #endif
#endif


// Logs
#ifdef DEBUG
    #define QPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define QPLog(...) while(0){}
#endif

#endif /* QPMacros_h */

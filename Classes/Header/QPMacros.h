//
//  QPMacros.h
//
//  Created by dyf on 2017/6/27.
//  Copyright © 2017年 dyf. All rights reserved.
//

#ifndef QPMacros_h
#define QPMacros_h

// iPhone
#define QPIsIdiomPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// iPad
#define QPIsIdiomPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIScreen width.
#define QPScreenWidth [UIScreen mainScreen].bounds.size.width

// UIScreen height.
#define QPScreenHeight [UIScreen mainScreen].bounds.size.height

// iPhone X
#define QPIsIdiomIPhoneX (QPScreenWidth == 375.f && QPScreenHeight == 812.f ? YES : NO)

// Status bar height.
#define QPStatusBarHeight (QPIsIdiomIPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define QPNavigationBarHeight 44.f

// Status bar & navigation bar height.
#define QPStatusBarAndNavigationBarHeight (QPIsIdiomIPhoneX ? 88.f : 64.f)

// Tabbar height.
#define QPTabbarHeight (QPIsIdiomIPhoneX ? (49.f+34.f) : 49.f)

// View safe bottom margin.
#define QPViewSafeBottomMargin (QPIsIdiomIPhoneX ? 34.f : 0.f)

// View safe insets.
#define QPViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

// NSFileManager's singleton
#define QPFileMgr [NSFileManager defaultManager]

// UIApplication's singleton
#define QPSharedApp [UIApplication sharedApplication]

// AppDelegate
#define QPAppDelegate ((AppDelegate *)QPSharedApp.delegate)

// NSNotificationCenter's singleton
#define QPNotiDefaultCenter [NSNotificationCenter defaultCenter]

// NSUserDefaults's singleton
#define QPStdUserDefaults [NSUserDefaults standardUserDefaults]

// System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)				   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// App configuration information
#define QPInfoDictionary [[NSBundle mainBundle] infoDictionary]

// App version
#define QPAppVersion [QPInfoDictionary objectForKey:@"CFBundleShortVersionString"]
// App build version
#define QPBuildVersion [QPInfoDictionary objectForKey:kCFBundleVersionKey]
// App bundle identifier
#define QPBundleID [QPInfoDictionary objectForKey:@"CFBundleIdentifier"]

// Judge iOS8+
#define IOS8OrNewerSDK ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

// App document path in sandbox
#define QPDocumentDirectoryPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

// App caches path in sandbox
#define QPCachesDirectoryPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

// Appending string
#define QPAppendingString(s1, s2) [(s1) stringByAppendingString:(s2)]
// Appending path
#define QPAppendingPathComponent(s1, s2) [(s1) stringByAppendingPathComponent:(s2)]

// Resource path
#define QPPathForResource(name, ext) [[NSBundle mainBundle] pathForResource:(name) ofType:(ext)]
// Get image with contents Of file
#define QPLoadImage(name) [UIImage imageWithContentsOfFile:QPPathForResource(name, nil)]
// Get image from memory
#define QPImageNamed(name) [UIImage imageNamed:(name)]

// RGB
#define QPColorRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

// RGB and set alpha
#define QPColorRGBAlp(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// Sets rgb by hexadecimal value
#define QPColorHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 \
                         green:((float)((hex & 0xFF00) >> 8))/255.0 \
                         blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

// Resolving block circular reference
#ifndef QPWeakObject
    #if __has_feature(objc_arc)
        #define QPWeakObject(o) try {} @finally {} __weak __typeof(o) weak##_##o = o;
    #else
        #define QPWeakObject(o) try {} @finally {} __block __typeof(o) weak##_##o = o;
    #endif
#endif

#ifndef QPStrongObject
    #if __has_feature(objc_arc)
        #define QPStrongObject(o) try {} @finally {} __strong __typeof(o) strong##_##o = weak##_##o;
    #else
        #define QPStrongObject(o) try {} @finally {} __typeof(o) strong##_##o = weak##_##o;
    #endif
#endif

// Logs
#ifdef DEBUG
    #define QPLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define QPLog(...) while(0){}
#endif

#endif /* QPMacros_h */

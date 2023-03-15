//
//  QPPchFile.h
//
//  Created by chenxing on 2017/6/27. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#ifndef QPPchFile_h
#define QPPchFile_h

#pragma mark - Internal

#import "AppDelegate.h"
#import "AppHelper.h"
#import "QPBaseViewController.h"
#import "QPMacros.h"
#import "QPGlobalDef.h"
#import "QPTitleView.h"
#import "DYFNetworkSniffer.h"
#import "QPHudUtils.h"

#pragma mark - Category

#import "NSObject+QPAdditions.h"
#import "UILabel+QPAdditions.h"
#import "UIView+QPAdditions.h"
#import "UIScrollView+QPAdditions.h"

#pragma mark - Third

#import "HTTPServer.h"
#import "SVBlurView.h"
#import "MBProgressHUD+JDragon.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
/// PYSearch
#import "PYSearch.h"
/// DYFProgressView
#import "DYFProgressView.h"
#import "DYFWebProgressView.h"

/// ZFPlayer
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFLandscapeRotationManager.h>
#import <ZFPlayer/ZFLandscapeRotationManager_iOS15.h>
#import <ZFPlayer/ZFLandscapeRotationManager_iOS16.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>

/// ZFIJKPlayerManager
#if __has_include(<ZFPlayer/ZFIJKPlayerManager.h>)
#import <ZFPlayer/ZFIJKPlayerManager.h>
#endif

/// KSYMediaPlayerManager
#import "KSYMediaPlayerManager.h"

/// MJRefresh
#import <MJRefresh/MJRefresh.h>

#endif /* QPPchFile_h */

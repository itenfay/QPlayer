//
//  QPAppConst.h
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import <UIKit/UIKit.h>

/// The key for whether player is playing.
FOUNDATION_EXPORT NSString *const kQPPlayerIsPlaying;
/// The key for record info.
FOUNDATION_EXPORT NSString *const kRecordKeyInfo;
/// The key for theme style flag written only once.
FOUNDATION_EXPORT NSString *const kExecAppConfigOnlyOnce;
/// The key for theme style on or off.
FOUNDATION_EXPORT NSString *const kThemeStyleOnOff;
/// The key for theme style change notification.
FOUNDATION_EXPORT NSString *const kThemeStyleDidChangeNotification;
/// The key for allowing carrier network.
FOUNDATION_EXPORT NSString *const kCarrierNetworkAllowed;
/// The key for skiping titles of the film automatically.
FOUNDATION_EXPORT NSString *const kAutomaticallySkipTitles;
/// The key for skiping titles seconds of the film automatically.
FOUNDATION_EXPORT NSString *const kSkipVideoTitlesSeconds;
/// The key for picture in picture.
FOUNDATION_EXPORT NSString *const kPlayerPictureInPictureEnabled;
/// The key for picture in picture when app enters background.
FOUNDATION_EXPORT NSString *const kPlayerPictureInPictureEnabledWhenBackgound;
/// The key for hard decoding.
FOUNDATION_EXPORT NSString *const kPlayerHardDecoding;
/// The key for unparsing web video.
FOUNDATION_EXPORT NSString *const kPlayerParsingWebVideo;
/// The key for using default player.
FOUNDATION_EXPORT NSString *const kPlayerUseIJKPlayer;

//
//  ApplicationHelper.h
//  QPlayer
//
//  Created by chenxing on 2023/2/27.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppHelper : NSObject

/// Return a string that uses to show the duration of a video.
+ (NSString *)formatVideoDuration:(int)duration;

/// Returns total display time.
+ (NSString *)totalTimeForVideo:(NSURL *)aUrl;

/// Returns a thumbnail with a specific url.
+ (UIImage *)thumbnailForVideo:(NSURL *)aUrl;

/// Returns a new string made from the receiver by replacing all characters not in the allowedCharacters set with percent encoded characters. UTF-8 encoding is used to determine the correct percent encoded characters.
+ (NSString *)urlEncode:(NSString *)string;

/// Returns a new string made from the receiver by replacing all percent encoded sequences with the matching UTF-8 characters.
+ (NSString *)urlDecode:(NSString *)string;

@end

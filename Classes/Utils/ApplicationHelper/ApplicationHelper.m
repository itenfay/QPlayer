//
//  ApplicationHelper.m
//  QPlayer
//
//  Created by chenxing on 2023/2/27.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "ApplicationHelper.h"

@implementation ApplicationHelper

+ (NSString *)formatVideoDuration:(int)duration
{
    int seconds = duration;
    int hour    = 0;
    int minute  = 0;
    
    int secondsPerHour = 60 * 60;
    if (seconds >= secondsPerHour) {
        int delta = seconds / secondsPerHour;
        hour = delta;
        seconds -= delta * secondsPerHour;
    }
    int secondsPerMinute = 60;
    if (seconds >= secondsPerMinute) {
        int delta = seconds / secondsPerMinute;
        minute = delta;
        seconds -= delta * secondsPerMinute;
    }
    if (hour == 0 && minute == 0 && seconds == 0) {
        return [NSString stringWithFormat:@"--:--"];
    }
    if (hour == 0) {
        return [NSString stringWithFormat:@"%02d:%02d", minute, seconds];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, seconds];
}

+ (NSString *)totalTimeForVideo:(NSURL *)aUrl
{
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:aUrl];
    CMTime time = playerItem.asset.duration;
    //Float64 sec = CMTimeGetSeconds(time);
    int duration = (int)time.value / time.timescale;
    return [self formatVideoDuration:duration];
}

+ (UIImage *)thumbnailForVideo:(NSURL *)aUrl
{
    AVAsset *asset = [AVAsset assetWithURL:aUrl];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(2, 1);
    CMTime actualTime;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:NULL];
    if (imageRef) {
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        return thumbnail;
    }
    return QPImageNamed(@"default_thumbnail");
}

+ (NSString *)urlEncode:(NSString *)string
{
    NSCharacterSet *characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

+ (NSString *)urlDecode:(NSString *)string
{
    NSString *_string = [string stringByRemovingPercentEncoding];
    if (_string) { return _string; }
    return [string copy];
}

@end

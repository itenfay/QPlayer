//
//  EasyPlayer.h
//  QPlayer
//
//  Created by Tenfay on 2024/4/9.
//  Copyright © 2024 Tenfay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/// EasyPlayer
@class EasyPlayer;

/// EasyPlayerDelegate
@protocol EasyPlayerDelegate <NSObject>

@optional
- (void)playerReadyToPlay:(EasyPlayer *)player;
- (void)player:(EasyPlayer *)player didFailWithError:(NSError *)error;
- (void)playerDidFinishPlayback:(EasyPlayer *)player;
- (void)player:(EasyPlayer *)player changePlayerItem:(AVPlayerItem *)playerItem;
- (void)player:(EasyPlayer *)player currentSeconds:(float)currentSeconds totalSeconds:(float)totalSeconds;
- (void)player:(EasyPlayer *)player loadedBuffer:(float)buffer duration:(float)duration;
- (void)player:(EasyPlayer *)player changeRate:(float)rate;

@end

@interface EasyPlayer : NSObject
/// The audio playback volume for the player.
@property (nonatomic, assign) float volume;
/// A Boolean value that indicates whether the audio output of the player is muted.
@property (nonatomic, assign, getter=isMuted) BOOL muted;
/// The current playback rate.
@property (nonatomic, assign) float rate;
/// Provides the interface to control the player’s transport behavior.
@property (nonatomic, strong, readonly) AVPlayer *player;
/// Presents the visual contents of a player object.
@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;
/// Represents the player whether is playing or not.
@property (nonatomic, assign, readonly) BOOL isPlaying;

/// The delegate for the player.
@property (nonatomic, weak) id<EasyPlayerDelegate> delegate;

/// Intializes an object.
+ (instancetype)playerWithURL:(NSURL *)aURL;

/// Intializes an object.
- (instancetype)initWithURL:(NSURL *)aURL;

- (void)play;
- (void)pause;

/// Seeks to a specified time with the amount of accuracy specified.
- (void)seekToTime:(Float64)seconds;
/// Seeks to a specified time with the amount of accuracy specified,  and to notify you when the seek is complete.
- (void)seekToTime:(Float64)seconds completionHandler:(void (^)(BOOL finished))completionHandler;

/// Shows in view with the specified frame.
- (void)showInView:(UIView *)view withFrame:(CGRect)frame;

/// Hides player frame.
- (void)hidePlayerFrame:(BOOL)hidden;

/// Formats media time.
- (NSString *)formatMediaTime:(float)seconds;

@end

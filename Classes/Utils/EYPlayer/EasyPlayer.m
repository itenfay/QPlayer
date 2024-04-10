//
//  EasyPlayer.m
//  QPlayer
//
//  Created by dengyf on 2024/4/9.
//  Copyright © 2024 dyf. All rights reserved.
//

#import "EasyPlayer.h"

@interface EasyPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSURL *playerItemURL;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *playerLayerContainerView;
@end

@implementation EasyPlayer

+ (instancetype)playerWithURL:(NSURL *)aURL {
    return [[self alloc] initWithURL:aURL];
}

- (instancetype)initWithURL:(NSURL *)aURL {
    self = [super init];
    if (self) {
        // 播放地址
        self.playerItemURL = aURL;
        self.isPlaying = NO;
        [self configurePlayer];
    }
    return self;
}

- (void)configurePlayer {
    // 创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:self.playerItemURL];
    // 播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    // 添加观察者
    [self _addObservers];
}

- (void)play {
    if (!self.isPlaying) {
        [self.player play];
        self.isPlaying = YES;
    }
}

- (void)pause {
    if (self.isPlaying) {
        [self.player pause];
        self.isPlaying = NO;
    }
}

- (void)seekToTime:(Float64)seconds {
    [self seekToTime:seconds completionHandler:NULL];
}

- (void)seekToTime:(Float64)seconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (!self.player) return;
    CMTimeScale cmtScale = self.player.currentItem.asset.duration.timescale;
    CMTime time = CMTimeMakeWithSeconds(seconds, cmtScale);
    [self.player seekToTime:time completionHandler:completionHandler];
    //[self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}

- (void)showInView:(UIView *)view withFrame:(CGRect)frame {
    if (self.playerLayer) return;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.playerLayerContainerView = [[UIView alloc] init];
    self.playerLayerContainerView.frame = frame;
    [view addSubview:self.playerLayerContainerView];
    [self.playerLayerContainerView.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.playerLayerContainerView.bounds;
}

- (void)hidePlayerFrame:(BOOL)hidden {
    if (!self.playerLayerContainerView) return;
    self.playerLayerContainerView.hidden = hidden;
}

- (NSString *)formatMediaTime:(float)seconds {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    if (seconds/3600 > 1) {
        self.dateFormatter.dateFormat = @"HH:mm:ss";
    } else {
        self.dateFormatter.dateFormat = @"mm:ss";
    }
    return [self.dateFormatter stringFromDate:date];
}

- (void)_addObservers {
    // 监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    // 监控缓冲加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    // 监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    // 监控时间进度
    // If you pass NULL, the system uses the main queue.
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        __strong typeof(self) self = weakSelf;
        AVPlayerItem *_item = self.player.currentItem;
        float currentSeconds = _item.currentTime.value / _item.currentTime.timescale;
        float totolSeconds = _item.duration.value / _item.duration.timescale;
        // 监听到的播放进度代理出去
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:currentSeconds:totalSeconds:)]) {
            [self.delegate player:self currentSeconds:currentSeconds totalSeconds:totolSeconds];
        }
    }];
}

- (void)_removeObservers {
    [self.player.currentItem removeObserver:self  forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self.player removeObserver:self forKeyPath:@"timeControlStatus"];
    [self.player removeTimeObserver:self.timeObserver];
}

#pragma mark - Dealloc

- (void)dealloc {
    // 移除监听
    [self _removeObservers];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: {
                // 开始播放
                [self play];
                // 代理回调，开始初始化状态
                if (self.delegate && [self.delegate respondsToSelector:@selector(playerReadyToPlay:)]) {
                    [self.delegate playerReadyToPlay:self];
                }
            }
                break;
            case AVPlayerItemStatusFailed: {
                // 加载失败
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:didFailWithError:)]) {
                    [self.delegate player:self didFailWithError:playerItem.error];
                }
            }
                break;
            case AVPlayerItemStatusUnknown: {
                // 未知资源
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:didFailWithError:)]) {
                    [self.delegate player:self didFailWithError:playerItem.error];
                }
            }
                break;
            default:
                break;
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playerItem.loadedTimeRanges;
        // 本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 缓冲总长度
        float loadedBuffer = startSeconds + durationSeconds;
        float duration = CMTimeGetSeconds(playerItem.duration);
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:loadedBuffer:duration:)]) {
            [self.delegate player:self loadedBuffer:loadedBuffer duration:duration];
        }
    } else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        float rate = self.player.rate;
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changeRate:)]) {
            [self.delegate player:self changeRate:rate];
        }
    } else if ([keyPath isEqualToString:@"currentItem"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changePlayerItem:)]) {
            [self.delegate player:self changePlayerItem:playerItem];
        }
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
        self.isPlaying = self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    }
}

- (void)playbackFinished:(NSNotification *)noti {
    [self seekToTime:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidFinishPlayback:)]) {
        [self.delegate playerDidFinishPlayback:self];
    }
}

#pragma mark - Lazy
#pragma mark - getters and setters

- (void)setVolume:(float)volume {
    self.player.volume = volume;
}

- (float)volume {
    return self.player.volume;
}

- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}

- (BOOL)isMuted {
    return self.player.isMuted;
}

- (void)setRate:(float)rate {
    self.player.rate = rate;
}

- (float)rate {
    return self.player.rate;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

@end

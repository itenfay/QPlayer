//
//  QPPlayerPresenter.m
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPPlayerPresenter.h"
#import "QPPlayerController.h"

@interface QPPlayerPresenter ()
@property (nonatomic, strong) ZFPlayerController *player;
@end

@implementation QPPlayerPresenter

- (ZFPlayerController *)player
{
    if (!_player) {
        QPPlayerController *vc = [self playViewController];
        if ((vc.model.isLocalVideo && vc.model.isMediaPlayerPlayback) || vc.model.isMediaPlayerPlayback) {
            //KSYMediaPlayerManager *playerManager = [[KSYMediaPlayerManager alloc] init];
            //_player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
            // 默认是硬解码
            if (QPPlayerHardDecoding() == 1) {
                //playerManager.player.videoDecoderMode = MPMovieVideoDecoderMode_Hardware;
            } else {
                //playerManager.player.videoDecoderMode = MPMovieVideoDecoderMode_Software;
            }
        } else if ((vc.model.isLocalVideo && vc.model.isIJKPlayerPlayback) || vc.model.isIJKPlayerPlayback) {
            #if DEBUG
            [IJKFFMoviePlayerController setLogReport:YES];
            [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
            #else
            [IJKFFMoviePlayerController setLogReport:NO];
            [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
            #endif
            NSURL *url = [NSURL URLWithString:vc.model.videoUrl];
            NSString *scheme = [url.scheme lowercaseString];
            QPLog(@":: urlScheme=%@", scheme);
            ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
            int hardDecoding = QPPlayerHardDecoding();
            // 开启硬解码（硬件解码CPU消耗低，软解更稳定）
            [playerManager.options setOptionIntValue:hardDecoding forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
            // 支持H265硬解 1：开启 0：关闭
            //[playerManager.options setOptionIntValue:0 forKey:@"mediacodec-hevc" ofCategory:kIJKFFOptionCategoryPlayer];
            // 支持硬解 1：开启 0：关闭
            //[playerManager.options setOptionIntValue:0 forKey:@"mediacodec" ofCategory:kIJKFFOptionCategoryPlayer];
            // 处理分辨率变化
            [playerManager.options setOptionIntValue:0 forKey:@"mediacodec-handle-resolution-change" ofCategory:kIJKFFOptionCategoryPlayer];
            // 自动旋屏开关
            [playerManager.options setOptionIntValue:0 forKey:@"mediacodec-auto-rotate" ofCategory:kIJKFFOptionCategoryPlayer];
            // 开启环路过滤: 0开启，画面质量高，解码开销大，48关闭，画面质量差，解码开销小
            [playerManager.options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
            // 跳过帧
            [playerManager.options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
            // 清空DNS
            [playerManager.options setOptionIntValue:1 forKey:@"dns_cache_clear" ofCategory:kIJKFFOptionCategoryFormat];
            // 延时优化
            if ([scheme hasPrefix:@"rtmp"] || [scheme hasPrefix:@"rtsp"]) {
                // 视频帧率
                [playerManager.options setOptionIntValue:30 forKey:@"fps" ofCategory:kIJKFFOptionCategoryPlayer];
                // 帧速率，非标准帧率会导致音画不同步
                [playerManager.options setOptionIntValue:30 forKey:@"r" ofCategory:kIJKFFOptionCategoryPlayer];
                // 是否有声音
                [playerManager.options setOptionIntValue:1 forKey:@"an" ofCategory:kIJKFFOptionCategoryPlayer];
                // 是否有视频
                [playerManager.options setOptionIntValue:1 forKey:@"vn" ofCategory:kIJKFFOptionCategoryPlayer];
                // 丢帧阈值，视频帧处理不过来的时候丢弃一些帧达到同步的效果
                [playerManager.options setOptionIntValue:5 forKey:@"framedrop" ofCategory:kIJKFFOptionCategoryPlayer];
                // 设置最小解码帧数
                [playerManager.options setOptionIntValue:3 forKey:@"min-frames" ofCategory:kIJKFFOptionCategoryPlayer];
                // 是否开启预缓冲，一般直播项目会开启，达到秒开的效果，不过带来播放丢帧卡顿的体验
                [playerManager.options setOptionIntValue:1 forKey:@"packet-buffering" ofCategory:kIJKFFOptionCategoryPlayer];
                // 是否限制输入缓存数，1不限制拉流缓存大小
                [playerManager.options setOptionIntValue:1 forKey:@"infbuf" ofCategory:kIJKFFOptionCategoryPlayer];
                // 启动预加载，关闭播放器缓冲，准备好后自动播放
                [playerManager.options setOptionIntValue:1 forKey:@"start-on-prepared" ofCategory:kIJKFFOptionCategoryPlayer];
                // 缩短播放的rtmp视频延迟在1s内
                [playerManager.options setOptionValue:@"nobuffer" forKey:@"fflags" ofCategory:kIJKFFOptionCategoryFormat];
                // 设置分析流时长，播放前的探测时间
                [playerManager.options setOptionIntValue:100 forKey:@"analyzeduration" ofCategory:kIJKFFOptionCategoryFormat];
                // 设置最大缓存数量
                [playerManager.options setOptionIntValue:1024 forKey:@"max-buffer-size" ofCategory:kIJKFFOptionCategoryFormat];
                // 设置播放前的探测包数量
                [playerManager.options setOptionIntValue:4096 forKey:@"probesize" ofCategory:kIJKFFOptionCategoryFormat];
                // 播放重连次数
                [playerManager.options setOptionIntValue:5 forKey:@"reconnect" ofCategory:kIJKFFOptionCategoryFormat];
                if ([scheme hasPrefix:@"rtsp"]) {
                    // 默认使用udp拉流，速度比较快，如果需要可靠且减少丢包，可以改为tcp协议
                    [playerManager.options setOptionValue:@"tcp" forKey:@"rtsp_transport" ofCategory:kIJKFFOptionCategoryFormat];
                }
            } else {
                // 最大缓存时长
                [playerManager.options setOptionIntValue:0 forKey:@"max_cached_duration" ofCategory:kIJKFFOptionCategoryPlayer];
                [playerManager.options setOptionIntValue:0 forKey:@"infbuf" ofCategory:kIJKFFOptionCategoryPlayer];
                [playerManager.options setOptionIntValue:1 forKey:@"packet-buffering" ofCategory:kIJKFFOptionCategoryPlayer];
            }
            _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
        } else {
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
        }
    }
    return _player;
}

- (void)getCoverImageWithURL:(NSURL *)url
{
    @weakify(self)
    [self yf_getThumbnailImageWithURL:url completionHandler:^(UIImage *image) {
        [weak_self configureControlView:image];
    }];
}

- (void)configureControlView:(UIImage *)coverImage
{
    //NSURL *url = [NSURL fileURLWithPath:vc.model.videoUrl];
    //UIImage *thumbnail = self.yf_videoThumbnailImage(url, 3, 107, 60);
    QPPlayerController *vc = [self playViewController];
    UIImage *defaultThumbnail = QPImageNamed(@"default_thumbnail");
    [vc.controlView showTitle:self.videoTitleByDeletingExtension
               coverURLString:vc.model.coverUrl
             placeholderImage:coverImage ?: defaultThumbnail
               fullScreenMode:ZFFullScreenModeAutomatic];
}

- (NSString *)videoTitleByDeletingExtension
{
    QPPlayerController *vc = [self playViewController];
    if ([vc.model.videoTitle containsString:@"://"]) {
        return vc.model.videoTitle;
    }
    return [vc.model.videoTitle stringByDeletingPathExtension];
}

- (QPPlayerController *)playViewController
{
    return (QPPlayerController *)_viewController;
}

- (void)prepareToPlay
{
    QPPlayerController *vc = [self playViewController];
    NSString *videoUrl = vc.model.videoUrl;
    
    NSURL *aURL = vc.model.isLocalVideo
                ? [NSURL fileURLWithPath:videoUrl]
                : [NSURL URLWithString:videoUrl];
    [self getCoverImageWithURL:aURL];
    
    [QPAppDelegate.pipContext setPresenter:self];
    [QPAppDelegate.pipContext configPlayerModel:vc.model];
    
    [self playWithURL:aURL];
    if (vc.model.seekToTime > 0) {
        [self seekToTime:vc.model.seekToTime];
    }
}

- (void)seekToTime:(NSTimeInterval)time
{
    [self seekToTime:time completionHandler:^(BOOL finished) {}];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completionHandler
{
    [self.player seekToTime:time completionHandler:completionHandler];
}

- (void)enterPortraitFullScreen
{
    [self.player enterPortraitFullScreen:YES animated:YES completion:NULL];
}

- (void)playWithURL:(NSURL *)aURL
{
    QPPlayerController *vc = [self playViewController];
    
    self.player.controlView    = vc.controlView;
    self.player.WWANAutoPlay   = QPCarrierNetworkAllowed();
    self.player.shouldAutoPlay = YES;
    self.player.assetURL       = aURL;
    
    self.player.playerApperaPercent      = 0.0;
    self.player.playerDisapperaPercent   = 1.0;
    self.player.allowOrentitaionRotation = YES;
    // 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    // 是否内存缓存播放
    //self.player.resumePlayRecord = YES;
    
    @zf_weakify(self)
    vc.controlView.backBtnClickCallback = ^{
        @zf_strongify(self)
        [self.player rotateToOrientation:UIInterfaceOrientationPortrait animated:YES completion:NULL];
    };
    
    // Force the user interface orientation to rotate landscape left.
    //self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskAllButUpsideDown;
    //[self.player rotateToOrientation:UIInterfaceOrientationLandscapeLeft animated:NO completion:NULL];
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        QPLog(@":: isFullScreen=%@", isFullScreen ? @"YES" : @"NO");
        QPAppDelegate.allowOrentitaionRotation = isFullScreen;
    };
    self.player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        QPLog(@":: isFullScreen=%@", isFullScreen ? @"YES" : @"NO");
        @zf_strongify(self)
        NSArray<UIWindow *> *windows = [self yf_activeWindows];
        QPPlayerController *vc = [self playViewController];
        // 使用YYTextView转屏失败
        for (UIWindow *window in windows) {
            if ([window isKindOfClass:NSClassFromString(@"YYTextEffectWindow")]) {
                window.hidden = isFullScreen;
            }
        }
        if (!isFullScreen) {
            for (UIWindow *window in windows) {
                if ([window isKindOfClass:ZFLandscapeWindow.class]) {
                    window.hidden = YES;
                }
            }
        }
        if (self.player.orientationObserver.fullScreenMode == ZFFullScreenModePortrait) {
            vc.controlView.showCustomStatusBar = NO;
        } else {
            vc.controlView.showCustomStatusBar = YES;
        }
        [vc needsStatusBarAppearanceUpdate];
        //[vc needsUpdateOfSupportedInterfaceOrientations];
    };
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback> _Nonnull asset) {
        QPLog(@":: asset=%@", asset);
    };
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, id _Nonnull error) {
        QPLog(@":: asset=%@, error=%@", asset, error);
    };
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        QPLog(@":: asset=%@, currentTime=%.2f, duration=%.2f", asset, currentTime, duration);
        //[weak_self takeThumbnailImageOfSpecifiedTime:currentTime];
    };
    self.player.playerBufferTimeChanged = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, NSTimeInterval bufferTime) {
        QPLog(@":: asset=%@, bufferTime=%.2f", asset, bufferTime);
    };
}

- (void)takeThumbnailImageOfSpecifiedTime:(NSTimeInterval)currentTime
{
    if (currentTime == 3.0) {
        @zf_weakify(self)
        [self.player.currentPlayerManager thumbnailImageAtCurrentTime:^(UIImage * _Nonnull image) {
            [weak_self configureControlView:image];
        }];
    }
}

#pragma mark - IJKFFOptions

- (IJKFFOptions *)supplyIJKFFOptions {
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    /*-------------PlayerOption-------------*/
    // 在视频帧处理不过来的时候丢弃一些帧达到同步的效果
    // 跳帧开关，如果cpu解码能力不足，可以设置成5，否则会引起音视频不同步，也可以通过设置它来跳帧达到倍速播放
    [options setPlayerOptionIntValue:5/*0*/ forKey:@"framedrop"];
    // 最大fps
    [options setPlayerOptionIntValue:30 forKey:@"max-fps"];
    // 帧速率(fps) 可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推）
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    // 指定最大宽度
    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
    // 开启/关闭 硬解码（硬件解码CPU消耗低。软解，更稳定）
    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
    // 是否有声音
    [options setPlayerOptionIntValue:1  forKey:@"an"];
    // 是否有视频
    [options setPlayerOptionIntValue:1  forKey:@"vn"];
    // 每处理一个packet之后刷新io上下文
    [options setPlayerOptionIntValue:1 forKey:@"flush_packets"];
    // 是否禁止图像显示(只输出音频)
    [options setPlayerOptionIntValue:1 forKey:@"nodisp"];
    //
    [options setPlayerOptionIntValue:0 forKey:@"start-on-prepared"];
    //
    [options setPlayerOptionValue:@"fcc-_es2" forKey:@"overlay-format"];
    //
    [options setPlayerOptionIntValue:3 forKey:@"video-pictq-size"];
    //
    [options setPlayerOptionIntValue:25 forKey:@"min-frames"];
    
    /*-------------FormatOption-------------*/
    // 如果是rtsp协议，可以优先用tcp(默认是用udp)
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    // 播放前的探测Size，默认是1M, 改小一点会出画面更快
    [options setFormatOptionIntValue:1024*16*0.5 forKey:@"probsize"];
    // 播放前的探测时间
    [options setFormatOptionIntValue:50000 forKey:@"analyzeduration"];
    // 自动转屏开关
    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
    // 重连次数
    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
    // 超时时间，timeout参数只对http设置有效。若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。rtmp的timeout参数含义和http的不一样。
    [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"];
    //
    [options setFormatOptionValue:@"nobuffer" forKey:@"fflags"];
    //
    [options setFormatOptionValue:@"ijkplayer" forKey:@"user-agent"];
    //
    [options setFormatOptionIntValue:0 forKey:@"safe"];
    //
    [options setFormatOptionIntValue:0 forKey:@"http-detect-range-support"];
    //
    [options setFormatOptionIntValue:4628439040 forKey:@"ijkapplication"];
    //
    [options setFormatOptionIntValue:6176477408 forKey:@"ijkiomanager"];
    
    return options;
}

@end

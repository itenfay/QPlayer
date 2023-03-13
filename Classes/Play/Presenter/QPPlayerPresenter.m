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
@property (nonatomic, strong) AVPictureInPictureController *pipController;
@end

@implementation QPPlayerPresenter

- (ZFPlayerController *)player
{
    if (!_player) {
        QPPlayerController *vc = [self playViewController];
        if ((vc.model.isLocalVideo && vc.model.isMediaPlayerPlayback) || vc.model.isMediaPlayerPlayback) {
            KSYMediaPlayerManager *playerManager = [[KSYMediaPlayerManager alloc] init];
            _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
            // 默认是硬解码
            if (vc.model.videoDecoding == 1) {
                //playerManager.player.videoDecoderMode = MPMovieVideoDecoderMode_Hardware;
            } else {
                //playerManager.player.videoDecoderMode = MPMovieVideoDecoderMode_Software;
            }
        } else if ((vc.model.isLocalVideo && vc.model.isIJKPlayerPlayback) || vc.model.isIJKPlayerPlayback) {
            //ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init]; // playerManager
            // Invalid, player hasn't been initialized yet.
            //[playerManager.player setPlayerOptionIntValue:vc.model.videoDecoding forKey:@"videotoolbox"];
            //NSURL *aURL = [NSURL URLWithString:vc.model.videoUrl];
            //NSString *scheme = [aURL scheme];
            //QPLog(@":: scheme=%@", scheme);
            //if ([scheme isEqualToString:@"rtsp"]) {
            //    [playerManager.player setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
            //}
            //_player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
        } else if ((vc.model.isLocalVideo && vc.model.isZFPlayerPlayback) || vc.model.isZFPlayerPlayback) {
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
        } else {
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:vc.containerView];
        }
    }
    return _player;
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
    [self playWithURL:aURL];
}

- (void)enterPortraitFullScreen
{
    [self.player enterPortraitFullScreen:YES animated:YES completion:NULL];
}

- (void)playWithURL:(NSURL *)aURL
{
    QPPlayerController *vc = [self playViewController];
    
    self.player.controlView    = vc.controlView;
    self.player.WWANAutoPlay   = YES;
    self.player.shouldAutoPlay = YES;
    self.player.assetURL       = aURL;
    
    self.player.playerApperaPercent      = 0.0;
    self.player.playerDisapperaPercent   = 1.0;
    self.player.allowOrentitaionRotation = NO;
    // 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = YES;
    // 是否内存缓存播放
    //self.player.resumePlayRecord = YES;
    
    @zf_weakify(self)
    vc.controlView.backBtnClickCallback = ^{
        @zf_strongify(self)
        [self.player rotateToOrientation:UIInterfaceOrientationPortrait animated:YES completion:NULL];
    };
    
    // Don't use this.
    //self.player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskAllButUpsideDown;
    //[self.player rotateToOrientation:UIInterfaceOrientationPortrait animated:NO completion:NULL];
    
    self.player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        QPLog(@":: %s, isFullScreen=%@", __func__, isFullScreen ? @"YES" : @"NO");
        //@zf_strongify(self)
        //[self.viewController setNeedsStatusBarAppearanceUpdate];
        //[UIViewController attemptRotationToDeviceOrientation];
        /* // 使用YYTextView转屏失败
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if ([window isKindOfClass:NSClassFromString(@"YYTextEffectWindow")]) {
                window.hidden = isFullScreen;
            }
        }
        */
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        QPLog(@":: %s, asset=%@", __func__, asset);
    };
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, id _Nonnull error) {
        QPLog(@":: %s, asset=%@, error=%@", __func__, asset, error);
    };
}

- (void)startPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    QPPlayerController *vc = [self playViewController];
    if (vc.model.isIJKPlayerPlayback) {
        return;
    }
    if (vc.model.isZFPlayerPlayback) {
        ZFAVPlayerManager *manager = (ZFAVPlayerManager *)self.player.currentPlayerManager;
        if (!manager) { return; }
        AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:manager.avPlayerLayer];
        self.pipController = pipVC;
        
    } else if (vc.model.isMediaPlayerPlayback) {
        KSYMediaPlayerManager *manager = (KSYMediaPlayerManager *)self.player.currentPlayerManager;
        AVPlayerLayer *avPlayerLayer = (AVPlayerLayer *)manager.view.playerView.layer;
        AVPictureInPictureController *pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:avPlayerLayer];
        self.pipController = pipVC;
    }
    /// 要有延迟 否则可能开启不成功
    [self delayToScheduleTask:2.0 completion:^{
        [self.pipController startPictureInPicture];
    }];
}

- (void)stopPictureInPicture
{
    if (!QPPlayerPictureInPictureEnabled())
        return;
    QPPlayerController *vc = [self playViewController];
    if (vc.model.isMediaPlayerPlayback || vc.model.isIJKPlayerPlayback) {
        return;
    }
    [self.pipController stopPictureInPicture];
}

//- (void)configureIJKFFOptions:(IJKFFOptions *)options {
//    // 帧速率（fps）可以改，确认非标准帧率会导致音画不同步，所以只能设定为15或者29.97）
//    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
//    // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推)
//    [options setPlayerOptionIntValue:512 forKey:@"vol"];
//    // 静音设置
//    [options setPlayerOptionValue:@"1" forKey:@"an"];
//
//    // 最大fps
//    [options setPlayerOptionIntValue:30 forKey:@"max-fps"];
//    // 跳帧开关
//    [options setPlayerOptionIntValue:0 forKey:@"framedrop"];
//    // 开启硬编码（默认是 0 ：软解）
//    [options setPlayerOptionIntValue:self.videoDecoding forKey:@"videotoolbox"];
//
//    // 指定最大宽度
//    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
//    // 自动转屏开关
//    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
//
//    // 重连开启 BOOL
//    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
//    // 超时时间，timeout参数只对http设置有效
//    // 若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。
//    // rtmp的timeout参数含义和http的不一样。
//    [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"];
//
//    // 播放前的探测Size，默认是1M, 改小一点会出画面更快
//    [options setFormatOptionIntValue:1024 * 16 forKey:@"probesize"];
//    // 开启环路滤波（0比48清楚，但解码开销大，48基本没有开启环路滤波，清晰度低，解码开销小）
//    [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
//    [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
//
//    // param for living
//    // 如果使用rtsp协议，可以优先用tcp（默认udp）
//    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
//    // 最大缓存大小是3秒，可以依据自己的需求修改
//    [options setPlayerOptionIntValue:3000 forKey:@"max_cached_duration"];
//    // 无限读
//    [options setPlayerOptionIntValue:1 forKey:@"infbuf"];
//    // 关闭播放器缓冲 (如果频繁卡顿，可以保留缓冲区，不设置默认为1)
//    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
//
//    // param for playback
//    //[options setPlayerOptionIntValue:0 forKey:@"max_cached_duration"];
//    //[options setPlayerOptionIntValue:0 forKey:@"infbuf"];
//    //[options setPlayerOptionIntValue:1 forKey:@"packet-buffering"];
//}

@end

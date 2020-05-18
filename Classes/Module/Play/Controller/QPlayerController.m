//
//  QPlayerController.m
//  QPlayer
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "QPlayerController.h"
#import "QPTitleView.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "KSYMediaPlayerManager.h" // Conflicts with ijkplayer.
/*
 #import <ZFPlayer/ZFIJKPlayerManager.h>
 #import <ZFPlayer/KSMediaPlayerManager.h>
 */

@interface QPlayerController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ZFPlayerController  *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView         *containerView;

@end

@implementation QPlayerController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setHidesBottomBarWhenPushed:YES];
        [self setVideoDecoding:0];
        [self setParsingButtonRequired:NO];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self addContainerView];
    
    [self initWebView];
    [self buildWebToolBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QPLog(@" >>>>>>>>>> videoTitle: %@", self.videoTitle);
    QPLog(@" >>>>>>>>>> videoUrl: %@", self.videoUrl);
    QPLog(@" >>>>>>>>>> videoDecoding: %d", self.videoDecoding);
    
    [self setupNavigationItems];
    [self configureControlView];
    [self loadDefaultRequest];
    
    self.scheduleTask(self, @selector(inspectWebToolBarAlpha), nil, 2.5);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self interactivePopGestureAction];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareToPlay];
}

- (void)prepareToPlay {
    
    if (self.isLocalVideo && self.isZFPlayerPlayback) {
        
        NSURL *fileURL = [NSURL fileURLWithPath:self.videoUrl];
        [self useZFPlayerToPlay:fileURL];
        
    } else if (self.isLocalVideo && self.isIJKPlayerPlayback) {
        
        NSURL *fileURL = [NSURL fileURLWithPath:self.videoUrl];
        [self useIJKPlayerToPlay:fileURL];
        
    } else if (self.isIJKPlayerPlayback) {
        
        NSURL *aURL = [NSURL URLWithString:self.videoUrl];
        [self useIJKPlayerToPlay:aURL]; // Live.
        
    } else if (self.isLocalVideo && self.isMediaPlayerPlayback) {
        
        NSURL *fileURL = [NSURL fileURLWithPath:self.videoUrl];
        [self useKSYMediaPlayerToPlay:fileURL];
        
    } else if (self.isMediaPlayerPlayback) {
        
        NSURL *aURL = [NSURL URLWithString:self.videoUrl];
        [self useKSYMediaPlayerToPlay:aURL]; // Live.
        
    } else {
        
        NSURL *aURL = [NSURL URLWithString:self.videoUrl];
        [self useZFPlayerToPlay:aURL];
    }
}

- (void)interactivePopGestureAction {
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    QPlayerSavePlaying(NO);
    [self.player stopCurrentPlayingView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat cX = 0.f;
    CGFloat cY = 0.f;
    CGFloat cW = self.view.width;
    CGFloat cH = cW*9/16;
    self.containerView.frame = CGRectMake(cX, cY, cW, cH);
    
    self.webView.x      = self.containerView.x;
    self.webView.y      = self.containerView.bottom;
    self.webView.width  = self.view.width;
    self.webView.height = self.view.height - self.containerView.height;
}

- (void)setupNavigationItems {
    self.navigationItem.hidesBackButton = YES;
    
    QPTitleView *titleView = [[QPTitleView alloc] init];
    titleView.left   = 0.f;
    titleView.top    = 0.f;
    titleView.width  = self.view.width;
    titleView.height = 36.f;
    titleView.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleView;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.width     = 30.f;
    backButton.height    = 30.f;
    backButton.left      = 0.f;
    backButton.top       = (titleView.height - backButton.height)/2;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 12);
    [titleView addSubview:backButton];
    
    UILabel *titleLabel        = [[UILabel alloc] init];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textColor       = UIColor.whiteColor;
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.text            = QPInfoDictionary[@"CFBundleName"];
    
    titleLabel.height = 30.f;
    titleLabel.left   = backButton.right - 12.f;
    titleLabel.top    = (titleView.height - titleLabel.height)/2;
    titleLabel.width  = titleView.right - titleLabel.left - 2*16.f;
    [titleView addSubview:titleLabel];
}

- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addContainerView {
    [self.view addSubview:self.containerView];
}

- (void)configureControlView {
    UIImage *defaultImage = QPImageNamed(@"default_thumbnail");
    UIImage *image = self.placeholderCoverImage ?: defaultImage;
    
    [self.controlView showTitle:self.videoTitleByDeletingExtension
                 coverURLString:self.coverUrl
               placeholderImage:image
                 fullScreenMode:ZFFullScreenModePortrait];
}

- (void)initWebView {
    CGRect frame = CGRectMake(0, 0, 0, 0);
    [self initWebViewWithFrame:frame];
    
    self.webView.backgroundColor     = QPColorFromRGB(243, 243, 243);
    self.webView.opaque              = NO;
    self.webView.navigationDelegate  = self;
    self.webView.UIDelegate          = self;
    self.webView.scrollView.delegate = self;
    
    self.webView.autoresizingMask    = (UIViewAutoresizingFlexibleLeftMargin |
                                        UIViewAutoresizingFlexibleTopMargin  |
                                        UIViewAutoresizingFlexibleWidth      |
                                        UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:self.webView];
}

- (void)buildWebToolBar {
    UIImageView *toolBar = [self buildCustomToolBar];
    toolBar.tag = 888;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (UIImageView *)webToolBar {
    return (UIImageView *)[self.view viewWithTag:888];
}

- (void)inspectWebToolBarAlpha {
    if (self.webToolBar.alpha > 0.f) {
        self.webToolBar.alpha = 0.f;
        self.scheduleTask(self,
                          @selector(cancelHidingToolBar),
                          nil,
                          0);
    }
}

- (void)loadDefaultRequest {
    NSString *aUrl = [QPInfoDictionary objectForKey:@"MyGithubUrl"];
    [self loadRequest:aUrl];
}

- (NSString *)videoTitleByDeletingExtension {
    if ([self.videoTitle containsString:@"://"]) {
        return self.videoTitle;
    }
    
    return [self.videoTitle stringByDeletingPathExtension];
}

- (void)useZFPlayerToPlay:(NSURL *)aURL {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init]; // playerManager
    
    // player
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    
    self.player.controlView    = self.controlView;
    self.player.WWANAutoPlay   = YES;
    self.player.shouldAutoPlay = YES;
    self.player.assetURL       = aURL;
    
    self.player.playerApperaPercent      = 1.0;
    self.player.playerDisapperaPercent   = 0.5;
    self.player.statusBarHidden          = NO;
    self.player.pauseWhenAppResignActive = YES;
    
    // Force Landscape Full Screen.
    //[self.player enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        //@strongify(self)
        QPLog(@"%s", __func__);
    };
    
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, id _Nonnull error) {
        //@strongify(self)
        QPLog(@"%s, error: %@", __func__, error);
    };
}

- (void)useIJKPlayerToPlay:(NSURL *)aURL {
    NSString *urlScheme = [aURL scheme];
    QPLog(@"urlScheme: %@", urlScheme);
    
    /*
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init]; // playerManager
    
    // Invalid, player hasn't been initialized yet.
    //[playerManager.player setPlayerOptionIntValue:self.videoDecoding forKey:@"videotoolbox"];
    //if ([urlScheme isEqualToString:@"rtsp"]) {
    //    [playerManager.player setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    //}
    
    // player
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    
    self.player.controlView    = self.controlView;
    self.player.WWANAutoPlay   = YES;
    self.player.shouldAutoPlay = YES;
    self.player.assetURL       = aURL;
    
    self.player.playerApperaPercent      = 1.0;
    self.player.playerDisapperaPercent   = 0.5;
    self.player.statusBarHidden          = NO;
    self.player.pauseWhenAppResignActive = YES;
    
    // Force Landscape Full Screen.
    //[self.player enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        //@strongify(self)
        QPLog(@"%s", __func__);
    };
    
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, id _Nonnull error) {
        //@strongify(self)
        QPLog(@"%s, error: %@", __func__, error);
    };
    */
}

- (void)useKSYMediaPlayerToPlay:(NSURL *)aURL {
    // playerManager
    KSYMediaPlayerManager *playerManager = [[KSYMediaPlayerManager alloc] init];
    
    // Invalid, player hasn't been initialized yet.
    //if (self.videoDecoding == 1) {
    //    // MPMovieVideoDecoderMode_AUTO
    //    playerManager.player.videoDecoderMode = MPMovieVideoDecoderMode_Hardware;
    //} else {
    //    playerManager.player.videoDecoderMode = MPMovieVideoDecoderMode_Software;
    //}
    
    // player
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    
    self.player.controlView    = self.controlView;
    self.player.WWANAutoPlay   = YES;
    self.player.shouldAutoPlay = YES;
    self.player.assetURL       = aURL;
    
    self.player.playerApperaPercent      = 1.0;
    self.player.playerDisapperaPercent   = 0.5;
    self.player.statusBarHidden          = NO;
    self.player.pauseWhenAppResignActive = YES;
    
    // Force Landscape Full Screen.
    //[self.player enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        //@strongify(self)
        QPLog(@"%s", __func__);
    };
    
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback> _Nonnull asset, id _Nonnull error) {
        //@strongify(self)
        QPLog(@"%s, error: %@", __func__, error);
    };
}

/*
- (void)configureIJKFFOptions:(IJKFFOptions *)options {
    // 帧速率（fps）可以改，确认非标准帧率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推)
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    // 静音设置
    [options setPlayerOptionValue:@"1" forKey:@"an"];
    
    // 最大fps
    [options setPlayerOptionIntValue:30 forKey:@"max-fps"];
    // 跳帧开关
    [options setPlayerOptionIntValue:0 forKey:@"framedrop"];
    // 开启硬编码（默认是 0 ：软解）
    [options setPlayerOptionIntValue:self.videoDecoding forKey:@"videotoolbox"];
    
    // 指定最大宽度
    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
    // 自动转屏开关
    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
    
    // 重连开启 BOOL
    [options setFormatOptionIntValue:1 forKey:@"reconnect"];
    // 超时时间，timeout参数只对http设置有效
    // 若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。
    // rtmp的timeout参数含义和http的不一样。
    [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"];
    
    // 播放前的探测Size，默认是1M, 改小一点会出画面更快
    [options setFormatOptionIntValue:1024 * 16 forKey:@"probesize"];
    // 开启环路滤波（0比48清楚，但解码开销大，48基本没有开启环路滤波，清晰度低，解码开销小）
    [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
    [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
    
    // param for living
    // 如果使用rtsp协议，可以优先用tcp（默认udp）
    [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
    // 最大缓存大小是3秒，可以依据自己的需求修改
    [options setPlayerOptionIntValue:3000 forKey:@"max_cached_duration"];
    // 无限读
    [options setPlayerOptionIntValue:1 forKey:@"infbuf"];
    // 关闭播放器缓冲 (如果频繁卡顿，可以保留缓冲区，不设置默认为1)
    [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];
    
    // param for playback
    //[options setPlayerOptionIntValue:0 forKey:@"max_cached_duration"];
    //[options setPlayerOptionIntValue:0 forKey:@"infbuf"];
    //[options setPlayerOptionIntValue:1 forKey:@"packet-buffering"];
}
*/

- (void)loadRequest:(NSString *)url {
    NSURL *aURL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:aURL];
    [self.webView loadRequest:request];
}

#pragma make - WKNavigationDelegate, WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // didStartProvisionalNavigation.
    
    NSURL *aURL = [webView.URL copy];
    NSString *aUrl = aURL.absoluteString;
    QPLog(@"webView.url: %@", aUrl);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    // didReceiveServerRedirectForProvisionalNavigation.
    QPLog(@"[redirect] webView.url: %@", webView.URL);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [super webView:webView didCommitNavigation:navigation];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    QPLog(@"url: %@", webView.URL);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailProvisionalNavigation:navigation withError:error];
    
    if (!error || error.code == NSURLErrorCancelled ||
        error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    
    NSString *errMessage = [NSString stringWithFormat:@"%zi, %@", error.code, error.localizedDescription];
    QPLog(@"[error]: %@", errMessage);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailNavigation:navigation withError:error];
    
    if (!error || error.code == NSURLErrorCancelled ||
        error.code == NSURLErrorUnsupportedURL) {
        return;
    }
    
    NSString *errMessage = [NSString stringWithFormat:@"%zi, %@", error.code, error.localizedDescription];
    QPLog(@"[error]: %@", errMessage);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // decidePolicyForNavigationAction.
    
    NSURL *aURL = [navigationAction.request.URL copy];
    NSString *aUrl = aURL.absoluteString;
    QPLog(@"url: %@", aUrl);
    
    // Method NO.1: resolve the problem about '_blank'.
    //if (navigationAction.targetFrame == nil) {
    //    QPLog(@"- [webView loadRequest:navigationAction.request]");
    //    [webView loadRequest:navigationAction.request];
    //}
    
    if ([aUrl isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    // createWebViewWithConfiguration.
    
    NSURL *aURL = [navigationAction.request.URL copy];
    NSString *aUrl = aURL.absoluteString;
    QPLog(@"url: %@", aUrl);
    
    if (!navigationAction.targetFrame.isMainFrame) {
        QPLog(@"- [webView loadRequest:navigationAction.request]");
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

#pragma make - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showToolBarWithAnimation];
    [self cancelHidingToolBar];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self delayToHideToolBar];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self delayToHideToolBar];
    }
}

- (void)delayToHideToolBar {
    self.scheduleTask(self,
                      @selector(hideToolBar),
                      nil,
                      6);
}

- (void)hideToolBar {
    [self hideToolBarWithAnimation];
}

- (void)showToolBarWithAnimation {
    UIImageView *toolBar = self.webToolBar;
    if (toolBar.alpha == 0.f) {
        [UIView animateWithDuration:0.5 animations:^{
            toolBar.alpha = 1.f;
        }];
    }
}

- (void)hideToolBarWithAnimation {
    UIImageView *toolBar = self.webToolBar;
    if (toolBar.alpha == 1.f) {
        [UIView animateWithDuration:0.5 animations:^{
            toolBar.alpha = 0.f;
        }];
    }
}

- (void)cancelHidingToolBar {
    self.cancelPerformingSelector(self, @selector(hideToolBar), nil);
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    //if (self.player.isFullScreen) {
    //    return UIStatusBarStyleLightContent;
    //}
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
} 

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated       = YES;
        _controlView.autoHiddenTimeInterval = 5.0;
        _controlView.autoFadeTimeInterval   = 0.5;
        _controlView.prepareShowControlView = YES;
        _controlView.prepareShowLoading     = YES;
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        _containerView.backgroundColor = QPColorFromRGB(36, 39, 46);
        _containerView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _containerView;
}

- (void)dealloc {
    QPLog(@" >>>>>>>>>> ");
    [self releaseWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

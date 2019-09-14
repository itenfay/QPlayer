//
//  VideoPlayerController.m
//
//  Created by dyf on 2017/12/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "VideoPlayerController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/KSMediaPlayerManager.h>

@interface VideoPlayerController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation VideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarButtonItem];
    [self setNavigationItemTitle];
    
    [self setPlayerControlView];
    [self attemptToPlay];
}

- (NSString *)getVideoName {
    return [self.video_name stringByDeletingPathExtension];
}

- (void)setNavigationItemTitle {
    self.navigationItem.title = [self getVideoName];
}

- (void)setLeftBarButtonItem {
    UIButton *backButton = [self backButtonWithTarget:self selector:@selector(back)];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftBarButtonItem];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setPlayerControlView {
    [self.controlView showTitle:[self getVideoName] coverImage:nil fullScreenMode:ZFFullScreenModePortrait];
}

- (void)attemptToPlay {
    // KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init]; // playerManager
    
    // player
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.view];
    self.player.assetURL = [NSURL fileURLWithPath:self.video_urlstr];
    self.player.controlView = self.controlView;
    self.player.shouldAutoPlay = NO;
    self.player.playerDisapperaPercent = 1.0;
    
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
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
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
    }
    return _controlView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

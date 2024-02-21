//
//  QPPlayerController.m
//  QPlayer
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPPlayerController.h"

@interface QPPlayerController ()
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) UILabel *overlayLabel;
@property (nonatomic, assign) BOOL showNext;
@end

@implementation QPPlayerController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (instancetype)initWithModel:(QPPlayerModel *)model
{
    if (self = [super init]) {
        self.model = model;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 3;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
        _controlView.showCustomStatusBar = YES;
    }
    return _controlView;
}

- (UIImageView *)containerView
{
    if (!_containerView) {
        _containerView = [UIImageView new];
        _containerView.backgroundColor = QPColorFromRGB(36, 39, 46);
        _containerView.image = QPImageNamed(@"default_thumbnail");
        _containerView.contentMode = UIViewContentModeScaleToFill;
    }
    return _containerView;
}

- (void)configureNavigationBar {
    QPTitleView *titleView = [[QPTitleView alloc] init];
    titleView.left   = 0.f;
    titleView.top    = 0.f;
    titleView.width  = self.view.width;
    titleView.height = 36.f;
    titleView.userInteractionEnabled = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.width     = 30.f;
    backButton.height    = 30.f;
    backButton.left      = 0.f;
    backButton.top       = 0.f;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self addLeftNavigationBarButton:backButton];
    
    UIButton *portraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    portraitButton.width     = 30.f;
    portraitButton.height    = 30.f;
    portraitButton.right     = 0.f;
    portraitButton.top       = 0.f;
    [portraitButton setTitle:@"竖屏" forState:UIControlStateNormal];
    [portraitButton setTitleColor:QPColorFromRGB(252, 252, 252) forState:UIControlStateNormal];
    [portraitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
    [portraitButton addTarget:self action:@selector(onPortraitFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    portraitButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self addRightNavigationBarButton:portraitButton];
    
    UIButton *pipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pipButton.width     = 30.f;
    pipButton.height    = 30.f;
    pipButton.right     = 0.f;
    pipButton.top       = 0.f;
    [pipButton setShowsTouchWhenHighlighted:YES];
    [pipButton setTitle:@"小窗播放" forState:UIControlStateNormal];
    [pipButton setTitleColor:QPColorFromRGB(252, 252, 252) forState:UIControlStateNormal];
    [pipButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
    [pipButton addTarget:self action:@selector(pipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addRightNavigationBarButton:pipButton];
    
    //[self setNavigationBarTitle:QPInfoDictionary[@"CFBundleName"]];
    [self setNavigationBarTitle:@""];
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pipBtnClick:(UIButton *)sender
{
    QPPictureInPictureContext *ctx = QPAppDelegate.pipContext;
    [ctx startPictureInPicture];
}

- (void)loadView
{
    [super loadView];
    [self addContainerView];
    [self addOverlayLayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    QPLog(@"videoTitle: %@", self.model.videoTitle);
    QPLog(@"videoUrl: %@", self.model.videoUrl);
    QPLog(@"videoDecoding: %d", QPPlayerHardDecoding());
    
    QPPlayerPresenter *presenter = [[QPPlayerPresenter alloc] init];
    presenter.view = self.view;
    presenter.viewController = self;
    self.presenter = presenter;
    
    [self loadBottomContents];
    [presenter prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QPAppDelegate.allowOrentitaionRotation = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableInteractivePopGesture:NO];
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if (![pt.player.currentPlayerManager isPlaying]) {
        [pt.player.currentPlayerManager play];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self enableInteractivePopGesture:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    QPAppDelegate.allowOrentitaionRotation = NO;
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if ([self isMovingFromParentViewController]) {
        QPPlayerSavePlaying(NO);
        [pt.player stopCurrentPlayingView];
    }
    if (_showNext) {
        _showNext = NO;
        QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
        if ([pt.player.currentPlayerManager isPlaying]) {
            [pt.player.currentPlayerManager pause];
        }
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat cX = 0.f;
    CGFloat cY = 0.f;
    CGFloat cW = self.view.width;
    CGFloat cH = cW*9/16;
    self.containerView.frame = CGRectMake(cX, cY, cW, cH);
    self.overlayLabel.frame = CGRectMake(cX, cY, cW, cH);
    
    self.webView.x      = self.containerView.x;
    self.webView.y      = self.containerView.bottom;
    self.webView.width  = self.view.width;
    self.webView.height = self.view.height - self.containerView.height;
}

- (void)onPortraitFullScreen:(UIButton *)sender
{
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    [pt enterPortraitFullScreen];
}

- (void)addContainerView
{
    [self.view addSubview:self.containerView];
}

- (void)loadBottomContents
{
    NSString *aUrl = QPInfoDictionary[@"MyGithubUrl"];
    [self loadRequestWithUrl:aUrl];
}

- (void)addOverlayLayer
{
    [self.view addSubview:_overlayLabel];
}

- (UILabel *)overlayLabel
{
    if (!_overlayLabel) {
        _overlayLabel = UILabel.alloc.init;
        _overlayLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        _overlayLabel.text = @"正在使用小窗播放";
        _overlayLabel.textColor = UIColor.whiteColor;
        _overlayLabel.textAlignment = NSTextAlignmentCenter;
        _overlayLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _overlayLabel.hidden = YES;
    }
    return _overlayLabel;
}

- (void)showOverlayLayer
{
    _overlayLabel.hidden = NO;
}

- (void)hideOverlayLayer {
    _overlayLabel.hidden = YES;
}

@end

//
//  QPPlayerController.m
//  QPlayer
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPPlayerController.h"
#import "QPTitleView.h"
#import "QPPlayerWebViewAdapter.h"

@interface QPPlayerController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *containerView;
@end

@implementation QPPlayerController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithModel:(QPPlayerModel *)model
{
    if (self = [super init]) {
        self.model = model;
        self.model.videoDecoding = 0;
        self.parsingButtonRequired = NO;
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
        _containerView.contentMode = UIViewContentModeCenter;
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
    backButton.top       = (titleView.height - backButton.height)/2;
    [backButton setImage:QPImageNamed(@"back_normal_white") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 12);
    [titleView addSubview:backButton];
    
    UIButton *portraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    portraitButton.width     = 40.f;
    portraitButton.height    = 30.f;
    portraitButton.right     = titleView.right - 2*12.f; // The margin is 12.
    portraitButton.top       = (titleView.height - portraitButton.height)/2;
    portraitButton.showsTouchWhenHighlighted = YES;
    [portraitButton setTitle:@"竖屏" forState:UIControlStateNormal];
    [portraitButton setTitleColor:QPColorFromRGB(252, 252, 252) forState:UIControlStateNormal];
    [portraitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [portraitButton addTarget:self action:@selector(onPortraitFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:portraitButton];
    
    UILabel *titleLabel        = [[UILabel alloc] init];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textColor       = UIColor.whiteColor;
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.text            = @""; // QPInfoDictionary[@"CFBundleName"];
    
    titleLabel.height = 30.f;
    titleLabel.left   = backButton.right - 12.f;
    titleLabel.top    = (titleView.height - titleLabel.height)/2;
    titleLabel.width  = portraitButton.left - titleLabel.left - 12.f;
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    self.navigationItem.hidesBackButton = YES;
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    [super loadView];
    [self addContainerView];
    [self addWebView];
    [self addWebToolBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    QPLog(@":: videoTitle: %@", self.model.videoTitle);
    QPLog(@":: videoUrl: %@", self.model.videoUrl);
    QPLog(@":: videoDecoding: %d", self.model.videoDecoding);
    [self configureNavigationBar];
    
    QPPlayerPresenter *presenter = [[QPPlayerPresenter alloc] init];
    presenter.view = self.view;
    presenter.viewController = self;
    self.presenter = presenter;
    
    QPPlayerWebViewAdapter *adater = [[QPPlayerWebViewAdapter alloc]
                                      initWithWebView:self.webView
                                      navigationBar:self.navigationBar
                                      toolBar:[self webToolBar]];
    self.adapter = adater;
    [self.adapter addProgressViewToWebView];
    [self setWebViewDelegate];
    [self delayToScheduleTask:3 completion:^{
        [self.adapter inspectToolBarAlpha];
    }];
    
    [self loadBottomContents];
    [presenter prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QPAppDelegate.allowOrentitaionRotation = YES;
    [self enableInteractivePopGesture:YES];
    [self configureControlView];
    QPlayerSavePlaying(YES);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if (![pt.player.currentPlayerManager isPlaying]) {
        [pt.player.currentPlayerManager play];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if ([self isMovingFromParentViewController]) {
        QPAppDelegate.allowOrentitaionRotation = NO;
        [self releaseWebView];
        QPlayerSavePlaying(NO);
        [pt.player stopCurrentPlayingView];
    } else {
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
    
    self.webView.x      = self.containerView.x;
    self.webView.y      = self.containerView.bottom;
    self.webView.width  = self.view.width;
    self.webView.height = self.view.height - self.containerView.height;
}

- (void)onPortraitFullScreen:(UIButton *)sender
{
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if (pt.player) {
        [pt.player enterPortraitFullScreen:YES animated:YES completion:NULL];
    }
}

- (void)addContainerView
{
    [self.view addSubview:self.containerView];
}

- (void)addWebView
{
    CGRect frame = CGRectMake(0, 0, 0, 0);
    [self initWebViewWithFrame:frame];
    
    self.webView.backgroundColor     = QPColorFromRGB(243, 243, 243);
    self.webView.opaque              = NO;
    [self.webView autoresizing];
    [self.view addSubview:self.webView];
}

- (void)setWebViewDelegate
{
    self.webView.navigationDelegate  = self.adapter;
    self.webView.UIDelegate          = self.adapter;
    self.webView.scrollView.delegate = self.adapter;
}

- (void)addWebToolBar
{
    UIImageView *toolBar = [self buildToolBar];
    toolBar.tag = 888;
    toolBar.alpha = 0.f;
    [self.view addSubview:toolBar];
}

- (UIImageView *)webToolBar
{
    return (UIImageView *)[self.view viewWithTag:888];
}

- (NSString *)videoTitleByDeletingExtension
{
    if ([self.model.videoTitle containsString:@"://"]) {
        return self.model.videoTitle;
    }
    return [self.model.videoTitle stringByDeletingPathExtension];
}

- (void)configureControlView
{
    [self.controlView showTitle:self.videoTitleByDeletingExtension
                 coverURLString:self.model.coverUrl
               placeholderImage:self.model.placeholderCoverImage
                 fullScreenMode:ZFFullScreenModeAutomatic];
}

- (void)loadBottomContents {
    NSString *aUrl = [QPInfoDictionary objectForKey:@"MyJianShuUrl"];
    [self loadRequestWithUrl:aUrl];
}

- (ZFPlayerControlView *)supplyControlView
{
    return self.controlView;
}

- (UIImageView *)supplyContainerView
{
    return self.containerView;
}

@end

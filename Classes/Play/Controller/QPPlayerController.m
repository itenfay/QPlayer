//
//  QPPlayerController.m
//  QPlayer
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPPlayerController.h"
#import "QPPlayerWebViewAdapter.h"

@interface QPPlayerController ()
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, assign) BOOL showNext;
@end

@implementation QPPlayerController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate
{
    return NO;
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
        self.parsingRequired = NO;
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
    [pipButton setTitle:@"画中画" forState:UIControlStateNormal];
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
    QPPlayerPresenter *pt = (QPPlayerPresenter *)self.presenter;
    if ([pt isPictureInPictureActive]) {
        [pt stopPictureInPicture];
    } else {
        [pt startPictureInPicture];
    }
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
    QPAppDelegate.playerController = self;
    QPLog(@":: videoTitle: %@", self.model.videoTitle);
    QPLog(@":: videoUrl: %@", self.model.videoUrl);
    QPLog(@":: videoDecoding: %d", QPPlayerHardDecoding());
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
    [self delayToScheduleTask:2 completion:^{
        [self.adapter inspectToolBarAlpha];
    }];
    
    [self loadBottomContents];
    [presenter prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QPAppDelegate.allowOrentitaionRotation = YES;
    QPPlayerSavePlaying(YES);
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

- (void)addWebView
{
    CGRect frame = CGRectMake(0, 0, 0, 0);
    [self initWebViewWithFrame:frame];
    
    self.webView.backgroundColor = QPColorFromRGB(243, 243, 243);
    self.webView.opaque          = NO;
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

- (void)loadBottomContents {
    NSString *aUrl = [QPInfoDictionary objectForKey:@"MyJianShuUrl"];
    [self loadRequestWithUrl:aUrl];
}

@end

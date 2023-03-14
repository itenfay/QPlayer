//
//  QPWebPlaybackContext.h
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBaseContext.h"
#import "QPWKWebViewAdapter.h"
#import "QPPlayerController.h"

@interface QPWebPlaybackContext : QPBaseContext
@property (nonatomic, weak) QPWKWebViewAdapter *adapter;
@property (nonatomic, weak) QPBaseViewController *controller;

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter viewController:(QPBaseViewController *)viewController;

- (BOOL)canAllowNavigation:(NSURL *)URL;

- (void)evaluateJavaScriptForVideoSrc;
- (void)evaluateJavaScriptForVideoCurrentSrc;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString usingMediaPlayer:(BOOL)usingMediaPlayer;

@end


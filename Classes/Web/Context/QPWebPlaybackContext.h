//
//  QPWebPlaybackContext.h
//  QPlayer
//
//  Created by Tenfay on 2023/3/9.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "BaseContext.h"
#import "QPPlaybackContext.h"
#import "QPWKWebViewAdapter.h"
#import "QPPlayerController.h"

@interface QPWebPlaybackContext : BaseContext
@property (nonatomic, weak) QPWKWebViewAdapter *adapter;
@property (nonatomic, weak) BaseViewController *controller;
@property (nonatomic, assign) QPPlayerType playerType;

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter viewController:(BaseViewController *)viewController;

- (BOOL)canAllowNavigation:(NSURL *)URL;

- (void)queryVideoUrlByJavaScript;
- (void)queryVideoUrlByCustomJavaScript;

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString;
- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type;

@end

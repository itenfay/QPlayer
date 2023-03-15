//
//  QPWebController.h
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseWebViewController.h"

@interface QPWebController : QPBaseWebViewController <UITextFieldDelegate>

/// Override
- (void)loadDefaultRequest;

/// Override
- (UITextField *)titleView;

/// Override
- (UIImageView *)webToolBar;

/// Override
- (void)configureWebViewAdapter;

/// Override
- (void)loadWebContents;

/// Override
- (void)adaptTitleViewStyle:(BOOL)isDark;

@end

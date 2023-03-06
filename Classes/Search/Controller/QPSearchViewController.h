//
//  QPSearchViewController.h
//
//  Created by chenxing on 2017/12/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseWebViewController.h"

@interface QPSearchViewController : QPBaseWebViewController <UITextFieldDelegate>

- (void)loadDefaultRequest;
- (UITextField *)titleView;
- (UIImageView *)webToolBar;
- (void)configureWebViewAdapter;
- (void)loadWebContents;
- (void)adaptTitleViewStyle:(BOOL)isDark;

@end

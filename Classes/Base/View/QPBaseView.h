//
//  QPBaseView.h
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QPBaseView : UIView

/// Resizes itself when its superview’s bounds change.
- (void)autoresize;

- (void)setup;
- (void)layoutUI;

@end

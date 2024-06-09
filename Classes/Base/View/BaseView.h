//
//  BaseView.h
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

/// Resizes itself when its superview’s bounds change.
- (void)autoresize;

- (void)setup;
- (void)layoutUI;

@end

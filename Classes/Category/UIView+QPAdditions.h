//
//  UIView+QPAdditions.h
//
//  Created by chenxing on 2016/8/9. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2016 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QPAdditions)

@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGSize  size;

@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

// Removes the all subviews for a view.
- (void)removeAllSubviews;

@end

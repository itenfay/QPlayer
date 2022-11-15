//
//  UIView+QPAdditions.h
//
//  Created by dyf on 2016/8/9. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2016 dyf. All rights reserved.
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

// Returns an image with a specified frame, corner radius,
// background color, border width and border color.
- (UIImage *)colorImage:(CGRect)rect
           cornerRadius:(CGFloat)cornerRadius
         backgroudColor:(UIColor *)backgroudColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor;

// Schedules a block for execution on a given queue at a specified time.
- (void)delayToScheduleTask:(NSTimeInterval)seconds completion:(void (^)(void))completion;

// Return a block with a target object, a selector, an object and a specified time, it schedules a task.
- (void (^)(id target, SEL selector, id object, NSTimeInterval delayInSeconds))scheduleTask;

// Return a block with a target object, a selector and an object, it cancels an execution selector.
- (void (^)(id target, SEL selector, id object))cancelPerformingSelector;

@end

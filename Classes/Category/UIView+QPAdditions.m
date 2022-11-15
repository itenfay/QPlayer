//
//  UIView+QPAdditions.m
//
//  Created by dyf on 2016/8/9. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2016 dyf. All rights reserved.
//

#import "UIView+QPAdditions.h"

@implementation UIView (QPAdditions)

@dynamic top;
@dynamic left;
@dynamic bottom;
@dynamic right;
@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;
@dynamic centerX;
@dynamic centerY;

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)value {
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (UIImage *)colorImage:(CGRect)rect cornerRadius:(CGFloat)cornerRadius backgroudColor:(UIColor *)backgroudColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *newImage  = nil;
    CGRect mRect       = rect;
    CGSize mSize       = mRect.size;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:mRect cornerRadius:cornerRadius];
    
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:mSize];
        
        newImage = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            UIGraphicsImageRendererContext *ctx = rendererContext;
            
            CGContextSetFillColorWithColor  (ctx.CGContext, backgroudColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx.CGContext, borderColor.CGColor);
            CGContextSetLineWidth           (ctx.CGContext, borderWidth);
            
            [path addClip];
            
            CGContextAddPath (ctx.CGContext, path.CGPath);
            CGContextDrawPath(ctx.CGContext, kCGPathFillStroke);
        }];
    } else {
        UIGraphicsBeginImageContext(mSize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor  (context, backgroudColor.CGColor);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth           (context, borderWidth);
        
        [path addClip];
        
        CGContextAddPath (context, path.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

- (void)delayToScheduleTask:(NSTimeInterval)seconds completion:(void (^)(void))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        !completion ?: completion();
    });
}

- (void (^)(id target, SEL selector, id object, NSTimeInterval delayInSeconds))scheduleTask
{
    void (^taskBlock)(id target, SEL selector, id object, NSTimeInterval delayInSeconds) = ^(id target, SEL selector, id object, NSTimeInterval delayInSeconds) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (delayInSeconds > 0) {
            [target performSelector:selector withObject:object afterDelay:delayInSeconds];
        }
        else {
            [target performSelector:selector withObject:object];
        }
#pragma clang diagnostic pop
    };
    return taskBlock;
}

- (void (^)(id target, SEL selector, id object))cancelPerformingSelector
{
    void (^cancelBlock)(id target, SEL selector, id object) = ^(id target,
                                                                SEL selector,
                                                                id object) {
        [NSObject cancelPreviousPerformRequestsWithTarget:target
                                                 selector:selector
                                                   object:object];
    };
    return cancelBlock;
}

@end

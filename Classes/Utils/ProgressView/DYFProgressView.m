//
//  DYFProgressView.m
//
//  Created by chenxing on 17/5/27.
//  Copyright © 2017 chenxing. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFProgressView.h"

@interface DYFProgressView ()
@property (nonatomic, strong) UIView         *progressView;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeOutAnimationDuration;
@end

@implementation DYFProgressView

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGSize w_size = self.window.bounds.size;
    CGRect frame  = CGRectMake(0, 0, w_size.width, w_size.height);
    [self configViewWithFrame:frame color:[UIColor orangeColor]];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame color:[UIColor orangeColor]];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        if (color) {
            [self configViewWithFrame:frame color:color];
        } else {
            [self configViewWithFrame:frame color:[UIColor orangeColor]];
        }
    }
    return self;
}

- (void)configViewWithFrame:(CGRect)frame color:(UIColor *)color
{
    self.userInteractionEnabled = NO;
    self.autoresizingMask       = UIViewAutoresizingFlexibleWidth;
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _progressView.alpha            = 0.0;
    _progressView.backgroundColor  = color;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_progressView];
    
    _animationDuration        = 0.25f;
    _fadeAnimationDuration    = 0.25f;
    _fadeOutAnimationDuration = 0.1f;
    
    self.progress = 0;
}

- (double)progress
{
    return CGRectGetWidth(_progressView.frame)/CGRectGetWidth(self.bounds);
}

- (void)setProgress:(double)progress
{
    [self setProgress:progress animated:NO];
}

- (UIColor *)progressColor
{
    return _progressView.backgroundColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressView.backgroundColor = progressColor;
}

- (void)setTrackColor:(UIColor *)trackColor
{
    self.backgroundColor = trackColor;
}

- (UIColor *)trackColor
{
    return self.backgroundColor;
}

- (void)clearBackgroundColor
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setProgress:(double)progress animated:(BOOL)animated
{
    BOOL change = progress > 0.0;
    [UIView animateWithDuration:(change && animated) ? _animationDuration : 0.0 animations:^{
        CGRect frame            = self.progressView.frame;
        frame.size.width        = progress * self.bounds.size.width;
        self.progressView.frame = frame;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _animationDuration : 0.0 delay:_fadeOutAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self clearBackgroundColor];
            CGRect frame            = self.progressView.frame;
            frame.size.width        = 0.0;
            self.progressView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressView.alpha = 1.0;
        } completion:nil];
    }
}

- (void)dealloc
{
    #if DEBUG
    NSLog(@"%s", __func__);
    #endif
    [_progressView removeFromSuperview];
    [self removeFromSuperview];
}

@end

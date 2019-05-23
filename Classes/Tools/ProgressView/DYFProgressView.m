//
//  DYFProgressView.m
//
//  Created by dyf on 16/5/27.
//  Copyright © 2016∫ dyf. All rights reserved.
//

#import "DYFProgressView.h"

@interface DYFProgressView ()

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeOutAnimationDuration;

@end

@implementation DYFProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
    [self configViewWithFrame:frame color:[UIColor orangeColor]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame color:[UIColor orangeColor]];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
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

- (void)configViewWithFrame:(CGRect)frame color:(UIColor *)color {
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _progressView.alpha = 0.0;
    _progressView.backgroundColor = color;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_progressView];
    
    _animationDuration = 0.25f;
    _fadeAnimationDuration = 0.25f;
    _fadeOutAnimationDuration = 0.1f;
    
    self.progress = 0;
}

- (double)progress {
    return CGRectGetWidth(_progressView.frame)/CGRectGetWidth(self.bounds);
}

- (void)setProgress:(double)progress {
    [self setProgress:progress animated:NO];
}

- (UIColor *)progressColor {
    return _progressView.backgroundColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressView.backgroundColor = progressColor;
}

- (void)setTrackColor:(UIColor *)trackColor {
    self.backgroundColor = trackColor;
}

- (UIColor *)trackColor {
    return self.backgroundColor;
}

- (void)clearBackgroundColor {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setProgress:(double)progress animated:(BOOL)animated {
    BOOL change = progress > 0.0;
    
    [UIView animateWithDuration:(change && animated) ? _animationDuration : 0.0 animations:^{
        
        CGRect frame = _progressView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressView.frame = frame;
        
        if (self.naiVisible) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        
    } completion:^(BOOL finished) {
        
        if (self.naiVisible) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    }];
    
    if (progress >= 1.0) {
        
        [UIView animateWithDuration:animated ? _animationDuration : 0.0 delay:_fadeOutAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _progressView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self clearBackgroundColor];
            
            CGRect frame = _progressView.frame;
            frame.size.width = 0.0;
            _progressView.frame = frame;
            
        }];
        
    } else {
        
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _progressView.alpha = 1.0;
            
        } completion:nil];
        
    }
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    [_progressView removeFromSuperview];
    [self removeFromSuperview];
}

@end

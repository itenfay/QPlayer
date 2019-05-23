//
//  DYFWebProgressView.m
//
//  Created by dyf on 16/5/27.
//  Copyright © 2016 dyf. All rights reserved.
//

#import "DYFWebProgressView.h"

@interface DYFWebProgressView ()
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) CGFloat growthValue;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation DYFWebProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame color:[UIColor orangeColor]];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame color:color];
    if (self) {
        [self configProperties];
    }
    return self;
}

- (void)configProperties {
    self.lineWidth = 2.0;
    
    _growthValue = 0.01;
    _timeInterval = 0.03;
    
    [self scheduleTimer];
}

- (void)scheduleTimer {
    _progressTimer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(progressChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    [self pauseTimer];
}

- (void)pauseTimer {
    if (!_progressTimer.isValid) return;
    [_progressTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    if (!_progressTimer.isValid) return;
    [_progressTimer setFireDate:[NSDate distantPast]];
}

- (void)invalidateTimer {
    if (_progressTimer.isValid) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (void)progressChanged {
    CGFloat progress = self.progress;
    
    if (progress >= 0.9) {
        [self pauseTimer];
        return;
    }
    
    progress += _growthValue;
    [self setProgress:progress animated:YES];
    
    if (progress > 0.8) {
        _growthValue = 0.001;
    }
}

- (void)updateFrame {
    CGRect rect = self.frame;
    rect.size.height = self.lineWidth;
    self.frame = rect;
}

- (void)updateLineColor {
    if (self.lineColor) {
        self.progressColor = self.lineColor;
    }
}

- (void)startLoading {
    [self updateFrame];
    [self updateLineColor];
    [self resumeTimer];
}

- (void)endLoading {
    [self invalidateTimer];
    [self setProgress:1.0 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),^{
                       [self removeFromSuperview];
                   });
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

@end

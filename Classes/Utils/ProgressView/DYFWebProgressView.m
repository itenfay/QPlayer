//
//  DYFWebProgressView.m
//
//  Created by dyf on 17/5/27.
//  Copyright © 2017 dyf. All rights reserved.
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

#import "DYFWebProgressView.h"

@interface DYFWebProgressView ()
@property (nonatomic, strong) NSTimer        *progressTimer;
@property (nonatomic, assign) CGFloat        growthValue;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation DYFWebProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame color:[UIColor orangeColor]];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame color:color];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.lineWidth = 2.0;
    
    _growthValue   = 0.01;
    _timeInterval  = 0.03;
    
    [self scheduleTimer];
}

- (void)scheduleTimer {
    _progressTimer = [NSTimer timerWithTimeInterval:_timeInterval
                                             target:self
                                           selector:@selector(progressChanged)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_progressTimer
                                 forMode:NSRunLoopCommonModes];
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
    
    if (progress >= 0.95) {
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
    CGRect rect      = self.frame;
    rect.size.height = self.lineWidth;
    self.frame       = rect;
}

- (void)updateLineColor {
    if (self.lineColor) {
        self.progressColor = self.lineColor;
    }
}

- (void)startLoading {
    [self updateFrame];
    [self updateLineColor];
    [self updateAlpha:1.f];
    [self resumeTimer];
}

- (void)endLoading {
    [self invalidateTimer];
    [self setProgress:1.f animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                (int64_t)(0.25 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [self updateAlpha:0.f];
        [self setProgress:0.f];
    });
}

- (void)updateAlpha:(CGFloat)alpha {
    self.alpha = alpha;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    [self removeFromSuperview];
}

@end

//
//  ZFPlayerGestureControl.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
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

#import "ZFPlayerGestureControl.h"

@interface ZFPlayerGestureControl ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGR;
@property (nonatomic) ZFPanDirection panDirection;
@property (nonatomic) ZFPanLocation panLocation;
@property (nonatomic) ZFPanMovingDirection panMovingDirection;
@property (nonatomic, weak) UIView *targetView;

@end

@implementation ZFPlayerGestureControl

- (void)addGestureToView:(UIView *)view {
    self.targetView = view;
    self.targetView.multipleTouchEnabled = YES;
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    [self.doubleTap requireGestureRecognizerToFail:self.panGR];
    [self.targetView addGestureRecognizer:self.singleTap];
    [self.targetView addGestureRecognizer:self.doubleTap];
    [self.targetView addGestureRecognizer:self.panGR];
    [self.targetView addGestureRecognizer:self.pinchGR];
}

- (void)removeGestureToView:(UIView *)view {
    [view removeGestureRecognizer:self.singleTap];
    [view removeGestureRecognizer:self.doubleTap];
    [view removeGestureRecognizer:self.panGR];
    [view removeGestureRecognizer:self.pinchGR];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    ZFPlayerGestureType type = ZFPlayerGestureTypeUnknown;
    if (gestureRecognizer == self.singleTap) type = ZFPlayerGestureTypeSingleTap;
    else if (gestureRecognizer == self.doubleTap) type = ZFPlayerGestureTypeDoubleTap;
    else if (gestureRecognizer == self.panGR) type = ZFPlayerGestureTypePan;
    else if (gestureRecognizer == self.pinchGR) type = ZFPlayerGestureTypePinch;
    CGPoint locationPoint = [touch locationInView:touch.view];
    if (locationPoint.x > _targetView.bounds.size.width / 2) {
        self.panLocation = ZFPanLocationRight;
    } else {
        self.panLocation = ZFPanLocationLeft;
    }
    
    ZFPlayerDisableGestureTypes disableTypes = self.disableTypes;
    if (disableTypes & ZFPlayerDisableGestureTypesAll) {
        disableTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch | ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesSingleTap;
    }
    switch (type) {
        case ZFPlayerGestureTypeUnknown: break;
        case ZFPlayerGestureTypePan: {
            if (disableTypes & ZFPlayerDisableGestureTypesPan) {
                return NO;
            }
        }
            break;
        case ZFPlayerGestureTypePinch: {
            if (disableTypes & ZFPlayerDisableGestureTypesPinch) {
                return NO;
            }
        }
            break;
        case ZFPlayerGestureTypeDoubleTap: {
            if (disableTypes & ZFPlayerDisableGestureTypesDoubleTap) {
                return NO;
            }
        }
            break;
        case ZFPlayerGestureTypeSingleTap: {
            if (disableTypes & ZFPlayerDisableGestureTypesSingleTap) {
                return NO;
            }
        }
            break;
    }
    
    if (self.triggerCondition) return self.triggerCondition(self, type, gestureRecognizer, touch);
    return YES;
}

// Whether to support multi-trigger, return YES, you can trigger a method with multiple gestures, return NO is mutually exclusive
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer != self.singleTap &&
        otherGestureRecognizer != self.doubleTap &&
        otherGestureRecognizer != self.panGR &&
        otherGestureRecognizer != self.pinchGR) return NO;
    if (gestureRecognizer.numberOfTouches >= 2) {
        return NO;
    }
    return YES;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.delegate = self;
        _singleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _singleTap.numberOfTouchesRequired = 1;  
        _singleTap.numberOfTapsRequired = 1;
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.delegate = self;
        _doubleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _doubleTap.numberOfTouchesRequired = 1; 
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)panGR {
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGR.delegate = self;
        _panGR.delaysTouchesBegan = YES;
        _panGR.delaysTouchesEnded = YES;
        _panGR.maximumNumberOfTouches = 1;
        _panGR.cancelsTouchesInView = YES;
    }
    return _panGR;
}

- (UIPinchGestureRecognizer *)pinchGR {
    if (!_pinchGR) {
        _pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        _pinchGR.delegate = self;
        _pinchGR.delaysTouchesBegan = YES;
    }
    return _pinchGR;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapped) self.singleTapped(self);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.doubleTapped) self.doubleTapped(self);
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translate = [pan translationInView:pan.view];
    CGPoint velocity = [pan velocityInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.panMovingDirection = ZFPanMovingDirectionUnkown;
            CGFloat x = fabs(velocity.x);
            CGFloat y = fabs(velocity.y);
            if (x > y) {
                self.panDirection = ZFPanDirectionH;
            } else {
                self.panDirection = ZFPanDirectionV;
            }
            
            if (self.beganPan) self.beganPan(self, self.panDirection, self.panLocation);
        }
            break;
        case UIGestureRecognizerStateChanged: {
            switch (_panDirection) {
                case ZFPanDirectionH: {
                    if (translate.x > 0) {
                        self.panMovingDirection = ZFPanMovingDirectionRight;
                    } else if (translate.y < 0) {
                        self.panMovingDirection = ZFPanMovingDirectionLeft;
                    }
                }
                    break;
                case ZFPanDirectionV: {
                    if (translate.y > 0) {
                        self.panMovingDirection = ZFPanMovingDirectionBottom;
                    } else {
                        self.panMovingDirection = ZFPanMovingDirectionTop;
                    }
                }
                    break;
                case ZFPanDirectionUnknown:
                    break;
            }
            if (self.changedPan) self.changedPan(self, self.panDirection, self.panLocation, velocity);
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (self.endedPan) self.endedPan(self, self.panDirection, self.panLocation);
        }
            break;
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateEnded: {
            if (self.pinched) self.pinched(self, pinch.scale);
        }
            break;
        default:
            break;
    }
}

@end

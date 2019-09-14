//
//  DYFProgressView.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DYFProgressView : UIView

/**
 The current progress shown by the receiver.
 */
@property (nonatomic, assign) double progress;

/**
 The color shown for the portion of the progress bar that is filled.
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
 The color shown for the portion of the progress bar that is not filled.
 */
@property (nonatomic, strong) UIColor *trackColor;

/**
 Initializes and returns a newly allocated view object with the specified frame rectangle.
 
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 @return An initialized view object.
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 Initializes and returns a newly allocated view object with the specified frame rectangle and the color shown for the portion of the progress.
 
 @param frame The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
 @param color The color shown for the portion of the progress bar that is filled.
 @return An initialized view object.
 */
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;

/**
 Adjusts the current progress shown by the receiver, optionally animating the change.
 
 @param progress The new progress value.
 @param animated YES if the change should be animated, NO if the change should happen immediately.
 */
- (void)setProgress:(double)progress animated:(BOOL)animated;

@end

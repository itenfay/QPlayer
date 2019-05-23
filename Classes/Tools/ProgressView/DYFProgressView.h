//
//  DYFProgressView.h
//
//  Created by dyf on 16/5/27.
//  Copyright © 2016 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DYFProgressView : UIView

/**
 Showing network spinning gear in status bar. default is NO.
 */
@property (nonatomic, assign) BOOL naiVisible;

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

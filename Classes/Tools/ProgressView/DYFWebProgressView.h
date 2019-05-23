//
//  DYFWebProgressView.h
//
//  Created by dyf on 16/5/27.
//  Copyright © 2016 dyf. All rights reserved.
//

#import "DYFProgressView.h"

@interface DYFWebProgressView : DYFProgressView

/**
 The line width used when stroking the path. Defaults to 2.0.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 The color to fill the path's stroked outline. Defaults to orange color.
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 Starts the loading of the progress.
 */
- (void)startLoading;

/**
 Ends the loading of the progress.
 */
- (void)endLoading;

@end

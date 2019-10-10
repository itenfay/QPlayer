//
//  UILabel+DYFAdd.h
//
//  Created by dyf on 2016/1/10.
//  Copyright © 2016 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DYFAdd)

// Return a fit height with a text, limited width and font.
- (CGFloat)yf_heightWithText:(NSString *)text limitedWidth:(CGFloat)limitedWidth font:(UIFont *)font;

// Return a block with a text, limited width and font, it returns a fit height.
- (CGFloat (^)(NSString *text, CGFloat limitedWidth, UIFont *font))yf_heightToFit;

// Return a fit height with a attributed text, limited width and font.
- (CGFloat)yf_heightWithAttributedText:(NSAttributedString *)attributedText limitedWidth:(CGFloat)limitedWidth font:(UIFont *)font;

// Return a block with a attributed text, limited width and font, it returns a fit height.
- (CGFloat (^)(NSAttributedString *attributedText, CGFloat limitedWidth, UIFont *font))yf_heightToFitA;

@end

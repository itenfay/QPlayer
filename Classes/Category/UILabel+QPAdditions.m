//
//  UILabel+QPAdditions.m
//
//  Created by chenxing on 2016/1/10. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2016 chenxing. All rights reserved.
//

#import "UILabel+QPAdditions.h"

@implementation UILabel (QPAdditions)

- (CGFloat)yf_heightWithText:(NSString *)text limitedWidth:(CGFloat)limitedWidth font:(UIFont *)font
{
    self.text          = text;
    self.font          = font;
    self.numberOfLines = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(limitedWidth, CGFLOAT_MAX)];
    return size.height;
}

- (CGFloat (^)(NSString *, CGFloat, UIFont *))yf_heightToFit
{
    __weak typeof(self) weakSelf = self;
    CGFloat (^block)(NSString *, CGFloat, UIFont *) = ^CGFloat (NSString *text, CGFloat limitedWidth, UIFont *font) {
        weakSelf.text          = text;
        weakSelf.font          = font;
        weakSelf.numberOfLines = 0;
        CGSize size = [weakSelf sizeThatFits:CGSizeMake(limitedWidth, CGFLOAT_MAX)];
        return size.height;
    };
    return block;
}

- (CGFloat)yf_heightWithAttributedText:(NSAttributedString *)attributedText limitedWidth:(CGFloat)limitedWidth font:(UIFont *)font
{
    self.attributedText = attributedText;
    self.font           = font;
    self.numberOfLines  = 0;
    CGSize size = [self sizeThatFits:CGSizeMake(limitedWidth, CGFLOAT_MAX)];
    return size.height;
}

- (CGFloat (^)(NSAttributedString *, CGFloat, UIFont *))yf_heightToFitA
{
    __weak typeof(self) weakSelf = self;
    CGFloat (^block)(NSAttributedString *, CGFloat, UIFont *) = ^CGFloat (NSAttributedString *attributedText, CGFloat limitedWidth, UIFont *font) {
        weakSelf.attributedText = attributedText;
        weakSelf.font           = font;
        weakSelf.numberOfLines  = 0;
        CGSize size = [weakSelf sizeThatFits:CGSizeMake(limitedWidth, CGFLOAT_MAX)];
        return size.height;
    };
    return block;
}

@end

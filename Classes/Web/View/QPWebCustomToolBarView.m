//
//  QPWebCustomToolBarView.m
//  QPlayer
//
//  Created by Tenfay on 2024/10/5.
//  Copyright © 2024 Tenfay. All rights reserved.
//

#import "QPWebCustomToolBarView.h"

@interface QPWebCustomToolBarView ()
@property (nonatomic, strong) UIColor *imageBgColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@end

@implementation QPWebCustomToolBarView

- (instancetype)initWithFrame:(CGRect)frame
                 imageBgColor:(UIColor *)imageBgColor
                 cornerRadius:(CGFloat)cornerRadius
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.imageBgColor = imageBgColor;
        self.cornerRadius = cornerRadius;
        [self buildAndLayoutToolBar:@selector(tbItemClicked:)];
    }
    return self;
}

- (UIImageView *)buildAndLayoutToolBar:(SEL)selector
{
    NSArray *items = @[
        @"web_reward_13x21",
        @"web_forward_13x21",
        @"web_refresh_24x21",
        @"web_stop_21x21"
    ];
    NSUInteger count = items.count;
    CGFloat hSpace   = 10.f;
    CGFloat vSpace   = isVertical ? 5.f : 8.f;
    CGFloat btnW     = 30.f;
    CGFloat btnH     = 30.f;
    CGFloat offset   = bVal ? QPTabBarHeight : (QPIsPhoneXAll ? 4 : 2)*vSpace;
    CGFloat tlbW     = btnW + 2*hSpace;
    CGFloat tlbH     = count*btnH + (count+1)*vSpace + 4*vSpace;
    CGFloat tlbX     = QPScreenWidth - tlbW - hSpace;
    CGFloat tlbY     = self.height - offset - tlbH - 2*vSpace;
    CGRect  tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
    
    if (!isVertical) {
        tlbX = 1.5*hSpace;
        tlbW = self.view.width - 2*tlbX;
        tlbH = btnH + 3*vSpace;
        tlbY = self.view.height - offset - tlbH - (bVal ? 2*vSpace : 0) + 5.f;
        tlbFrame = CGRectMake(tlbX, tlbY, tlbW, tlbH);
        btnW = (tlbW - (count+1)*hSpace)/count;
    }
    
    UIImageView *toolBar    = [[UIImageView alloc] initWithFrame:tlbFrame];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.image           = [self colorImage:toolBar.bounds
                                  cornerRadius:15.f
                                backgroudColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                                   borderWidth:0.f
                                   borderColor:nil];
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isVertical) {
            button.frame = CGRectMake(hSpace, (i+1)*vSpace+i*btnH, btnW, btnH);
        } else {
            button.frame = CGRectMake((i+1)*vSpace+i*btnW, 1.5*vSpace, btnW, btnH);
        }
        button.tag = 100 + i;
        button.showsTouchWhenHighlighted = YES;
        [button setImage:QPImageNamed(items[i]) forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [toolBar addSubview:button];
    }
    toolBar.userInteractionEnabled = YES;
    [toolBar autoresizing];
    
    return toolBar;
}

- (void)tbItemClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag - 100;
}

@end

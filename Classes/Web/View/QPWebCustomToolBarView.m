//
//  QPWebCustomToolBarView.m
//  QPlayer
//
//  Created by Tenfay on 2024/10/5.
//  Copyright © 2024 Tenfay. All rights reserved.
//

#import "QPWebCustomToolBarView.h"

@interface QPWebCustomToolBarView ()
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL needSettings;
@end

@implementation QPWebCustomToolBarView

- (instancetype)initWithFrame:(CGRect)frame
                 cornerRadius:(CGFloat)cornerRadius
                 needSettings:(BOOL)needSettings;
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.cornerRadius = cornerRadius;
        self.needSettings = needSettings;
        [self buildSubviews:@selector(tbItemClicked:)];
    }
    return self;
}

- (NSArray *)items {
    NSMutableArray *itemArray = @[
        @"web_reward_13x21",
        @"web_forward_13x21",
        @"web_refresh_24x21",
        @"web_stop_21x21",
        @"⚙︎"
    ].mutableCopy;
    if (!self.needSettings) {
        [itemArray removeLastObject];
    }
    return itemArray.copy;
}

- (void)buildSubviews:(SEL)selector
{
    NSUInteger count = self.items.count;
    CGFloat space = 10.f;
    CGFloat btnH = 40.f;
    CGFloat btnW = (QPScreenWidth - (count + 1) * space) / count;
    
    UIImageView *imageBgView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageBgView.backgroundColor = [UIColor clearColor];
    imageBgView.tag = 99;
    
    [self addSubview:imageBgView];
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i+1)*space+i*btnW, (CGRectGetHeight(self.bounds) - btnH)/2, btnW, btnH);
        button.tag = 100 + i;
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [imageBgView addSubview:button];
        if (i == self.items.count - 1 && self.needSettings) {
            UILabel *settingLabel = [[UILabel alloc] init];
            settingLabel.width = 24.f;
            settingLabel.height = 24.;
            settingLabel.x = (btnW - settingLabel.width) / 2;
            settingLabel.y = (btnH - settingLabel.height) / 2;
            settingLabel.tag = 1000 + i;
            [button addSubview:settingLabel];
        }
    }
    imageBgView.userInteractionEnabled = YES;
    [imageBgView autoresizing];
    
    [self updateAppearance:NO];
}

- (void)updateAppearance:(BOOL)isDark {
    UIColor *backgroundColor = isDark ? QPColorFromRGB(20, 20, 20) : UIColor.whiteColor;
    UIImageView *imageBgView = [self viewWithTag:99];
    imageBgView.image = [self colorImage:imageBgView.bounds
                            cornerRadius:self.cornerRadius
                          backgroudColor: backgroundColor
                             borderWidth:0.f
                             borderColor:nil];
    UIColor *shadowColor = QPColorFromHex(0x999999);
    imageBgView.layer.shadowColor = shadowColor.CGColor;
    imageBgView.layer.shadowOffset = CGSizeMake(0, -2);
    imageBgView.layer.shadowOpacity = .3f;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIColor *itemColor = isDark ? UIColor.whiteColor : QPColorFromRGB(20, 20, 20);
        UIButton *button = [imageBgView viewWithTag:100 + i];
        if (i == self.items.count - 1 && self.needSettings) {
            UILabel *settingLabel = [button viewWithTag: 1000 + i];
            settingLabel.text = self.items[i];
            settingLabel.textColor = itemColor;
            settingLabel.textAlignment = NSTextAlignmentCenter;
            settingLabel.font = [UIFont systemFontOfSize:14.f];
            settingLabel.layer.cornerRadius = 12.f;
            settingLabel.layer.borderWidth = 1.f;
            settingLabel.layer.borderColor = itemColor.CGColor;
        } else {
            UIImage *image = [QPImageNamed(self.items[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setImage:image forState:UIControlStateNormal];
            button.tintColor = itemColor;
        }
    }
}

- (void)tbItemClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag - 100;
    !self.onItemClick ?: self.onItemClick(index);
}

@end

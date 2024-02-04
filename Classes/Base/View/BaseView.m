//
//  BaseView.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutUI];
}

- (void)autoresize
{
    [self autoresizing];
}

- (void)setup
{
    
}

- (void)layoutUI
{
    
}

@end

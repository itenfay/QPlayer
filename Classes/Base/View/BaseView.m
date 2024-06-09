//
//  BaseView.m
//
//  Created by Tenfay on 2017/6/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self layoutUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
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

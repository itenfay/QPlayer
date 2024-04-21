//
//  BaseCollectionViewCell.m
//  QPlayer
//
//  Created by chenxing on 2023/2/21.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

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

- (void)setup
{
    
}

- (void)layoutUI
{
    
}

@end

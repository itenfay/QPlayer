//
//  DYFDropListViewCell.m
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "DYFDropListViewCell.h"

@implementation DYFDropListViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

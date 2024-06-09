//
//  BaseListViewCell.m
//
//  Created by Tenfay on 2017/8/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseListViewCell.h"

@implementation BaseListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup
{
    
}

- (void)layoutUI
{
    
}

@end

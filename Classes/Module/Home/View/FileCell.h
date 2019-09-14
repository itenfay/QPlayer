//
//  FileCell.h
//
//  Created by dyf on 2017/8/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "BaseCell.h"

#define FileCellHeight    90.f

@interface FileCell : BaseCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizelabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

//
//  FileTableViewCell.h
//
//  Created by dyf on 2017/8/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "BaseTableViewCell.h"

#define FileTableViewCellHeight 100.f

@interface FileTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infolabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *formatImgView;

@property (weak, nonatomic) IBOutlet UIView *divider;

@end

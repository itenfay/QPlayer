//
//  QPFileTableViewCell.h
//
//  Created by dyf on 2017/8/28. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import "QPBaseListViewCell.h"

#define FileTableViewCellHeight 100.f

@interface QPFileTableViewCell : QPBaseListViewCell

/// Display thumbnail image.
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImgView;

/// Display the title.
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// Display the information of the file.
@property (weak, nonatomic) IBOutlet UILabel *infolabel;

/// Display the uploaded date of the file.
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/// Display the extended image.
@property (weak, nonatomic) IBOutlet UIImageView *formatImgView;

/// Display the divider.
@property (weak, nonatomic) IBOutlet UIView *divider;

@end

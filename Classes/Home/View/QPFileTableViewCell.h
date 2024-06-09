//
//  QPFileTableViewCell.h
//
//  Created by Tenfay on 2017/8/28. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseListViewCell.h"
#import "QPFileModelPresenter.h"

@interface QPFileTableViewCell : BaseListViewCell
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

@property (strong, nonatomic) QPFileModelPresenter *presenter;

@end

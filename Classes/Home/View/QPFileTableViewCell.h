//
//  QPFileTableViewCell.h
//
//  Created by chenxing on 2017/8/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseListViewCell.h"
#import "QPFileModelPresenter.h"

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

@property (strong, nonatomic) QPFileModelPresenter *presenter;

@end

//
//  QPDropListViewCell.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseListViewCell.h"

@interface QPDropListViewCell : QPBaseListViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;

@end

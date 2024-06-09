//
//  QPDropListViewCell.h
//
//  Created by Tenfay on 2017/6/28.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "BaseListViewCell.h"

@interface QPDropListViewCell : BaseListViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;
@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;

@end

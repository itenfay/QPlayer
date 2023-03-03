//
//  DYFDropListViewCell.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DropListViewCellHeight 50.f

@interface DYFDropListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_titleLabel;

@property (weak, nonatomic) IBOutlet UIView *verticalLine;

@property (weak, nonatomic) IBOutlet UILabel *m_detailLabel;

@property (weak, nonatomic) IBOutlet UIView *horizontalLine;

@end

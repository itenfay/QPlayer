//
//  AboutMeTableHeader.h
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "BaseView.h"

@interface AboutMeTableHeader : BaseView

// UI Widget.
@property (weak, nonatomic) IBOutlet UIImageView *logoBgImgView;
@property (weak, nonatomic) IBOutlet UILabel *briefIntroLabel;

// Layout Constraint.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBgImgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoBgImgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *briefIntroLabelHeight;

@end

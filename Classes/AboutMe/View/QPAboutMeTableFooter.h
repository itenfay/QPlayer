//
//  QPAboutMeTableFooter.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPBaseView.h"

typedef NS_ENUM(NSUInteger, AMFooterActionType)
{
    AMFooterActionTypeJianShu = 1,
    AMFooterActionTypeBlog    = 2
};

typedef void (^AMFooterActionHandler)(AMFooterActionType type);

@interface QPAboutMeTableFooter : QPBaseView
@property (weak, nonatomic) IBOutlet UIButton *jshuButton;
@property (weak, nonatomic) IBOutlet UIButton *blogButton;
@property (weak, nonatomic) IBOutlet UILabel  *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel  *copyrightLabel;

- (void)onAct:(AMFooterActionHandler)handler;

@end

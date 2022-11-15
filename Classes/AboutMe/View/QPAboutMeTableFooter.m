//
//  AboutMeTableFooter.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "AboutMeTableFooter.h"

@interface AboutMeTableFooter ()
@property (nonatomic, copy) AMFooterActionHandler aHandler;
@end

@implementation AboutMeTableFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    QPLog(@" >>>>>>>>>> ");
    self.backgroundColor = UIColor.clearColor;
}

- (void)onAct:(AMFooterActionHandler)handler {
    self.aHandler = handler;
}

- (IBAction)gotoJianShu:(id)sender {
    QPLog(@" >>>>>>>>>> ");
    AMFooterActionType type = AMFooterActionTypeJianShu;
    !self.aHandler ?: self.aHandler(type);
}

- (IBAction)gotoMyBlog:(id)sender {
    QPLog(@" >>>>>>>>>> ");
    AMFooterActionType type = AMFooterActionTypeBlog;
    !self.aHandler ?: self.aHandler(type);
}

@end

//
//  QPAboutMeTableFooter.m
//
//  Created by Tenfay on 2017/6/28.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPAboutMeTableFooter.h"

@interface QPAboutMeTableFooter ()
@property (nonatomic, copy) AMFooterActionHandler aHandler;
@end

@implementation QPAboutMeTableFooter

- (void)setup
{
    [super setup];
    self.backgroundColor = UIColor.clearColor;
}

- (void)onAct:(AMFooterActionHandler)handler {
    self.aHandler = handler;
}

- (IBAction)gotoJianShu:(id)sender {
    AMFooterActionType type = AMFooterActionTypeJianShu;
    !self.aHandler ?: self.aHandler(type);
}

- (IBAction)gotoMyBlog:(id)sender {
    AMFooterActionType type = AMFooterActionTypeBlog;
    !self.aHandler ?: self.aHandler(type);
}

@end

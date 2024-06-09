//
//  QPFileModelPresenter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/1.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPFileModelPresenter.h"

@implementation QPFileModelPresenter

- (instancetype)initWithView:(NSObject<QPFileModelDelegate> *)view
{
    if (self = [super init]) {
        self.view = view;
    }
    return self;
}

- (void)presentWithModel:(QPFileModel *)model viewController:(BaseViewController *)viewController
{
    self.model = model;
    self.viewController = viewController;
    [self present];
}

- (void)present
{
    BOOL isDarkMode = _viewController.isDarkMode;
    [_view setCellBackgroundColor: isDarkMode ? QPColorFromRGB(30, 30, 30) : [UIColor whiteColor]];
    [_view setThumbnail:_model.path];
    [_view setFormatImage:_model.fileType];
    [_view setTitleText:_model.title];
    [_view setTitleTextColor:isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(30, 30, 30)];
    [_view setDateText:_model.creationDate];
    [_view setDateTextColor:isDarkMode ? QPColorFromRGB(180, 180, 180) : UIColor.grayColor];
    [_view setText:_model.path fileSize:_model.fileSize];
    [_view setTextColor:isDarkMode ? QPColorFromRGB(180, 180, 180) : UIColor.grayColor];
    [_view setDividerColor:isDarkMode ? QPColorFromRGB(40, 40, 40) : QPColorFromRGB(230, 230, 230)];
}

@end

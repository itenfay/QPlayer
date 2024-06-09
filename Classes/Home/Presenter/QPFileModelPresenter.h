//
//  QPFileModelPresenter.h
//  QPlayer
//
//  Created by Tenfay on 2023/3/1.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPModularDelegate.h"
#import "QPFileModel.h"

@protocol QPFileModelDelegate <NSObject>

- (void)setCellBackgroundColor:(UIColor *)color;
- (void)setThumbnail:(NSString *)filePath;
- (void)setFormatImage:(NSString *)fileType;
- (void)setTitleText:(NSString *)title;
- (void)setTitleTextColor:(UIColor *)color;
- (void)setDateText:(NSString *)text;
- (void)setDateTextColor:(UIColor *)color;
- (void)setText:(NSString *)filePath fileSize:(double)fileSize;
- (void)setTextColor:(UIColor *)color;
- (void)setDividerColor:(UIColor *)color;

@end

@interface QPFileModelPresenter : NSObject <QPPresenterDelegate>
@property (nonatomic, weak) NSObject<QPFileModelDelegate> *view;
@property (nonatomic, weak) BaseViewController *viewController;
@property (nonatomic, strong) QPFileModel *model;

- (instancetype)initWithView:(NSObject<QPFileModelDelegate> *)view;

- (void)presentWithModel:(QPFileModel *)model viewController:(BaseViewController *)viewController;
- (void)present;

@end

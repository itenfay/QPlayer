//
//  QPFileModelPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/1.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPModularDelegate.h"
#import "QPFileModel.h"

NS_ASSUME_NONNULL_BEGIN

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
@property (nonatomic, weak) QPBaseViewController *viewController;
@property (nonatomic, strong) QPFileModel *model;

- (instancetype)initWithView:(NSObject<QPFileModelDelegate> *)view;

- (void)presentWithModel:(QPFileModel *)model viewController:(QPBaseViewController *)viewController;
- (void)present;

@end

NS_ASSUME_NONNULL_END

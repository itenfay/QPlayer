//
//  QPWebCustomToolBarView.h
//  QPlayer
//
//  Created by Tenfay on 2024/10/5.
//  Copyright © 2024 Tenfay. All rights reserved.
//

#import "BaseView.h"

@interface QPWebCustomToolBarView : BaseView
@property (nonatomic, copy) void (^onItemClick)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame
                 cornerRadius:(CGFloat)cornerRadius
                 needSettings:(BOOL)needSettings;

- (void)updateAppearance:(BOOL)isDark;

@end

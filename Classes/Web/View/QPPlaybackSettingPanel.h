//
//  QPPlaybackSettingPanel.h
//  QPlayer
//
//  Created by Tenfay on 2024/4/21.
//  Copyright © 2024 Tenfay. All rights reserved.
//

#import "BaseView.h"

@interface QPPlaybackSettingPanel : BaseView
@property (nonatomic, copy) void (^onHideBlock)(BOOL animated);

- (void)showPanel;
- (void)hidePanel:(BOOL)animated;

@end

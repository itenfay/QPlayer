//
//  DYFDropListView.h
//
//  Created by dyf on 2017/6/28. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYFDropListViewCell.h"

// A bundle name for the resource.
FOUNDATION_EXPORT NSString *const kResourceBundle;

// A file name for the dropping list.
FOUNDATION_EXPORT NSString *const kDropListDataFile;

// When a closed action is performed, it's called.
typedef void (^DropListViewOnCloseHandler)(void);

// When a cell row has been selected, it's called.
typedef void (^DropListViewOnSelectRowHandler)(NSInteger selectedRow,
                                               NSString *title,
                                               NSString *content);

@interface DYFDropListView : UIView

// It provides a simple abstraction over complex visual effects.
@property (weak, nonatomic) IBOutlet UIVisualEffectView *m_visualEffectView;

// A view that presents data using rows arranged in a single column.
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

// A control that executes your custom code in response to user interactions.
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// Carries out a action for closing with a `DLVOnCloseHandler` handler.
- (void)onCloseAction:(DropListViewOnCloseHandler)completionHandler;

// Carries out a action for selecting row with a `DLVOnSelectRowHandler` handler.
- (void)onSelectRow:(DropListViewOnSelectRowHandler)completionHandler;

@end

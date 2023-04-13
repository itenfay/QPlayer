//
//  QPDropListViewPresenter.h
//  QPlayer
//
//  Created by chenxing on 2023/3/2.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPDropListViewAdapter.h"
#import "QPDropListModel.h"

NS_ASSUME_NONNULL_BEGIN

// When a closed action is performed, it's called.
typedef void (^DropListViewOnCloseHandler)(void);

// When a cell row has been selected, it's called.
typedef void (^DropListViewOnSelectRowHandler)(NSInteger selectedRow,
                                               NSString *title,
                                               NSString *content);

// A bundle name for the resource.
FOUNDATION_EXPORT NSString *const kResourceBundle;

// A file name for the dropping list.
FOUNDATION_EXPORT NSString *const kDropListDataFile;

@interface QPDropListViewPresenter : QPBasePresenter <QPPresenterDelegate, QPListViewAdapterDelegate>
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) DropListViewOnCloseHandler onCloseHandler;
@property (nonatomic, copy) DropListViewOnSelectRowHandler onSelectRowHandler;

- (NSString *)customBundlePath;
- (NSString *)customTVFilePath;

- (void)loadData;

- (void)updateValue:(NSString *)value atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

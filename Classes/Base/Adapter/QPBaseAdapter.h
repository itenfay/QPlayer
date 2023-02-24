//
//  QPBaseAdapter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QPListViewAdapterDelegate <NSObject>

@optional
- (void)selectCellData:(id)cellData;
- (void)deleteCellData:(id)cellData;
- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol QPScrollViewAdapterDelegate <NSObject>

@optional
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

@end

@interface QPBaseAdapter : NSObject

@property (nonatomic, weak) id<QPScrollViewAdapterDelegate> scrollViewAdapterDelegate;
@property (nonatomic, weak) id<QPListViewAdapterDelegate> listViewAdapterDelegate;

@end

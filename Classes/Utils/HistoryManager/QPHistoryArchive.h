//
//  QPHistoryArchive.h
//
//  Created by Tenfay on 2017/9/1.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPHistoryArchive : NSObject

// 保存数组与归档
- (void)saveArray:(NSArray *)array;

// 解档得到数组
- (NSArray *)loadArchives;

@end

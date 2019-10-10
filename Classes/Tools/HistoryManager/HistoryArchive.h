//
//  HistoryArchive.h
//
//  Created by dyf on 2017/9/1.
//  Copyright © 2017 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryArchive : NSObject

// 保存数组与归档
- (void)saveArray:(NSArray *)array;

// 解档得到数组
- (NSArray *)loadArchives;

@end

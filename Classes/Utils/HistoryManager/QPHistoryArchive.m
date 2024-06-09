//
//  QPHistoryArchive.m
//
//  Created by Tenfay on 2017/9/1.
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPHistoryArchive.h"

static NSString *const kHistoryArchiveKey = @"QPlayerHistoryArchive";

@implementation QPHistoryArchive

- (NSString *)cacheDir
{
    return QPAppendingPathComponent(QPCachesDirectoryPath, @"QPlayerHistoryCache");
}

- (void)saveArray:(NSArray *)array
{
    // 归档
    NSMutableData *data = [[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:kHistoryArchiveKey]; // archivingData的encodeWithCoder
    [archiver finishEncoding];
    
    // 写入文件
    [data writeToFile:[self cacheDir] atomically:YES];
}

- (NSArray *)loadArchives
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self cacheDir]];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    // 获得数组
    NSArray *archivingData = [unarchiver decodeObjectForKey:kHistoryArchiveKey]; // initWithCoder 方法被调用
    [unarchiver finishDecoding];
    
    return archivingData;
}

@end

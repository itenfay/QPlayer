//
//  QPFileHelper.m
//
//  Created by chenxing on 2017/8/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPFileHelper.h"

static inline NSString *QPFCacheDirpath()
{
    NSString *cachePath = QPAppendingPathComponent(QPCachesDirectoryPath, @"qp-filecache");
    QPLog(@":: cachePath=%@", cachePath);
    
    if (![QPFileMgr fileExistsAtPath:cachePath]) {
        NSError *error = nil;
        [QPFileMgr createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            QPLog(@":: [createDirectoryAtPath] error=%zi, %@", error.code, error.localizedDescription);
            return nil;
        }
    }
    return cachePath;
}

@implementation QPFileHelper

+ (NSString *)cachePath
{
    return QPFCacheDirpath();
}

+ (NSArray *)localVideoFiles
{
    NSString *path = QPFCacheDirpath();
    NSArray *contents = [QPFileMgr contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *filesArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *item in contents) {
        QPFileModel *fm = [[QPFileModel alloc] init];
        fm.name = fm.sortName = item;
        fm.path = QPAppendingPathComponent(path, item);
        
        NSDictionary *fileAttrs = [QPFileMgr attributesOfItemAtPath:fm.path error:nil];
        fm.fileSize = [[fileAttrs objectForKey:@"NSFileSize"] doubleValue]/1000000;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"]; // yyyy-MM-dd HH:mm:ss
        fm.modificationDate = [formatter stringFromDate:[fileAttrs objectForKey:@"NSFileModificationDate"]];
        fm.creationDate = [formatter stringFromDate:[fileAttrs objectForKey:@"NSFileCreationDate"]];
        
        NSArray *components = [item componentsSeparatedByString:@"."];
        if (components.count > 0) {
            fm.fileType = [components lastObject];
        }
        fm.title = fm.name;
        [filesArray addObject:fm];
    }
    
    return [filesArray copy];
}

+ (NSArray *)localFiles
{
    NSString *path    = QPFCacheDirpath();
    NSArray *contents = [QPFileMgr contentsOfDirectoryAtPath:path error:nil];
    return contents;
}

+ (BOOL)removeLocalFile:(NSString *)filename
{
    NSString *path     = QPFCacheDirpath();
    NSString *filePath = QPAppendingPathComponent(path, filename);
    
    BOOL ret = [QPFileMgr removeItemAtPath:filePath error:nil];
    BOOL exists = [QPFileMgr fileExistsAtPath:filePath];
    QPLog(@"%@ exists: %@", filename, exists ? @"YES" : @"NO");
    return ret;
}

@end

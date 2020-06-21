//
//  FileHelper.m
//
//  Created by dyf on 2017/8/28. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import "FileHelper.h"

static inline NSString *FHCacheDirpath() {
    NSString *cachePath = QPAppendingPathComponent(QPCachesDirectoryPath, @"QPlayerCacheFiles");
    
    if (![QPFileMgr fileExistsAtPath:cachePath]) {
        NSError *error = nil;
        
        [QPFileMgr createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            QPLog(@" >>>>>>>>>> [createDirectoryAtPath] error: %@", error);
            return nil;
        }
    }
    QPLog(@" >>>>>>>>>> cachePath: %@", cachePath);
    
    return cachePath;
}

@implementation FileHelper

+ (NSString *)getCachePath {
    return FHCacheDirpath();
}

+ (NSArray *)getLocalVideoFiles {
    NSString *path    = FHCacheDirpath();
    NSArray *contents = [QPFileMgr contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *filesArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *item in contents) {
        FileModel *fileModel = [[FileModel alloc] init];
        fileModel.path = QPAppendingPathComponent(path, item);
        
        NSDictionary *fileAttrs = [QPFileMgr attributesOfItemAtPath:fileModel.path error:nil];
        fileModel.fileSize = [[fileAttrs objectForKey:@"NSFileSize"] doubleValue]/1000000;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"]; // yyyy-MM-dd HH:mm:ss
        fileModel.modificationDate = [formatter stringFromDate:[fileAttrs objectForKey:@"NSFileModificationDate"]];
        fileModel.creationDate     = [formatter stringFromDate:[fileAttrs objectForKey:@"NSFileCreationDate"]];
        
        fileModel.name = item;
        
        NSArray *components = [item componentsSeparatedByString:@"."];
        if (components.count > 0) {
            fileModel.fileType = [components lastObject];
        }
        
        fileModel.title = fileModel.name;
        
        [filesArray addObject:fileModel];
    }
    
    return [filesArray copy];
}

+ (NSArray *)getLocalFiles {
    NSString *path    = FHCacheDirpath();
    NSArray *contents = [QPFileMgr contentsOfDirectoryAtPath:path error:nil];
    return contents;
}

+ (BOOL)removeLocalFile:(NSString *)filename {
    NSString *path     = FHCacheDirpath();
    NSString *filePath = QPAppendingPathComponent(path, filename);
    
    BOOL ret   = [QPFileMgr removeItemAtPath:filePath error:nil];
    BOOL exist = [QPFileMgr fileExistsAtPath:filePath];
    QPLog(@"%@ exists: %@", filename, exist ? @"YES" : @"NO");
    
    return ret;
}

@end

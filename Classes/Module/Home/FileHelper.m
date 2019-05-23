//
//  FileHelper.m
//
//  Created by dyf on 2017/8/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "FileHelper.h"

static NSString *FHCacheDirpath() {
    NSString *path = QPAppendingPathComponent(QPCachesDirectoryPath, @"QPFiles");
    
    if (![QPFileMgr fileExistsAtPath:path]) {
        NSError *error = nil;
        
        BOOL shouldCreate = [QPFileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (!shouldCreate) {
            QPLog(@"%s: %ld, %@", __func__, (long)error.code, error.localizedDescription)
            return nil;
        }
    }
    
    return path;
}

@implementation FileHelper

+ (NSString *)getCachePath {
    return FHCacheDirpath();
}

+ (NSArray *)getLocalVideoFiles {
    NSString *path = FHCacheDirpath();
    NSArray *contents = [QPFileMgr contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *item in contents) {
        FileModel *fileModel = [[FileModel alloc] init];
        fileModel.path = QPAppendingPathComponent(path, item);
        
        NSDictionary *fileAttrs = [QPFileMgr attributesOfItemAtPath:fileModel.path error:nil];
        
        fileModel.fileSize = [[fileAttrs objectForKey:@"NSFileSize"] doubleValue]/1000000;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        fileModel.modificationDate = [formatter stringFromDate:[fileAttrs objectForKey:@"NSFileModificationDate"]];
        fileModel.creationDate = [formatter stringFromDate:[fileAttrs objectForKey:@"NSFileCreationDate"]];
        
        fileModel.name = item;
        NSArray *range = [item componentsSeparatedByString:@"."];
        if (range.count > 0) {
            fileModel.fileType = [range lastObject];
        }
        
        fileModel.title = fileModel.name;
        
        [mArr addObject:fileModel];
    }
    
    return mArr;
}

+ (NSArray *)getLocalFiles {
    NSString *path = FHCacheDirpath();
    NSArray *contents = [QPFileMgr contentsOfDirectoryAtPath:path error:nil];
    return contents;
}

+ (BOOL)removeLocalFile:(NSString *)filename {
    NSString *path = FHCacheDirpath();
    NSString *filePath = QPAppendingPathComponent(path, filename);
    
    BOOL re = [QPFileMgr removeItemAtPath:filePath error:nil];
    
    BOOL exist = [QPFileMgr fileExistsAtPath:filePath];
    QPLog(@"%@ exists: %@", filename, exist ? @"YEW" : @"NO");
    
    return re;
}

@end

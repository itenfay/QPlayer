//
//  FileHelper.h
//
//  Created by dyf on 2017/8/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@interface FileHelper : NSObject

// Returns a path for caching the files.
+ (NSString *)getCachePath;

// Returns a array with the local video files.
+ (NSArray *)getLocalVideoFiles;

// Returns a array for the local files.
+ (NSArray *)getLocalFiles;

// Removes a local file with the file name.
+ (BOOL)removeLocalFile:(NSString *)filename;

@end

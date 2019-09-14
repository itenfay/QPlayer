//
//  FileHelper.h
//
//  Created by dyf on 2017/8/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileModel.h"

@interface FileHelper : NSObject

+ (NSString *)getCachePath;
+ (NSArray *)getLocalVideoFiles;
+ (NSArray *)getLocalFiles;

+ (BOOL)removeLocalFile:(NSString *)localFile;

@end

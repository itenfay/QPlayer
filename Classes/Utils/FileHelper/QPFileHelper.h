//
//  QPFileHelper.h
//
//  Created by chenxing on 2017/8/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPFileModel.h"

@interface QPFileHelper : NSObject

// Returns a path for caching the files.
+ (NSString *)cachePath;

// Returns a array with the local video files.
+ (NSArray *)localVideoFiles;

// Returns a array for the local files.
+ (NSArray *)localFiles;

// Removes a local file with the file name.
+ (BOOL)removeLocalFile:(NSString *)filename;

@end

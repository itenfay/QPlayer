//
//  QPHomePresenter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPHomePresenter.h"

@interface QPHomePresenter ()

@property (nonatomic, strong) NSMutableArray *localFileList;
@property (nonatomic, strong) NSMutableArray *fileList;

@end

@implementation QPHomePresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupFileResourceDelegate];
        [self initArr];
        [self loadFileList];
    }
    return self;
}

- (void)setupFileResourceDelegate {
    [QPWifiManager shared].httpServer.fileResourceDelegate = self;
}

- (void)initArr {
    [self loadLocalFileList];
}

// load local file list.
- (void)loadLocalFileList {
    // remove all objects.
    [self.localFileList removeAllObjects];
    
    NSArray *files = [QPFileHelper localVideoFiles];
    [self.localFileList addObjectsFromArray:files];
    
    // sort objects.
    [self.localFileList sortUsingFunction:yf_sortObjects context:NULL];
}

// load file list.
- (void)loadFileList {
    [self.fileList removeAllObjects];
    
    NSString *path = [QPFileHelper cachePath];
    NSDirectoryEnumerator *dirEnum = [QPFileMgr enumeratorAtPath:path];
    
    NSString *name = nil;
    while (name = [dirEnum nextObject]) {
        [self.fileList addObject:name];
    }
}


#pragma mark - WebFileResourceDelegate

// number of the files.
- (NSInteger)numberOfFiles {
    return [self.fileList count];
}

// the file name by the index.
- (NSString *)fileNameAtIndex:(NSInteger)index {
    return [self.fileList objectAtIndex:index];
}

// provide full file path by given file name.
- (NSString *)filePathForFileName:(NSString *)filename {
    return QPAppendingPathComponent([QPFileHelper cachePath], filename);
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString *)name inTempPath:(NSString *)tmpPath {
    if (name == nil || tmpPath == nil) return;
    
    NSString *path = QPAppendingPathComponent([QPFileHelper cachePath], name);
    NSError *error = nil;
    
    if (![QPFileMgr moveItemAtPath:tmpPath toPath:path error:&error]) {
        QPLog(@"can not move %@ to %@ because: %@", tmpPath, path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadUI)]) {
        [self.delegate reloadUI];
    }
}

// implement this method to delete requested file and update the file list.
- (void)fileShouldDelete:(NSString *)fileName {
    NSString *path = [self filePathForFileName:fileName];
    NSError *error = nil;
    
    if(![QPFileMgr removeItemAtPath:path error:&error]) {
        QPLog(@"%@ can not be removed because: %@", path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadUI)]) {
        [self.delegate reloadUI];
    }
}

#pragma mark - lazy load

- (NSMutableArray *)localFileList {
    if (!_localFileList) {
        _localFileList = [NSMutableArray arrayWithCapacity:0];
    }
    return _localFileList;
}

- (NSMutableArray *)fileList {
    if (!_fileList) {
        _fileList = [NSMutableArray arrayWithCapacity:0];
    }
    return _fileList;
}

#pragma mark - dealloc

- (void)dealloc {
    [QPWifiManager shared].httpServer.fileResourceDelegate = nil;
}

@end

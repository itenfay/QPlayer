//
//  QPHomePresenter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPHomePresenter.h"
#import "QPHomeViewController.h"
#import "QPHomeListViewAdapter.h"
#import "QPFileTableViewCell.h"

@interface QPHomePresenter () <QPListViewAdapterDelegate>
@property (nonatomic, strong) NSMutableArray *localFileList;
@property (nonatomic, strong) NSMutableArray *fileList;
@end

@implementation QPHomePresenter

- (instancetype)init
{
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithViewController:(QPBaseViewController *)viewController
{
    self = [super init];
    if (self) {
        [self setViewController:viewController];
        [self configure];
    }
    return self;
}

- (void)setupFileResourceDelegate
{
    [QPWifiManager shared].httpServer.fileResourceDelegate = self;
}

- (void)initArray
{
    [self loadLocalFileList];
    [self loadFileList];
}

/// Load local file list.
- (void)loadLocalFileList
{
    // remove all objects.
    [self.localFileList removeAllObjects];
    
    NSArray *files = [QPFileHelper localVideoFiles];
    [self.localFileList addObjectsFromArray:files];
    
    // sort objects.
    [self.localFileList sortUsingFunction:qp_sortObjects context:NULL];
}

/// Load file list.
- (void)loadFileList
{
    [self.fileList removeAllObjects];
    
    NSString *path = [QPFileHelper cachePath];
    NSDirectoryEnumerator *dirEnum = [QPFileMgr enumeratorAtPath:path];
    
    NSString *name = nil;
    while (name = [dirEnum nextObject]) {
        [self.fileList addObject:name];
    }
}

#pragma mark - loadData

- (QPHomeViewController *)homeViewController
{
    return (QPHomeViewController *)_viewController;
}

- (void)configure
{
    [self setupFileResourceDelegate];
    [self initArray];
    if (_viewController) {
        [self homeViewController].homeView.adapter.listViewDelegate = self;
    }
}

- (void)loadData
{
    [self loadFileList];
    QPHomeViewController *vc = [self homeViewController];
    [vc.homeView.adapter.dataSource removeAllObjects];
    [vc.homeView.adapter.dataSource addObjectsFromArray:_localFileList];
    [vc.homeView reloadUI];
}

#pragma mark - WebFileResourceDelegate

// number of the files.
- (NSInteger)numberOfFiles
{
    return [self.fileList count];
}

// the file name by the index.
- (NSString *)fileNameAtIndex:(NSInteger)index
{
    return [self.fileList objectAtIndex:index];
}

// provide full file path by given file name.
- (NSString *)filePathForFileName:(NSString *)filename
{
    return QPAppendingPathComponent([QPFileHelper cachePath], filename);
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString *)name inTempPath:(NSString *)tmpPath
{
    if (name == nil || tmpPath == nil) return;
    
    NSString *path = QPAppendingPathComponent([QPFileHelper cachePath], name);
    NSError *error = nil;
    
    if (![QPFileMgr moveItemAtPath:tmpPath toPath:path error:&error]) {
        QPLog(@"can not move %@ to %@ because: %@", tmpPath, path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    
    QPHomeViewController *vc = [self homeViewController];
    [vc.homeView reloadUI];
}

// implement this method to delete requested file and update the file list.
- (void)fileShouldDelete:(NSString *)fileName
{
    NSString *path = [self filePathForFileName:fileName];
    NSError *error = nil;
    
    if(![QPFileMgr removeItemAtPath:path error:&error]) {
        QPLog(@"%@ can not be removed because: %@", path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    
    QPHomeViewController *vc = [self homeViewController];
    [vc.homeView reloadUI];
}

#pragma mark - QPListViewAdapterDelegate

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    return 100.f;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    static NSString *cellID = @"QPFileDetailsCellIdentifier";
    QPHomeViewController *vc = [self homeViewController];
    QPFileTableViewCell *cell = [vc.homeView.mTableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([QPFileTableViewCell class]) owner:nil options:nil] firstObject];
    }
    cell.backgroundColor = vc.isDarkMode ? QPColorFromRGB(30, 30, 30) : [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QPFileModel *fileModel = self.localFileList[indexPath.row];
    //[self setThumbnailForCell:cell model:fileModel];
    
    [cell.titleLabel setText:fileModel.title];
    [cell.titleLabel setTextColor:vc.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(30, 30, 30)];
    [cell.titleLabel setNumberOfLines:2];
    [cell.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    
    // [self setInfoForCell:cell model:fileModel];
    
    [cell.dateLabel setText:fileModel.creationDate];
    [cell.dateLabel setTextColor:vc.isDarkMode ? QPColorFromRGB(180, 180, 180) : UIColor.grayColor];
    
    //[self setFormatImageForCell:cell model:fileModel];
    
    [cell.divider setBackgroundColor:vc.isDarkMode ? QPColorFromRGB(40, 40, 40) : QPColorFromRGB(230, 230, 230)];
    
    return cell;
}

- (void)selectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - lazy load

- (NSMutableArray *)localFileList
{
    if (!_localFileList) {
        _localFileList = [NSMutableArray arrayWithCapacity:0];
    }
    return _localFileList;
}

- (NSMutableArray *)fileList
{
    if (!_fileList) {
        _fileList = [NSMutableArray arrayWithCapacity:0];
    }
    return _fileList;
}

#pragma mark - dealloc

- (void)dealloc
{
    [QPWifiManager shared].httpServer.fileResourceDelegate = nil;
}

@end

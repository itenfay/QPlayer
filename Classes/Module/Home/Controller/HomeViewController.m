//
//  HomeViewController.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "HomeViewController.h"
#import "WifiManager.h"
#import "FileHelper.h"
#import "FileTableViewCell.h"
#import "FileModel.h"
#import "QPlayerController.h"
#import "LiveViewController.h"

// Transforms two objects's title to pinying and sorts them.
NSInteger yf_sortObjects(FileModel *obj1, FileModel *obj2, void *context) {
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:obj1.name];
    if (CFStringTransform((__bridge CFMutableStringRef)str1, 0, kCFStringTransformMandarinLatin, NO)) {
    }
    
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:obj2.name];
    if (CFStringTransform((__bridge CFMutableStringRef)str2, 0,     kCFStringTransformMandarinLatin, NO)) {
    }
    
    return [str1 localizedCompare:str2];
}

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, WebFileResourceDelegate>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *localFileList;
@property (nonatomic, strong) NSMutableArray *fileList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self setFileResourceDelegate];
    
    [self initArr];
    [self loadFileList];
    
    [self addTableView];
    [self buildMJRefreshHeader];
    
    [self addManualThemeStyleObserver];
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"本地资源";
    
    UIButton *liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    liveButton.frame = CGRectMake(0, 0, 30, 30);
    //liveButton.showsTouchWhenHighlighted = YES;
    [liveButton setTitle:@"LIVE" forState:UIControlStateNormal];
    [liveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [liveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [liveButton addTarget:self action:@selector(pushLiveViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *liveItem = [[UIBarButtonItem alloc] initWithCustomView:liveButton];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = 15;
    
    self.navigationItem.rightBarButtonItems = @[liveItem, spaceItem];
}

- (void)pushLiveViewController:(UIButton *)sender {
    LiveViewController *liveVC = [[LiveViewController alloc] init];
    liveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (void)setFileResourceDelegate {
    [WifiManager shared].httpServer.fileResourceDelegate = self;
}

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

- (void)initArr {
    [self loadLocalFileList];
}

// load local file list.
- (void)loadLocalFileList {
    // remove all objects.
    [self.localFileList removeAllObjects];
    
    NSArray *files = [FileHelper getLocalVideoFiles];
    [self.localFileList addObjectsFromArray:files];
    
    // sort objects.
    [self.localFileList sortUsingFunction:yf_sortObjects context:NULL];
}

// load file list.
- (void)loadFileList {
    [self.fileList removeAllObjects];
    
    NSString *path = [FileHelper getCachePath];
    NSDirectoryEnumerator *dirEnum = [QPFileMgr enumeratorAtPath:path];
    
    NSString *name = nil;
    while (name = [dirEnum nextObject]) {
        [self.fileList addObject:name];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tW   = QPScreenWidth;
        CGFloat tH   = self.view.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tW, tH);
        _tableView   = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    }
    return _tableView;
}

- (void)addTableView {
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.dataSource       = self;
    self.tableView.delegate         = self;
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleTopMargin  |
                                       UIViewAutoresizingFlexibleWidth      |
                                       UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:self.tableView];
}

- (void)buildMJRefreshHeader {
    @QPWeakObject(self)
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self loadNewData];
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = mj_header;
}

- (void)loadNewData {
    [self loadFileList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self reloadData];
    });
}

- (void)reloadData {
    [self.tableView reloadData];
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
    return QPAppendingPathComponent([FileHelper getCachePath], filename);
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString *)name inTempPath:(NSString *)tmpPath {
    if (name == nil || tmpPath == nil) return;
    
    NSString *path = QPAppendingPathComponent([FileHelper getCachePath], name);
    NSError *error = nil;
    
    if (![QPFileMgr moveItemAtPath:tmpPath toPath:path error:&error]) {
        QPLog(@"can not move %@ to %@ because: %@", tmpPath, path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    
    [self reloadData];
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
    
    [self reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    @QPWeakObject(self)
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weak_self deleteRowAtIndexPath:indexPath];
    }];
    
    return @[deleteRowAction];
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FileModel *fileModel = self.localFileList[indexPath.row];
        
        if ([FileHelper removeLocalFile:fileModel.name]) {
            // Delete data for datasource, delete row from table.
            [self.localFileList removeObjectAtIndex:indexPath.row];
            
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
*/

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath {
    FileModel *fileModel = self.localFileList[indexPath.row];
    
    if ([FileHelper removeLocalFile:fileModel.name]) {
        
        // Delete data for datasource, delete row from table.
        [self.localFileList removeObjectAtIndex:indexPath.row];
        
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.localFileList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FileTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FileDetailsCellID";
    
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([FileTableViewCell class]) owner:nil options:nil] firstObject];
    } else {
        //[self removeCellAllSubviews:cell];
    }
    
    cell.backgroundColor = self.isDarkMode ? QPColorFromRGB(30, 30, 30) : [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FileModel *fileModel = self.localFileList[indexPath.row];
    
    [self setThumbnailForCell:cell model:fileModel];
    
    [cell.titleLabel setText:fileModel.title];
    [cell.titleLabel setTextColor:self.isDarkMode ? QPColorFromRGB(230, 230, 230) : QPColorFromRGB(30, 30, 30)];
    [cell.titleLabel setNumberOfLines:2];
    [cell.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    
    [self setInfoForCell:cell model:fileModel];
    
    [cell.dateLabel setText:fileModel.creationDate];
    [cell.dateLabel setTextColor:self.isDarkMode ? QPColorFromRGB(180, 180, 180) : UIColor.grayColor];
    
    [self setFormatImageForCell:cell model:fileModel];
    
    [cell.divider setBackgroundColor:self.isDarkMode ? QPColorFromRGB(40, 40, 40) : QPColorFromRGB(230, 230, 230)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FileModel *fileModel = self.localFileList[indexPath.row];
    
    [self playLocalVideo:fileModel forCell:cell];
}

- (void)playLocalVideo:(FileModel *)model forCell:(FileTableViewCell *)cell {
    if (!QPlayerIsPlaying()) {
        QPlayerSavePlaying(YES);
        
        QPlayerController *qpc    = [[QPlayerController alloc] init];
        qpc.isLocalVideo          = YES;
        qpc.isMediaPlayerPlayback = YES;
        qpc.videoTitle            = model.name;
        qpc.videoUrl              = model.path;
        qpc.placeholderCoverImage = cell.thumbnailImgView.image;
        
        [self.navigationController pushViewController:qpc animated:YES];
    }
}

- (void)setInfoForCell:(FileTableViewCell *)cell model:(FileModel *)model {
    NSURL *aURL = [NSURL fileURLWithPath:model.path];
    
    int duration = self.yf_videoDuration(aURL);
    NSString *displayTime = [self formatVideoDuration:duration];
    
    double fileSize = model.fileSize;
    double ret = fileSize / 1000.0;
    
    NSString *sizeStr;
    if (ret < 1.0) {
        sizeStr = [NSString stringWithFormat:@"%0.1f MB", fileSize];
    } else {
        sizeStr = [NSString stringWithFormat:@"%0.1f GB", ret];
    }
    
    NSString *info = [NSString stringWithFormat:@"%@ | %@", displayTime, sizeStr];
    [cell.infolabel setText:info];
    
    [cell.infolabel setTextColor:self.isDarkMode ? QPColorFromRGB(180, 180, 180) : UIColor.grayColor];
}

- (void)setThumbnailForCell:(FileTableViewCell *)cell model:(FileModel *)model {
    NSURL *aURL = [NSURL fileURLWithPath:model.path];
    UIImage *thumbnail = self.yf_videoThumbnailImage(aURL, 3, 107, 60);
    
    [cell.thumbnailImgView setBackgroundColor:QPColorFromRGB(36, 39, 46)];
    [cell.thumbnailImgView setImage:thumbnail];
    [cell.thumbnailImgView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setFormatImageForCell:(FileTableViewCell *)cell model:(FileModel *)model {
    NSString *fileExt = [model.fileType lowercaseString];
    
    NSString *filename = nil;
    
    if ([fileExt isEqualToString:@"avi"]) {
        filename = [NSString stringWithFormat:@"icon_avi"];
    } else if ([fileExt isEqualToString:@"flv"]) {
        filename = [NSString stringWithFormat:@"icon_flv"];
    } else if ([fileExt isEqualToString:@"mkv"]) {
        filename = [NSString stringWithFormat:@"icon_mkv"];
    } else if ([fileExt isEqualToString:@"mov"]) {
        filename = [NSString stringWithFormat:@"icon_mov"];
    } else if ([fileExt isEqualToString:@"mp4"]) {
        filename = [NSString stringWithFormat:@"icon_mp4"];
    } else if ([fileExt isEqualToString:@"mpg"]) {
        filename = [NSString stringWithFormat:@"icon_mpg"];
    } else if ([fileExt isEqualToString:@"rm"]) {
        filename = [NSString stringWithFormat:@"icon_rm"];
    } else if ([fileExt isEqualToString:@"rmv"]) {
        filename = [NSString stringWithFormat:@"icon_rmv"];
    } else if ([fileExt isEqualToString:@"rmvb"]) {
        filename = [NSString stringWithFormat:@"icon_rmv"];
    } else if ([fileExt isEqualToString:@"swf"]) {
        filename = [NSString stringWithFormat:@"icon_swf"];
    } else if ([fileExt isEqualToString:@"wmv"]) {
        filename = [NSString stringWithFormat:@"icon_wmv"];
    } else if ([fileExt isEqualToString:@"mp3"]) {
        filename = [NSString stringWithFormat:@"default_thumbnail"];
    } else {
        filename = [NSString stringWithFormat:@"icon_jpg"];
    }
    
    cell.formatImgView.image = QPImageNamed(filename);
    cell.formatImgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)adjustThemeStyle {
    [super adjustThemeStyle];
    [self.tableView reloadData];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.tableView reloadData];
}

- (void)dealloc {
    [WifiManager shared].httpServer.fileResourceDelegate = nil;
    [self removeManualThemeStyleObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

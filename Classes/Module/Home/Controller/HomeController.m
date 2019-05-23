//
//  HomeController.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "HomeController.h"
#import "WifiManager.h"
#import "FileHelper.h"
#import "FileCell.h"
#import "FileModel.h"
#import "VideoPlayerController.h"

@interface HomeController () <UITableViewDelegate, UITableViewDataSource, WebFileResourceDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *localFileList;
@property (nonatomic, strong) NSMutableArray *fileList;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"本地资源";
    
    [self initArr];
    
    [self localFileList];
    [self setFileResourceDelegate];
    [self setupTableView];
    
    [self addMJHeader];
}

- (void)initArr {
    self.localFileList = [NSMutableArray arrayWithArray:[FileHelper getLocalVideoFiles]];
    self.fileList = [NSMutableArray arrayWithCapacity:0];
}

- (void)setFileResourceDelegate {
    [WifiManager shared].httpServer.fileResourceDelegate = self;
}

// load file list
- (void)loadFileList {
    [self.fileList removeAllObjects];
    
    NSString *path = [FileHelper getCachePath];
    NSDirectoryEnumerator *dirEnum = [QPFileMgr enumeratorAtPath:path];
    
    NSString *name = nil;
    
    while (name = [dirEnum nextObject]) {
        [self.fileList addObject:name];
    }
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, QPScreenHeight - QPStatusBarAndNavigationBarHeight - QPTabbarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addMJHeader {
    @QPWeakObject(self)
    
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weak_self loadNewData];
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = mj_header;
}

- (void)loadNewData {
    [self loadFileList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self reloadData];
                       [self.tableView.mj_header endRefreshing];
                   });
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - WebFileResourceDelegate

// number of the files
- (NSInteger)numberOfFiles {
    return [self.fileList count];
}

// the file name by the index
- (NSString *)fileNameAtIndex:(NSInteger)index {
    return [self.fileList objectAtIndex:index];
}

// provide full file path by given file name
- (NSString *)filePathForFileName:(NSString *)filename {
    return QPAppendingPathComponent([FileHelper getCachePath], filename);
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString *)name inTempPath:(NSString *)tmpPath {
    if (name == nil || tmpPath == nil) return;
    
    NSError *error = nil;
    
    NSString *path = QPAppendingPathComponent([FileHelper getCachePath], name);
    if (![QPFileMgr moveItemAtPath:tmpPath toPath:path error:&error]) {
        QPLog(@"can not move %@ to %@ because: %@", tmpPath, path, error);
    }
    
    [self localFileList];
    [self setLocalFileList:[[FileHelper getLocalVideoFiles] mutableCopy]];
    [self reloadData];
}

// implement this method to delete requested file and update the file list
- (void)fileShouldDelete:(NSString *)fileName {
    NSString *path = [self filePathForFileName:fileName];
    
    NSError *error = nil;
    
    if(![QPFileMgr removeItemAtPath:path error:&error]) {
        QPLog(@"%@ can not be removed because: %@", path, error);
    }
    
    [self localFileList];
    [self setLocalFileList:[[FileHelper getLocalVideoFiles] mutableCopy]];
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
    return FileCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"fileDescCell"];
    
    FileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FileCell" owner:self options:nil] firstObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    FileModel *fileModel = self.localFileList[indexPath.row];
    [self setIconForCell:cell withModel:fileModel];
    [cell.titleLabel setText:fileModel.title];
    [self setFileSizeForCell:cell withModel:fileModel];
    [cell.dateLabel setText:fileModel.creationDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FileModel *fileModel = self.localFileList[indexPath.row];
    
    VideoPlayerController *vpc = [[VideoPlayerController alloc] init];
    vpc.v_url_str = fileModel.path;
    vpc.v_name = fileModel.name;
    vpc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vpc animated:YES];
}

- (void)setFileSizeForCell:(FileCell *)cell withModel:(FileModel *)model {
    double fsize = model.fileSize;
    double re = fsize/1000;
    
    NSString *text;
    
    if (re < 1.0) {
        text = [NSString stringWithFormat:@"%0.1f MB", fsize];
    } else {
        text = [NSString stringWithFormat:@"%0.1f GB", re];
    }
    
    [cell.sizelabel setText:text];
}

- (void)setIconForCell:(FileCell *)cell withModel:(FileModel *)model {
    NSString *fileExt = [model.fileType lowercaseString];
    
    NSString *imgName = nil;
    
    if ([fileExt isEqualToString:@"avi"]) {
        imgName = [NSString stringWithFormat:@"icon_avi"];
    } else if ([fileExt isEqualToString:@"flv"]) {
        imgName = [NSString stringWithFormat:@"icon_flv"];
    } else if ([fileExt isEqualToString:@"mkv"]) {
        imgName = [NSString stringWithFormat:@"icon_mkv"];
    } else if ([fileExt isEqualToString:@"mov"]) {
        imgName = [NSString stringWithFormat:@"icon_mov"];
    } else if ([fileExt isEqualToString:@"mp4"]) {
        imgName = [NSString stringWithFormat:@"icon_mp4"];
    } else if ([fileExt isEqualToString:@"mpg"]) {
        imgName = [NSString stringWithFormat:@"icon_mpg"];
    } else if ([fileExt isEqualToString:@"rm"]) {
        imgName = [NSString stringWithFormat:@"icon_rm"];
    } else if ([fileExt isEqualToString:@"rmv"]) {
        imgName = [NSString stringWithFormat:@"icon_rmv"];
    } else if ([fileExt isEqualToString:@"rmvb"]) {
        imgName = [NSString stringWithFormat:@"icon_rmv"];
    } else if ([fileExt isEqualToString:@"swf"]) {
        imgName = [NSString stringWithFormat:@"icon_swf"];
    } else if ([fileExt isEqualToString:@"wmv"]) {
        imgName = [NSString stringWithFormat:@"icon_wmv"];
    } else {
        imgName = [NSString stringWithFormat:@"icon_jpg"];
    }
    
    cell.typeImgView.image = QPImageNamed(imgName);
    cell.typeImgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)dealloc {
    [WifiManager shared].httpServer.fileResourceDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

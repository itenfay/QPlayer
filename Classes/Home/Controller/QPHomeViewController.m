//
//  QPHomeViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPHomeViewController.h"

#import "QPFileTableViewCell.h"
#import "QPPlayerController.h"
#import "QPLiveViewController.h"

#import "QPListViewAdapter.h"
#import "QPHomeView.h"

@interface QPHomeViewController ()

@property (nonatomic, strong) QPListViewAdapter *adapter;
@property (nonatomic, strong) QPHomeView *homeView;

@end

@implementation QPHomeViewController

- (void)loadView {
    [super loadView];
    
    self.homeView = [[QPHomeView alloc] initWithFrame:CGRectZero];
    self.view = self.homeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self addThemeStyleChangedObserver];
    
    
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
    QPLiveViewController *liveVC = [[QPLiveViewController alloc] init];
    liveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liveVC animated:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    @QPWeakify(self)
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weak_self deleteRowAtIndexPath:indexPath];
    }];
    
    return @[deleteRowAction];
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        FileModel *fileModel = self.localFileList[indexPath.row];
//
//        if ([FileHelper removeLocalFile:fileModel.name]) {
//            // Delete data for datasource, delete row from table.
//            [self.localFileList removeObjectAtIndex:indexPath.row];
//
//            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        }
//    }
//}


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
    NSString *ext = [model.fileType lowercaseString];
    NSString *iconName = QPlayerMatchingIconName(ext);
    
    cell.formatImgView.image = QPImageNamed(iconName);
    cell.formatImgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)adaptThemeStyle {
    [super adaptThemeStyle];
    [self.tableView reloadData];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.tableView reloadData];
}

- (void)dealloc {
    [self removeThemeStyleChangedObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

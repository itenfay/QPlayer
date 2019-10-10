//
//  SettingsViewController.m
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "SettingsViewController.h"
#import "WifiManager.h"
#import "AboutMeViewController.h"

#define SettingsCellHeight   50.f

#define SectionHeaderHeight  40.f
#define SectionFooterHeight  45.f

#define BaseTopMargin         5.f
#define BaseLeftMargin       10.f

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UInt16 m_port;
@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setM_port:52013];
        QPLog(@" >>>>>>>>>> ");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self addTableView];
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"设置";
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    infoBtn.frame = CGRectMake(0, 0, 20, 20);
    infoBtn.tintColor = UIColor.whiteColor;
    [infoBtn addTarget:self action:@selector(viewMyInfor:) forControlEvents:UIControlEventTouchUpInside];
    infoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

- (void)viewMyInfor:(UIButton *)sender {
    QPLog(@" >>>>>>>>>> ");
    
    AboutMeViewController *aboutVC = [[AboutMeViewController alloc] init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tabW = QPScreenWidth;
        CGFloat tabH = self.view.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tabW, tabH);
        _tableView   = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL status = WifiManager.shared.serverStatus;
    if (!status) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SettingsCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL status = [[WifiManager shared] serverStatus];
    if (section == 0 && status) {
        //return 0.1f;
    }
    return SectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, SectionHeaderHeight)];
        headerView.backgroundColor = [UIColor clearColor];
        
        CGFloat tX = 2*BaseLeftMargin;
        CGFloat tY = headerView.height/2.0 - BaseTopMargin;
        CGFloat tW = headerView.width - 2*tX;
        CGFloat tH = headerView.height/2.0;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tX, tY, tW, tH)];
        titleLabel.backgroundColor = UIColor.clearColor;
        titleLabel.font            = [UIFont systemFontOfSize:13.6f];
        titleLabel.textColor       = QPColorFromRGB(96, 96, 96);
        titleLabel.textAlignment   = NSTextAlignmentLeft;
        titleLabel.text = (section == 0) ? @"开启后，可以享用 WiFi 文件传输服务" : @"打开电脑浏览器，输入以下网址进行访问";
        [headerView addSubview:titleLabel];
        
        return headerView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //BOOL status = [[WifiManager shared] serverStatus];
    
    //if ((section == 0 && !status) || (section == 1 && status)) {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, SectionFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    
    CGFloat tX = 2*BaseLeftMargin;
    CGFloat tY = BaseTopMargin;
    CGFloat tW = footerView.width - 2*tX;
    CGFloat tH = footerView.height*7/9.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tX, tY, tW, tH)];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont systemFontOfSize:13.6f];
    titleLabel.textColor       = QPColorFromRGB(96, 96, 96);
    titleLabel.textAlignment   = NSTextAlignmentLeft;
    titleLabel.numberOfLines   = 2;
    titleLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLabel.text = (section == 0) ? @"支持 mp4,mov,avi,flv,mkv,wmv,m4v,rm,rmvb,mp3 等主流媒体格式，支持 rtmp,http,hls,rstp 等直播流媒体播放" : @"上传媒体文件时，确保电脑和手机在同一 WiFi 环境并且不要关闭本应用也不要锁屏";
    [footerView addSubview:titleLabel];
    
    return footerView;
    //}
    
    //return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SettingsCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    } else {
        [self removeCellAllSubviews:cell];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"WiFi 文件传输";
        cell.textLabel.textColor = QPColorFromRGB(48, 48, 48);
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = SettingsCellHeight/2.0;
        sw.on        = [WifiManager shared].serverStatus;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:sw];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port];
        cell.textLabel.textColor = QPColorFromRGB(48, 48, 48);
        
        //UIButton *cPortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //cPortBtn.width   = 70.f;
        //cPortBtn.height  = 30.f;
        //cPortBtn.left    = QPScreenWidth - cPortBtn.width - 20.f;
        //cPortBtn.centerY = SettingsCellHeight/2.0;
        
        //cPortBtn.showsTouchWhenHighlighted = YES;
        //cPortBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //cPortBtn.backgroundColor = UIColor.clearColor;
        
        //[cPortBtn setTitle:@"更改端口" forState:UIControlStateNormal];
        //[cPortBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        //[cPortBtn setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
        
        //[cPortBtn addTarget:self action:@selector(onChangePort:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.contentView addSubview:cPortBtn];
        
        cell.detailTextLabel.text = @"更改端口";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self onChangePort:nil];
        }
    }
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [[WifiManager shared] operateServer:YES];
    } else {
        [[WifiManager shared] operateServer:NO];
    }
    
    BOOL status = [WifiManager shared].serverStatus;
    QPLog(@" >>>>>>>>>> [Server] status: %d, %@", status, status ? [NSString stringWithFormat:@"http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port] : @"The server didn't open.");
    
    [self.tableView reloadData];
}

- (void)onChangePort:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"使用 8080 端口" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self onConfigurePort:YES];
    }];
    [alertController addAction:destructiveAction];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"使用其他端口" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self onConfigurePort:NO];
    }];
    [alertController addAction:defaultAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)onConfigurePort:(BOOL)isDefault {
    QPLog(@" >>>>>>>>>> ");
    
    if (isDefault) {
        [WifiManager.shared useDefaultPort8080];
    } else {
        [WifiManager.shared changePort:self.m_port++];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

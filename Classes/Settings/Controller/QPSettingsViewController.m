//
//  QPSettingsViewController.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "QPSettingsViewController.h"
#import "AboutMeViewController.h"
#import "WifiManager.h"
#import "TabBarController.h"

#define SettingsCellHeight   50.f

#define SectionHeaderHeight  40.f
#define SectionFooterHeight  45.f

#define BaseTopMargin         5.f
#define BaseLeftMargin       10.f

@interface QPSettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UInt16 m_port;

@end

@implementation QPSettingsViewController

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
    
    [self monitorNetworkChangesWithSelector:@selector(networkStatusDidChange:)];
    [self addThemeStyleChangedObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)networkStatusDidChange:(NSNotification *)noti {
    [self.tableView reloadData];
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
    if (!status || ![chenxingNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
        return 4;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    } else if (section == 4) {
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SettingsCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        return 0.1f;
    }
    
    //BOOL status = [[WifiManager shared] serverStatus];
    //if (section == 1 && status) {
    //    return 0.1f;
    //}
    
    return SectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *headerTitles = @[@"开启后，将与手机设置保持一致的深色或浅色模式", @"显示网络连接状态", @"播放设置", @"开启后，可以享用 WiFi 文件传输服务", @"打开电脑浏览器，输入以下网址进行访问"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, SectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    
    CGFloat tX = 2*BaseLeftMargin;
    CGFloat tY = headerView.height/2.0 - BaseTopMargin;
    CGFloat tW = headerView.width - 2*tX;
    CGFloat tH = headerView.height/2.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tX, tY, tW, tH)];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor       = self.isDarkMode ? QPColorFromRGB(160, 160, 160) : QPColorFromRGB(96, 96, 96);
    titleLabel.textAlignment   = NSTextAlignmentLeft;
    titleLabel.text            = headerTitles[section];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) return nil;
    
    NSArray *footerDescs = @[@"开启后，可以使用流量在线观看视频，注意网页播放器仍可使用流量播放。", @"支持 MP4,MOV,AVI,FLV,MKV,WMV,M4V,RMVB,MP3 等主流媒体格式，支持 HTTP,RTMP,RSTP,HLS 等流媒体或直播播放。", @"上传媒体文件时，确保电脑和手机在同一 WiFi 环境并且不要关闭本应用也不要锁屏。"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, SectionFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    
    CGFloat tX = 2*BaseLeftMargin;
    CGFloat tY = BaseTopMargin;
    CGFloat tW = footerView.width - 2*tX;
    CGFloat tH = footerView.height*7/9.0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tX, tY, tW, tH)];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor       = self.isDarkMode ? QPColorFromRGB(160, 160, 160) : QPColorFromRGB(96, 96, 96);
    titleLabel.textAlignment   = NSTextAlignmentLeft;
    titleLabel.numberOfLines   = 2;
    titleLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLabel.text            = footerDescs[section - 2];
    
    [footerView addSubview:titleLabel];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SettingsCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    } else {
        [self removeCellAllSubviews:cell];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.backgroundColor = self.isDarkMode ? QPColorFromRGB(40, 40, 40) : [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"自动跟随系统设置";
        cell.textLabel.textColor = self.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = SettingsCellHeight/2.0;
        sw.on        = [QPlayerExtractValue(kThemeStyleOnOff) boolValue];
        sw.tag       = 10;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:sw];
        
    } else if (indexPath.section == 1) {
        
        cell.textLabel.text = @"当前网络连接状态";
        cell.textLabel.textColor = self.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
        
        cell.detailTextLabel.text = chenxingNetworkSniffer.sharedSniffer.statusFlags;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.textColor = self.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
        
    } else if (indexPath.section == 2) {
        
        cell.textLabel.text = @"允许运营商网络播放";
        cell.textLabel.textColor = self.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = SettingsCellHeight/2.0;
        sw.on        = QPlayerCarrierNetworkAllowed();
        sw.tag       = 9;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:sw];
        
    } else if (indexPath.section == 3) {
        
        cell.textLabel.text = @"WiFi 文件传输";
        cell.textLabel.textColor = self.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = SettingsCellHeight/2.0;
        sw.tag       = 8;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([chenxingNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
            sw.on = [WifiManager shared].serverStatus;
        } else {
            sw.on = NO;
        }
        
        [cell.contentView addSubview:sw];
        
    } else if (indexPath.section == 4) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port];
        cell.textLabel.textColor = self.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
        
        cell.detailTextLabel.text = @"更改端口";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.textColor = QPColorFromRGB(66, 126, 210);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            [self onChangePort:nil];
        }
    }
}

- (void)switchValueChanged:(UISwitch *)sender {
    
    if (sender.tag == 10) {
        
        QPlayerStoreValue(kThemeStyleOnOff, [NSNumber numberWithBool:sender.isOn]);
        [NSNotificationCenter.defaultCenter postNotificationName:kThemeStyleDidChangeNotification object:nil];
        if (self.tabBarController) {
            TabBarController *tbc = (TabBarController *)self.tabBarController;
            [tbc adjustTabBarThemeStyle];
        }
        
    } else if (sender.tag == 9) {
        
        QPlayerSetCarrierNetworkAllowed(sender.isOn);
        if (sender.isOn) {
            [QPHudObject showTipMessageInView:@"已开启"];
        } else {
            [QPHudObject showTipMessageInView:@"已关闭"];
        }
        
    } else {
        
        if (![chenxingNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
            sender.on = !sender.isOn;
            [QPHudObject showWarnMessage:@"当前网络不是WiFi"];
            return;
        }
        
        if (sender.isOn) {
            [[WifiManager shared] operateServer:YES];
        } else {
            [[WifiManager shared] operateServer:NO];
        }
        
        BOOL status = [WifiManager shared].serverStatus;
        QPLog(@" >>>>>>>>>> [Server] status: %d, %@", status, status ? [NSString stringWithFormat:@"http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port] : @"The server didn't open.");
        
    }
    
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

- (void)adaptThemeStyle {
    [super adaptThemeStyle];
    [self.tableView reloadData];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self.tableView reloadData];
}

- (void)dealloc {
    [self stopMonitoringNetworkChanges];
    [self removeThemeStyleChangedObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

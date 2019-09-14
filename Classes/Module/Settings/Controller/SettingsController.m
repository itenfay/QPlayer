//
//  SettingsController.m
//  Player
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "SettingsController.h"
#import "WifiManager.h"

#define SettingsCellHeight   60.f
#define SectionHeaderHeight  40.f
#define SectionFooterHeight  40.f

@interface SettingsController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self setupTableView];
}

- (void)configureNavigationBar {
    self.navigationItem.title = @"设置";
}

- (void)setupTableView {
    if (!_tableView) {
        CGFloat tabW = QPScreenWidth;
        CGFloat tabH = self.view.height - QPTabBarHeight;
        CGRect frame = CGRectMake(0, 0, tabW, tabH);
        
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BOOL status = [[WifiManager shared] serverStatus];
    if (status) {
        return 2;
    }
    return 1;
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
        return 0.1f;
    }
    return SectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, SectionHeaderHeight)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, headerView.height/2.0, headerView.width - 20, headerView.height/2.0)];
        titleLabel.backgroundColor = UIColor.clearColor;
        titleLabel.font = [UIFont systemFontOfSize:13.5f];
        titleLabel.textColor = UIColor.grayColor;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = (section == 0) ? @"开启后，可以享用 WiFi 文件传输服务" : @"打开电脑浏览器，输入以下网址访问";
        [headerView addSubview:titleLabel];
        
        return headerView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL status = [[WifiManager shared] serverStatus];
    
    if ((section == 0 && !status) || (section == 1 && status)) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, SectionFooterHeight)];
        footerView.backgroundColor = [UIColor clearColor];
        
        if (section == 1) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, footerView.width - 20, footerView.height/2.0)];
            titleLabel.backgroundColor = UIColor.clearColor;
            titleLabel.font = [UIFont systemFontOfSize:13.5f];
            titleLabel.textColor = UIColor.grayColor;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.text = @"上传文件时，确保在同一 WiFi 环境并且不要关闭本应用";
            [footerView addSubview:titleLabel];
        }
        
        return footerView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SettingsCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    } else {
        [self removeCellAllSubviews:cell];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"WiFi 文件传输";
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 60;
        sw.centerY   = SettingsCellHeight/2.0;
        sw.on        = [WifiManager shared].serverStatus;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:sw];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [[WifiManager shared]   operateServer:YES];
        [[WifiManager shared] setServerStatus:YES];
    } else {
        [[WifiManager shared]   operateServer:NO];
        [[WifiManager shared] setServerStatus:NO];
    }
    
    BOOL status = [WifiManager shared].serverStatus;
    QPLog(@"[Server] status: %d, %@", status, status ? [NSString stringWithFormat:@"http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port] : @"Server didn't open.");
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

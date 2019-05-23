//
//  SettingsController.m
//  Player
//
//  Created by dyf on 2017/6/28.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "SettingsController.h"
#import "WifiManager.h"

@interface SettingsController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    [self setupTableView];
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, QPScreenHeight - QPStatusBarAndNavigationBarHeight - QPTabbarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
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
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    BOOL status = [[WifiManager shared] serverStatus];
    if (section == 0 && status) {
        return 0.1f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, 15)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL status = [[WifiManager shared] serverStatus];
    if ((section == 0 && !status) || (section == 1 && status)) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, 15)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    } else {
        while (cell.contentView.subviews.lastObject != nil) {
            [(UIView *)cell.contentView.subviews.lastObject removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Wi-Fi文件传输";
        
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left = QPScreenWidth - 70;
        sw.centerY = cell.contentView.centerY;
        sw.on = [WifiManager shared].serverStatus;
        [sw addTarget:self action:@selector(swValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:sw];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"在电脑浏览器访问：http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)swValueChanged:(UISwitch *)sw {
    if (sw.isOn) {
        [[WifiManager shared] operateServer:YES];
        [[WifiManager shared] setServerStatus:YES];
    } else {
        [[WifiManager shared] operateServer:NO];
        [[WifiManager shared] setServerStatus:NO];
    }
    
    BOOL status = [WifiManager shared].serverStatus;
    
    QPLog(@"Server status: %d %@", status, status ? [NSString stringWithFormat:@", http://%@:%d", [WifiManager shared].httpServer.hostName, [WifiManager shared].httpServer.port] : @"");
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

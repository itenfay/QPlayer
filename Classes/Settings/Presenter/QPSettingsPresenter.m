//
//  QPSettingsPresenter.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/2.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPSettingsPresenter.h"
#import "QPTabBarController.h"
#import "QPWifiManager.h"
#import "QPSettingsViewController.h"
#import "QPSettingsModel.h"

#define SettingsCellHeight   50.f
#define SectionHeaderHeight  40.f
#define SectionFooterHeight  60.f
#define BaseTopMargin         5.f
#define BaseLeftMargin       10.f

@interface QPSettingsPresenter ()

@end

@implementation QPSettingsPresenter

- (QPSettingsViewController *)settingsController
{
    return (QPSettingsViewController *)_viewController;
}

- (void)loadData
{
    QPSettingsViewController *vc = [self settingsController];
    [vc.adapter.dataSource removeAllObjects];
    
    QPSettingsModel *sysSettingmodel = [QPSettingsModel new];
    sysSettingmodel.title = @"自动跟随系统设置";
    [vc.adapter.dataSource addObject:sysSettingmodel];
    
    QPSettingsModel *netConnectedModel = [QPSettingsModel new];
    netConnectedModel.title = @"当前网络连接状态";
    [vc.adapter.dataSource addObject:netConnectedModel];
    
    NSMutableArray *subArray = [NSMutableArray arrayWithCapacity:0];
    QPSettingsModel *decodingModel = [QPSettingsModel new];
    decodingModel.title = @"硬解码播放";
    [subArray addObject:decodingModel];
    
    QPSettingsModel *smallWinModel = [QPSettingsModel new];
    smallWinModel.title = @"开启小窗播放";
    [subArray addObject:smallWinModel];
    
    QPSettingsModel *smallWinModelInBackground = [QPSettingsModel new];
    smallWinModelInBackground.title = @"允许应用后台继续小窗播放";
    [subArray addObject:smallWinModelInBackground];
    
    QPSettingsModel *skiptitlesModel = [QPSettingsModel new];
    skiptitlesModel.title = @"自动跳过片头";
    [subArray addObject:skiptitlesModel];
    
    QPSettingsModel *carrierModel = [QPSettingsModel new];
    carrierModel.title = @"允许运营商网络播放";
    [subArray addObject:carrierModel];
    [vc.adapter.dataSource addObject:subArray];
    
    QPSettingsModel *transmissionModel = [QPSettingsModel new];
    transmissionModel.title = @"WiFi 文件传输";
    [vc.adapter.dataSource addObject:transmissionModel];
    
    QPSettingsModel *portModel = [QPSettingsModel new];
    portModel.title = @"更改端口";
    [vc.adapter.dataSource addObject:portModel];
    
    [_view reloadData];
}

- (NSInteger)numberOfSectionsForAdapter:(QPListViewAdapter *)adapter
{
    NSMutableArray *dataArray = [self settingsController].adapter.dataSource;
    BOOL status = QPWifiManager.shared.serverStatus;
    if (!status || ![DYFNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
        return dataArray.count - 1;
    }
    return dataArray.count;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter
{
    //if (section == 0 || section == 1 || section == 2) {
    //    return 0.01f;
    //}
    //BOOL status = [[QPWifiManager shared] serverStatus];
    //if (section == 1 && status) {
    //    return 0.01f;
    //}
    return UITableViewAutomaticDimension;
}

- (UIView *)viewForHeaderInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter
{
    NSArray *headerTitles = @[@"开启后，将与手机设置保持一致的深色或浅色模式",
                              @"显示网络连接状态",
                              @"播放设置",
                              @"开启后，可以享用 WiFi 文件传输服务",
                              @"打开电脑浏览器，输入以下网址进行访问"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, 0)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor       = _viewController.isDarkMode ? QPColorFromRGB(160, 160, 160) : QPColorFromRGB(96, 96, 96);
    titleLabel.textAlignment   = NSTextAlignmentLeft;
    titleLabel.numberOfLines   = 0;
    titleLabel.text            = headerTitles[section];
    [headerView addSubview:titleLabel];
    
    CGFloat tX = 2*BaseLeftMargin;
    CGFloat tW = headerView.width - 2*tX;
    CGFloat tH = titleLabel.tf_heightToFit(titleLabel.text, tW, titleLabel.font);
    CGFloat tY = 1.5*BaseTopMargin;
    titleLabel.left = tX;
    titleLabel.top = tY;
    titleLabel.width = tW;
    titleLabel.height = tH;
    headerView.height = 2*(tH + BaseTopMargin);
    
    return headerView;
}

- (UIView *)viewForFooterInSection:(NSInteger)section forAdapter:(QPListViewAdapter *)adapter
{
    if (section == 0 || section == 1) {
        return nil;
    }
    NSArray *footerDescs = @[@"开启后，可以使用流量在线观看视频，注意网页播放器仍可使用流量播放。",
                             @"支持 MP4,MOV,AVI,FLV,MKV,WMV,M4V,RMVB,MP3 等主流媒体格式，支持 HTTP,RTMP,RSTP,HLS 等流媒体或直播播放。",
                             @"上传媒体文件时，确保电脑和手机在同一 WiFi 环境并且不要关闭本应用也不要锁屏。"];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QPScreenWidth, 0)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = UIColor.clearColor;
    titleLabel.font            = [UIFont systemFontOfSize:13.f];
    titleLabel.textColor       = _viewController.isDarkMode ? QPColorFromRGB(160, 160, 160) : QPColorFromRGB(96, 96, 96);
    titleLabel.textAlignment   = NSTextAlignmentLeft;
    titleLabel.numberOfLines   = 0;
    titleLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLabel.text            = footerDescs[section - 2];
    [footerView addSubview:titleLabel];
    
    CGFloat tX = 2*BaseLeftMargin;
    CGFloat tY = BaseTopMargin;
    CGFloat tW = footerView.width - 2*tX;
    CGFloat tH = titleLabel.tf_heightToFit(titleLabel.text, tW, titleLabel.font);
    titleLabel.left = tX;
    titleLabel.top = tY;
    titleLabel.width = tW;
    titleLabel.height = tH;
    footerView.height = 2*(tH + BaseTopMargin);
    
    return footerView;
}

//- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
//{
//    return UITableViewAutomaticDimension; //SettingsCellHeight;
//}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    static NSString *cellID = @"SettingsCellIdentifier";
    UITableViewCell *cell = [_view dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    } else {
        [cell removeAllSubviews];
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = _viewController.isDarkMode ? QPColorFromRGB(40, 40, 40) : [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QPSettingsModel *model = (QPSettingsModel *)[adapter modelAtIndexPath:indexPath];
    if (indexPath.section == 4) {
        cell.detailTextLabel.text = model.title;
    } else {
        cell.textLabel.text = model.title;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textColor = _viewController.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.textColor = _viewController.isDarkMode ? QPColorFromRGB(180, 180, 180) : QPColorFromRGB(48, 48, 48);
    
    if (indexPath.section == 0) {
        //@"自动跟随系统设置";
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = cell.height/2.0;
        sw.on        = [QPExtractValue(kThemeStyleOnOff) boolValue];
        sw.tag       = 12;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:sw];
    } else if (indexPath.section == 1) {
        //@"当前网络连接状态";
        cell.detailTextLabel.text = DYFNetworkSniffer.sharedSniffer.statusFlags;
    } else if (indexPath.section == 2) {
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = cell.height/2.0;
        if (indexPath.item == 0) {
            //@"硬解码播放";
            sw.on  = QPPlayerHardDecoding() == 1 ? YES : NO;
            sw.tag = 10;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        } else if (indexPath.item == 1) {
            //@"开启小窗播放"; @"画中画播放";
            sw.on  = QPPlayerPictureInPictureEnabled();
            sw.tag = 9;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        } else if (indexPath.item == 2) {
            //@"允许应用后台继续小窗播放";
            sw.on  = QPPlayerPictureInPictureEnabledWhenBackgound();
            sw.tag = 8;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        } else if (indexPath.item == 3) {
            //@"自动跳过片头";
            sw.on  = QPAutomaticallySkipTitles();
            sw.tag = 6;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        } else if (indexPath.item == 4) {
            //@"允许运营商网络播放";
            sw.on  = QPCarrierNetworkAllowed();
            sw.tag = 7;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        }
    } else if (indexPath.section == 3) {
        //@"WiFi 文件传输";
        UISwitch *sw = [[UISwitch alloc] init];
        sw.left      = QPScreenWidth - 70.f;
        sw.centerY   = cell.height/2.0;
        sw.tag       = 4;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        if ([DYFNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
            sw.on = [QPWifiManager shared].serverStatus;
        } else {
            sw.on = NO;
        }
        [cell.contentView addSubview:sw];
    } else if (indexPath.section == 4) {
        //@"更改端口";
        cell.textLabel.text = [NSString stringWithFormat:@"http://%@:%d", [QPWifiManager shared].httpServer.hostName, [QPWifiManager shared].httpServer.port];
        cell.detailTextLabel.textColor = QPColorFromRGB(66, 126, 210);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)switchValueChanged:(UISwitch *)sender
{
    if (sender.tag == 12) {
        QPStoreValue(kThemeStyleOnOff, [NSNumber numberWithBool:sender.isOn]);
        [NSNotificationCenter.defaultCenter postNotificationName:kThemeStyleDidChangeNotification object:nil];
        if (self.viewController.tabBarController) {
            QPTabBarController *tbc = (QPTabBarController *)self.viewController.tabBarController;
            [tbc adaptThemeStyle];
        }
    } else if (sender.tag == 10) {
        QPPlayerSetHardDecoding(sender.isOn ? 1 : 0);
        if (sender.isOn) {
            [QPHudUtils showTipMessageInView:@"已开启硬解码播放"];
        } else {
            [QPHudUtils showTipMessageInView:@"已关闭硬解码播放"];
        }
    } else if (sender.tag == 9) {
        QPPlayerSetPictureInPictureEnabled(sender.isOn);
        if (sender.isOn) {
            [QPHudUtils showTipMessageInView:@"已开启小窗播放"];
        } else {
            [QPHudUtils showTipMessageInView:@"已关闭小窗播放"];
        }
    } else if (sender.tag == 8) {
        QPPlayerSetPictureInPictureEnabledWhenBackgound(sender.isOn);
        if (sender.isOn) {
            [QPHudUtils showTipMessageInView:@"已开启"];
        } else {
            [QPHudUtils showTipMessageInView:@"已关闭"];
        }
    } else if (sender.tag == 7) {
        QPSetCarrierNetworkAllowed(sender.isOn);
        if (sender.isOn) {
            [QPHudUtils showTipMessageInView:@"已开启"];
        } else {
            [QPHudUtils showTipMessageInView:@"已关闭"];
        }
    } else if (sender.tag == 6) {
        QPSetAutomaticallySkipTitles(sender.isOn);
        if (sender.isOn) {
            [QPHudUtils showTipMessageInView:@"已开启"];
        } else {
            [QPHudUtils showTipMessageInView:@"已关闭"];
        }
    } else {
        if (![DYFNetworkSniffer.sharedSniffer isConnectedViaWiFi]) {
            sender.on = !sender.isOn;
            [QPHudUtils showWarnMessage:@"当前不是WiFi网络"];
            return;
        }
        if (sender.isOn) {
            [[QPWifiManager shared] operateServer:YES];
        } else {
            [[QPWifiManager shared] operateServer:NO];
        }
        BOOL status = [QPWifiManager shared].serverStatus;
        QPLog(@"[Server] status: %d, %@", status, status ?
              [NSString stringWithFormat:@"http://%@:%d",
               [QPWifiManager shared].httpServer.hostName,
               [QPWifiManager shared].httpServer.port] : @"The server didn't open.");
    }
    [self.view reloadData];
}

- (void)selectCell:(BaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    [_view deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            [self onChangePort:nil];
        }
    }
}

- (void)onChangePort:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否切换端口？" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
    
    [self.viewController presentViewController:alertController animated:YES completion:^{}];
}

- (void)onConfigurePort:(BOOL)isDefault
{
    if (isDefault) {
        [QPWifiManager.shared usingPort8080];
    } else {
        [QPWifiManager.shared changePort:self.mPort++];
    }
    [self.view reloadData];
}

@end

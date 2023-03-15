//
//  DYFNetworkSniffer.m
//
//  Created by chenxing on 2017/8/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import "DYFNetworkSniffer.h"

@interface DYFNetworkSniffer ()

@end

@implementation DYFNetworkSniffer

+ (instancetype)sharedSniffer
{
    static DYFNetworkSniffer *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStarted = NO;
        _statusFlags = @"Unknown";
    }
    return self;
}

- (void)start
{
    self.isStarted = YES;
    [self delayToSniff];
}

- (void)delayToSniff
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startSniffing];
    });
}

- (void)startSniffing
{
    [AFNetworkReachabilityManager.sharedManager startMonitoring];
    [AFNetworkReachabilityManager.sharedManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                _statusFlags = @"Unknown";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _statusFlags = @"Not Reachable";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self updateCellularNetworkStatus];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _statusFlags = @"WiFi";
                break;
            default:
                break;
        }
    }];
}

- (void)stop
{
    self.isStarted = NO;
    [AFNetworkReachabilityManager.sharedManager stopMonitoring];
}

- (BOOL)isConnectedToNetwork
{
    AFNetworkReachabilityManager *mgr = AFNetworkReachabilityManager.sharedManager;
    return mgr.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable;
}

- (BOOL)isConnectedViaWWAN
{
    AFNetworkReachabilityManager *mgr = AFNetworkReachabilityManager.sharedManager;
    
    if (![self isConnectedToNetwork]) {
        return NO;
    }
    return mgr.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isConnectedViaWiFi
{
    AFNetworkReachabilityManager *mgr = AFNetworkReachabilityManager.sharedManager;
    if (![self isConnectedToNetwork]) {
        return NO;
    }
    return mgr.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (void)updateCellularNetworkStatus
{
    if (@available(iOS 7.0, *)) {
        NSArray *type2G_Strings = @[CTRadioAccessTechnologyEdge,
                                    CTRadioAccessTechnologyGPRS];
        NSArray *type3G_Strings = @[CTRadioAccessTechnologyHSDPA,
                                    CTRadioAccessTechnologyWCDMA,
                                    CTRadioAccessTechnologyCDMA1x,
                                    CTRadioAccessTechnologyHSUPA,
                                    CTRadioAccessTechnologyeHRPD,
                                    CTRadioAccessTechnologyCDMAEVDORev0,
                                    CTRadioAccessTechnologyCDMAEVDORevA,
                                    CTRadioAccessTechnologyCDMAEVDORevB];
        NSArray *type4G_Strings = @[CTRadioAccessTechnologyLTE];
        
        CTTelephonyNetworkInfo *info= [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentAccessType = info.currentRadioAccessTechnology;
        if (@available(iOS 14.1, *)) {
            NSArray *type5G_Strings = @[CTRadioAccessTechnologyNR,
                                        CTRadioAccessTechnologyNRNSA];
            if ([type5G_Strings containsObject:currentAccessType]) {
                _statusFlags = @"5G";
            } else {
                _statusFlags = @"WWAN";
            }
        } else if ([type4G_Strings containsObject:currentAccessType]) {
            _statusFlags = @"4G";
        } else if ([type3G_Strings containsObject:currentAccessType]) {
            _statusFlags = @"3G";
        } else if ([type2G_Strings containsObject:currentAccessType]) {
            _statusFlags = @"2G";
        } else {
            _statusFlags = @"WWAN";
        }
    } else {
        _statusFlags = @"WWAN";
    }
}

@end

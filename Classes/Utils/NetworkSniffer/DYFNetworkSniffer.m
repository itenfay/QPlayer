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
                self->_statusFlags = @"Unknown";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self->_statusFlags = @"Not Reachable";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self updateCellularNetworkStatus];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self->_statusFlags = @"WiFi";
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
    CTTelephonyNetworkInfo *info= [[CTTelephonyNetworkInfo alloc] init];
    NSString *ct;
    if (@available(iOS 12.0, *)) {
        ct = info.serviceCurrentRadioAccessTechnology.allValues.firstObject;
    } else {
        ct = info.currentRadioAccessTechnology;
    }
    NSArray *t2GStrings = @[CTRadioAccessTechnologyEdge,
                            CTRadioAccessTechnologyGPRS];
    NSArray *t3GStrings = @[CTRadioAccessTechnologyHSDPA,
                            CTRadioAccessTechnologyWCDMA,
                            CTRadioAccessTechnologyCDMA1x,
                            CTRadioAccessTechnologyHSUPA,
                            CTRadioAccessTechnologyeHRPD,
                            CTRadioAccessTechnologyCDMAEVDORev0,
                            CTRadioAccessTechnologyCDMAEVDORevA,
                            CTRadioAccessTechnologyCDMAEVDORevB];
    NSArray *t4GStrings = @[CTRadioAccessTechnologyLTE];
    if ([t2GStrings containsObject:ct]) {
        _statusFlags = @"2G";
    } else if ([t3GStrings containsObject:ct]) {
        _statusFlags = @"3G";
    } else if ([t4GStrings containsObject:ct]) {
        _statusFlags = @"4G";
    } else {
        if (@available(iOS 14.1, *)) {
            NSArray *t5GStrings = @[CTRadioAccessTechnologyNR,
                                    CTRadioAccessTechnologyNRNSA];
            if ([t5GStrings containsObject:ct]) {
                _statusFlags = @"5G";
            } else {
                _statusFlags = @"Unkown";
            }
        } else {
            _statusFlags = @"Unkown";
        }
    }
}

@end

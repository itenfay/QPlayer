//
//  DYFNetworkSniffer.h
//
//  Created by chenxing on 2017/8/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AFNetworkReachabilityManager.h"

@interface DYFNetworkSniffer : NSObject

/// Whether or not it is already started.
@property (nonatomic, assign) BOOL isStarted;

/// Returns a string representation of the current network reachability status.
@property (readonly, nonatomic, copy) NSString *statusFlags;

/// Returns the shared network reachability sniffer.
+ (instancetype)sharedSniffer;

/// Unavailable initializer
+ (instancetype)new NS_UNAVAILABLE;

/// Starts sniffing for changes in network reachability status.
- (void)start;

/// Stops sniffing for changes in network reachability status.
- (void)stop;

/// Whether or not the network is currently reachable.
- (BOOL)isConnectedToNetwork;

/// Whether or not the network is currently reachable via WWAN.
- (BOOL)isConnectedViaWWAN;

/// Whether or not the network is currently reachable via WiFi.
- (BOOL)isConnectedViaWiFi;

@end

//
//  QPWifiManager.m
//
//  Created by Tenfay on 2017/9/1. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import "QPWifiManager.h"

@implementation QPWifiManager

+ (instancetype)shared
{
    static QPWifiManager *_inst;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inst = [[[self class] alloc] init];
    });
    
    return _inst;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:8888];
        [_httpServer setName:@"CocoaWebResource"];
        [_httpServer setupBuiltInDocroot];
    }
    return self;
}

- (void)using8080Port
{
    [self changePort:8080];
}

- (void)changePort:(UInt16)port
{
    [self operateServer:NO];
    [_httpServer setPort:port];
    [self operateServer:YES];
}

- (void)operateServer:(BOOL)status
{
    NSError *error = nil;
    if (status) {
        _serverStatus = [_httpServer start:&error];
        if (!_serverStatus) {
            QPLog(@"Error Starting HTTP Server: %@", error);
        }
    } else {
        if ([_httpServer stop]) {
            _serverStatus = NO;
        }
    }
}

- (void)dealloc
{
    self.httpServer.fileResourceDelegate = nil;
}

@end

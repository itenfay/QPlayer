//
//  WifiManager.m
//
//  Created by dyf on 2017/9/1.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import "WifiManager.h"

@implementation WifiManager

+ (instancetype)shared {
    static WifiManager *_inst;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inst = [[[self class] alloc] init];
    });
    
    return _inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:63425];
        [_httpServer setName:@"CocoaWebResource"];
        [_httpServer setupBuiltInDocroot];
    }
    return self;
}

- (void)operateServer:(BOOL)status {
    NSError *error = nil;
    if (status) {
        BOOL serverIsRunning = [_httpServer start:&error];
        if (!serverIsRunning) {
            QPLog(@"Error Starting HTTP Server: %@", error);
        }
    } else {
        [_httpServer stop];
    }
}

- (void)dealloc {
    self.httpServer.fileResourceDelegate = nil;
}

@end

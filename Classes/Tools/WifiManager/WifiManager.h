//
//  WifiManager.h
//
//  Created by dyf on 2017/9/1.
//  Copyright © 2017年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"

@interface WifiManager : NSObject
@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic, assign) BOOL serverStatus;

+ (instancetype)shared;

- (void)operateServer:(BOOL)status;

@end

//
//  QPWifiManager.h
//
//  Created by Tenfay on 2017/9/1. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2017 Tenfay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"
#import "FileResource.h"

@interface QPWifiManager : NSObject

// Declares an `HTTPServer` object.
@property (nonatomic, strong) HTTPServer *httpServer;

// The status for a server, "YES": it means open, "NO": it means stopping.
@property (nonatomic, assign) BOOL serverStatus;

// Creates and returns a `QPWifiManager` singleton.
+ (instancetype)shared;

// Uses the default port 8080.
- (void)using8080Port;

// Changes a port with a `unsigned int` number.
- (void)changePort:(UInt16)port;

// Operates a server with a `BOOL` status that controls whether the server is open or not.
- (void)operateServer:(BOOL)status;

@end

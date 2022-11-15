//
//  QPBaseView.m
//
//  Created by dyf on 2017/6/28. ( https://github.com/dgynfi/QPlayer )
//  Copyright © 2017 dyf. All rights reserved.
//

#import "QPBaseView.h"

@implementation QPBaseView

- (void)autoresize {
    self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                             UIViewAutoresizingFlexibleTopMargin  |
                             UIViewAutoresizingFlexibleWidth      |
                             UIViewAutoresizingFlexibleHeight);
}

@end

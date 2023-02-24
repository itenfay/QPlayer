//
//  QPBaseView.m
//
//  Created by chenxing on 2017/6/28. ( https://github.com/chenxing640/QPlayer )
//  Copyright © 2017 chenxing. All rights reserved.
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

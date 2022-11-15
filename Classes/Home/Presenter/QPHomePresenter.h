//
//  QPHomePresenter.h
//
//  Created by dyf on 2015/6/18. ( https://github.com/dgynfi/QPlayer )
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPWifiManager.h"
#import "QPFileHelper.h"
#import "QPModularDelegate.h"

// Transforms two objects's title to pinying and sorts them.
NSInteger yf_sortObjects(QPFileModel *o1, QPFileModel *o2, void *context) {
    
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:o1.name];
    if (CFStringTransform((__bridge CFMutableStringRef)str1, 0, kCFStringTransformMandarinLatin, NO)) {
    }
    
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:o2.name];
    if (CFStringTransform((__bridge CFMutableStringRef)str2, 0, kCFStringTransformMandarinLatin, NO)) {
    }
    
    return [str1 localizedCompare:str2];
}

@interface QPHomePresenter : QPBasePresenter <WebFileResourceDelegate>

@property (nonatomic, weak) id<QPModularDelegate> delegate;

@end

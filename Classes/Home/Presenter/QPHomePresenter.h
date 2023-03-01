//
//  QPHomePresenter.h
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPBasePresenter.h"
#import "QPWifiManager.h"
#import "QPFileHelper.h"

// Transforms two objects's title to pinying and sorts them.
NSInteger qp_sortObjects(QPFileModel *o1, QPFileModel *o2, void *context)
{
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:o1.name];
    if (CFStringTransform((__bridge CFMutableStringRef)str1,
                          0,
                          kCFStringTransformMandarinLatin, NO)) {}
    NSMutableString *str2 = [[NSMutableString alloc] initWithString:o2.name];
    if (CFStringTransform((__bridge CFMutableStringRef)str2,
                          0,
                          kCFStringTransformMandarinLatin,
                          NO)) {}
    return [str1 localizedCompare:str2];
}

@interface QPHomePresenter : QPBasePresenter <WebFileResourceDelegate>

@property (nonatomic, weak) QPBaseViewController *viewController;

- (instancetype)initWithViewController:(QPBaseViewController *)viewController;

- (void)loadData;

@end

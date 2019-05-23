//
//  NSObject+JudgeNull.m
//
//  Created by dyf on 2017/6/27.
//  Copyright (c) 2015年 dyf. All rights reserved.
//

#import "NSObject+JudgeNull.h"

@implementation NSObject (JudgeNull)

- (BOOL)isNull {
    if ([self isEqual:[NSNull null]]) {
        return YES;
    } else {
        if ([self isKindOfClass:[NSNull class]]) {
            return YES;
        } else {
            if (self == nil) {
                return YES;
            }
        }
    }
    if ([self isKindOfClass:[NSString class]]) {
        if ([((NSString *)self) isEqualToString:@"(null)"]) {
            return YES;
        }
    }
    return NO;
}

@end

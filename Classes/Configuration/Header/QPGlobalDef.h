//
//  QPGlobalDef.h
//
//  Created by dyf on 2017/6/27.
//  Copyright © 2017 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPAppConst.h"

#ifndef QPGlobalDef_h
#define QPGlobalDef_h

#ifndef QP_STATIC
    #define QP_STATIC static
#endif

#ifndef QP_STATIC_INLINE
    #define QP_STATIC_INLINE static inline
#endif

QP_STATIC NSString *const QPCharactersGeneralDelimitersToEncode = @":#[]@";
QP_STATIC NSString *const QPCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

QP_STATIC_INLINE NSString *QPStringByAddingPercentEncodingFromString(NSString *str) {
    //does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[QPCharactersGeneralDelimitersToEncode stringByAppendingString:QPCharactersSubDelimitersToEncode]];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < str.length) {
        NSUInteger length = MIN(str.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        //To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [str rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [str substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

QP_STATIC_INLINE NSString *QPUrlEncode(NSString *str) {
    return QPStringByAddingPercentEncodingFromString(str);
}

QP_STATIC_INLINE NSString *QPUrlDecode(NSString *str) {
    NSString *_str = [str stringByRemovingPercentEncoding];
    if (_str) {
        return _str;
    }
    return [str copy];
}

QP_STATIC_INLINE void QPlayerSetPlaying(BOOL value) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:kQPlayerPlaying];
    [userDefaults synchronize];
}

QP_STATIC_INLINE BOOL QPlayerIsPlaying() {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kQPlayerPlaying];
}

#endif /* QPGlobalDef_h */

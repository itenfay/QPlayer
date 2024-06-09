//
//  DYFHttpClient.m
//
//  Created by Tenfay on 16/6/30. ( https://github.com/itenfay/QPlayer )
//  Copyright © 2016 Tenfay. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DYFHttpClient.h"

NSString *const DYFHttpMethodGET    = @"GET";
NSString *const DYFHttpMethodPOST   = @"POST";
NSString *const DYFHttpMethodHEAD   = @"HEAD";
NSString *const DYFHttpMethodPATCH  = @"PATCH";
NSString *const DYFHttpMethodPUT    = @"PUT";
NSString *const DYFHttpMethodDELETE = @"DELETE";

static NSString *const DYFCharactersGeneralDelimitersToEncode = @":#[]@";
static NSString *const DYFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

NSString *DYFPercentEscapedStringFromString(NSString *str)
{
    //does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSMutableCharacterSet *allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[DYFCharactersGeneralDelimitersToEncode stringByAppendingString:DYFCharactersSubDelimitersToEncode]];
    
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

NSString *DYFUrlEncode(NSString *str)
{
    return DYFPercentEscapedStringFromString(str);
}

NSString *DYFUrlDecode(NSString *str)
{
    NSString *m_str = [str stringByRemovingPercentEncoding];
    if (m_str) {
        return m_str;
    }
    m_str = [str copy];
    return m_str;
}

@implementation DYFHttpClient

+ (instancetype)httpClient
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _acceptableContentTypes = [NSSet setWithObjects:
                                   @"application/json",
                                   @"application/xml",
                                   @"text/plain",
                                   @"text/json", @"text/xml",
                                   @"text/html",
                                   @"text/javascript",
                                   @"image/jpeg", @"image/png", nil];
    }
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters
{
    return [self requestWithMethod:method URLString:URLString parameters:parameters timeoutInterval:0];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    if (timeoutInterval > 0) {
        serializer.timeoutInterval = timeoutInterval;
    }
    
    NSError *error = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:method URLString:URLString parameters:parameters error:&error];
    if (!error) {
        return request;
    }
    
    return nil;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler
{
    return [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request uploadProgress:(DYFURLSessionTaskUploadProgressHandler)uploadProgressHandler downloadProgress:(DYFURLSessionTaskDownloadProgressHandler)downloadProgressHandler completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    if (_acceptableContentTypes) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:_acceptableContentTypes];
        manager.responseSerializer = responseSerializer;
    }
    
    if (_securityPolicy) {
        manager.securityPolicy = _securityPolicy;
    }
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressHandler) {
            uploadProgressHandler(uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressHandler) {
            downloadProgressHandler(downloadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, responseObject, error);
        }
    }];
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL progress:(DYFURLSessionTaskUploadProgressHandler)uploadProgressHandler completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    if (_acceptableContentTypes) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:_acceptableContentTypes];
        manager.responseSerializer = responseSerializer;
    }
    
    if (_securityPolicy) {
        manager.securityPolicy = _securityPolicy;
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:fileURL progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressHandler) {
            uploadProgressHandler(uploadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, responseObject, error);
        }
    }];
    [uploadTask resume];
    
    return uploadTask;
}

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request progress:(DYFURLSessionTaskDownloadProgressHandler)downloadProgressHandler destination:(DYFURLSessionTaskDestinationHandler)destinationHandler completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    if (_acceptableContentTypes) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:_acceptableContentTypes];
        manager.responseSerializer = responseSerializer;
    }
    
    if (_securityPolicy) {
        manager.securityPolicy = _securityPolicy;
    }
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressHandler) {
            downloadProgressHandler(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destinationHandler) {
            return destinationHandler(targetPath, response);
        }
        return nil;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, filePath, error);
        }
    }];
    [downloadTask resume];
    
    return downloadTask;
}

@end

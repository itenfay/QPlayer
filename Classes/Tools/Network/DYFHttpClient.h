//
//  DYFHttpClient.h
//
//  Created by dyf on 16/6/30.
//  Copyright © 2016 dyf. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 *  Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
 - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
 - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
 
 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
 *
 *  @param str The string to be percent-escaped.
 *
 *  @return The percent-escaped string.
 */
FOUNDATION_EXPORT NSString *DYFStringByAddingPercentEncodingFromString(NSString *str);

/**
 *  This method starts an encode operation on the given string.
 *
 *  @param str The string to encode.
 *
 *  @return An encoded string.
 */
FOUNDATION_EXPORT NSString *DYFUrlEncode(NSString *str);

/**
 *  Takes a shortened string and decodes it. This method starts an decode operation on the given string.
 *
 *  @param str The string to decode.
 *
 *  @return A decoded string.
 */
FOUNDATION_EXPORT NSString *DYFUrlDecode(NSString *str);

// The HTTP method for the request, the string is "GET".
FOUNDATION_EXPORT NSString *const DYFHttpMethodGET;
// The HTTP method for the request, the string is "POST".
FOUNDATION_EXPORT NSString *const DYFHttpMethodPOST;
// The HTTP method for the request, the string is "HEAD".
FOUNDATION_EXPORT NSString *const DYFHttpMethodHEAD;
// The HTTP method for the request, the string is "PATCH".
FOUNDATION_EXPORT NSString *const DYFHttpMethodPATCH;
// The HTTP method for the request, the string is "PUT".
FOUNDATION_EXPORT NSString *const DYFHttpMethodPUT;
// The HTTP method for the request, the string is "DELETE".
FOUNDATION_EXPORT NSString *const DYFHttpMethodDELETE;

// The HTTP status code of the receiver.
static const NSInteger DYFURLNoError = 200;

// Returned when an asynchronous operation times out. NSURLSession sends this error to its delegate when the timeoutInterval of an NSURLRequest expires before a load can complete.
static const NSInteger DYFURLErrorTimeout = NSURLErrorTimedOut;

// Returned when a network resource was requested, but an internet connection is not established and cannot be established automatically, either through a lack of connectivity, or by the user's choice not to make a network connection automatically.
static const NSInteger DYFURLErrorDisconnection = NSURLErrorNotConnectedToInternet;

// A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
typedef void (^DYFURLSessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);

// A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
typedef void (^DYFURLSessionTaskUploadProgressHandler)(NSProgress *uploadProgress);

// A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
typedef void (^DYFURLSessionTaskDownloadProgressHandler)(NSProgress *downloadProgress);

// A block to be executed when a task finishes. This block has no return value and takes two arguments: the server response, the path of the downloaded file, if any.
typedef NSURL *(^DYFURLSessionTaskDestinationHandler)(NSURL *targetPath, NSURLResponse *response);

@interface DYFHttpClient : NSObject

// The acceptable MIME types for responses. When non-`nil`, responses with a `Content-Type` with MIME types that do not intersect with the set will result in an error during validation.
// e.g.: @"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", @"image/jpeg".
@property (nonatomic, strong) NSSet *acceptableContentTypes;

// `AFSecurityPolicy` evaluates server trust against pinned X.509 certificates and public keys over secure connections.
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

// Creates and returns an `DYFHttpClient` instance.
+ (instancetype)httpClient;

// Creates an `NSMutableURLRequest` object with the specified HTTP method and URL string.
// The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
// The timeout interval, in seconds, for created requests. The default timeout interval is 60 seconds.
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters;

// Creates an `NSMutableURLRequest` object with the specified HTTP method and URL string.
// The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
// The timeout interval, in seconds, for created requests. The default timeout interval is 60 seconds.
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval;

// Creates an `NSURLSessionDataTask` with the specified request for a local file.
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler;

// Creates an `NSURLSessionDataTask` with the specified request for a local file.
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(DYFURLSessionTaskUploadProgressHandler)uploadProgressHandler
                             downloadProgress:(DYFURLSessionTaskDownloadProgressHandler)downloadProgressHandler
                            completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler;

// Creates an `NSURLSessionUploadTask` with the specified request for a local file.
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(DYFURLSessionTaskUploadProgressHandler)uploadProgressHandler
                                completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler;

// Creates an `NSURLSessionDownloadTask` with the specified request.
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(DYFURLSessionTaskDownloadProgressHandler)downloadProgressHandler
                                          destination:(DYFURLSessionTaskDestinationHandler)destinationHandler
                                    completionHandler:(DYFURLSessionTaskCompletionHandler)completionHandler;

@end

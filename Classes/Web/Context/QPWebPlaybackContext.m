//
//  QPWebPlaybackContext.m
//  QPlayer
//
//  Created by chenxing on 2023/3/9.
//  Copyright © 2023 chenxing. All rights reserved.
//

#import "QPWebPlaybackContext.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@interface QPWebPlaybackContext ()

@end

@implementation QPWebPlaybackContext

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter viewController:(QPBaseViewController *)viewController
{
    if (self = [super init]) {
        self.adapter = adapter;
        self.controller = viewController;
    }
    return  self;
}

- (BOOL)canAllowNavigation:(NSURL *)URL
{
    NSString *url = URL.absoluteString;
    NSString *host = [URL host];
    QPLog(@":: host=%@", host);
    if ([host containsString:@"zuida.com"] || [host containsString:@".zuida"] || [host containsString:@"zuida"]) {
        if ([url containsString:@"?url="]) { // host is zuidajiexi.net
            NSString *videoUrl = [url componentsSeparatedByString:@"?url="].lastObject;
            [self attemptToPlayVideo:videoUrl];
            return NO;
        } else {
            if (![self parse80sHtmlWithURL:URL]) {
                [self delayToScheduleTask:1.0 completion:^{
                    [QPHudUtils hideHUD];
                }];
                return YES;
            }
            return NO;
        }
    } else if ([host isEqualToString:@"jx.yingdouw.com"]) {
        NSString *videoUrl = [url componentsSeparatedByString:@"?id="].lastObject;
        [self attemptToPlayVideo:videoUrl];
        return NO;
    } else if ([host isEqualToString:@"www.boqudy.com"]) {
        if ([url containsString:@"?videourl="]) {
            NSString *tempStr = [url componentsSeparatedByString:@"?videourl="].lastObject;
            NSString *videoUrl = [tempStr componentsSeparatedByString:@","].lastObject;
            [self attemptToPlayVideo:videoUrl];
            return NO;
        }
    }
    return YES;
}

- (BOOL)parse80sHtmlWithURL:(NSURL *)URL
{
    [QPHudUtils showActivityMessageInView:@"正在解析..."];
    BOOL shouldPlay = NO;
    NSURL *aURL = [URL copy];
    NSString *htmlString = [NSString stringWithContentsOfURL:aURL encoding:NSUTF8StringEncoding error:NULL];
    //QPLog(@":: htmlString=%@", htmlString);
    
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    if (!document) {
        return shouldPlay;
    }
    
    OCGumboNode *titleElement = document.Query(@"head").find(@"title").first();
    NSString *title = titleElement.html();
    QPLog(@":: title=%@", title);
    OCQueryObject *objArray = document.Query(@"body").find(@"script");
    for (OCGumboNode *e in objArray) {
        NSString *text = e.html();
        //QPLog(@":: e.text=%@", text);
        NSString *keywords = @"var main";
        if (text && text.length > 0 && [text containsString:keywords]) {
            NSArray *argArray = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";\""]];
            for (int i = 0; i < argArray.count; i++) {
                NSString *arg = [argArray objectAtIndex:i];
                //QPLog(@":: arg=%@", arg);
                if ([arg containsString:keywords]) {
                    shouldPlay = YES;
                    int index = (i+1);
                    if (index < argArray.count) {
                        NSString *tempUrl  = [argArray objectAtIndex:index];
                        NSString *videoUrl = [tempUrl componentsSeparatedByString:@"?"].firstObject;
                        videoUrl = [NSString stringWithFormat:@"%@://%@%@", aURL.scheme, aURL.host, videoUrl];
                        QPLog(@":: videoUrl=%@", videoUrl);
                        [self playVideoWithTitle:title urlString:videoUrl];
                    }
                    break;
                }
            }
        }
    }
    
    return shouldPlay;
}

- (void)evaluateJavaScriptForVideoSrc
{
    NSString *jsStr = @"document.getElementsByTagName('video')[0].src";
    [self.adapter.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if(![response isEqual:[NSNull null]] && response != nil) {
            // 截获到视频地址
            NSString *videoUrl = (NSString *)response;
            QPLog(@":: videoUrl=%@", videoUrl);
            [self attemptToPlayVideo:videoUrl];
        } else {
            QPLog(@":: error=%@", error);
        }
    }];
}

- (void)attemptToPlayVideo:(NSString *)url
{
    QPLog(@":: videoUrl=%@", url);
    [QPHudUtils showActivityMessageInView:@"正在解析..."];
    NSString *videoTitle = self.adapter.webView.title;
    QPLog(@":: videoTitle=%@", videoTitle);
    if (url && url.length > 0 && [url hasPrefix:@"http"]) {
        [self playVideoWithTitle:videoTitle urlString:url];
    } else {
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
        }];
    }
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString
{
    [self playVideoWithTitle:title urlString:urlString usingMediaPlayer:NO];
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString usingMediaPlayer:(BOOL)usingMediaPlayer
{
    if (!QPPlayerIsPlaying()) {
        QPPlayerSavePlaying(YES);
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
            QPPlayerModel *model = [[QPPlayerModel alloc] init];
            model.videoTitle     = title;
            model.videoUrl       = urlString;
            if (usingMediaPlayer) {
                model.isMediaPlayerPlayback = YES;
            } else {
                model.isZFPlayerPlayback = YES;
            }
            QPPlayerController *qpc = [[QPPlayerController alloc] initWithModel:model];
            [self.yf_currentViewController.navigationController pushViewController:qpc animated:YES];
        }];
    }
}

@end

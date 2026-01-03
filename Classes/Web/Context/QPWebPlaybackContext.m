//
//  QPWebPlaybackContext.m
//  QPlayer
//
//  Created by Tenfay on 2023/3/9.
//  Copyright © 2023 Tenfay. All rights reserved.
//

#import "QPWebPlaybackContext.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"
#import "QPWebVideoListView.h"

@interface QPWebPlaybackContext ()

@end

@implementation QPWebPlaybackContext

- (instancetype)initWithAdapter:(QPWKWebViewAdapter *)adapter viewController:(BaseViewController *)viewController
{
    if (self = [super init]) {
        self.adapter = adapter;
        self.controller = viewController;
        self.playerType = QPPlayerTypeZFPlayer;
    }
    return  self;
}

//- (void)queryVideoCurrentSrcByJavaScript
//{
//    // currentSrc: 只能返回视频地址，不能设置，并且要等到视频加载好了并且可以播放时才能获取到
//    NSString *js = @"document.querySelector('video').currentSrc";
//    QPLog(@"js=%@", js);
//    @QPWeakify(self);
//    [self.adapter.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            QPLog(@"error=%zi, %@", error.code, error.localizedDescription);
//        }
//        if ([weak_self handleJSResp:response]) {
//            QPLog(@"js ok(currentSrc).");
//        }
//    }];
//}

//- (void)queryVideoUrlByJavaScript
//{
//    NSString *js = @"document.getElementsByTagName('video')[0].src";
//    QPLog(@"js=%@", js);
//    @QPWeakify(self);
//    [self.adapter.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//        if(error) {
//            QPLog(@"error=%zi, %@", error.code, error.localizedDescription);
//        }
//        if ([weak_self handleJSResp:response]) {
//            QPLog(@"js ok(src).");
//        }
//    }];
//}

- (void)queryVideoUrlByCustomJavaScript
{
    NSString *jsPath = [NSBundle.mainBundle pathForResource:@"jsquery_video_srcy" ofType:@"js"];
    NSData *jsData = [NSData dataWithContentsOfFile:jsPath];
    NSString *jsString = [NSString.alloc initWithData:jsData encoding:NSUTF8StringEncoding];
    //QPLog(@"jsString=%@", jsString);
    @QPWeakify(self);
    [self.adapter.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            QPLog(@"jsString error=%zi, %@.", error.code, error.localizedDescription);
        }
        if ([weak_self handleJSResp:response]) {
            QPLog(@"jsString ok.");
        }
    }];
}

- (NSArray *)filterResponseData:(NSArray *)response {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
        if (![obj isKindOfClass:NSString.class]) {
            return NO;
        }
        NSString *url = (NSString *)obj;
        // 检查是否以 .html 结尾
        BOOL endsWithHtml = [url.lowercaseString hasSuffix:@".html"];
        // 检查是否包含 = 符号
        BOOL containsEqual = [url.lowercaseString containsString:@"="];
        
        // 返回既不以 .html 结尾 也不包含 = 的 URL
        return !endsWithHtml && !containsEqual;
    }];
    return [response filteredArrayUsingPredicate:predicate];
}

- (BOOL)handleJSResp:(id)response
{
    if(![response isEqual:[NSNull null]] && response != nil) {
        if (![response isKindOfClass:NSArray.class]) {
            return NO;
        }
        NSArray *tempArr = (NSArray *)response;
        // 获取视频地址
        NSArray *videoUrls = [self filterResponseData: tempArr];
        QPLog(@"tempArr: %@, videoUrls: %@", tempArr, videoUrls);
        [self showWebVideoListView:videoUrls];
        return YES;
    }
    return NO;
}

- (void)showWebVideoListView:(NSArray *)urls
{
    if (urls.count == 0) {
        return;
    }
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([QPWebVideoListView class]) bundle:nil];
    QPWebVideoListView *webVideoListView = [nib instantiateWithOwner:nil options:nil].firstObject;
    webVideoListView.left   = 43.f;
    webVideoListView.height = 320.f;
    webVideoListView.top    = (self.adapter.webView.height - webVideoListView.height) / 2.0;
    webVideoListView.width  = self.controller.view.width - 2*webVideoListView.left;
    
    [webVideoListView autoresizing];
    [self.controller.view addSubview:webVideoListView];
    [self.controller.view bringSubviewToFront:webVideoListView];
    
    //webVideoListView.alpha = 0.f;
    webVideoListView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3 animations:^{
        //webVideoListView.alpha = 1.f;
        webVideoListView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        webVideoListView.transform = CGAffineTransformIdentity;
    }];
    [webVideoListView.presenter loadData:urls];
    
    @QPWeakify(self);
    [webVideoListView onSelectRow:^(NSInteger selectedRow, NSString *title, NSString *content) {
        @QPStrongify(self);
        NSString *videoUrl = [content copy];
        [strong_self attemptToPlayVideo:videoUrl];
    }];
    
    [webVideoListView onCloseAction:^{}];
}

//- (BOOL)canAllowNavigation:(NSURL *)URL
//{
//    NSString *url = URL.absoluteString;
//    NSString *host = [URL host];
//    QPLog(@"host=%@", host);
//    if ([host containsString:@"zuida.com"] || [host containsString:@".zuida"] || [host containsString:@"zuida"]) {
//        if ([url containsString:@"?url="]) { // host is zuidajiexi.net
//            NSString *videoUrl = [url componentsSeparatedByString:@"?url="].lastObject;
//            [self attemptToPlayVideo:videoUrl];
//            return NO;
//        } else {
//            if (![self parse80sHtmlWithURL:URL]) {
//                [self delayToScheduleTask:1.0 completion:^{
//                    [QPHudUtils hideHUD];
//                }];
//                return YES;
//            }
//            return NO;
//        }
//    } else if ([host isEqualToString:@"jx.yingdouw.com"]) {
//        NSString *videoUrl = [url componentsSeparatedByString:@"?id="].lastObject;
//        [self attemptToPlayVideo:videoUrl];
//        return NO;
//    } else if ([host isEqualToString:@"www.boqudy.com"]) {
//        if ([url containsString:@"?videourl="]) {
//            NSString *tempStr = [url componentsSeparatedByString:@"?videourl="].lastObject;
//            NSString *videoUrl = [tempStr componentsSeparatedByString:@","].lastObject;
//            [self attemptToPlayVideo:videoUrl];
//            return NO;
//        }
//    }
//    return YES;
//}

//- (BOOL)parse80sHtmlWithURL:(NSURL *)URL
//{
//    [QPHudUtils showActivityMessageInView:@"加载中，请稍等"];
//    BOOL shouldPlay = NO;
//    NSURL *aURL = [URL copy];
//    NSString *htmlString = [NSString stringWithContentsOfURL:aURL encoding:NSUTF8StringEncoding error:NULL];
//    //QPLog(@"htmlString=%@", htmlString);
//
//    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
//    if (!document) {
//        return shouldPlay;
//    }
//
//    OCGumboNode *titleElement = document.Query(@"head").find(@"title").first();
//    NSString *title = titleElement.html();
//    QPLog(@"title=%@", title);
//    OCQueryObject *objArray = document.Query(@"body").find(@"script");
//    for (OCGumboNode *e in objArray) {
//        NSString *text = e.html();
//        //QPLog(@"e.text=%@", text);
//        NSString *keywords = @"var main";
//        if (text && text.length > 0 && [text containsString:keywords]) {
//            NSArray *argArray = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";\""]];
//            for (int i = 0; i < argArray.count; i++) {
//                NSString *arg = [argArray objectAtIndex:i];
//                //QPLog(@"arg=%@", arg);
//                if ([arg containsString:keywords]) {
//                    shouldPlay = YES;
//                    int index = (i+1);
//                    if (index < argArray.count) {
//                        NSString *tempUrl  = [argArray objectAtIndex:index];
//                        NSString *videoUrl = [tempUrl componentsSeparatedByString:@"?"].firstObject;
//                        videoUrl = [NSString stringWithFormat:@"%@://%@%@", aURL.scheme, aURL.host, videoUrl];
//                        QPLog(@"videoUrl=%@", videoUrl);
//                        [self playVideoWithTitle:title urlString:videoUrl playerType:self.playerType];
//                    }
//                    break;
//                }
//            }
//        }
//    }
//
//    return shouldPlay;
//}

- (void)attemptToPlayVideo:(NSString *)url
{
    [QPHudUtils showActivityMessageInView:@"影片加载中..."];
    NSString *title = self.adapter.webView.title;
    QPLog(@"videoTitle=%@", title);
    QPLog(@"videoUrl=%@", url);
    if (url && url.length > 0 && [url hasPrefix:@"http"]) {
        [self playVideoWithTitle:title urlString:url playerType:QPPlayerUseIJKPlayer() ? QPPlayerTypeIJKPlayer : _playerType];
    } else {
        [self delayToScheduleTask:1.0 completion:^{
            [QPHudUtils hideHUD];
        }];
        [QPHudUtils showWarnMessage:@"未获取到播放地址，不能播放！"];
    }
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString
{
    [self playVideoWithTitle:title urlString:urlString playerType:_playerType];
}

- (void)playVideoWithTitle:(NSString *)title urlString:(NSString *)urlString playerType:(QPPlayerType)type
{
    QPPlaybackContext *context = QPPlaybackContext.alloc.init;
    [context playVideoWithTitle:title urlString:urlString playerType:type];
}

@end

//
//  QPWKWebViewAdapter.m
//
//  Created by dyf on 2015/6/18. ( https://github.com/dgynfi/QPlayer )
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "QPWKWebViewAdapter.h"

@interface QPWKWebViewAdapter ()

@end

@implementation QPWKWebViewAdapter

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // didStartProvisionalNavigation.
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    // didReceiveServerRedirectForProvisionalNavigation.
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //[self buildProgressView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //[self adjustThemeForWebView:webView];
    //[self removeProgressView];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //[self removeProgressView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //[self removeProgressView];
}

@end

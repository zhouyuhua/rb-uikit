//
//  UIWebView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/26/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWebView.h"
#import <WebKit/WebKit.h>
#import "UIAppKitView.h"

@implementation UIWebView {
    WebView *_webView;
    UIAppKitView *_adaptorView;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        _webView = [[WebView alloc] initWithFrame:self.bounds];
        [_webView setFrameLoadDelegate:self];
        [_webView setPolicyDelegate:self];
        _adaptorView = [[UIAppKitView alloc] initWithNativeView:_webView];
        _adaptorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_adaptorView];
    }
    
    return self;
}

#pragma mark - Loading Content

- (void)loadData:(NSData *)data MIMEType:(NSString *)mimeType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL
{
    [[_webView mainFrame] loadData:data MIMEType:mimeType textEncodingName:encodingName baseURL:baseURL];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    [[_webView mainFrame] loadHTMLString:string baseURL:baseURL];
}

- (void)loadRequest:(NSURLRequest *)request
{
    [[_webView mainFrame] loadRequest:request];
}

#pragma mark -

- (NSURLRequest *)request
{
    return [[[_webView mainFrame] dataSource] request];
}

- (BOOL)isLoading
{
    return [_webView isLoading];
}

#pragma mark -

- (void)stopLoading
{
    [[_webView mainFrame] stopLoading];
}

- (void)reload
{
    [[_webView mainFrame] reload];
}

#pragma mark - Moving Back and Forward

- (BOOL)canGoBack
{
    return [_webView canGoBack];
}

- (BOOL)canGoForward
{
    return [_webView canGoForward];
}

- (void)goBack
{
    [_webView goBack];
}

- (void)goForward
{
    [_webView goForward];
}

#pragma mark - Setting Web Content Properties

- (void)setScalesPageToFit:(BOOL)scalesPageToFit
{
    //Do nothing.
}

- (BOOL)scalesPageToFit
{
    return NO;
}

#pragma mark -

- (UIScrollView *)scrollView
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark -

- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering
{
    //Do nothing.
}

- (BOOL)suppressesIncrementalRendering
{
    return NO;
}

#pragma mark -

- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction
{
    //Do nothing.
}

- (BOOL)keyboardDisplayRequiresUserAction
{
    return NO;
}

#pragma mark - Running JavaScript

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)string
{
    return [_webView stringByEvaluatingJavaScriptFromString:string];
}

#pragma mark - Managing Media Playback

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback
{
    //Do nothing.
}

- (BOOL)allowsInlineMediaPlayback
{
    return YES;
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction
{
    //Do nothing.
}

- (BOOL)mediaPlaybackRequiresUserAction
{
    return NO;
}

- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay
{
    //Do nothing.
}

- (BOOL)mediaPlaybackAllowsAirPlay
{
    return YES;
}

#pragma mark - Managing Pages

- (NSUInteger)pageCount
{
    return 0;
}

- (CGFloat)pageLength
{
    return 0.0;
}

- (void)setPaginationMode:(UIWebPaginationMode)paginationMode
{
    UIKitUnimplementedMethod();
}

- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode
{
    UIKitUnimplementedMethod();
}

#pragma mark - <WebFrameLoadDelegate>

- (void)webView:(WebView *)webView didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if(frame == [webView mainFrame]) {
        if([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
            [self.delegate webViewDidStartLoad:self];
        }
    }
}

- (void)webView:(WebView *)webView didFinishLoadForFrame:(WebFrame *)frame
{
    if(frame == [webView mainFrame]) {
        if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
            [self.delegate webViewDidFinishLoad:self];
        }
    }
}

#pragma mark -

- (void)webView:(WebView *)webView didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if(frame == [webView mainFrame]) {
        if([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
            [self.delegate webView:self didFailLoadWithError:error];
        }
    }
}

- (void)webView:(WebView *)webView didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    if(frame == [webView mainFrame]) {
        if([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
            [self.delegate webView:self didFailLoadWithError:error];
        }
    }
}

#pragma mark - <WebPolicyDelegate>

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if(frame == [webView mainFrame] && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        /* UIWebViewNavigationType is compatible with WebNavigationType */
        UIWebViewNavigationType type = [actionInformation[WebActionNavigationTypeKey] unsignedIntegerValue];
        if([self.delegate webView:self shouldStartLoadWithRequest:request navigationType:type]) {
            [listener use];
        } else {
            [listener ignore];
        }
    } else {
        [listener use];
    }
}

@end

//
//  UIWebView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/26/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIDataDetectorTypes.h"

@protocol UIWebViewDelegate;
@class UIScrollView;

typedef NS_ENUM(NSInteger, UIWebPaginationMode) {
    UIWebPaginationModeUnpaginated,
    UIWebPaginationModeLeftToRight,
    UIWebPaginationModeTopToBottom,
    UIWebPaginationModeBottomToTop,
    UIWebPaginationModeRightToLeft
};

typedef NS_ENUM(NSInteger, UIWebPaginationBreakingMode) {
    UIWebPaginationBreakingModePage,
    UIWebPaginationBreakingModeColumn
};

typedef NS_ENUM(NSUInteger, UIWebViewNavigationType) {
    UIWebViewNavigationTypeLinkClicked,
    UIWebViewNavigationTypeFormSubmitted,
    UIWebViewNavigationTypeBackForward,
    UIWebViewNavigationTypeReload,
    UIWebViewNavigationTypeFormResubmitted,
    UIWebViewNavigationTypeOther
};

@interface UIWebView : UIView

#pragma mark - Setting the Delegate

@property (nonatomic, unsafe_unretained) id <UIWebViewDelegate> delegate;

#pragma mark - Loading Content

- (void)loadData:(NSData *)data MIMEType:(NSString *)mimeType textEncodingName:(NSString *)encodingName baseURL:(NSURL *)baseURL;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadRequest:(NSURLRequest *)request;

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, getter=isLoading) BOOL loading;

- (void)stopLoading;
- (void)reload;

#pragma mark - Moving Back and Forward

@property (nonatomic) BOOL canGoBack;
@property (nonatomic) BOOL canGoForward;

- (void)goBack;
- (void)goForward;

#pragma mark - Setting Web Content Properties

@property (nonatomic) BOOL scalesPageToFit UIKIT_STUB;
@property (nonatomic, readonly) UIScrollView *scrollView UIKIT_UNIMPLEMENTED;
@property (nonatomic) BOOL suppressesIncrementalRendering UIKIT_STUB;
@property (nonatomic) BOOL keyboardDisplayRequiresUserAction UIKIT_STUB;

#pragma mark - Running JavaScript

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)string;

#pragma mark - Detecting Types of Data

@property (nonatomic) UIDataDetectorTypes dataDetectorTypes UIKIT_UNIMPLEMENTED;

#pragma mark - Managing Media Playback

@property (nonatomic) BOOL allowsInlineMediaPlayback UIKIT_STUB;
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction UIKIT_STUB;
@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay UIKIT_STUB;

#pragma mark - Managing Pages

@property (nonatomic) CGFloat gapBetweenPages UIKIT_UNIMPLEMENTED;
@property (nonatomic, readonly) NSUInteger pageCount UIKIT_UNIMPLEMENTED;
@property (nonatomic, readonly) CGFloat pageLength UIKIT_UNIMPLEMENTED;
@property (nonatomic) UIWebPaginationBreakingMode paginationBreakingMode UIKIT_UNIMPLEMENTED;
@property (nonatomic) UIWebPaginationMode paginationMode UIKIT_UNIMPLEMENTED;

@end

#pragma mark -

@protocol UIWebViewDelegate <NSObject>
@optional

#pragma mark - Loading Content

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

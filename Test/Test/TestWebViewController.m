//
//  TestWebViewController.m
//  Test
//
//  Created by Kevin MacWhinnie on 9/26/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "TestWebViewController.h"

@interface TestWebViewController () <UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

@end

@implementation TestWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://apple.com"]]];
    
    self.toolbarItems = @[ [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self.webView action:@selector(goBack)],
                           [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self.webView action:@selector(goForward)],
                           [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:nil],
                           [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.webView action:@selector(reload)] ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.navigationItem.title = NSLocalizedString(@"Loading...", @"");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *errorTemplate = @"<html><title>Error</title><body><h2>Error</h2><p>%@</p>";
    NSString *errorHTML = [NSString stringWithFormat:errorTemplate, [error localizedDescription]];
    [webView loadHTMLString:errorHTML baseURL:nil];
}

@end

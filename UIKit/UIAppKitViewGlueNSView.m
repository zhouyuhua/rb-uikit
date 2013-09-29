//
//  UIAppKitAdaptorView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppKitViewGlueNSView.h"
#import "UIAppKitView.h"
#import "UIWindow_Private.h"
#import "UIWindowHostNativeView.h"

@interface UIAppKitViewGlueNSView ()

@property (nonatomic, unsafe_unretained, readwrite) UIAppKitView *appKitView;
@property (nonatomic, readwrite, assign) NSView *view;

@end

#pragma mark -

@implementation UIAppKitViewGlueNSView

#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithView:(NSView *)view appKitView:(UIAppKitView *)appKitView
{
    NSParameterAssert(view);
    NSParameterAssert(appKitView);
    
    if((self = [super initWithFrame:view.frame])) {
        self.wantsLayer = YES;
        
        self.view = view;
        self.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        self.view.frame = self.bounds;
        
        self.view.postsFrameChangedNotifications = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(viewFrameDidChange:)
                                                     name:NSViewFrameDidChangeNotification
                                                   object:self.view];
        
        [self addSubview:self.view];
        
        self.appKitView = appKitView;
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Overrides

- (BOOL)isFlipped
{
    return YES;
}

#pragma mark -

- (NSView *)hitTest:(NSPoint)point
{
    UIView *matchingView = [self.appKitView.window hitTest:point withEvent:nil];
    if(matchingView && matchingView != self.appKitView) {
        return nil;
    }
    
    return [super hitTest:point];
}

#pragma mark - Notifications

- (void)viewFrameDidChange:(NSNotification *)notification
{
    [self.appKitView reflectNativeViewSizeChange];
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    if(self.makeViewFirstResponderUponAdditionToWindow) {
        [self.window makeFirstResponder:self.view];
        
        self.makeViewFirstResponderUponAdditionToWindow = NO;
    }
}

@end

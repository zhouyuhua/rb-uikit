//
//  UIAppKitAdaptorView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppKitViewAdaptorNativeView.h"
#import "UIAppKitView.h"
#import "UIWindow_Private.h"
#import "UIWindowHostNativeView.h"

@interface UIAppKitViewAdaptorNativeView ()

@property (nonatomic, weak, readwrite) UIAppKitView *appKitView;
@property (nonatomic, readwrite, assign) NSView *view;

@end

#pragma mark -

@implementation UIAppKitViewAdaptorNativeView

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

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (BOOL)isFlipped
{
    return YES;
}

#pragma mark - Notifications

- (void)viewFrameDidChange:(NSNotification *)notification
{
    [self.appKitView reflectNativeViewSizeChange];
}

#pragma mark - Event Handling

- (NSView *)hitTest:(NSPoint)point
{
    UIView *matchingView = [self.appKitView.window hitTest:point withEvent:nil];
    if(matchingView && matchingView != self.appKitView) {
        return nil;
    }
    
    return [super hitTest:point];
}

@end

//
//  UIAppKitView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppKitView.h"
#import "UIWindow_Private.h"
#import "UIWindowHostNativeView.h"
#import "UIAppKitViewAdaptorNativeView.h"

@interface UIAppKitView ()

@property (nonatomic, readwrite) UIAppKitViewAdaptorNativeView *adaptorView;

@end

#pragma mark -

@implementation UIAppKitView

- (void)dealloc
{
    [self.layer removeObserver:self forKeyPath:@"position"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithView:(NSView *)view
{
    NSParameterAssert(view);
    
    if((self = [super initWithFrame:view.frame])) {
        view.wantsLayer = YES;
        self.adaptorView = [[UIAppKitViewAdaptorNativeView alloc] initWithView:view appKitView:self];
        
        [self.layer addObserver:self forKeyPath:@"position" options:0 context:NULL];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)init
{
    return [self initWithView:[NSView new]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.layer && [keyPath isEqualToString:@"position"]) {
        [self updateView];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Updating

- (void)layoutSubviews
{
    [self updateView];
}

- (void)updateView
{
    self.adaptorView.frame = [self.window convertRect:self.frame fromView:self.superview];
    self.adaptorView.layer.frame = self.bounds;
    [self.adaptorView resetCursorRects];
}

#pragma mark - Responder Business

- (BOOL)canBecomeFirstResponder
{
    return self.adaptorView.view.acceptsFirstResponder;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [self.adaptorView.view becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.adaptorView.view resignFirstResponder];
}

#pragma mark - Responding To Movements

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if(self.window) {
        [self.adaptorView removeFromSuperviewWithoutNeedingDisplay];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSViewFrameDidChangeNotification
                                                      object:newWindow._hostNativeView];
    }
}

- (void)didMoveToWindow
{
    if(self.window) {
        self.window._hostNativeView.postsFrameChangedNotifications = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(layoutSubviews)
                                                     name:NSViewFrameDidChangeNotification
                                                   object:self.window._hostNativeView];
        
        [self.window._hostNativeView addSubview:self.adaptorView];
        [self.adaptorView.layer removeFromSuperlayer];
        [self.layer addSublayer:self.adaptorView.layer];
        
        [self updateView];
    }
}

- (void)didMoveToSuperview
{
    [self updateView];
}

#pragma mark - Unsupported Things

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [NSException raise:NSInternalInconsistencyException format:@"You cannot put subviews inside of a %@", NSStringFromClass(self.class)];
}

@end

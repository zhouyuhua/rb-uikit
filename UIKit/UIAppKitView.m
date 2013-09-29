//
//  UIAppKitView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppKitView_Private.h"
#import <objc/runtime.h>

#import "UIWindow_Private.h"
#import "UIWindowHostNativeView.h"
#import "UIAppKitViewGlueNSView.h"
#import "UIScrollView.h"

static const char *kAdaptorViewKey = "com.roundabout.uikit.UIAppKitView/adaptor";

UIView *NSViewToUIView(NSView *view)
{
    if(!view)
        return nil;
    
    UIAppKitView *adaptor = objc_getAssociatedObject(view, kAdaptorViewKey);
    if(!adaptor) {
        adaptor = [[UIAppKitView alloc] initWithNativeView:view];
        objc_setAssociatedObject(view, kAdaptorViewKey, adaptor, OBJC_ASSOCIATION_ASSIGN);
    }
    
    return adaptor;
}

#pragma mark -

@implementation UIAppKitView

- (void)dealloc
{
    [self.layer removeObserver:self forKeyPath:@"position"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    objc_setAssociatedObject(self.nativeView, kAdaptorViewKey, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (instancetype)initWithNativeView:(NSView *)view
{
    NSParameterAssert(view);
    
    if((self = [super initWithFrame:view.frame])) {
        self.adaptorView = [[UIAppKitViewGlueNSView alloc] initWithView:view appKitView:self];
        
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
    return [self initWithNativeView:[NSView new]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"position"] || [keyPath isEqualToString:@"bounds"]) {
        [self performSelector:@selector(updateView) withObject:nil afterDelay:0.0];
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
    [self beginSupressingSizeChanges];
    {
        [self.adaptorView.layer removeFromSuperlayer];
        [self.layer addSublayer:self.adaptorView.layer];
        
        _lastKnownFrame = [self.window convertRect:self.frame fromView:self.superview];
        self.adaptorView.frame = _lastKnownFrame;
        self.adaptorView.layer.frame = self.bounds;
        [self.adaptorView resetCursorRects];
    }
    [self endSuppressingSizeChanges];
}

#pragma mark -

- (void)beginSupressingSizeChanges
{
    _suppressSizeChangeMessagesCount++;
}

- (void)endSuppressingSizeChanges
{
    if(_suppressSizeChangeMessagesCount > 0)
        _suppressSizeChangeMessagesCount--;
}

- (BOOL)isSuppressingSizeChanges
{
    return (_suppressSizeChangeMessagesCount > 0);
}

- (void)reflectNativeViewSizeChange
{
    if([self isSuppressingSizeChanges])
        return;
    
    CGRect currentFrame = self.nativeView.frame;
    if(!CGSizeEqualToSize(_lastKnownFrame.size, currentFrame.size)) {
        CGRect frame = self.frame;
        frame.size = currentFrame.size;
        self.frame = frame;
        
        if(_nativeViewSizeChangeObserver)
            _nativeViewSizeChangeObserver(currentFrame);
    }
}

#pragma mark - Responder Business

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (BOOL)canResignFirstResponder
{
    return NO;
}

- (BOOL)becomeFirstResponder
{
    NSLog(@"*** Warning, UIAppKitView does not support first responder status manipulation");
    return NO;
}

- (BOOL)resignFirstResponder
{
    NSLog(@"*** Warning, UIAppKitView does not support first responder status manipulation");
    return NO;
}

#pragma mark - First Responder Status

- (BOOL)canNativeViewBecomeFirstResponder
{
    return self.nativeView.canBecomeKeyView;
}

- (BOOL)makeNativeViewBecomeFirstResponder
{
    if(self.nativeView.window != nil) {
        return [self.nativeView.window makeFirstResponder:self.nativeView];
    } else {
        self.adaptorView.makeViewFirstResponderUponAdditionToWindow = YES;
        
        return YES;
    }
}

- (BOOL)makeNativeViewResignFirstResponder
{
    if(self.nativeView.window != nil) {
        return [self.nativeView.window makeFirstResponder:self.window._hostNativeView];
    } else {
        return YES;
    }
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

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if(self.enclosingScrollView) {
        [self.enclosingScrollView removeObserver:self forKeyPath:@"bounds"];
        self.enclosingScrollView = nil;
    }
}

- (void)didMoveToSuperview
{
    [self updateView];
    
    if([self.superview isKindOfClass:[UIScrollView class]]) {
        self.enclosingScrollView = (UIScrollView *)self.superview;
        [self.enclosingScrollView addObserver:self forKeyPath:@"bounds" options:kNilOptions context:NULL];
    }
}

#pragma mark - Unsupported Things

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [NSException raise:NSInternalInconsistencyException format:@"You cannot put subviews inside of a %@", NSStringFromClass(self.class)];
}

#pragma mark - Properties

- (void)setEnclosingScrollView:(UIScrollView *)enclosingScrollView
{
    _enclosingScrollView = enclosingScrollView;
    
    if([self.nativeView conformsToProtocol:@protocol(UIAppKitScrollViewAdaptor)]) {
        ((id <UIAppKitScrollViewAdaptor>)self.nativeView).UIScrollView = enclosingScrollView;
    }
}

- (NSView *)nativeView
{
    return _adaptorView.view;
}

@end

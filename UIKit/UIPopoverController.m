//
//  UIPopoverController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIPopoverController.h"

#import "UIBarButtonItem_Private.h"
#import "UIView_Private.h"

#import "UIButton.h"

#import "UIWindow_Private.h"
#import "UIWindowHostNativeView.h"

@interface UIPopoverController () <NSPopoverDelegate>

@property (nonatomic) NSPopover *_nativePopover;
@property (nonatomic) UIWindow *_window;

#pragma mark - readwrite

@property (nonatomic, getter=isPopovervisible, readwrite) BOOL popoverVisible;
@property (nonatomic, readwrite) UIPopoverArrowDirection popoverArrowDirection;

@end

#pragma mark -

@implementation UIPopoverController

#pragma mark - Initializing the Popover

- (instancetype)initWithContentViewController:(UIViewController *)controller
{
    if((self = [super initWithNibName:nil bundle:nil])) {
        self.contentViewController = controller;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithContentViewController:[UIViewController new]];
}

#pragma mark - Presenting and Dismissing the Popover

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animate
{
    NSParameterAssert(view);
    
    if(self.popoverVisible)
        return;
    
    UIView *presentingContext = (UIView *)view.window ?: view._topSuperview;
    
    self._nativePopover = [NSPopover new];
    self._nativePopover.behavior = NSPopoverBehaviorTransient;
    self._nativePopover.contentSize = self.popoverContentSize;
    self._nativePopover.delegate = self;
    [self._nativePopover setContentViewController:[NSViewController new]];
    
    if(self.backgroundColor.whiteComponent < 0.5 && ![self.backgroundColor isEqual:[UIColor clearColor]]) {
        self._nativePopover.appearance = NSPopoverAppearanceHUD;
    } else {
        self._nativePopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    CGRect frame = {CGPointZero, self.popoverContentSize};
    self._window = [[UIWindow alloc] initWithFrame:frame nativeWindow:nil];
    self._window.rootViewController = self.contentViewController;
    self._window._superwindow = presentingContext.window;
    
    self._nativePopover.contentViewController.view = self._window._hostNativeView;
    
    NSRectEdge popUpEdge = 0;
    if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionUp)) {
        popUpEdge = NSMinYEdge;
    } else if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionDown)) {
        popUpEdge = NSMaxYEdge;
    } else if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionLeft)) {
        popUpEdge = NSMaxXEdge;
    } else if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionRight)) {
        popUpEdge = NSMinXEdge;
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unsupported arrow direction given"];
    }
    
    NSRect popoverOriginFrame = [presentingContext.window convertRect:view.bounds fromView:view];
    [self._nativePopover showRelativeToRect:popoverOriginFrame
                                     ofView:presentingContext.window._hostNativeView
                              preferredEdge:popUpEdge];
    
    self.popoverVisible = YES;
    
    (void)(__bridge_retained CFTypeRef)(self); // [self retain];
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animate
{
    NSParameterAssert(item);
    
    UIView *itemView = item._itemView;
    [self presentPopoverFromRect:itemView.bounds inView:itemView permittedArrowDirections:arrowDirections animated:animate];
}

- (void)dismissPopoverAnimated:(BOOL)animate
{
    if(!self.popoverVisible)
        return;
    
    [self._nativePopover close];
    
    self._nativePopover = nil;
    self._window = nil;
    
    (void)(__bridge_transfer id)((__bridge CFTypeRef)(self)); // [self autorelease];
}

#pragma mark - Configuring the Popover Content

- (void)setContentViewController:(UIViewController *)contentViewController
{
    [self setContentViewController:contentViewController animated:NO];
}

- (void)setContentViewController:(UIViewController *)controller animated:(BOOL)animate
{
    [_contentViewController.view removeFromSuperview];
    [_contentViewController removeFromParentViewController];
    
    _contentViewController = controller;
    
    if(_contentViewController) {
        [self addChildViewController:_contentViewController];
        [self.view addSubview:_contentViewController.view];
    }
    
    [self setPopoverContentSize:controller.preferredContentSize animated:animate];
}

- (void)setPopoverContentSize:(CGSize)popoverContentSize
{
    [self setPopoverContentSize:popoverContentSize animated:NO];
}

- (void)setPopoverContentSize:(CGSize)popoverContentSize animated:(BOOL)animate
{
    _popoverContentSize = popoverContentSize;
    
    if(self._nativePopover)
        self._nativePopover.contentSize = popoverContentSize;
}

#pragma mark - Customizing the Popover Appearance

- (void)setPopoverBackgroundViewClass:(Class)popoverBackgroundViewClass
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"*** Warning, UIPopoverController does not support background view classes.");
    });
}

- (Class)popoverBackgroundViewClass
{
    return nil;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.view.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor
{
    return self.view.backgroundColor;
}

#pragma mark - <NSPopoverDelegate>

- (BOOL)popoverShouldClose:(NSPopover *)popover
{
    if([self.delegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)])
        return [self.delegate popoverControllerShouldDismissPopover:self];
    else
        return YES;
}

- (void)popoverDidClose:(NSNotification *)notification
{
    if([self.delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)])
        [self.delegate popoverControllerDidDismissPopover:self];
    
    self._nativePopover = nil;
    self._window = nil;
    
    (void)(__bridge_transfer id)((__bridge CFTypeRef)(self)); // [self autorelease];
}

@end

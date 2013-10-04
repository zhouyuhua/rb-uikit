//
//  UIPopoverController.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIPopoverController.h"

#import "_UIConcretePopoverBackgroundView.h"
#import "UIBarButtonItem_Private.h"
#import "UIView_Private.h"

#import "UIButton.h"

@interface UIPopoverController ()

@property (nonatomic) UIButton *shieldView;
@property (nonatomic) UIPopoverBackgroundView *backgroundView;

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
        self.popoverBackgroundViewClass = [_UIConcretePopoverBackgroundView class];
        self.contentViewController = controller;
        self.contentViewController.view.layer.cornerRadius = _UIPopoverCornerRadius;
        
        self.shieldView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shieldView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.shieldView addTarget:self action:@selector(_dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithContentViewController:[UIViewController new]];
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    _backgroundView.frame = bounds;
    
    CGRect contentViewFrame = UIEdgeInsetsInsetRect(bounds, [_backgroundView.class contentViewInsets]);
    switch (self.popoverArrowDirection) {
        case UIPopoverArrowDirectionUp:
            contentViewFrame.size.height -= [_popoverBackgroundViewClass arrowHeight];
            contentViewFrame.origin.y += [_popoverBackgroundViewClass arrowHeight];
            break;
            
        case UIPopoverArrowDirectionDown:
            contentViewFrame.size.height -= [_popoverBackgroundViewClass arrowHeight];
            break;
            
        case UIPopoverArrowDirectionLeft:
            contentViewFrame.size.width -= [_popoverBackgroundViewClass arrowBase];
            contentViewFrame.origin.x += [_popoverBackgroundViewClass arrowBase];
            break;
            
        case UIPopoverArrowDirectionRight:
            contentViewFrame.size.width -= [_popoverBackgroundViewClass arrowBase];
            break;
            
        default:
            break;
    }
    
    _contentViewController.view.frame = contentViewFrame;
}

#pragma mark - Internal Properties

- (void)setBackgroundView:(UIPopoverBackgroundView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    _backgroundView.userInteractionEnabled = YES;
    
    [self.view insertSubview:_backgroundView atIndex:0];
}

#pragma mark - Presenting and Dismissing the Popover

- (CGRect)_popoverFrameForArrowDirection:(UIPopoverArrowDirection)arrowDirection
                     inPresentingContext:(UIView *)contextView
                          fromOriginRect:(CGRect)popoverOriginRect
                     adjustedContentSize:(out BOOL *)outAdjustedContentSize
{
    NSParameterAssert(outAdjustedContentSize);
    
    CGSize contextViewSize = contextView.bounds.size;
    
    CGSize popoverSize = self.popoverContentSize;
    
    UIEdgeInsets contentViewInsets = [_popoverBackgroundViewClass contentViewInsets];
    if(UIKIT_FLAG_IS_SET(arrowDirection, UIPopoverArrowDirectionLeft) || UIKIT_FLAG_IS_SET(arrowDirection, UIPopoverArrowDirectionRight)) {
        popoverSize.width += [_popoverBackgroundViewClass arrowBase];
    }
    
    if(UIKIT_FLAG_IS_SET(arrowDirection, UIPopoverArrowDirectionUp) || UIKIT_FLAG_IS_SET(arrowDirection, UIPopoverArrowDirectionDown)) {
        popoverSize.height += [_popoverBackgroundViewClass arrowHeight];
    }
    
    popoverSize.width += contentViewInsets.left + contentViewInsets.right;
    popoverSize.height += contentViewInsets.top + contentViewInsets.bottom;
    
    if(popoverSize.width > contextViewSize.width) {
        popoverSize.width = contextViewSize.width;
        *outAdjustedContentSize = YES;
    }
    if(popoverSize.height > contextViewSize.height) {
        popoverSize.height = contextViewSize.height;
        *outAdjustedContentSize = YES;
    }
    
    CGRect frame = {CGPointZero, popoverSize};
    switch (arrowDirection) {
        case UIPopoverArrowDirectionUp: {
            frame.origin.x = CGRectGetMinX(popoverOriginRect);
            if(CGRectGetMaxX(frame) > contextViewSize.width) {
                frame.origin.x -= CGRectGetMaxX(frame) - contextViewSize.width;
            }
            
            frame.origin.y = CGRectGetMaxY(popoverOriginRect);
            
            break;
        }
            
        case UIPopoverArrowDirectionDown: {
            frame.origin.x = CGRectGetMinX(popoverOriginRect);
            if(CGRectGetMinX(frame) <= 0.0) {
                frame.origin.x = 0.0;
            }
            
            frame.origin.y = CGRectGetMinY(popoverOriginRect) - popoverSize.height;
            
            break;
        }
            
        case UIPopoverArrowDirectionLeft: {
            frame.origin.x = CGRectGetMaxX(popoverOriginRect);
            
            frame.origin.y = CGRectGetMinY(popoverOriginRect);
            if(CGRectGetMaxY(frame) > contextViewSize.height) {
                frame.origin.y -= CGRectGetMaxY(frame) - contextViewSize.height;
            }
            
            break;
        }
            
        case UIPopoverArrowDirectionRight: {
            frame.origin.x = CGRectGetMinX(popoverOriginRect) - popoverSize.width;
            
            frame.origin.y = CGRectGetMinY(popoverOriginRect);
            if(CGRectGetMinY(frame) <= 0.0) {
                frame.origin.y = 0.0;
            }
            
            break;
        }
            
        default: {
            break;
        }
    }
    
    if(!CGRectContainsRect(contextView.bounds, frame))
        return CGRectZero;
    
    return frame;
}

- (CGRect)_bestPopoverFrameForArrowDirections:(UIPopoverArrowDirection)arrowDirections
                          inPresentingContext:(UIView *)contextView
                               fromOriginRect:(CGRect)popoverOriginRect
                         chosenArrowDirection:(out UIPopoverArrowDirection *)outArrowDirection
{
    NSParameterAssert(outArrowDirection);
    
    BOOL didAdjustContentSize = NO;
    CGRect bestFrame = {};
    
    if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionUp)) {
        CGRect possibleFrame = [self _popoverFrameForArrowDirection:UIPopoverArrowDirectionUp
                                                inPresentingContext:contextView
                                                     fromOriginRect:popoverOriginRect
                                                adjustedContentSize:&didAdjustContentSize];
        *outArrowDirection = UIPopoverArrowDirectionUp;
        if(!didAdjustContentSize && !CGRectEqualToRect(possibleFrame, CGRectZero)) {
            return possibleFrame;
        } else {
            bestFrame = possibleFrame;
        }
    }
    
    if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionDown)) {
        CGRect possibleFrame = [self _popoverFrameForArrowDirection:UIPopoverArrowDirectionDown
                                                inPresentingContext:contextView
                                                     fromOriginRect:popoverOriginRect
                                                adjustedContentSize:&didAdjustContentSize];
        *outArrowDirection = UIPopoverArrowDirectionDown;
        if(!didAdjustContentSize && !CGRectEqualToRect(possibleFrame, CGRectZero)) {
            return possibleFrame;
        } else {
            bestFrame = possibleFrame;
        }
    }
    
    if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionLeft)) {
        CGRect possibleFrame = [self _popoverFrameForArrowDirection:UIPopoverArrowDirectionLeft
                                                inPresentingContext:contextView
                                                     fromOriginRect:popoverOriginRect
                                                adjustedContentSize:&didAdjustContentSize];
        *outArrowDirection = UIPopoverArrowDirectionLeft;
        if(!didAdjustContentSize && !CGRectEqualToRect(possibleFrame, CGRectZero)) {
            return possibleFrame;
        } else {
            bestFrame = possibleFrame;
        }
    }
    
    if(UIKIT_FLAG_IS_SET(arrowDirections, UIPopoverArrowDirectionRight)) {
        CGRect possibleFrame = [self _popoverFrameForArrowDirection:UIPopoverArrowDirectionRight
                                                inPresentingContext:contextView
                                                     fromOriginRect:popoverOriginRect
                                                adjustedContentSize:&didAdjustContentSize];
        *outArrowDirection = UIPopoverArrowDirectionRight;
        if(!didAdjustContentSize && !CGRectEqualToRect(possibleFrame, CGRectZero)) {
            return possibleFrame;
        } else {
            bestFrame = possibleFrame;
        }
    }
    
    if(CGRectEqualToRect(bestFrame, CGRectZero) && arrowDirections != UIPopoverArrowDirectionAny) {
        return [self _bestPopoverFrameForArrowDirections:UIPopoverArrowDirectionAny
                                     inPresentingContext:contextView
                                          fromOriginRect:popoverOriginRect
                                    chosenArrowDirection:outArrowDirection];
    }
    
    return bestFrame;
}

#pragma mark -

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animate
{
    NSParameterAssert(view);
    
    if(self.popoverVisible)
        return;
    
    UIView *presentingContext = (UIView *)view.window ?: view._topSuperview;
    CGRect popoverOriginRect = [presentingContext convertRect:rect fromView:view];
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionUnknown;
    CGRect popoverFrame = [self _bestPopoverFrameForArrowDirections:arrowDirections
                                                inPresentingContext:presentingContext
                                                     fromOriginRect:popoverOriginRect
                                               chosenArrowDirection:&arrowDirection];
    
    
    CGRect backgroundFrame = { CGPointZero, self.popoverContentSize };
    self.backgroundView = [[self.popoverBackgroundViewClass alloc] initWithFrame:backgroundFrame];
    self.backgroundView.arrowDirection = arrowDirection;
    self.backgroundView.arrowOffset = UIOffsetMake(CGRectGetMidX(popoverFrame) - CGRectGetMidX(popoverOriginRect),
                                                   CGRectGetMidY(popoverFrame) - CGRectGetMidY(popoverOriginRect));
    self.popoverArrowDirection = arrowDirection;
    
    
    self.shieldView.frame = presentingContext.bounds;
    [presentingContext addSubview:self.shieldView];
    
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 0.0;
    self.view.frame = popoverFrame;
    [presentingContext addSubview:self.view];
    
    self.popoverVisible = YES;
    
    [UIView animateWithDuration:(animate? UIKitAnimationDurationFast : 0.0) animations:^{
        self.view.alpha = 1.0;
    }];
    
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
    
    [UIView animateWithDuration:(animate? UIKitAnimationDuration : 0.0) animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.popoverVisible = NO;
        
        [self.shieldView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
    
    (void)(__bridge_transfer id)((__bridge_retained CFTypeRef)(self)); // [self autorelease];
}

#pragma mark -

- (void)_dismiss:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)]) {
        if(![self.delegate popoverControllerShouldDismissPopover:self])
            return;
    }
    
    [self dismissPopoverAnimated:YES];
    
    if([self.delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)])
        [self.delegate popoverControllerDidDismissPopover:self];
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
}

@end

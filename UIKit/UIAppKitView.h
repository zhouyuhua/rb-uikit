//
//  UIAppKitView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIAppKitView_h
#define UIAppKitView_h 1

#import "UIView.h"
#import <AppKit/NSView.h>

@class UIAppKitViewGlueNSView, UIScrollView;

///Converts an NSView into an equivalent UIView.
///
/// \param  view    The native NSView to convert into a UIView.
///
/// \result The passed in view wrapped into a UIView adaptor.
///
///This function returns the same adaptor view for any view passed in.
UIKIT_EXTERN UIView *NSViewToUIView(NSView *view);

///The UIAppKitView class encapsulates a simple adaptor to place NSViews into a UIView hierarchy.
///
///The UIAppKitView class does not itself accept first responder. It is assumed that clients
///of the class will manage native first responder and emulated first responder state.
@interface UIAppKitView : UIView

///Initialize the receiver with a given native NSView object.
///
/// \param  view    The native NSView to wrap. Required.
///
/// \result A fully initialized UIAppKitView.
///
///This is the designated initializer.
- (instancetype)initWithNativeView:(NSView *)view;

#pragma mark - Layout

///Updates the app kit view's frame to reflect the current geometry of its native view.
- (void)reflectNativeViewSizeChange;

///A block that is invoked whenever the native view changes its sizing.
@property (nonatomic, copy) void(^nativeViewSizeChangeObserver)(CGRect newFrame);

#pragma mark - Properties

///The adaptor view that sits between the UIAppKitView and the NSView.
@property (nonatomic, readonly) UIAppKitViewGlueNSView *adaptorView;

///The native view being wrapped.
@property (nonatomic, readonly) NSView *nativeView;

#pragma mark - First Responder Status

///Returns a BOOL indicating whether or not the native view can be made first responder.
- (BOOL)canNativeViewBecomeFirstResponder;

///Makes the native view the first responder in AppKit land.
- (BOOL)makeNativeViewBecomeFirstResponder;

///Makes the native view resign first responder status in AppKit land.
- (BOOL)makeNativeViewResignFirstResponder;

@end

#pragma mark -

///The UIAppKitScrollViewAdaptor protocol marks an NSView subclass
///as being able to embed itself within a UIScrollView.
@protocol UIAppKitScrollViewAdaptor <NSObject>

///The scroll view that visually contains the implementor of the protocol.
@property (nonatomic, unsafe_unretained) UIScrollView *UIScrollView;

@end

#endif /* UIAppKitView_h */

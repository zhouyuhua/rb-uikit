//
//  UIAppKitView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppKit/AppKit.h>

@class UIAppKitViewAdaptorNativeView;

///Converts an NSView into an equivalent UIView.
///
/// \param  view    The native NSView to convert into a UIView.
///
/// \result The passed in view wrapped into a UIView adaptor.
///
///This function returns the same adaptor view for any view passed in.
UIKIT_EXTERN UIView *NSViewToUIView(NSView *view);

///The UIAppKitView class encapsulates a simple adaptor to place NSViews into a UIView hierarchy.
@interface UIAppKitView : UIView

///Initialize the receiver with a given native NSView object.
///
/// \param  view    The native NSView to wrap. Required.
///
/// \result A fully initialized UIAppKitView.
///
///This is the designated initializer.
- (instancetype)initWithNativeView:(NSView *)view;

#pragma mark - Properties

///The adaptor view that sits between the UIAppKitView and the NSView.
@property (nonatomic, readonly) UIAppKitViewAdaptorNativeView *adaptorView;

///The native view being wrapped.
@property (nonatomic, readonly) NSView *nativeView;

@end

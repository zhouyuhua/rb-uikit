//
//  UIAppKitAdaptorView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UIAppKitView;

///The UIAppKitViewGlueNSView class acts as glue between a normal NSView
///instance and a UIAppKitView adaptor. It forwards sizing changes and manages
///changing responder status when a native window is not present.
@interface UIAppKitViewGlueNSView : NSView

///Initialize the receiver with a given view, and a containing app kit adaptor view. 
///
/// \param  view        The native view to provide glue for. Required.
/// \param  appKitView  The adaptor view. Required.
///
/// \result A fully initialized adaptor view ready to be used with an instance of UIAppKitView.
///
///This is the designated initializer.
- (instancetype)initWithView:(NSView *)view appKitView:(UIAppKitView *)appKitView;

#pragma mark - Properties

///The app kit view that this glue view is being used with.
@property (nonatomic, unsafe_unretained, readonly) UIAppKitView *appKitView;

///The native view being adapted.
@property (nonatomic, readonly, assign) NSView *view;

#pragma mark -

///Whether or not the view of the adaptor should be made first responder
///when the adaptor is added to an NSWindow instance.
///
///Resets to NO when the adaptor is added to an NSWindow instance. This
///property should be set in response to an AppKit view being made first
///responder before that view has a native window associated with it.
@property (nonatomic) BOOL makeViewFirstResponderUponAdditionToWindow;

@end

//
//  UIControl.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@class UITouch;

typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
    UIControlEventTouchDown           = 1 <<  0,      // on all touch downs
    UIControlEventTouchDownRepeat     = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    UIControlEventTouchDragInside     = 1 <<  2, 
    UIControlEventTouchDragOutside    = 1 <<  3, 
    UIControlEventTouchDragEnter      = 1 <<  4, 
    UIControlEventTouchDragExit       = 1 <<  5, 
    UIControlEventTouchUpInside       = 1 <<  6, 
    UIControlEventTouchUpOutside      = 1 <<  7, 
    UIControlEventTouchCancel         = 1 <<  8, 
    
    UIControlEventValueChanged        = 1 << 12,     // sliders, etc.
    
    UIControlEventEditingDidBegin     = 1 << 16,     // UITextField
    UIControlEventEditingChanged      = 1 << 17, 
    UIControlEventEditingDidEnd       = 1 << 18, 
    UIControlEventEditingDidEndOnExit = 1 << 19,     // 'return key' ending editing
    
    UIControlEventAllTouchEvents      = 0x00000FFF,  // for touch events
    UIControlEventAllEditingEvents    = 0x000F0000,  // for UITextField
    UIControlEventApplicationReserved = 0x0F000000,  // range available for application use
    UIControlEventSystemReserved      = 0xF0000000,  // range reserved for internal framework use
    UIControlEventAllEvents           = 0xFFFFFFFF
};

typedef NS_ENUM(NSInteger, UIControlContentVerticalAlignment) {
    UIControlContentVerticalAlignmentCenter  = 0, 
    UIControlContentVerticalAlignmentTop     = 1, 
    UIControlContentVerticalAlignmentBottom  = 2, 
    UIControlContentVerticalAlignmentFill    = 3, 
};

typedef NS_ENUM(NSInteger, UIControlContentHorizontalAlignment) {
    UIControlContentHorizontalAlignmentCenter = 0, 
    UIControlContentHorizontalAlignmentLeft   = 1, 
    UIControlContentHorizontalAlignmentRight  = 2, 
    UIControlContentHorizontalAlignmentFill   = 3, 
};

typedef NS_ENUM(NSInteger, UIControlState) {
    UIControlStateNormal               = 0, 
    UIControlStateHighlighted          = 1 << 0, 
    UIControlStateDisabled             = 1 << 1, 
    UIControlStateSelected             = 1 << 2, 
    UIControlStateApplication          = 0x00FF0000, 
    UIControlStateReserved             = 0xFF000000
};

@interface UIControl : UIView

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

#pragma mark -

@property (nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
@property (nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;

#pragma mark -

@property (nonatomic, readonly) UIControlState state;

#pragma mark - Tracking

@property (nonatomic, readonly, getter=isTracking) BOOL tracking;
@property (nonatomic, readonly, getter=isTouchInside) BOOL touchInside;

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)cancelTrackingWithEvent:(UIEvent *)event;

#pragma mark - Actions

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (NSSet *)allTargets;
- (UIControlEvents)allControlEvents;
- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent;

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;

@end

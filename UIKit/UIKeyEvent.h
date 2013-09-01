//
//  UIKeyEvent.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/19/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, UIKeyMask) {
    UIKeyMaskAlphaShift = NSAlphaShiftKeyMask,
    UIKeyMaskShift = NSShiftKeyMask,
    UIKeyMaskControl = NSControlKeyMask,
    UIKeyMaskAlternate = NSAlternateKeyMask,
    UIKeyMaskCommand = NSCommandKeyMask,
    UIKeyMaskNumericPad = NSNumericPadKeyMask,
    UIKeyMaskHelp = NSHelpKeyMask,
    UIKeyMaskFunction = NSFunctionKeyMask,
    UIKeyMaskDeviceIndependent = NSDeviceIndependentModifierFlagsMask
};

typedef NS_ENUM(NSUInteger, UIKeyEventType) {
    UIKeyEventTypeKeyDown = NSKeyDown,
    UIKeyEventTypeKeyUp = NSKeyUp
};

@interface UIKeyEvent : NSObject

@property (nonatomic, readonly) NSTimeInterval timestamp;
@property (nonatomic, readonly) UIKeyEventType type;
@property (nonatomic, readonly) unsigned short keyCode;
@property (nonatomic, readonly) UIKeyMask modifierFlags;
@property (nonatomic, getter = isRepeat, readonly) BOOL repeat;

@end
//
//  UIHostView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UIWindow;

@interface UIWindowHostNativeView : NSView <NSUserInterfaceValidations>

@property (nonatomic, unsafe_unretained) UIWindow *kitWindow;

@end

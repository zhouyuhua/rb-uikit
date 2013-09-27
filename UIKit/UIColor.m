//
//  UIColor.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIColor.h"
#import <objc/runtime.h>
#import "UIImage_Private.h"

///A pair of selectors that describe UIColor methods
///that may be missing, and their NSColor equivalents.
typedef struct MethodPair {
    ///The UIColor method selector.
    SEL UIColorSelector;
    
    ///The NSColor equivalent method selector.
    SEL NSColorSelector;
} MethodPair;

@implementation NSColor (UIColor_Implementation)

+ (void)load
{
    /*
     Mavericks adds the following methods to NSColor, so just injecting them
     in a category results in compiler warnings and unnecessarily replaces
     native implementations of the methods that may be faster. As such, the
     following code checks for the presence of these methods, and provides
     implementations if they are missing for Mountain Lion.
     */
    MethodPair const methodPairs[] = {
        { @selector(colorWithWhite:alpha:), @selector(colorWithDeviceWhite:alpha:) },
        { @selector(colorWithHue:saturation:brightness:alpha:), @selector(colorWithDeviceHue:saturation:brightness:alpha:) },
        { @selector(colorWithRed:green:blue:alpha:), @selector(colorWithDeviceRed:green:blue:alpha:) },
    };
    
    Class metaclass = object_getClass(self);
    for (size_t index = 0, count = (sizeof(methodPairs) / sizeof(methodPairs[0])); index < count; index++) {
        MethodPair methodPair = methodPairs[index];
        if(!class_getClassMethod(self, methodPair.UIColorSelector)) {
            Method method = class_getClassMethod(self, methodPair.NSColorSelector);
            class_addMethod(metaclass, methodPair.UIColorSelector, method_getImplementation(method), method_getTypeEncoding(method));
        }
    }
    
    method_exchangeImplementations(class_getClassMethod(self.class, @selector(colorWithPatternImage:)),
                                   class_getClassMethod(self.class, @selector(UIKit_colorWithPatternImage:)));
    
    /*
     It's possible someone has looked up UIColor using NSClassFromString
     so this just ensures they actually get back something.
     */
    Class runtimeUIColor = objc_allocateClassPair([NSColor class], "UIColor", 0);
    objc_registerClassPair(runtimeUIColor);
}

#pragma mark -

- (UIColor *)UIKit_colorWithPatternImage:(id)image
{
    NSImage *pattern = image;
    if([image isKindOfClass:[UIImage class]])
        pattern = [image NSImage];
    
    return [self UIKit_colorWithPatternImage:pattern];
}

@end

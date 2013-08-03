//
//  UIColor.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIColor.h"

@implementation NSColor (UIColor)

+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha
{
    return (UIColor *)[self colorWithDeviceWhite:white alpha:alpha];
}

+ (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha
{
    return (UIColor *)[self colorWithDeviceHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return (UIColor *)[self colorWithDeviceRed:red green:green blue:blue alpha:alpha];
}

@end

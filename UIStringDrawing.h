//
//  NSString+UIStringDrawing.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AppKit/NSStringDrawing.h>
#import "UIFont.h"

typedef NS_ENUM(NSInteger, UIBaselineAdjustment) {
    UIBaselineAdjustmentAlignBaselines = 0,
    UIBaselineAdjustmentAlignCenters,
    UIBaselineAdjustmentNone,
};

@interface NSString (UIStringDrawing)

#pragma mark - Computing Metrics for a Single Line of Text

- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(out CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark - Computing Metrics for Multiple Lines of Text

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)boundingSize;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark - Drawing Strings on a Single Line

- (void)drawAtPoint:(CGPoint)point withFont:(UIFont *)font;
- (void)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;
- (void)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(out CGFloat *)actualFontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;

#pragma mark - Drawing Strings in a Given Area

- (void)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font;
- (void)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)textAlignment;

@end

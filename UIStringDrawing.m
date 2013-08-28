//
//  UIStringDrawing.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIStringDrawing.h"

#import <CoreText/CoreText.h>

static NSLayoutManager *NSLayoutManagerForString(NSString *string, UIFont *font, CGRect boundingFrame, NSLineBreakMode lineBreakMode)
{
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:boundingFrame.size];
    textContainer.lineFragmentPadding = 0.0;
    [layoutManager addTextContainer:textContainer];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string attributes:@{NSFontAttributeName: font,
                                                                                           NSParagraphStyleAttributeName: paragraphStyle}];
    [layoutManager setTextStorage:textStorage];
    
    return layoutManager;
}

#pragma mark -

@implementation NSString (UIStringDrawing)

#pragma mark - Computing Metrics for a Single Line of Text

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font forWidth:CGFLOAT_MAX lineBreakMode:NSLineBreakByClipping];
}

- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)sizeWithFont:(UIFont *)font minFontSize:(CGFloat)minFontSize actualFontSize:(out CGFloat *)actualFontSize forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    UIKitUnimplementedMethod();
    return CGSizeZero;
}

#pragma mark - Computing Metrics for Multiple Lines of Text

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)boundingSize
{
    return [self sizeWithFont:font constrainedToSize:boundingSize lineBreakMode:NSLineBreakByClipping];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)boundingSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSLayoutManager *layoutManager = NSLayoutManagerForString(self, font, CGRectMake(0.0, 0.0, boundingSize.width, boundingSize.height), lineBreakMode);
    
    NSTextContainer *textContainer = layoutManager.textContainers.firstObject;
    [layoutManager glyphRangeForTextContainer:textContainer]; //Force layout.
    
    return [layoutManager usedRectForTextContainer:textContainer].size;
}

#pragma mark - Drawing Strings on a Single Line

- (void)drawAtPoint:(CGPoint)point withFont:(UIFont *)font
{
    [self drawAtPoint:point forWidth:CGFLOAT_MAX withFont:font lineBreakMode:NSLineBreakByClipping];
}

- (void)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self drawAtPoint:point forWidth:width
             withFont:font
             fontSize:font.pointSize
        lineBreakMode:lineBreakMode
   baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

- (void)drawAtPoint:(CGPoint)point
           forWidth:(CGFloat)width
           withFont:(UIFont *)font
           fontSize:(CGFloat)fontSize
      lineBreakMode:(NSLineBreakMode)lineBreakMode
 baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    UIKitUnimplementedMethod();
}

- (void)drawAtPoint:(CGPoint)point
           forWidth:(CGFloat)width
           withFont:(UIFont *)font
        minFontSize:(CGFloat)minFontSize
     actualFontSize:(out CGFloat *)actualFontSize
      lineBreakMode:(NSLineBreakMode)lineBreakMode
 baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    UIKitUnimplementedMethod();
}

#pragma mark - Drawing Strings in a Given Area

- (void)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font
{
    [self drawInRect:drawingRect withFont:font lineBreakMode:NSLineBreakByClipping];
}

- (void)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self drawInRect:drawingRect withFont:font lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

- (void)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)textAlignment
{
    NSLayoutManager *layoutManager = NSLayoutManagerForString(self, font, drawingRect, lineBreakMode);
    
    NSTextStorage *textStorage = layoutManager.textStorage;
    NSMutableParagraphStyle *paragraphStyle = [textStorage attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
    paragraphStyle.alignment = textAlignment;
    
    [layoutManager drawGlyphsForGlyphRange:NSMakeRange(0, textStorage.length) atPoint:drawingRect.origin];
}

@end

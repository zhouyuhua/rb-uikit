//
//  UIStringDrawing.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIStringDrawing.h"

#import <CoreText/CoreText.h>
#import "UIGraphics.h"

static float NSTextAlignmentToFlushFactor(NSTextAlignment textAlignment)
{
    if(textAlignment == NSTextAlignmentCenter)
        return 0.5;
    else if(textAlignment == NSTextAlignmentRight)
        return 1.0;
    
    return 0.0; //Left
}

static CTLineRef GetSharedElipsisLine(void)
{
    static CTLineRef elipsis = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        elipsis = CTLineCreateWithAttributedString((CFAttributedStringRef)[[NSAttributedString alloc] initWithString:@"…"]);
    });
    
    return elipsis;
}

static NSArray *CreateLinesForString(NSString *string, UIFont *font, NSLineBreakMode lineBreakMode, CGSize boundingSize, CGSize *outRenderSize)
{
    NSDictionary *attributes = @{ (id)kCTForegroundColorFromContextAttributeName: @YES,
                                  (id)kCTFontAttributeName: font };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    NSMutableArray *lines = [NSMutableArray array];
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CGSize renderSize = CGSizeZero;
    CGFloat lineHeight = font.lineHeight;
    CFIndex stringLength = attributedString.length;
    CFIndex stringOffset = 0;
    while (stringOffset < stringLength) {
        renderSize.height += lineHeight;
        
        CFIndex consumedCharacters = 0;
        CTLineRef line = NULL;
        
        switch (lineBreakMode) {
            case NSLineBreakByClipping:
            case NSLineBreakByWordWrapping: {
                consumedCharacters = CTTypesetterSuggestClusterBreak(typesetter, stringOffset, boundingSize.width);
                line = CTTypesetterCreateLine(typesetter, CFRangeMake(stringOffset, consumedCharacters));
                
                break;
            }
                
            case NSLineBreakByCharWrapping: {
                consumedCharacters = CTTypesetterSuggestLineBreak(typesetter, stringOffset, boundingSize.width);
                line = CTTypesetterCreateLine(typesetter, CFRangeMake(stringOffset, consumedCharacters));
                
                break;
            }
            
            case NSLineBreakByTruncatingHead:
            case NSLineBreakByTruncatingTail:
            case NSLineBreakByTruncatingMiddle: {
                CTLineTruncationType truncationType;
                if(lineBreakMode == NSLineBreakByTruncatingHead)
                    truncationType = kCTLineTruncationStart;
                else if(lineBreakMode == NSLineBreakByTruncatingTail)
                    truncationType = kCTLineTruncationEnd;
                else
                    truncationType = kCTLineTruncationMiddle;
                
                consumedCharacters = stringLength - stringOffset;
                CTLineRef lineToTruncate = CTTypesetterCreateLine(typesetter, CFRangeMake(stringOffset, consumedCharacters));
                line = CTLineCreateTruncatedLine(lineToTruncate, boundingSize.width, truncationType, GetSharedElipsisLine());
                CFRelease(lineToTruncate);
                
                break;
            }
        }
        
        if(line) {
            renderSize.width = MAX(renderSize.width, CTLineGetTypographicBounds(line, NULL, NULL, NULL));
            
            [lines addObject:(__bridge id)line];
            CFRelease(line);
        }
        
        stringOffset += consumedCharacters;
        
        if(renderSize.height > boundingSize.height)
            break;
    }
    
    CFRelease(typesetter);
    
    if(outRenderSize) *outRenderSize = renderSize;
    
    return lines;
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
    CGSize renderSize;
    (void)CreateLinesForString(self, font, lineBreakMode, boundingSize, &renderSize);
    return renderSize;
}

#pragma mark - Drawing Strings on a Single Line

- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font
{
    return [self drawAtPoint:point forWidth:CGFLOAT_MAX withFont:font lineBreakMode:NSLineBreakByClipping];
}

- (CGSize)drawAtPoint:(CGPoint)point forWidth:(CGFloat)width withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self drawAtPoint:point forWidth:width
                    withFont:font
                    fontSize:font.pointSize
               lineBreakMode:lineBreakMode
          baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

- (CGSize)drawAtPoint:(CGPoint)point
             forWidth:(CGFloat)width
             withFont:(UIFont *)font
             fontSize:(CGFloat)fontSize
        lineBreakMode:(NSLineBreakMode)lineBreakMode
   baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
#pragma unused(baselineAdjustment)
    
    UIFont *adjustedFont = font.pointSize == fontSize? font : [font fontWithSize:fontSize];
    return [self drawInRect:CGRectMake(point.x, point.y, width, font.lineHeight)
                   withFont:adjustedFont
              lineBreakMode:lineBreakMode 
                  alignment:NSTextAlignmentLeft];
}

- (CGSize)drawAtPoint:(CGPoint)point
             forWidth:(CGFloat)width
             withFont:(UIFont *)font
          minFontSize:(CGFloat)minFontSize
       actualFontSize:(out CGFloat *)actualFontSize
        lineBreakMode:(NSLineBreakMode)lineBreakMode
   baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    UIKitUnimplementedMethod();
    return CGSizeZero;
}

#pragma mark - Drawing Strings in a Given Area

- (CGSize)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font
{
    return [self drawInRect:drawingRect withFont:font lineBreakMode:NSLineBreakByClipping];
}

- (CGSize)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self drawInRect:drawingRect withFont:font lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

- (CGSize)drawInRect:(CGRect)drawingRect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)textAlignment
{
    CGSize renderSize;
    NSArray *lines = CreateLinesForString(self, font, lineBreakMode, drawingRect.size, &renderSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextTranslateCTM(context, CGRectGetMinX(drawingRect), CGRectGetMinY(drawingRect) + font.ascender);
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
        
        CGFloat textOffset = 0.0;
        CGFloat lineHeight = font.lineHeight;
        CGFloat flushFactor = NSTextAlignmentToFlushFactor(textAlignment);
        
        for (id untypedLine in lines) {
            CTLineRef line = (__bridge CTLineRef)untypedLine;
            
            double penOffset = CTLineGetPenOffsetForFlush(line, flushFactor, CGRectGetWidth(drawingRect));
            CGContextSetTextPosition(context, penOffset, textOffset);
            
            CTLineDraw(line, context);
            
            textOffset += lineHeight;
        }
    }
    CGContextRestoreGState(context);
    
    return renderSize;
}

@end

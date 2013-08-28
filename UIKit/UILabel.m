//
//  UILabel.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UILabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont.h"
#import "UIColor.h"
#import "UIStringDrawing.h"

@implementation UILabel {
    NSMutableDictionary *_attributes;
}

- (id)initWithFrame:(NSRect)frame
{
    if((self = [super initWithFrame:frame])) {
        NSShadow *shadow = [NSShadow new];
        
        _attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [NSMutableParagraphStyle new], NSParagraphStyleAttributeName,
                       [UIFont boldSystemFontOfSize:15.0], NSFontAttributeName,
                       [UIColor blackColor], NSForegroundColorAttributeName,
                       shadow, NSShadowAttributeName, nil];
        
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    NSRect textFrame = [self textRectForBounds:rect limitedToNumberOfLines:_numberOfLines];
    [self drawTextInRect:textFrame];
}

#pragma mark - Sizing

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self textRectForBounds:(CGRect){ CGPointZero, size } limitedToNumberOfLines:_numberOfLines].size;
}

#pragma mark - Properties

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self setNeedsDisplay];
}

#pragma mark -

- (void)setShadowColor:(UIColor *)shadowColor
{
    NSShadow *shadow = _attributes[NSShadowAttributeName];
    shadow.shadowColor = shadowColor;
}

- (UIColor *)shadowColor
{
    return (UIColor *)[_attributes[NSShadowAttributeName] shadowColor];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    NSShadow *shadow = _attributes[NSShadowAttributeName];
    shadow.shadowOffset = CGSizeMake(-shadowOffset.width, -shadowOffset.height);
}

- (CGSize)shadowOffset
{
    CGSize shadowOffset = [_attributes[NSShadowAttributeName] shadowOffset];
    return CGSizeMake(-shadowOffset.width, -shadowOffset.height);
}

#pragma mark -

- (void)setFont:(NSFont *)font
{
    [_attributes setValue:font forKey:NSFontAttributeName];
}

- (NSFont *)font
{
    return _attributes[NSFontAttributeName];
}

#pragma mark -

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    if(!_highlighted)
        [_attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    [self setNeedsDisplay];
}

- (void)setHighlightedTextColor:(NSColor *)highlightedTextColor
{
    _highlightedTextColor = highlightedTextColor;
    if(_highlighted)
        [_attributes setValue:highlightedTextColor forKey:NSForegroundColorAttributeName];
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    
    if(_highlighted)
        [_attributes setValue:self.highlightedTextColor forKey:NSForegroundColorAttributeName];
    else
        [_attributes setValue:self.textColor forKey:NSForegroundColorAttributeName];
    
    [self setNeedsDisplay];
}

#pragma mark -

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    NSMutableParagraphStyle *paragraphStyle = _attributes[NSParagraphStyleAttributeName];
    paragraphStyle.alignment = textAlignment;
    [self setNeedsDisplay];
}

- (NSTextAlignment)textAlignment
{
    return [_attributes[NSParagraphStyleAttributeName] alignment];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = _attributes[NSParagraphStyleAttributeName];
    paragraphStyle.lineBreakMode = lineBreakMode;
    [self setNeedsDisplay];
}

- (NSLineBreakMode)lineBreakMode
{
    return [_attributes[NSParagraphStyleAttributeName] lineBreakMode];
}

#pragma mark -

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (CGRect)textRectForBounds:(CGRect)rect limitedToNumberOfLines:(NSInteger)numberOfLines
{
    if(!_attributedText && !_text)
        return CGRectZero;
    
    CGRect textFrame;
    if(_attributedText) {
        textFrame = [_attributedText boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin];
    } else if(_text) {
        textFrame = [_text boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:_attributes];
    }
    
    if(self.textAlignment == NSTextAlignmentCenter) {
        if(CGRectGetWidth(textFrame) > CGRectGetWidth(rect)) {
            textFrame.origin.x = 0.0;
            textFrame.size.width = CGRectGetWidth(rect);
        } else {
            textFrame.origin.x = round(CGRectGetMidX(rect) - CGRectGetWidth(textFrame) / 2.0);
        }
    }
    
    textFrame.origin.y = round(CGRectGetMidY(rect) - CGRectGetHeight(textFrame) / 2.0);
    
    return CGRectIntegral(textFrame);
}

- (void)drawTextInRect:(CGRect)rect
{
    if(_attributedText) {
        [_attributedText drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin];
    } else if(_text) {
        [_text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:_attributes];
    }
}

@end

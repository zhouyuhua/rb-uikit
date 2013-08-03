//
//  UIGraphics.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGraphics.h"

static NSMutableArray *GetContextStack()
{
    static NSMutableArray *ContextStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ContextStack = [NSMutableArray array];
    });
    
    return ContextStack;
}

CGContextRef UIGraphicsGetCurrentContext(void)
{
    return [[NSGraphicsContext currentContext] graphicsPort];
}

void UIGraphicsPushContext(CGContextRef context)
{
    NSCParameterAssert(context);
    
    NSMutableArray *stack = GetContextStack();
    
    if([NSGraphicsContext currentContext] != nil)
        [stack addObject:[NSGraphicsContext currentContext]];
    
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:YES]];
}

void UIGraphicsPopContext(void)
{
    NSMutableArray *stack = GetContextStack();
    if([stack lastObject] != nil) {
        [NSGraphicsContext setCurrentContext:[stack lastObject]];
        [stack removeLastObject];
    }
}

#pragma mark -

void UIRectFillUsingBlendMode(CGRect rect, CGBlendMode blendMode)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetBlendMode(context, blendMode);
        CGContextFillRect(context, rect);
    }
    CGContextRestoreGState(context);
}

void UIRectFill(CGRect rect)
{
    UIRectFillUsingBlendMode(rect, kCGBlendModeDestinationOver);
}

#pragma mark -

void UIRectFrameUsingBlendMode(CGRect rect, CGBlendMode blendMode)
{
    UIRectFillUsingBlendMode(rect, blendMode);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetBlendMode(context, blendMode);
        CGContextStrokeRect(context, rect);
    }
    CGContextRestoreGState(context);
    NSFrameRectWithWidthUsingOperation(rect, 1.0, blendMode - kCGBlendModeLuminosity);
}

void UIRectFrame(CGRect rect)
{
    UIRectFrameUsingBlendMode(rect, kCGBlendModeDestinationOver);
}

#pragma mark -

void UIRectClip(CGRect rect)
{
    CGContextClipToRect(UIGraphicsGetCurrentContext(), rect);
}

#pragma mark - UIImage context

void UIGraphicsBeginImageContext(CGSize size)
{
    UIKitUnimplementedMethod();
}

void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
{
    UIKitUnimplementedMethod();
}

UIImage *UIGraphicsGetImageFromCurrentImageContext(void)
{
    UIKitUnimplementedMethod();
    return nil;
}

void UIGraphicsEndImageContext(void)
{
    UIKitUnimplementedMethod();
}

#pragma mark -PDF context

BOOL UIGraphicsBeginPDFContextToFile(NSString *path, CGRect bounds, NSDictionary *documentInfo)
{
    UIKitUnimplementedMethod();
    return NO;
}

void UIGraphicsBeginPDFContextToData(NSMutableData *data, CGRect bounds, NSDictionary *documentInfo)
{
    UIKitUnimplementedMethod();
}

void UIGraphicsEndPDFContext(void)
{
    UIKitUnimplementedMethod();
}

#pragma mark -

void UIGraphicsBeginPDFPage(void)
{
    UIKitUnimplementedMethod();
}

void UIGraphicsBeginPDFPageWithInfo(CGRect bounds, NSDictionary *pageInfo)
{
    UIKitUnimplementedMethod();
}

#pragma mark -

CGRect UIGraphicsGetPDFContextBounds(void)
{
    UIKitUnimplementedMethod();
    return CGRectZero;
}

#pragma mark -

void UIGraphicsSetPDFContextURLForRect(NSURL *url, CGRect rect)
{
    UIKitUnimplementedMethod();
}

void UIGraphicsAddPDFContextDestinationAtPoint(NSString *name, CGPoint point)
{
    UIKitUnimplementedMethod();
}

void UIGraphicsSetPDFContextDestinationForRect(NSString *name, CGRect rect)
{
    UIKitUnimplementedMethod();
}

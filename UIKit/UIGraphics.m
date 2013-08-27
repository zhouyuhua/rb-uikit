//
//  UIGraphics.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGraphics.h"
#import "UIScreen.h"

#import "UIImage_Private.h"

static NSMutableArray *GetContextStack()
{
    NSMutableDictionary *threadStorage = [[NSThread currentThread] threadDictionary];
    NSMutableArray *contextStack = threadStorage[@"contextStack"];
    if(!contextStack) {
        contextStack = [NSMutableArray array];
        threadStorage[@"contextStack"] = contextStack;
    }
    
    return contextStack;
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

CGContextRef UIGraphicsPeakContext(void)
{
    NSMutableArray *stack = GetContextStack();
    return [[stack lastObject] graphicsPort];
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
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
}

void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
{
    if(scale == 0.0)
        scale = [UIScreen mainScreen].scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext = CGBitmapContextCreate(/* in data */ NULL,
                                                      /* in width */ size.width,
                                                      /* in height */ size.height,
                                                      /* in bitsPerComponent */ 8,
                                                      /* in bytesPerRow */ 0,
                                                      /* in colorSpace */ colorSpace,
                                                      /* in bitmapInfo */ (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    UIGraphicsPushContext(imageContext);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(imageContext);
}

UIImage *UIGraphicsGetImageFromCurrentImageContext(void)
{
    CGImageRef CGImage = CGBitmapContextCreateImage(UIGraphicsPeakContext());
    UIImage *image = [[UIImage alloc] initWithCGImage:CGImage];
    CGImageRelease(CGImage);
    return image;
}

void UIGraphicsEndImageContext(void)
{
    UIGraphicsPopContext();
}

#pragma mark - PDF context

BOOL UIGraphicsBeginPDFContextToFile(NSString *path, CGRect bounds, NSDictionary *documentInfo)
{
    NSCParameterAssert(path);
    
    if(!CGPointEqualToPoint(bounds.origin, CGPointZero))
        [NSException raise:NSInternalInconsistencyException
                    format:@"Cannot pass a bounds with a non-zero origin to %s", __PRETTY_FUNCTION__];
    
    if(CGRectIsNull(bounds))
        bounds = CGRectMake(0.0, 0.0, 612.0, 792.0); //Per docs.
    
    CGContextRef context = CGPDFContextCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], &bounds, (__bridge CFDictionaryRef)documentInfo);
    if(context) {
        UIGraphicsPushContext(context);
        CGContextRelease(context);
        
        return YES;
    } else {
        return NO;
    }
}

void UIGraphicsBeginPDFContextToData(NSMutableData *data, CGRect bounds, NSDictionary *documentInfo)
{
    NSCParameterAssert(data);
    
    if(!CGPointEqualToPoint(bounds.origin, CGPointZero))
        [NSException raise:NSInternalInconsistencyException
                    format:@"Cannot pass a bounds with a non-zero origin to %s", __PRETTY_FUNCTION__];
    
    if(CGRectIsNull(bounds))
        bounds = CGRectMake(0.0, 0.0, 612.0, 792.0); //Per docs.
    
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(dataConsumer, &bounds, (__bridge CFDictionaryRef)documentInfo);
    
    UIGraphicsPushContext(context);
    
    CGContextRelease(context);
    CGDataConsumerRelease(dataConsumer);
}

void UIGraphicsEndPDFContext(void)
{
    CGContextRef context = UIGraphicsPeakContext();
    
    CGPDFContextClose(context);
    
    UIGraphicsPopContext();
}

#pragma mark -

void UIGraphicsBeginPDFPage(void)
{
    UIGraphicsBeginPDFPageWithInfo(CGRectZero, nil);
}

void UIGraphicsBeginPDFPageWithInfo(CGRect bounds, NSDictionary *pageInfo)
{
    CGContextRef context = UIGraphicsPeakContext();
    
    NSMutableDictionary *fullPageInfo = [NSMutableDictionary dictionary];
    if(!CGRectIsNull(bounds)) {
        fullPageInfo[(__bridge id)kCGPDFContextMediaBox] = [NSValue valueWithRect:bounds];
    }
    
    if(pageInfo) {
        [fullPageInfo addEntriesFromDictionary:pageInfo];
    }
    
    CGPDFContextBeginPage(context, (__bridge CFDictionaryRef)fullPageInfo);
}

#pragma mark -

CGRect UIGraphicsGetPDFContextBounds(void)
{
    CGContextRef context = UIGraphicsPeakContext();
    return CGContextGetClipBoundingBox(context);
}

#pragma mark -

void UIGraphicsSetPDFContextURLForRect(NSURL *url, CGRect rect)
{
    NSCParameterAssert(url);
    
    CGContextRef context = UIGraphicsPeakContext();
    CGPDFContextSetURLForRect(context, (__bridge CFURLRef)url, rect);
}

void UIGraphicsAddPDFContextDestinationAtPoint(NSString *name, CGPoint point)
{
    CGContextRef context = UIGraphicsPeakContext();
    CGPDFContextAddDestinationAtPoint(context, (__bridge CFStringRef)name, point);
}

void UIGraphicsSetPDFContextDestinationForRect(NSString *name, CGRect rect)
{
    CGContextRef context = UIGraphicsPeakContext();
    CGPDFContextSetDestinationForRect(context, (__bridge CFStringRef)name, rect);
}

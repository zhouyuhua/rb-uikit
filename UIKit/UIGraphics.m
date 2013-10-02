//
//  UIGraphics.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGraphics_Private.h"
#import "UIScreen.h"

#import "UIImage_Private.h"

static NSMutableArray *GetContextStack()
{
    NSMutableDictionary *threadStorage = [[NSThread currentThread] threadDictionary];
    NSMutableArray *contextStack = threadStorage[@"UIKit/UIGraphics/contextStack"];
    if(!contextStack) {
        contextStack = [NSMutableArray array];
        threadStorage[@"UIKit/UIGraphics/contextStack"] = contextStack;
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
    
    CGContextTranslateCTM(imageContext, 0.0, size.height);
    CGContextScaleCTM(imageContext, 1.0, -1.0);
    
    UIGraphicsPushContext(imageContext);
    _UIGraphicsPushScale(scale);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(imageContext);
}

UIImage *UIGraphicsGetImageFromCurrentImageContext(void)
{
    CGImageRef CGImage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIImage *image = [[UIImage alloc] initWithCGImage:CGImage];
    CGImageRelease(CGImage);
    return image;
}

void UIGraphicsEndImageContext(void)
{
    UIGraphicsPopContext();
    _UIGraphicsPopScale();
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
        _UIGraphicsPushScale(1.0);
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
    _UIGraphicsPushScale(1.0);
    
    CGContextRelease(context);
    CGDataConsumerRelease(dataConsumer);
}

void UIGraphicsEndPDFContext(void)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPDFContextClose(context);
    
    UIGraphicsPopContext();
    _UIGraphicsPopScale();
}

#pragma mark -

void UIGraphicsBeginPDFPage(void)
{
    UIGraphicsBeginPDFPageWithInfo(CGRectZero, nil);
}

void UIGraphicsBeginPDFPageWithInfo(CGRect bounds, NSDictionary *pageInfo)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    return CGContextGetClipBoundingBox(context);
}

#pragma mark -

void UIGraphicsSetPDFContextURLForRect(NSURL *url, CGRect rect)
{
    NSCParameterAssert(url);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPDFContextSetURLForRect(context, (__bridge CFURLRef)url, rect);
}

void UIGraphicsAddPDFContextDestinationAtPoint(NSString *name, CGPoint point)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPDFContextAddDestinationAtPoint(context, (__bridge CFStringRef)name, point);
}

void UIGraphicsSetPDFContextDestinationForRect(NSString *name, CGRect rect)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPDFContextSetDestinationForRect(context, (__bridge CFStringRef)name, rect);
}

#pragma mark - Private

static NSMutableArray *GetScaleStack()
{
    NSMutableDictionary *threadStorage = [[NSThread currentThread] threadDictionary];
    NSMutableArray *contextStack = threadStorage[@"UIKit/UIGraphics/scaleStack"];
    if(!contextStack) {
        contextStack = [NSMutableArray array];
        threadStorage[@"UIKit/UIGraphics/scaleStack"] = contextStack;
    }
    
    return contextStack;
}

void _UIGraphicsPushScale(CGFloat scale)
{
    NSMutableArray *scaleStack = GetScaleStack();
    [scaleStack addObject:@(scale)];
}

void _UIGraphicsPopScale(void)
{
    NSMutableArray *scaleStack = GetScaleStack();
    [scaleStack removeLastObject];
}

CGFloat _UIGraphicsGetCurrentScale(void)
{
    NSMutableArray *scaleStack = GetScaleStack();
    if(scaleStack.count != 0) {
        NSNumber *scale = [scaleStack lastObject];
        [scaleStack removeLastObject];
        return scale.floatValue;
    } else {
        return [UIScreen mainScreen].scale;
    }
}

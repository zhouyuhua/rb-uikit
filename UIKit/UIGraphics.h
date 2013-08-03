//
//  UIGraphics.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIGraphics_h
#define UIKit_UIGraphics_h

#import <Cocoa/Cocoa.h>
#import "UIGeometry.h"

@class UIImage;

UIKIT_EXTERN CGContextRef UIGraphicsGetCurrentContext(void);
UIKIT_EXTERN void UIGraphicsPushContext(CGContextRef context);
UIKIT_EXTERN void UIGraphicsPopContext(void);

#pragma mark -

UIKIT_EXTERN void UIRectFillUsingBlendMode(CGRect rect, CGBlendMode blendMode);
UIKIT_EXTERN void UIRectFill(CGRect rect);

#pragma mark -

UIKIT_EXTERN void UIRectFrameUsingBlendMode(CGRect rect, CGBlendMode blendMode);
UIKIT_EXTERN void UIRectFrame(CGRect rect);

#pragma mark -

UIKIT_EXTERN void UIRectClip(CGRect rect);

#pragma mark - UIImage context

UIKIT_EXTERN void UIGraphicsBeginImageContext(CGSize size);
UIKIT_EXTERN void UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
UIKIT_EXTERN UIImage *UIGraphicsGetImageFromCurrentImageContext(void);
UIKIT_EXTERN void UIGraphicsEndImageContext(void);

#pragma mark - PDF context

UIKIT_EXTERN BOOL UIGraphicsBeginPDFContextToFile(NSString *path, CGRect bounds, NSDictionary *documentInfo);
UIKIT_EXTERN void UIGraphicsBeginPDFContextToData(NSMutableData *data, CGRect bounds, NSDictionary *documentInfo);
UIKIT_EXTERN void UIGraphicsEndPDFContext(void);

#pragma mark -

UIKIT_EXTERN void UIGraphicsBeginPDFPage(void);
UIKIT_EXTERN void UIGraphicsBeginPDFPageWithInfo(CGRect bounds, NSDictionary *pageInfo);

#pragma mark -

UIKIT_EXTERN CGRect UIGraphicsGetPDFContextBounds(void);

#pragma mark -

UIKIT_EXTERN void UIGraphicsSetPDFContextURLForRect(NSURL *url, CGRect rect);
UIKIT_EXTERN void UIGraphicsAddPDFContextDestinationAtPoint(NSString *name, CGPoint point);
UIKIT_EXTERN void UIGraphicsSetPDFContextDestinationForRect(NSString *name, CGRect rect);

#endif

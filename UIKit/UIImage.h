//
//  UIImage.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#ifndef UIKit_UIImage_h
#define UIKit_UIImage_h

#import <Cocoa/Cocoa.h>
#import "UIGeometry.h"

typedef NS_ENUM(NSInteger, UIImageOrientation) {
    UIImageOrientationUp,
    UIImageOrientationDown,
    UIImageOrientationLeft,
    UIImageOrientationRight,
    UIImageOrientationUpMirrored,
    UIImageOrientationDownMirrored,
    UIImageOrientationLeftMirrored,
    UIImageOrientationRightMirrored,
};

typedef NS_ENUM(NSInteger, UIImageResizingMode) {
    UIImageResizingModeTile,
    UIImageResizingModeStretch,
};

typedef NS_ENUM(NSInteger, UIImageRenderingMode) {
    UIImageRenderingModeAutomatic,
    
    UIImageRenderingModeAlwaysOriginal,
    UIImageRenderingModeAlwaysTemplate,
};

@interface UIImage : NSObject

+ (UIImage *)imageNamed:(NSString *)name;

#pragma mark -

+ (UIImage *)imageWithContentsOfFile:(NSString *)path;
+ (UIImage *)imageWithData:(NSData *)data;
+ (UIImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;
+ (UIImage *)imageWithCGImage:(CGImageRef)cgImage;
+ (UIImage *)imageWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
+ (UIImage *)imageWithCIImage:(CIImage *)ciImage;
+ (UIImage *)imageWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

#pragma mark -

- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithData:(NSData *)data;
- (id)initWithData:(NSData *)data scale:(CGFloat)scale;
- (id)initWithCGImage:(CGImageRef)cgImage;
- (id)initWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;
- (id)initWithCIImage:(CIImage *)ciImage;
- (id)initWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

#pragma mark - Properties

@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGImageRef CGImage;
@property (nonatomic, readonly) CIImage *CIImage;
@property (nonatomic, readonly) UIImageOrientation imageOrientation;
@property (nonatomic, readonly) CGFloat scale;

#pragma mark -

@property (nonatomic, readonly) UIEdgeInsets capInsets;
@property (nonatomic, readonly) UIImageResizingMode resizingMode;

#pragma mark - Drawing

- (void)drawAtPoint:(CGPoint)point;
- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawInRect:(CGRect)rect;
- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

#pragma mark -

- (void)drawAsPatternInRect:(CGRect)rect;

#pragma mark - Resizable Images

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets;
- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode;

#pragma mark - Rendering Modes

@property (nonatomic, readonly) UIImageRenderingMode renderingMode;
- (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode;

@end

#pragma mark - Representations

UIKIT_EXTERN NSData *UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality);
UIKIT_EXTERN NSData *UIImagePNGRepresentation(UIImage *image);

#endif

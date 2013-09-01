//
//  UIImage.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImage_Private.h"
#import "UIScreen.h"

#import "UIImageProvider.h"
#import "UIThreePartImageProvider.h"
#import "UITemplateImageProvider.h"

#import "UIGraphics.h"

@implementation UIImage

+ (NSCache *)namedImageCache
{
    static NSCache *namedImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        namedImageCache = [NSCache new];
        namedImageCache.name = @"com.roundabout.uikit.image.namedImageCache";
    });
    
    return namedImageCache;
}

+ (UIImage *)imageNamed:(NSString *)name
{
    return [self imageNamed:name inBundle:[NSBundle mainBundle]];
}

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle
{
    NSCache *namedImageCache = self.namedImageCache;
    
    UIImage *image = [namedImageCache objectForKey:[name stringByDeletingPathExtension]];
    if(!image) {
        NSString *imagePath = nil;
        if([UIScreen mainScreen].scale == 2.0)
            imagePath = [bundle pathForImageResource:[name stringByAppendingString:@"@2x"]];
        
        if(!imagePath)
            imagePath = [bundle pathForImageResource:name];
        
        image = [UIImage imageWithContentsOfFile:imagePath];
        [namedImageCache setObject:image forKey:[name stringByDeletingPathExtension]];
    }
    
    return image;
}

#pragma mark -

+ (UIImage *)imageWithContentsOfFile:(NSString *)path
{
    return [[self alloc] initWithContentsOfFile:path];
}

+ (UIImage *)imageWithData:(NSData *)data
{
    return [[self alloc] initWithData:data];
}

+ (UIImage *)imageWithData:(NSData *)data scale:(CGFloat)scale
{
    return [[self alloc] initWithData:data scale:scale];
}

+ (UIImage *)imageWithCGImage:(CGImageRef)cgImage
{
    return [[self alloc] initWithCGImage:cgImage];
}

+ (UIImage *)imageWithCGImage:(CGImageRef)cgImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    return [[self alloc] initWithCGImage:cgImage scale:scale orientation:orientation];
}

+ (UIImage *)imageWithCIImage:(CIImage *)ciImage
{
    return [[self alloc] initWithCIImage:ciImage];
}

+ (UIImage *)imageWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    return [[self alloc] initWithCIImage:ciImage scale:scale orientation:orientation];
}

#pragma mark -

- (id)initWithContentsOfFile:(NSString *)path
{
    NSParameterAssert(path);
    
    return [self initWithProvider:[[UIImageProvider alloc] initWithContentsOfFile:path scale:[UIScreen mainScreen].scale]];
}

- (id)initWithData:(NSData *)data
{
    return [self initWithData:data scale:[UIScreen mainScreen].scale];
}

- (id)initWithData:(NSData *)data scale:(CGFloat)scale
{
    NSParameterAssert(data);
    
    return [self initWithProvider:[[UIImageProvider alloc] initWithData:data scale:[UIScreen mainScreen].scale]];
}

- (id)initWithCGImage:(CGImageRef)cgImage
{
    return [self initWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (id)initWithCGImage:(CGImageRef)image scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    NSParameterAssert(image);
    
    return [self initWithProvider:[[UIImageProvider alloc] initWithCGImage:image scale:scale]];
}

- (id)initWithCIImage:(CIImage *)ciImage
{
    return [self initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (id)initWithCIImage:(CIImage *)ciImage scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark -

- (id)initWithProvider:(UIImageProvider *)provider
{
    if(!provider)
        return nil;
    
    if((self = [super init])) {
        self.provider = provider;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[UIImage alloc] initWithProvider:self.provider];
}

#pragma mark - Properties

- (CGSize)size
{
    CGFloat scale = self.scale;
    CGSize imageSize = [_provider imageSize];
    imageSize.width /= scale;
    imageSize.height /= scale;
    return imageSize;
}

- (CGImageRef)CGImage
{
    return [_provider image];
}

- (CGFloat)scale
{
    return [_provider scale];
}

- (CIImage *)CIImage
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark -

- (NSImage *)NSImage
{
    return [[NSImage alloc] initWithCGImage:_provider.image size:_provider.imageSize];
}

#pragma mark - Drawing

- (void)drawAtPoint:(CGPoint)point
{
    [self drawAtPoint:point blendMode:kCGBlendModeDestinationOver alpha:1.0];
}

- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(point.x, point.y, self.size.width, self.size.height);
    [self drawInRect:rect blendMode:blendMode alpha:alpha];
}

- (void)drawInRect:(CGRect)rect
{
    [self drawInRect:rect blendMode:kCGBlendModeDestinationOver alpha:1.0];
}

- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetBlendMode(context, blendMode);
        CGContextSetAlpha(context, alpha);
        
        [_provider drawInRect:rect fromRect:CGRectZero tile:(_resizingMode == UIImageResizingModeTile)];
    }
    CGContextRestoreGState(context);
}

#pragma mark -

- (void)drawAsPatternInRect:(CGRect)rect
{
    [_provider drawInRect:rect fromRect:CGRectZero tile:YES];
}

#pragma mark - Resizable Images

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
{
    if(capInsets.top != 0.0 || capInsets.bottom != 0.0)
        UIKitUnimplementedMethod();
    
    UIThreePartImageProvider *threePartProvider = [[UIThreePartImageProvider alloc] initWithProvider:self.provider
                                                                                             leftCap:capInsets.left
                                                                                            rightCap:capInsets.right
                                                                                        resizingMode:resizingMode];
    UIImage *image = [[UIImage alloc] initWithProvider:threePartProvider];
    image.capInsets = capInsets;
    image.resizingMode = resizingMode;
    return image;
}

#pragma mark -

- (BOOL)_isResizable
{
    return [self.provider isKindOfClass:[UIThreePartImageProvider class]];
}

#pragma mark - Rendering Modes

- (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode
{
    if(renderingMode == self.renderingMode) {
        return [self copy];
    } else if(renderingMode != UIImageRenderingModeAlwaysTemplate) {
        if(self.renderingMode != UIImageRenderingModeAlwaysTemplate) {
            UIImage *newImage = [self copy];
            newImage.renderingMode = renderingMode;
            return newImage;
        } else {
            UITemplateImageProvider *templateProvider = (UITemplateImageProvider *)self.provider;
            return templateProvider.originalImage;
        }
    } else {
        UITemplateImageProvider *imageProvider = [[UITemplateImageProvider alloc] initWithOriginalImage:self];
        UIImage *newImage = [[UIImage alloc] initWithProvider:imageProvider];
        newImage.renderingMode = UIImageRenderingModeAlwaysTemplate;
        return newImage;
    }
}

@end

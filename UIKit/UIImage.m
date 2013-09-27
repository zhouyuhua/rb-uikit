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

#import "UIGraphics_Private.h"

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
        NSString *imagePath = [bundle pathForImageResource:name];
        if([UIScreen mainScreen].scale == 2.0) {
            NSString *imagePathFor2x = [bundle pathForImageResource:[name stringByAppendingString:@"@2x"]];
            
            NSMutableArray *providers = [NSMutableArray array];
            UIImageProvider *providerFor1x = [[UIImageProvider alloc] initWithContentsOfFile:imagePath scale:1.0];
            if(providerFor1x)
                [providers addObject:providerFor1x];
            
            UIImageProvider *providerFor2x = [[UIImageProvider alloc] initWithContentsOfFile:imagePathFor2x scale:2.0];
            if(providerFor2x)
                [providers addObject:providerFor2x];
            
            if(providers.count == 0)
                return nil;
            
            image = [[UIImage alloc] initWithProviders:providers];
            
        } else {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
        
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
    
    return [self initWithProviders:@[ [[UIImageProvider alloc] initWithContentsOfFile:path scale:[UIScreen mainScreen].scale] ]];
}

- (id)initWithData:(NSData *)data
{
    return [self initWithData:data scale:[UIScreen mainScreen].scale];
}

- (id)initWithData:(NSData *)data scale:(CGFloat)scale
{
    NSParameterAssert(data);
    
    return [self initWithProviders:@[ [[UIImageProvider alloc] initWithData:data scale:[UIScreen mainScreen].scale] ]];
}

- (id)initWithCGImage:(CGImageRef)cgImage
{
    return [self initWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

- (id)initWithCGImage:(CGImageRef)image scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    NSParameterAssert(image);
    
    return [self initWithProviders:@[ [[UIImageProvider alloc] initWithCGImage:image scale:scale] ]];
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

- (id)initWithProviders:(NSArray *)providers
{
    if(!providers)
        return nil;
    
    if((self = [super init])) {
        self._providers = providers;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[UIImage alloc] initWithProviders:self._providers];
}

#pragma mark - Providers

- (UIImageProvider *)_bestProviderForScale:(CGFloat)scale
{
    UIImageProvider *bestProvider;
    
    for (UIImageProvider *provider in self._providers) {
        bestProvider = provider;
        
        CGFloat providerScale = provider.scale;
        if(providerScale >= scale) {
            break;
        }
    }
    
    return bestProvider;
}

#pragma mark - Properties

- (CGSize)size
{
    CGFloat scale = self.scale;
    CGSize imageSize = [[self _bestProviderForScale:2.0] imageSize];
    imageSize.width /= scale;
    imageSize.height /= scale;
    return imageSize;
}

- (CGImageRef)CGImage
{
    return [[self _bestProviderForScale:2.0] image];
}

- (CGFloat)scale
{
    return [[self _bestProviderForScale:2.0] scale];
}

- (CIImage *)CIImage
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark -

- (NSImage *)NSImage
{
    return [[NSImage alloc] initWithCGImage:self.CGImage size:self.size];
}

#pragma mark - Tinting

- (UIImage *)_tintedImageWithColor:(UIColor *)color
{
    NSParameterAssert(color);
    
    CGSize size = self.size;
    CGRect drawingRect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextClipToMask(context, drawingRect, self.CGImage);
        
        CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
        CGContextFillRect(context, drawingRect);
        
        [self drawAtPoint:CGPointZero blendMode:kCGBlendModeOverlay alpha:1.0];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
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
        
        [[self _bestProviderForScale:_UIGraphicsGetCurrentScale()] drawInRect:rect fromRect:CGRectZero tile:(_resizingMode == UIImageResizingModeTile)];
    }
    CGContextRestoreGState(context);
}

#pragma mark -

- (void)drawAsPatternInRect:(CGRect)rect
{
    [[self _bestProviderForScale:_UIGraphicsGetCurrentScale()] drawInRect:rect fromRect:CGRectZero tile:YES];
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
    
    UIThreePartImageProvider *threePartProvider = [[UIThreePartImageProvider alloc] initWithProvider:[self _bestProviderForScale:2.0]
                                                                                             leftCap:capInsets.left
                                                                                            rightCap:capInsets.right
                                                                                        resizingMode:resizingMode];
    UIImage *image = [[UIImage alloc] initWithProviders:@[ threePartProvider ]];
    image.capInsets = capInsets;
    image.resizingMode = resizingMode;
    return image;
}

#pragma mark -

- (BOOL)_isResizable
{
    return [self._providers.lastObject isKindOfClass:[UIThreePartImageProvider class]];
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
            UITemplateImageProvider *templateProvider = (UITemplateImageProvider *)[self _bestProviderForScale:2.0];
            return templateProvider.originalImage;
        }
    } else {
        UITemplateImageProvider *imageProvider = [[UITemplateImageProvider alloc] initWithOriginalImage:self];
        UIImage *newImage = [[UIImage alloc] initWithProviders:@[ imageProvider ]];
        newImage.renderingMode = UIImageRenderingModeAlwaysTemplate;
        return newImage;
    }
}

@end

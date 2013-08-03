//
//  UIImageProvider.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImageProvider.h"
#import "UIGraphics.h"

@implementation UIImageProvider {
    CGImageRef _image;
    CGFloat _scale;
}

- (void)dealloc
{
    if(_image) {
        CGImageRelease(_image);
        _image = NULL;
    }
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithContentsOfFile:(NSString *)file scale:(CGFloat)scale
{
    NSParameterAssert(file);
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:file], NULL);
    if(CGImageSourceGetCount(imageSource) == 0) {
        CFRelease(imageSource);
        return nil;
    }
    
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    self = [self initWithCGImage:image scale:scale];
    
    CGImageRelease(image);
    CFRelease(imageSource);
    
    return self;
}

- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale
{
    NSParameterAssert(data);
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if(CGImageSourceGetCount(imageSource) == 0) {
        CFRelease(imageSource);
        return nil;
    }
    
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    self = [self initWithCGImage:image scale:scale];
    
    CGImageRelease(image);
    CFRelease(imageSource);
    
    return self;
}

- (instancetype)initWithCGImage:(CGImageRef)image scale:(CGFloat)scale
{
    NSParameterAssert(image);
    NSParameterAssert(scale);
    
    if((self = [super init])) {
        _image = CGImageRetain(image);
        _scale = scale;
    }
    
    return self;
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone
{
    CGImageRef imageCopy = CGImageCreateCopy(_image);
    UIImageProvider *copy = [[self.class alloc] initWithCGImage:imageCopy scale:_scale];
    CGImageRelease(imageCopy);
    return copy;
}

#pragma mark - Accessors

- (CGImageRef)image
{
    return _image;
}

- (CGSize)imageSize
{
    return CGSizeMake(CGImageGetWidth(self.image), CGImageGetHeight(self.image));
}

- (CGFloat)scale
{
    return _scale;
}

- (BOOL)isOpaque
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(_image);
    return (alphaInfo == kCGImageAlphaNone ||
            alphaInfo == kCGImageAlphaNoneSkipLast ||
            alphaInfo == kCGImageAlphaNoneSkipFirst);
}

#pragma mark - Drawing

- (void)drawInRect:(CGRect)destinationRect fromRect:(CGRect)fromRect tile:(BOOL)tile
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextTranslateCTM(context, 0.0, CGRectGetHeight(destinationRect));
        CGContextScaleCTM(context, 1.0, -1.0);
        
        if(CGRectEqualToRect(fromRect, CGRectZero)) {
            if(tile)
                CGContextDrawTiledImage(context, destinationRect, _image);
            else
                CGContextDrawImage(context, destinationRect, _image);
        } else {
            fromRect.origin.x *= _scale;
            fromRect.origin.y *= _scale;
            fromRect.size.width *= _scale;
            fromRect.size.height *= _scale;
            
            CGImageRef temporaryImage = CGImageCreateWithImageInRect(_image, fromRect);
            if(tile)
                CGContextDrawTiledImage(context, destinationRect, temporaryImage);
            else
                CGContextDrawImage(context, destinationRect, temporaryImage);
            CGImageRelease(temporaryImage);
        }
    }
    CGContextRestoreGState(context);
}

@end

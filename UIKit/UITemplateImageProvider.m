//
//  UITemplateImageProvider.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITemplateImageProvider.h"
#import "UIImage_Private.h"
#import "UIGraphics.h"

#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))

//From <http://stackoverflow.com/questions/8126276/how-to-convert-uiimage-cgimagerefs-alpha-channel-to-mask>
static CGImageRef CreateMaskWithImage(CGImageRef originalMaskImage)
{
    CGFloat width = CGImageGetWidth(originalMaskImage);
    CGFloat height = CGImageGetHeight(originalMaskImage);
    
    NSUInteger strideLength = ROUND_UP(width * 1, 4);
    unsigned char *alphaData = calloc(strideLength * height, sizeof(unsigned char));
    CGContextRef alphaOnlyContext = CGBitmapContextCreate(alphaData,
                                                          width,
                                                          height,
                                                          8,
                                                          strideLength,
                                                          NULL,
                                                          (CGBitmapInfo)kCGImageAlphaOnly);
    
    CGContextDrawImage(alphaOnlyContext, CGRectMake(0, 0, width, height), originalMaskImage);
    
    for (NSUInteger y = 0; y < height; y++) {
        for (NSUInteger x = 0; x < width; x++) {
            unsigned char val = alphaData[y*strideLength + x];
            val = 255 - val;
            alphaData[y * strideLength + x] = val;
        }
    }
    
    CGImageRef alphaMaskImage = CGBitmapContextCreateImage(alphaOnlyContext);
    CGContextRelease(alphaOnlyContext);
    free(alphaData);
    
    return CGImageMaskCreate(CGImageGetWidth(alphaMaskImage),
                             CGImageGetHeight(alphaMaskImage),
                             CGImageGetBitsPerComponent(alphaMaskImage),
                             CGImageGetBitsPerPixel(alphaMaskImage),
                             CGImageGetBytesPerRow(alphaMaskImage),
                             CGImageGetDataProvider(alphaMaskImage),
                             NULL,
                             false);
}

@implementation UITemplateImageProvider

- (instancetype)initWithSourceProvider:(UIImageProvider *)provider
{
    NSParameterAssert(provider);
    
    CGImageRef maskImage = CreateMaskWithImage(provider.image);
    
    if((self = [super initWithCGImage:maskImage scale:provider.scale])) {
        self.sourceProvider = provider;
    }
    
    CGImageRelease(maskImage);
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    UITemplateImageProvider *providerCopy = [super copyWithZone:zone];
    providerCopy->_sourceProvider = _sourceProvider;
    return providerCopy;
}

@end

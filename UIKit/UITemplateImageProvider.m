//
//  UITemplateImageProvider.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITemplateImageProvider.h"
#import "UIImage_Private.h"

@implementation UITemplateImageProvider

- (instancetype)initWithOriginalImage:(UIImage *)originalImage
{
    NSParameterAssert(originalImage);
    
    self.originalImage = originalImage;
    
    CGImageRef underlyingImage = originalImage.CGImage;
    CGSize size = originalImage.size;
    
    CGImageRef maskImage = CGImageMaskCreate(size.width,
                                             size.height,
                                             CGImageGetBitsPerComponent(underlyingImage),
                                             CGImageGetBitsPerPixel(underlyingImage),
                                             CGImageGetBytesPerRow(underlyingImage),
                                             CGImageGetDataProvider(underlyingImage),
                                             NULL, 
                                             true);
    
    self = [super initWithCGImage:maskImage scale:self.originalImage.scale];
    
    CGImageRelease(maskImage);
    
    return self;
}

@end

//
//  UIImage_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImage.h"
#import "UIColor.h"

@class UIImageProvider;

@interface UIImage () <NSCopying>

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

- (instancetype)initWithNSImage:(NSImage *)image;
- (NSImage *)NSImage;

#pragma mark - Providers

@property (nonatomic, copy) NSArray *_providers;

- (UIImageProvider *)_bestProviderForScale:(CGFloat)scale;

- (BOOL)_isResizable;

#pragma mark - Tinting

- (UIImage *)_tintedImageWithColor:(UIColor *)color;

#pragma mark - readwrite

@property (nonatomic, readwrite) UIImageOrientation imageOrientation;
@property (nonatomic, readwrite) UIEdgeInsets capInsets;
@property (nonatomic, readwrite) UIImageResizingMode resizingMode;
@property (nonatomic, readwrite) UIImageRenderingMode renderingMode;

@end

UIKIT_INLINE UIImage *UIKitImageNamed(NSString *name, UIImageResizingMode resizingMode)
{
    NSBundle *bundle = [NSBundle bundleForClass:[UIImage class]];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle];
    image.resizingMode = resizingMode;
    return image;
}

//
//  UIImage_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImage.h"

@class UIImageProvider;

@interface UIImage ()

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

- (NSImage *)NSImage;

#pragma mark - Properties

@property (nonatomic) UIImageProvider *provider;

- (BOOL)_isResizable;

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

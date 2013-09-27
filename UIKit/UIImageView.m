//
//  UIImageView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImageView_Private.h"
#import "UIImage_Private.h"
#import "UIGraphics.h"

@implementation UIImageView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if((self = [self initWithFrame:(CGRect){ CGPointZero, image.size }])) {
        self.image = image;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if((self = [self initWithFrame:(CGRect){ CGPointZero, image.size }])) {
        self.image = image;
        self.highlightedImage = highlightedImage;
    }
    
    return self;
}

#pragma mark - Sizing

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.image.size;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if(_manuallyDrawingImage) {
        [_displayedImage drawInRect:rect];
    }
}

#pragma mark - Properties

- (UIImage *)_prerenderImage:(UIImage *)image
{
    if(image.renderingMode == UIImageRenderingModeAlwaysTemplate) {
        UIGraphicsBeginImageContextWithOptions(_displayedImage.size, NO, _displayedImage.scale);
        
        [self.tintColor setFill];
        [image drawAtPoint:CGPointZero];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

- (void)_update
{
    if(_highlighted && _highlightedImage)
        _displayedImage = _highlightedImage;
    else
        _displayedImage = _image;
    
    _manuallyDrawingImage = [_displayedImage _isResizable];
    if(_manuallyDrawingImage) {
        self.layer.needsDisplayOnBoundsChange = YES;
        self.layer.contents = nil;
        
        [self setNeedsDisplay];
    } else {
        _displayedImage = [self _prerenderImage:_displayedImage];
        
        self.layer.needsDisplayOnBoundsChange = NO;
        self.layer.contents = (__bridge id)_displayedImage.CGImage;
    }
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    if(self._prefersToRenderTemplateImages && image.renderingMode == UIImageRenderingModeAutomatic)
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _image = image;
    [self _update];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    if(self._prefersToRenderTemplateImages && highlightedImage.renderingMode == UIImageRenderingModeAutomatic)
        highlightedImage = [highlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _highlightedImage = highlightedImage;
    [self _update];
}

#pragma mark -

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self _update];
}

#pragma mark - Tinting

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    [self _update];
}

@end

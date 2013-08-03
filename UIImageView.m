//
//  UIImageView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIImageView.h"
#import "UIImage_Private.h"

@implementation UIImageView {
    UIImage *_displayedImage;
    BOOL _manuallyDrawingImage;
}

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

- (void)update
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
        self.layer.needsDisplayOnBoundsChange = NO;
        self.layer.contents = (__bridge id)_displayedImage.CGImage;
    }
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self update];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    _highlightedImage = highlightedImage;
    [self update];
}

#pragma mark -

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self update];
}

@end

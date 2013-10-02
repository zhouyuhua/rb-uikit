//
//  _UIConcretePopoverBackgroundView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UIConcretePopoverBackgroundView.h"
#import "UIImage_Private.h"

@implementation _UIConcretePopoverBackgroundView {
    UIView *_backgroundView;
    UIImageView *_arrowImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        _backgroundView.layer.cornerRadius = 3.0;
        [self addSubview:_backgroundView];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self.class arrowBase], [self.class arrowHeight])];
        _arrowImageView.tintColor = _backgroundView.backgroundColor;
        [self addSubview:_arrowImageView];
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    
    CGRect arrowFrame = _arrowImageView.bounds;
    
    CGRect backgroundViewFrame = CGRectZero;
    backgroundViewFrame.size = bounds.size;
    
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            backgroundViewFrame.size.height -= [self.class arrowHeight];
            backgroundViewFrame.origin.y += [self.class arrowHeight];
            
            arrowFrame.origin.x = round(CGRectGetMidX(backgroundViewFrame) - CGRectGetWidth(arrowFrame) / 2.0) - self.arrowOffset.horizontal;
            arrowFrame.origin.y = 0.0;
            
            break;
            
        case UIPopoverArrowDirectionDown:
            backgroundViewFrame.size.height -= [self.class arrowHeight];
            break;
            
        case UIPopoverArrowDirectionLeft:
            backgroundViewFrame.size.width -= [self.class arrowBase];
            backgroundViewFrame.origin.x += [self.class arrowBase];
            break;
            
        case UIPopoverArrowDirectionRight:
            backgroundViewFrame.size.width -= [self.class arrowBase];
            break;
            
        default:
            break;
    }
    
    _backgroundView.frame = backgroundViewFrame;
    _arrowImageView.frame = arrowFrame;
}

#pragma mark - Returning the Content View Insets

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
}

#pragma mark - Accessing the Arrow Metrics

@synthesize arrowDirection = _arrowDirection;
- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    
    switch (_arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _arrowImageView.image = [UIKitImageNamed(@"UIPopoverArrowUp", UIImageResizingModeStretch) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            break;
            
        case UIPopoverArrowDirectionDown:
            _arrowImageView.image = [UIKitImageNamed(@"UIPopoverArrowDown", UIImageResizingModeStretch) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            break;
        
        case UIPopoverArrowDirectionLeft:
            _arrowImageView.image = [UIKitImageNamed(@"UIPopoverArrowLeft", UIImageResizingModeStretch) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            break;
        
        case UIPopoverArrowDirectionRight:
            _arrowImageView.image = [UIKitImageNamed(@"UIPopoverArrowRight", UIImageResizingModeStretch) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            break;
            
        default:
            break;
    }
    [_arrowImageView sizeToFit];
    
    [self setNeedsLayout];
}

@synthesize arrowOffset = _arrowOffset;
- (void)setArrowOffset:(UIOffset)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

#pragma mark -

+ (CGFloat)arrowHeight
{
    return 15.0;
}

+ (CGFloat)arrowBase
{
    return 30.0;
}

#pragma mark - Controlling the Popover Appearance

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

@end

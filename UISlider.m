//
//  UISlider.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/11/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UISlider.h"

#import "UIConcreteAppearance.h"

#import "UIImageView.h"
#import "UIImage_Private.h"

#define TRACK_INSET 5.0

@interface UISlider () {
    UIImageView *_minimumValueImageView;
    UIImageView *_maximumValueImageView;
    
    UIImageView *_thumbImageView;
    UIImageView *_minimumTrackImageView;
    UIImageView *_maximumTrackImageView;
    
    NSMutableDictionary *_minimumTrackImageValues;
    NSMutableDictionary *_maximumTrackImageValues;
    NSMutableDictionary *_thumbImageValues;
}

@end

#pragma mark -

@implementation UISlider

UI_CONCRETE_APPEARANCE_GENERATE(UISlider);

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        _minimumValueImageView = [UIImageView new];
        [self addSubview:_minimumValueImageView];
        
        _maximumValueImageView = [UIImageView new];
        [self addSubview:_maximumValueImageView];
        
        
        _maximumTrackImageView = [UIImageView new];
        _maximumTrackImageView.clipsToBounds = YES;
        [self addSubview:_maximumTrackImageView];
        
        _minimumTrackImageView = [UIImageView new];
        _minimumTrackImageView.clipsToBounds = YES;
        [self addSubview:_minimumTrackImageView];
        
        _thumbImageView = [UIImageView new];
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        
        
        
        _minimumTrackImageValues = [NSMutableDictionary dictionary];
        _maximumTrackImageValues = [NSMutableDictionary dictionary];
        _thumbImageValues = [NSMutableDictionary dictionary];
        
        
        [self setThumbImage:nil forState:UIControlStateNormal];
        [self setThumbImage:nil forState:UIControlStateDisabled];
        [self setMinimumTrackImage:nil forState:UIControlStateNormal];
        [self setMinimumTrackImage:nil forState:UIControlStateDisabled];
        [self setMaximumTrackImage:nil forState:UIControlStateNormal];
        
        
        _minimumValue = 0.0;
        _maximumValue = 1.0;
        _value = 0.0;
        _continuous = YES;
        
        [self updateViews];
    }
    
    return self;
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width ?: 100.0, self.currentThumbImage.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    _minimumTrackImageView.frame = [self minimumValueImageRectForBounds:bounds];
    _maximumTrackImageView.frame = [self maximumValueImageRectForBounds:bounds];
    
    CGRect trackRect = [self trackRectForBounds:bounds];
    CGRect thumbRect = [self thumbRectForBounds:bounds trackRect:trackRect value:_value];
    
    _maximumTrackImageView.frame = trackRect;
    _thumbImageView.frame = thumbRect;
    
    CGRect minimumTrackFrame = trackRect;
    minimumTrackFrame.size.width = round(CGRectGetMidX(thumbRect));
    _minimumTrackImageView.frame = minimumTrackFrame;
}

- (void)updateViews
{
    _minimumTrackImageView.image = self.currentMinimumTrackImage;
    _maximumTrackImageView.image = self.currentMaximumTrackImage;
    _thumbImageView.image = self.currentThumbImage;
    
    [self setNeedsLayout];
}

#pragma mark - Overrides

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self updateViews];
}

#pragma mark - Accessing the Slider’s Value

- (float)_constrainValue:(float)value
{
    if(value > _maximumValue)
        return _maximumValue;
    else if(value < _minimumValue)
        return _minimumValue;
    else
        return value;
}

- (void)setValue:(float)value
{
    [self setValue:value animated:NO];
}

- (void)setValue:(float)value animated:(BOOL)animate
{
    _value = [self _constrainValue:value];
    
    [self setNeedsLayout];
}

#pragma mark - Accessing the Slider’s Value Limits

- (void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    
    _value = [self _constrainValue:_value];
    [self setNeedsLayout];
}

- (void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    
    _value = [self _constrainValue:_value];
    [self setNeedsLayout];
}

#pragma mark - Changing the Slider’s Appearance

- (void)setMinimumValueImage:(UIImage *)minimumValueImage
{
    _minimumValueImageView.image = minimumValueImage;
}

- (UIImage *)minimumValueImage
{
    return _minimumValueImageView.image;
}

- (void)setMaximumValueImage:(UIImage *)maximumValueImage
{
    _maximumValueImageView.image = maximumValueImage;
}

- (UIImage *)maximumValueImage
{
    return _maximumValueImageView.image;
}

#pragma mark -

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor
{
    _minimumTrackImageView.tintColor = minimumTrackTintColor;
}

- (UIColor *)minimumTrackTintColor
{
    return _minimumTrackImageView.tintColor;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor
{
    _maximumTrackImageView.tintColor = maximumTrackTintColor;
}

- (UIColor *)maximumTrackTintColor
{
    return _maximumTrackImageView.tintColor;
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    _thumbImageView.tintColor = thumbTintColor;
}

- (UIColor *)thumbTintColor
{
    return _thumbImageView.tintColor;
}

#pragma mark -

- (UIImage *)currentMinimumTrackImage
{
    return [self minimumTrackImageForState:self.state];
}

- (UIImage *)minimumTrackImageForState:(UIControlState)state
{
    return _minimumTrackImageValues[@(state)] ?: _minimumTrackImageValues[@(UIControlStateNormal)];
}

- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state
{
    if(image) {
        _minimumTrackImageValues[@(state)] = image;
    } else {
        if(state == UIControlStateNormal) {
            _minimumTrackImageValues[@(state)] = [UIKitImageNamed(@"UISliderMinimumTrackImage", UIImageResizingModeStretch) resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
        } else if(state == UIControlStateDisabled) {
            _minimumTrackImageValues[@(state)] = [UIKitImageNamed(@"UISliderMinimumTrackImage_Disabled", UIImageResizingModeStretch) resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
        } else {
            [_minimumTrackImageValues removeObjectForKey:@(state)];
        }
    }
    
    [self updateViews];
}

#pragma mark -

- (UIImage *)currentMaximumTrackImage
{
    return [self maximumTrackImageForState:self.state];
}

- (UIImage *)maximumTrackImageForState:(UIControlState)state
{
    return _maximumTrackImageValues[@(state)] ?: _maximumTrackImageValues[@(UIControlStateNormal)];
}

- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state
{
    if(image) {
        _maximumTrackImageValues[@(state)] = image;
    } else {
        if(state == UIControlStateNormal) {
            _maximumTrackImageValues[@(state)] = [UIKitImageNamed(@"UISliderMaximumTrackImage", UIImageResizingModeStretch) resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
        } else {
            [_maximumTrackImageValues removeObjectForKey:@(state)];
        }
    }
    [self updateViews];
}

#pragma mark -

- (UIImage *)currentThumbImage
{
    return [self thumbImageForState:self.state];
}

- (UIImage *)thumbImageForState:(UIControlState)state
{
    return _thumbImageValues[@(state)] ?: _thumbImageValues[@(UIControlStateNormal)];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
    if(image) {
        _thumbImageValues[@(state)] = image;
    } else {
        if(state == UIControlStateNormal) {
            _thumbImageValues[@(state)] = UIKitImageNamed(@"UISliderThumbImage", UIImageResizingModeStretch);
        } else if(state == UIControlStateDisabled) {
            _thumbImageValues[@(state)] = UIKitImageNamed(@"UISliderThumbImage_Disabled", UIImageResizingModeStretch);
        } else {
            [_thumbImageValues removeObjectForKey:@(state)];
        }
    }
    
    [self updateViews];
}

#pragma mark - Overrides for Subclasses

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
{
    //UIKitUnimplementedMethod();
    return CGRectZero;
}

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    //UIKitUnimplementedMethod();
    return CGRectZero;
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect trackRect = CGRectZero;
    trackRect.size.height = self.currentMaximumTrackImage.size.height;
    trackRect.size.width = CGRectGetWidth(bounds) - (TRACK_INSET * 2.0);
    trackRect.origin.x = TRACK_INSET;
    trackRect.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(trackRect) / 2.0);
    
    return trackRect;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)trackRect value:(float)value
{
    CGFloat fraction = (value - _minimumValue) / (_maximumValue - _minimumValue);
    
    CGRect thumbFrame = CGRectZero;
    thumbFrame.size = self.currentThumbImage.size;
    thumbFrame.origin.x = round(CGRectGetWidth(bounds) * fraction - CGRectGetWidth(thumbFrame) / 2.0);
    thumbFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(thumbFrame) / 2.0);
    
    return thumbFrame;
}

#pragma mark - Event Handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.enabled)
        return;
    
    if(!_continuous) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        CGFloat percentage = touchLocation.x / CGRectGetWidth(self.bounds);
        self.value = (_maximumValue + ABS(_minimumValue)) * percentage + _minimumValue;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.enabled)
        return;
    
    if(_continuous) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        CGFloat percentage = touchLocation.x / CGRectGetWidth(self.bounds);
        self.value = (_maximumValue + ABS(_minimumValue)) * percentage + _minimumValue;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.enabled)
        return;
    
    if(_continuous) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView:self];
        CGFloat percentage = touchLocation.x / CGRectGetWidth(self.bounds);
        self.value = (_maximumValue + ABS(_minimumValue)) * percentage + _minimumValue;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end

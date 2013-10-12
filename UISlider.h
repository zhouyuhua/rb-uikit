//
//  UISlider.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/11/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIControl.h"
#import "UIAppearance.h"

@interface UISlider : UIControl <UIAppearance>

#pragma mark - Accessing the Slider’s Value

@property (nonatomic) float value;
- (void)setValue:(float)value animated:(BOOL)animate;

#pragma mark - Accessing the Slider’s Value Limits

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;

#pragma mark - Modifying the Slider’s Behavior

@property (nonatomic, getter=isContinuous) BOOL continuous;

#pragma mark - Changing the Slider’s Appearance

@property (nonatomic) UIImage *minimumValueImage;
@property (nonatomic) UIImage *maximumValueImage;

#pragma mark -

@property (nonatomic) UIColor *minimumTrackTintColor;
@property (nonatomic) UIColor *maximumTrackTintColor;
@property (nonatomic) UIColor *thumbTintColor;

#pragma mark -

@property (nonatomic, readonly) UIImage *currentMinimumTrackImage;
- (UIImage *)minimumTrackImageForState:(UIControlState)state;
- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state;

#pragma mark -

@property (nonatomic, readonly) UIImage *currentMaximumTrackImage;
- (UIImage *)maximumTrackImageForState:(UIControlState)state;
- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state;

#pragma mark -

@property (nonatomic, readonly) UIImage *currentThumbImage;
- (UIImage *)thumbImageForState:(UIControlState)state;
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

#pragma mark - Overrides for Subclasses

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds;
- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds;
- (CGRect)trackRectForBounds:(CGRect)bounds;
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)trackRect value:(float)value;

@end

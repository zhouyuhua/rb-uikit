//
//  UIButton.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIControl.h"
#import "UIGeometry.h"

@class UIImageView, UILabel;

typedef NS_ENUM(NSInteger, UIButtonType) {
    UIButtonTypeCustom = 0,
    UIButtonTypeSystem,
    
    UIButtonTypeDetailDisclosure, 
    UIButtonTypeInfoLight, 
    UIButtonTypeInfoDark, 
    UIButtonTypeContactAdd,
    
    UIButtonTypeRoundedRect = UIButtonTypeSystem,
};

@interface UIButton : UIControl

+ (instancetype)buttonWithType:(UIButtonType)type;

#pragma mark - Properties

@property (nonatomic) UIEdgeInsets contentEdgeInsets;
@property (nonatomic) UIEdgeInsets titleEdgeInsets;
@property (nonatomic) BOOL reversesTitleShadowWhenHighlighted;
@property (nonatomic) UIEdgeInsets imageEdgeInsets;
@property (nonatomic) BOOL adjustsImageWhenHighlighted;
@property (nonatomic) BOOL adjustsImageWhenDisabled;
@property (nonatomic) BOOL showsTouchWhenHighlighted;
@property (nonatomic, retain) UIColor *tintColor;
@property (nonatomic, readonly) UIButtonType buttonType;

#pragma mark -

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;

#pragma mark -

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state;

#pragma mark -

- (NSString *)titleForState:(UIControlState)state;
- (UIColor *)titleColorForState:(UIControlState)state;
- (UIColor *)titleShadowColorForState:(UIControlState)state;
- (UIImage *)imageForState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;
- (NSAttributedString *)attributedTitleForState:(UIControlState)state;

#pragma mark -

@property (nonatomic, readonly, retain) NSString *currentTitle;
@property (nonatomic, readonly, retain) UIColor *currentTitleColor;
@property (nonatomic, readonly, retain) UIColor *currentTitleShadowColor;
@property (nonatomic, readonly, retain) UIImage *currentImage;
@property (nonatomic, readonly, retain) UIImage *currentBackgroundImage;
@property (nonatomic, readonly, retain) NSAttributedString *currentAttributedTitle;

#pragma mark - Views

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *titleLabel;

#pragma mark - Metrics

- (CGRect)backgroundRectForBounds:(CGRect)bounds;
- (CGRect)contentRectForBounds:(CGRect)bounds;
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
- (CGRect)imageRectForContentRect:(CGRect)contentRect;

@end

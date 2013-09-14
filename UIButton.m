//
//  UIButton.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIButton.h"
#import "UIButton_Private.h"

#import "UIImage_Private.h"
#import "UIImageView_Private.h"
#import "UILabel.h"
#import "UIBezierPath.h"

#import "UIButtonBackgroundView.h"
#import "UIButtonBorderlessBackgroundView.h"
#import "UIButtonRoundRectBackgroundView.h"
#import "UIButtonBarBackgroundView.h"

#define INTER_VIEW_PADDING      20.0
#define MIN_PREFERRED_HEIGHT    30.0

@implementation UIButton {
    BOOL _mouseDown;
    
    NSMutableDictionary *_titles;
    NSMutableDictionary *_titleColors;
    NSMutableDictionary *_titleShadowColors;
    NSMutableDictionary *_images;
    NSMutableDictionary *_backgroundImages;
    NSMutableDictionary *_attributedTitles;
}

+ (instancetype)buttonWithType:(UIButtonType)type
{
    if(type >= UIButtonTypeDetailDisclosure && type <= UIButtonTypeContactAdd)
        UIKitUnimplementedMethod();
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    button.buttonType = type;
    return button;
}

- (id)initWithFrame:(NSRect)frame
{
    if((self = [super initWithFrame:frame])) {
        _titles = [NSMutableDictionary dictionary];
        _titleColors = [NSMutableDictionary dictionary];
        _titleShadowColors = [NSMutableDictionary dictionary];
        _images = [NSMutableDictionary dictionary];
        _backgroundImages = [NSMutableDictionary dictionary];
        _attributedTitles = [NSMutableDictionary dictionary];
        
        [self setTitleColor:[UIColor colorWithRed:0.21 green:0.22 blue:0.36 alpha:1.00] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithWhite:0.45 alpha:1.0] forState:UIControlStateDisabled];
        
        self.backgroundView = [UIImageView new];
        [self addSubview:self.backgroundView];
        
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
        
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

#pragma mark - State

- (void)updateViews
{
    if([_backgroundView isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)self.backgroundView).image = [self currentBackgroundImage];
    } else if([_backgroundView isKindOfClass:[UIButtonBackgroundView class]]) {
        ((UIButtonBackgroundView *)_backgroundView).highlighted = (self.state == UIControlStateHighlighted);
    }
    
    _titleLabel.text = [self currentTitle];
    _titleLabel.attributedText = [self currentAttributedTitle];
    _titleLabel.textColor = [self currentTitleColor];
    _titleLabel.shadowColor = [self currentTitleShadowColor];
    
    _imageView.image = [self currentImage];
    
    [self setNeedsLayout];
}

- (UIControlState)state
{
    return _mouseDown? UIControlStateHighlighted : [super state];
}

#pragma mark - Properties

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self updateViews];
}

- (void)setButtonType:(UIButtonType)buttonType
{
    _buttonType = buttonType;
    
    BOOL wantsBorderlessButtons = [UIKitConfigurationManager sharedConfigurationManager].wantsBorderlessButtons;
    
    [_backgroundView removeFromSuperview];
    if(buttonType == UIButtonTypeSystem) {
        self.imageView._prefersToRenderTemplateImages = wantsBorderlessButtons;
        
        if(wantsBorderlessButtons)
            _backgroundView = [UIButtonBorderlessBackgroundView new];
        else
            _backgroundView = [UIButtonRoundRectBackgroundView new];
    } else if((NSInteger)buttonType == UIButtonType_Private_BarButton) {
        self.imageView._prefersToRenderTemplateImages = wantsBorderlessButtons;
        
        if(wantsBorderlessButtons)
            _backgroundView = [UIButtonBorderlessBackgroundView new];
        else
            _backgroundView = [UIButtonBarBackgroundView new];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if((NSInteger)buttonType == UIButtonType_Private_BackBarButton) {
        self.imageView._prefersToRenderTemplateImages = wantsBorderlessButtons;
        
        if(wantsBorderlessButtons)
            _backgroundView = [UIButtonBorderlessBackgroundView new];
        else
            _backgroundView = [UIButtonBarBackgroundView new];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self setTitleColor:[UIColor colorWithWhite:0.15 alpha:1.0] forState:UIControlStateNormal];
        [self setImage:UIKitImageNamed(@"UIBackButtonChevron", UIImageResizingModeStretch) forState:UIControlStateNormal];
    } else {
        _backgroundView = [UIImageView new];
    }
    [self insertSubview:_backgroundView atIndex:0];
    
    [self updateViews];
}

#pragma mark -

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsLayout];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    _titleEdgeInsets = titleEdgeInsets;
    [self setNeedsLayout];
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
{
    _imageEdgeInsets = imageEdgeInsets;
    [self setNeedsLayout];
}

#pragma mark -

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if(title)
        _titles[@(state)] = title;
    else
        [_titles removeObjectForKey:@(state)];
    
    [self updateViews];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if(color)
        _titleColors[@(state)] = color;
    else
        [_titleColors removeObjectForKey:@(state)];
    
    [self updateViews];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state
{
    if(color)
        _titleShadowColors[@(state)] = color;
    else
        [_titleShadowColors removeObjectForKey:@(state)];
    
    [self updateViews];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if(image)
        _images[@(state)] = image;
    else
        [_images removeObjectForKey:@(state)];
    
    if(state == UIControlStateNormal && _images[@(UIControlStateHighlighted)] == nil) {
        [self setImage:[image _tintedImageWithColor:[UIColor colorWithWhite:0.0 alpha:0.2]] forState:UIControlStateHighlighted];
    }
    
    [self updateViews];
}

#pragma mark -

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    if(image)
        _backgroundImages[@(state)] = image;
    else
        [_backgroundImages removeObjectForKey:@(state)];
    
    [self updateViews];
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
    if(title)
        _titles[@(state)] = title;
    else
        [_titles removeObjectForKey:@(state)];
    
    [self updateViews];
}

#pragma mark -

- (NSString *)titleForState:(UIControlState)state
{
    return _titles[@(state)] ?: _titles[@(UIControlStateNormal)];
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    return _titleColors[@(state)] ?: _titleColors[@(UIControlStateNormal)];
}

- (UIColor *)titleShadowColorForState:(UIControlState)state
{
    return _titleShadowColors[@(state)] ?: _titleShadowColors[@(UIControlStateNormal)];
}

- (UIImage *)imageForState:(UIControlState)state
{
    return _images[@(state)] ?: _images[@(UIControlStateNormal)];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
    return _backgroundImages[@(state)] ?: _backgroundImages[@(UIControlStateNormal)];
}

- (NSAttributedString *)attributedTitleForState:(UIControlState)state
{
    return _attributedTitles[@(state)] ?: _attributedTitles[@(UIControlStateNormal)];
}

#pragma mark -

- (NSString *)currentTitle
{
    return [self titleForState:self.state];
}

- (UIColor *)currentTitleColor
{
    return [self titleColorForState:self.state];
}

- (UIColor *)currentTitleShadowColor
{
    return [self titleShadowColorForState:self.state];
}

- (UIImage *)currentImage
{
    return [self imageForState:self.state];
}

- (UIImage *)currentBackgroundImage
{
    return [self backgroundImageForState:self.state];
}

- (NSAttributedString *)currentAttributedTitle
{
    return [self attributedTitleForState:self.state];
}

#pragma mark - Metrics

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    return bounds;
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.contentEdgeInsets);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize preferredSize = [self.titleLabel sizeThatFits:contentRect.size];
    return CGRectMake(round(CGRectGetMidX(contentRect) - preferredSize.width / 2.0) + self.currentImage.size.width,
                      round(CGRectGetMidY(contentRect) - preferredSize.height / 2.0) - 1.0,
                      preferredSize.width,
                      preferredSize.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize preferredSize = [self.imageView sizeThatFits:contentRect.size];
    return CGRectMake(5.0,
                      round(CGRectGetMidY(contentRect) - preferredSize.height / 2.0),
                      preferredSize.width,
                      preferredSize.height);
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize buttonSize;
    
    CGSize imageViewSize = [self.imageView sizeThatFits:size];
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:size];
    
    if(imageViewSize.width > 0.0 && titleLabelSize.width > 0.0) {
        buttonSize.width = INTER_VIEW_PADDING + imageViewSize.width + titleLabelSize.width;
        buttonSize.height = MAX(imageViewSize.height, buttonSize.height);
    } else if(imageViewSize.width > 0.0) {
        buttonSize = imageViewSize;
    } else if(titleLabelSize.width > 0.0) {
        buttonSize.width = titleLabelSize.width;
        buttonSize.height = MAX(MIN_PREFERRED_HEIGHT, buttonSize.height);
    }
    
    return buttonSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGRect backgroundRect = [self backgroundRectForBounds:bounds];
    self.backgroundView.frame = backgroundRect;
    
    CGRect contentRect = [self contentRectForBounds:bounds];
    
    CGRect titleRect = [self titleRectForContentRect:contentRect];
    self.titleLabel.frame = titleRect;
    
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    self.imageView.frame = imageRect;
}

#pragma mark - Events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint pointInSelf = [touch locationInView:self];
    BOOL isMouseInClickableArea = [self pointInside:pointInSelf withEvent:event];
	if(isMouseInClickableArea)
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    
    _mouseDown = NO;
    [self updateViews];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint pointInSelf = [touch locationInView:self];
    BOOL mouseInside = [self pointInside:pointInSelf withEvent:event];
    
    if(mouseInside == _mouseDown) {
        if(mouseInside)
            [self sendActionsForControlEvents:UIControlEventTouchDragInside];
        else
            [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    } else {
        if(mouseInside)
            [self sendActionsForControlEvents:UIControlEventTouchDragEnter];
        else
            [self sendActionsForControlEvents:UIControlEventTouchDragExit];
    }
    
    _mouseDown = mouseInside;
    [self updateViews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.enabled)
        return;
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    
    _mouseDown = YES;
    [self updateViews];
}

@end

//
//  UITableViewCell.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableViewCell_Private.h"

#import "UIImage_Private.h"

#import "UILabel.h"
#import "UIImageView.h"

static UIEdgeInsets const kContentInsets = { 0.0, 10.0, 0.0, 10.0 };
static CGFloat const kSubtitleStyleInterLabelPadding = 2.0;

@implementation UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if((self = [super initWithFrame:CGRectZero])) {
        self.userInteractionEnabled = NO;
        
        self.style = style;
        self.reuseIdentifier = reuseIdentifier;
        
        self.contentView = [UIView new];
        self.contentView.userInteractionEnabled = NO;
        [self addSubview:self.contentView];
        
        self.textLabel = [UILabel new];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self.contentView addSubview:self.textLabel];
        
        if(style != UITableViewCellStyleDefault) {
            self.detailTextLabel = [UILabel new];
            self.detailTextLabel.textColor = [UIColor grayColor];
            self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
            self.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
            [self.contentView addSubview:self.detailTextLabel];
        }
        
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
        
        
        self._separatorView = [UIView new];
        self._separatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self._separatorView];
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (void)prepareForReuse
{
    
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    if(_accessoryView) {
        CGRect accessoryViewFrame = _accessoryView.frame;
        accessoryViewFrame.origin.x = CGRectGetMaxX(bounds) - CGRectGetWidth(accessoryViewFrame) - kContentInsets.right;
        accessoryViewFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(accessoryViewFrame) / 2.0);
        _accessoryView.frame = accessoryViewFrame;
        
        CGRect contentViewFrame = bounds;
        contentViewFrame.size.width -= CGRectGetWidth(accessoryViewFrame) + kContentInsets.right + 5.0;
        self.contentView.frame = contentViewFrame;
    } else {
        self.contentView.frame = bounds;
    }
    
    self.backgroundView.frame = bounds;
    self.selectedBackgroundView.frame = bounds;
    
    self._separatorView.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - 1.0, CGRectGetWidth(bounds), 1.0);
    
    bounds = UIEdgeInsetsInsetRect(bounds, kContentInsets);
    
    CGRect imageViewFrame = self.imageView.frame;
    if(self.imageView.image) {
        imageViewFrame.size = [self.imageView sizeThatFits:bounds.size];
        imageViewFrame.origin = bounds.origin;
        
        bounds.origin.x += CGRectGetMaxX(imageViewFrame);
    } else {
        imageViewFrame = CGRectZero;
    }
    self.imageView.frame = imageViewFrame;
    
    CGRect textLabelFrame = self.textLabel.frame;
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    
    switch (_style) {
        case UITableViewCellStyleDefault: {
            textLabelFrame = bounds;
            
            break;
        }
            
        case UITableViewCellStyleSubtitle: {
            BOOL textLabelHasText = (self.textLabel.text.length > 0);
            BOOL detailTextLabelHasText = (self.detailTextLabel.text.length > 0);
            BOOL bothLabelsHaveText = (textLabelHasText && detailTextLabelHasText);
            
            if(textLabelHasText) {
                textLabelFrame.size.height = [self.textLabel sizeThatFits:bounds.size].height;
                textLabelFrame.size.width = CGRectGetWidth(bounds);
                textLabelFrame.origin.x = CGRectGetMinX(bounds);
                if(bothLabelsHaveText)
                    textLabelFrame.origin.y = CGRectGetMidY(bounds) - (CGRectGetHeight(textLabelFrame) + kSubtitleStyleInterLabelPadding);
                else
                    textLabelFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(textLabelFrame) / 2.0);
            } else {
                textLabelFrame = CGRectZero;
            }
            
            if(detailTextLabelHasText) {
                detailTextLabelFrame.size.height = [self.detailTextLabel sizeThatFits:bounds.size].height;
                detailTextLabelFrame.size.width = CGRectGetWidth(bounds);
                detailTextLabelFrame.origin.x = CGRectGetMinX(bounds);
                if(bothLabelsHaveText)
                    detailTextLabelFrame.origin.y = CGRectGetMidY(bounds) + kSubtitleStyleInterLabelPadding;
                else
                    detailTextLabelFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(detailTextLabelFrame) / 2.0);
            } else {
                detailTextLabelFrame = CGRectZero;
            }
            
            break;
        }
            
        case UITableViewCellStyleValue1: {
            UIKitUnimplementedMethod();
            break;
        }
            
        case UITableViewCellStyleValue2: {
            UIKitUnimplementedMethod();
            break;
        }
    }
    
    self.textLabel.frame = textLabelFrame;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

#pragma mark - Selection / Highlighting

- (void)setHighlighted:(BOOL)highlighted
{
    [self setHighlighted:highlighted animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animate
{
    _highlighted = highlighted;
    
    if(animate) {
        [UIView animateWithDuration:UIKitAnimationDuration animations:^{
            self.backgroundView.alpha = highlighted? 1.0 : 0.0;
            self.selectedBackgroundView.alpha = !highlighted? 0.0 : 1.0;
        } completion:^(BOOL finished) {
            self.backgroundView.hidden = highlighted;
            self.backgroundView.alpha = 1.0;
            
            self.selectedBackgroundView.hidden = !highlighted;
            self.selectedBackgroundView.alpha = 1.0;
            
            self.textLabel.highlighted = highlighted;
            self.detailTextLabel.highlighted = highlighted;
        }];
    } else {
        self.backgroundView.hidden = highlighted;
        self.selectedBackgroundView.hidden = !highlighted;
        
        self.textLabel.highlighted = highlighted;
        self.detailTextLabel.highlighted = highlighted;
    }
}

#pragma mark -

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animate
{
    [self setHighlighted:selected animated:animate];
    _selected = selected;
}

#pragma mark - Properties

- (void)setBackgroundView:(UIView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    _backgroundView.hidden = _highlighted;
    _backgroundView.userInteractionEnabled = NO;
    
    if(_backgroundView)
        [self insertSubview:_backgroundView atIndex:0];
    [self setNeedsLayout];
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView
{
    [_selectedBackgroundView removeFromSuperview];
    
    _selectedBackgroundView = selectedBackgroundView;
    _selectedBackgroundView.hidden = !_highlighted;
    _selectedBackgroundView.userInteractionEnabled = NO;
    
    if(_selectedBackgroundView)
        [self insertSubview:_selectedBackgroundView atIndex:0];
    [self setNeedsLayout];
}

#pragma mark -

- (void)_setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle color:(UIColor *)color
{
    self._separatorView.hidden = (separatorStyle == UITableViewCellSeparatorStyleNone);
    self._separatorView.backgroundColor = color;
}

- (void)setSelectionStyle:(UITableViewCellSelectionStyle)selectionStyle
{
    _selectionStyle = selectionStyle;
    
    self.selectedBackgroundView = [UIView new];
    
    switch (selectionStyle) {
        case UITableViewCellSelectionStyleNone: {
            self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            break;
        }
            
        case UITableViewCellSelectionStyleBlue: {
            self.selectedBackgroundView.backgroundColor = self.tintColor;
            break;
        }
            
        case UITableViewCellSelectionStyleGray: {
            self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
            break;
        }
    }
}

#pragma mark - Accessory Views

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    _accessoryType = accessoryType;
    
    UIView *accessoryView = nil;
    switch (accessoryType) {
        case UITableViewCellAccessoryNone: {
            break;
        }
            
        case UITableViewCellAccessoryCheckmark: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UITableViewCellAccessoryCheckmark");
            break;
        }
            
        case UITableViewCellAccessoryDetailDisclosureButton: {
            accessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            break;
        }
            
        case UITableViewCellAccessoryDisclosureIndicator: {
            UIImage *disclosureIndicatorImage = UIKitImageNamed(@"UITableViewCellAccessoryDisclosureIndicator", UIImageResizingModeStretch);
            accessoryView = [[UIImageView alloc] initWithImage:disclosureIndicatorImage];
            break;
        }
    }
    
    self.accessoryView = accessoryView;
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    [_accessoryView removeFromSuperview];
    
    _accessoryView = accessoryView;
    
    if(_accessoryView)
        [self addSubview:_accessoryView];
    
    [self setNeedsLayout];
}

#pragma mark - Tint Color

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    if(_selectionStyle == UITableViewCellSelectionStyleBlue)
        self.selectedBackgroundView.backgroundColor = self.tintColor;
}

@end

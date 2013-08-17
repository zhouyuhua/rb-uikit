//
//  UITableViewCell.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableViewCell_Private.h"

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
        
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor alternateSelectedControlColor];
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
    self.contentView.frame = bounds;
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
            textLabelFrame.size.height = [self.textLabel sizeThatFits:bounds.size].height;
            textLabelFrame.size.width = CGRectGetWidth(bounds);
            textLabelFrame.origin.x = CGRectGetMinX(bounds);
            textLabelFrame.origin.y = CGRectGetMidY(bounds) - (CGRectGetHeight(textLabelFrame) + kSubtitleStyleInterLabelPadding);
            
            detailTextLabelFrame.size.height = [self.detailTextLabel sizeThatFits:bounds.size].height;
            detailTextLabelFrame.size.width = CGRectGetWidth(bounds);
            detailTextLabelFrame.origin.x = CGRectGetMinX(bounds);
            detailTextLabelFrame.origin.y = CGRectGetMidY(bounds) + kSubtitleStyleInterLabelPadding;
            
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
        [UIView animateWithDuration:0.25 animations:^{
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
    
    [self insertSubview:_backgroundView atIndex:0];
    [self setNeedsLayout];
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView
{
    [_selectedBackgroundView removeFromSuperview];
    
    _selectedBackgroundView = selectedBackgroundView;
    _selectedBackgroundView.hidden = !_highlighted;
    _selectedBackgroundView.userInteractionEnabled = NO;
    
    [self insertSubview:_selectedBackgroundView atIndex:0];
    [self setNeedsLayout];
}

#pragma mark -

- (void)_setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle color:(UIColor *)color
{
    self._separatorView.hidden = (separatorStyle == UITableViewCellSeparatorStyleNone);
    self._separatorView.backgroundColor = color;
}

@end

//
//  UITableViewHeaderFooterView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableViewHeaderFooterView.h"

#import "UILabel.h"

#import "UIImageView.h"
#import "UIImage_Private.h"

static UIEdgeInsets const kContentInsets = { 0.0, 10.0, 0.0, 10.0 };
static CGFloat const kSubtitleStyleInterLabelPadding = 2.0;

@interface UITableViewHeaderFooterView ()

#pragma mark - readwrite

@property (nonatomic, readwrite, copy) NSString *reuseIdentifier;

@property (nonatomic, readwrite) UIView *contentView;

@property (nonatomic, readwrite) UILabel *textLabel;
@property (nonatomic, readwrite) UILabel *detailTextLabel;

@end

@implementation UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if((self = [super init])) {
        self.reuseIdentifier = nil;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.contentView = [UIView new];
        [self addSubview:self.contentView];
        
        self.textLabel = [UILabel new];
        self.textLabel.font = [UIFont boldSystemFontOfSize:10.0];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [self.contentView addSubview:self.textLabel];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:UIKitImageNamed(@"UITableViewHeaderFooterViewBackground", UIImageResizingModeStretch)];
        backgroundView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundView = backgroundView;
    }
    
    return self;
}

#pragma mark -

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
    
    bounds = UIEdgeInsetsInsetRect(bounds, kContentInsets);
    
    CGRect textLabelFrame = self.textLabel.frame;
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
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
    self.textLabel.frame = textLabelFrame;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

#pragma mark - Properties

- (void)setBackgroundView:(UIView *)backgroundView
{
    if(_backgroundView)
        [_backgroundView removeFromSuperview];
    
    _backgroundView = backgroundView;
    
    if(_backgroundView)
        [self insertSubview:_backgroundView atIndex:0];
    
    [self setNeedsLayout];
}

@end

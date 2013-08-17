//
//  UITableViewCell.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@class UILabel, UIImageView;

typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
    UITableViewCellStyleDefault,
    UITableViewCellStyleValue1,
    UITableViewCellStyleValue2,
    UITableViewCellStyleSubtitle
};

@interface UITableViewCell : UIView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)prepareForReuse;

#pragma mark - Properties

@property (nonatomic, readonly) UITableViewCellStyle style;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

#pragma mark -

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *selectedBackgroundView;

#pragma mark -

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailTextLabel;
@property (nonatomic, readonly) UIImageView *imageView;

#pragma mark - Selection / Highlighting

@property (nonatomic, getter=isHighlighted) BOOL highlighted;
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animate;

@property (nonatomic, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animate;

@end

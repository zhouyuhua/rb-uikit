//
//  UILabel.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"
#import "UIFont.h"

@interface UILabel : UIView

#pragma mark - Properties

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) NSLineBreakMode lineBreakMode;

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, retain) UIColor *highlightedTextColor;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@property (nonatomic) NSInteger numberOfLines;

@property (nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (nonatomic) CGFloat minimumFontSize;
//@property (nonatomic) UIBaselineAdjustment baselineAdjustment;
@property (nonatomic) CGFloat minimumScaleFactor;

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
- (void)drawTextInRect:(CGRect)rect;

@property (nonatomic) CGFloat preferredMaxLayoutWidth;

@end

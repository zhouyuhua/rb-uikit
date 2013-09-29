//
//  UITextView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollView.h"
#import "UIDataDetectorTypes.h"
#import "UIGeometry.h"
#import "UIFont.h"
#import "UIColor.h"

@class UITextView;

@protocol UITextViewDelegate <NSObject, UIScrollViewDelegate>
@optional

@end

#pragma mark -

@interface UITextView : UIScrollView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer;

#pragma mark - Configuring the Text Attributes

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;

#pragma mark -

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;

#pragma mark -

@property (nonatomic, getter=isEditable) BOOL editable;
@property (nonatomic) BOOL allowsEditingTextAttributes;

#pragma mark -

@property (nonatomic) UIDataDetectorTypes dataDetectorTypes;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic, copy) NSDictionary *typingAttributes;
@property (nonatomic, copy) NSDictionary *linkTextAttributes;
@property (nonatomic) UIEdgeInsets textContainerInset;

#pragma mark - Working with the Selection

@property (nonatomic) NSRange selectedRange;
- (void)scrollRangeToVisible:(NSRange)range;
@property (nonatomic) BOOL clearsOnInsertion;
@property (nonatomic, getter=isSelectable) BOOL selectable;

#pragma mark - Accessing the Delegate

@property (nonatomic, unsafe_unretained) id <UITextViewDelegate> delegate;

#pragma mark - Replacing the System Input Views

@property (nonatomic) UIView *inputView;
@property (nonatomic) UIView *inputAccessoryView;

#pragma mark - Accessing Text Kit Objects

@property (nonatomic, readonly) NSLayoutManager *layoutManager;
@property (nonatomic, readonly) NSTextContainer *textContainer;
@property (nonatomic, readonly) NSTextStorage *textStorage;

@end

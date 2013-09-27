//
//  UITextField.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIControl.h"
#import "UIFont.h"
#import "UITextInputTraits.h"

@protocol UITextFieldDelegate;

typedef NS_ENUM(NSInteger, UITextBorderStyle) {
    UITextBorderStyleNone,
    UITextBorderStyleLine,
    UITextBorderStyleBezel,
    UITextBorderStyleRoundedRect
};

typedef NS_ENUM(NSInteger, UITextFieldViewMode) {
    UITextFieldViewModeNever,
    UITextFieldViewModeWhileEditing,
    UITextFieldViewModeUnlessEditing,
    UITextFieldViewModeAlways
};

@interface UITextField : UIControl <UITextInputTraits>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) UITextBorderStyle borderStyle;

#pragma mark -

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;
@property (nonatomic) BOOL clearsOnBeginEditing;
@property (nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (nonatomic) CGFloat minimumFontSize;
@property (nonatomic, assign) id <UITextFieldDelegate> delegate;
@property (nonatomic, retain) UIImage *background;
@property (nonatomic, retain) UIImage *disabledBackground;

#pragma mark -

@property (nonatomic, readonly, getter=isEditing) BOOL editing;
@property (nonatomic) BOOL allowsEditingTextAttributes;
@property (nonatomic, copy) NSDictionary *typingAttributes;

#pragma mark -

@property (nonatomic) UITextFieldViewMode clearButtonMode;

#pragma mark -

@property (nonatomic, retain) UIView *leftView;
@property (nonatomic) UITextFieldViewMode leftViewMode;

@property (nonatomic, retain) UIView *rightView;
@property (nonatomic) UITextFieldViewMode rightViewMode;

#pragma mark - drawing and positioning overrides

- (CGRect)borderRectForBounds:(CGRect)bounds;
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)placeholderRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;
- (CGRect)clearButtonRectForBounds:(CGRect)bounds;
- (CGRect)leftViewRectForBounds:(CGRect)bounds;
- (CGRect)rightViewRectForBounds:(CGRect)bounds;

#pragma mark - Drawing

- (void)drawTextInRect:(CGRect)rect;
- (void)drawPlaceholderInRect:(CGRect)rect;

#pragma mark -

@property (readwrite, retain) UIView *inputView;
@property (readwrite, retain) UIView *inputAccessoryView;

#pragma mark -

@property (nonatomic) BOOL clearsOnInsertion;

@end

@protocol UITextFieldDelegate <NSObject>

@optional

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)textFieldShouldClear:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

UIKIT_EXTERN NSString *const UITextFieldTextDidBeginEditingNotification;
UIKIT_EXTERN NSString *const UITextFieldTextDidEndEditingNotification;
UIKIT_EXTERN NSString *const UITextFieldTextDidChangeNotification;

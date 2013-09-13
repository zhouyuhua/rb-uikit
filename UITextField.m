//
//  UITextField.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITextField_Private.h"
#import "UIAppKitView.h"
#import "UINSTextFieldCell.h"
#import "UIImage_Private.h"
#import "UIWindow_Private.h"

NSString *const UITextFieldTextDidBeginEditingNotification = @"UITextFieldTextDidBeginEditingNotification";
NSString *const UITextFieldTextDidEndEditingNotification = @"UITextFieldTextDidEndEditingNotification";
NSString *const UITextFieldTextDidChangeNotification = @"UITextFieldTextDidChangeNotification";

#define TEXT_MARGIN 5.0
#define VIEW_MARGIN 10.0

#pragma mark -

@implementation UITextField

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUnderlyingInputView
{
    UINSTextField *underlyingTextField = [UINSTextField new];
    underlyingTextField.textField = self;
    
    underlyingTextField.editable = YES;
    underlyingTextField.bordered = NO;
    underlyingTextField.drawsBackground = NO;
    underlyingTextField.focusRingType = NSFocusRingTypeNone;
    underlyingTextField.bezelStyle = NSTextFieldSquareBezel;
    underlyingTextField.action = @selector(textFieldEntered:);
    underlyingTextField.target = self;
    underlyingTextField.delegate = self;
    [underlyingTextField.cell setWraps:NO];
    [underlyingTextField.cell setScrollable:YES];
    
    self.underlyingTextField = underlyingTextField;
    self.textFieldHost = [[UIAppKitView alloc] initWithView:underlyingTextField];
    [self addSubview:self.textFieldHost];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextDidBeginEditing:)
                                                 name:NSControlTextDidBeginEditingNotification
                                               object:self.underlyingTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextDidEndEditing:)
                                                 name:NSControlTextDidEndEditingNotification
                                               object:self.underlyingTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextDidChange:)
                                                 name:NSControlTextDidChangeNotification
                                               object:self.underlyingTextField];
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        [self setupUnderlyingInputView];
        
        self.backgroundView = [UIImageView new];
        self.backgroundView.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:self.backgroundView atIndex:0];
        
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.font = [UIFont systemFontOfSize:13.0];
        
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    
    self.backgroundView.frame = [self borderRectForBounds:bounds];
    self.textFieldHost.frame = bounds;
    
    if([self _isLeftViewVisible]) {
        self.leftView.frame = [self leftViewRectForBounds:bounds];
    }
    
    if([self _isRightViewVisible]) {
        self.leftView.frame = [self rightViewRectForBounds:bounds];
    }
}

#pragma mark - Responder Business

- (BOOL)canBecomeFirstResponder
{
    return self.textFieldHost.canBecomeFirstResponder;
}

- (BOOL)canResignFirstResponder
{
    return self.textFieldHost.canResignFirstResponder;
}

- (BOOL)becomeFirstResponder
{
    return [self.textFieldHost becomeFirstResponder] && [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textFieldHost resignFirstResponder] && [super resignFirstResponder];
}

#pragma mark - Properties

- (void)setDelegate:(id <UITextFieldDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.textFieldShouldBeginEditing = [delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)];
    _delegateRespondsTo.textFieldDidBeginEditing = [delegate respondsToSelector:@selector(textFieldDidBeginEditing:)];
    _delegateRespondsTo.textFieldShouldEndEditing = [delegate respondsToSelector:@selector(textFieldShouldEndEditing:)];
    _delegateRespondsTo.textFieldDidEndEditing = [delegate respondsToSelector:@selector(textFieldDidEndEditing:)];
    
    _delegateRespondsTo.textFieldShouldChangeCharactersInRangeReplacementString = [delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)];
    
    _delegateRespondsTo.textFieldShouldClear = [delegate respondsToSelector:@selector(textFieldShouldClear:)];
    _delegateRespondsTo.textFieldShouldReturn = [delegate respondsToSelector:@selector(textFieldShouldReturn:)];
}

#pragma mark -

- (void)setText:(NSString *)text
{
    self.underlyingTextField.stringValue = text ?: @"";
}

- (NSString *)text
{
    return self.underlyingTextField.stringValue;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.underlyingTextField.attributedStringValue = attributedText;
}

- (NSAttributedString *)attributedText
{
    return self.underlyingTextField.attributedStringValue;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.underlyingTextField.textColor = textColor;
}

- (UIColor *)textColor
{
    return self.underlyingTextField.textColor;
}

- (void)setFont:(UIFont *)font
{
    self.underlyingTextField.font = font;
}

- (UIFont *)font
{
    return self.underlyingTextField.font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.underlyingTextField.alignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return self.underlyingTextField.alignment;
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    _borderStyle = borderStyle;
    
    switch (_borderStyle) {
        case UITextBorderStyleNone: {
            self.background = nil;
            self.disabledBackground = nil;
            break;
        }
            
        case UITextBorderStyleLine:
        case UITextBorderStyleBezel: {
            UIImage *backgroundImage = [UIKitImageNamed(@"UITextFieldSquareBackground", UIImageResizingModeStretch) resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
            self.background = backgroundImage;
            self.disabledBackground = backgroundImage;
            break;
        }
            
        case UITextBorderStyleRoundedRect: {
            UIImage *backgroundImage = [UIKitImageNamed(@"UITextFieldRoundBackground", UIImageResizingModeStretch) resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
            self.background = backgroundImage;
            self.disabledBackground = backgroundImage;
            break;
        }
    }
}

#pragma mark -

- (void)setPlaceholder:(NSString *)placeholder
{
    [(NSTextFieldCell *)self.underlyingTextField.cell setPlaceholderString:placeholder];
}

- (NSString *)placeholder
{
    return [(NSTextFieldCell *)self.underlyingTextField.cell placeholderString];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    [(NSTextFieldCell *)self.underlyingTextField.cell setPlaceholderAttributedString:attributedPlaceholder];
}

- (NSAttributedString *)attributedPlaceholder
{
    return [(NSTextFieldCell *)self.underlyingTextField.cell placeholderAttributedString];
}

#pragma mark -

//@property (nonatomic) BOOL adjustsFontSizeToFitWidth;
//@property (nonatomic) CGFloat minimumFontSize;

- (void)setBackground:(UIImage *)background
{
    _background = background;
    if(self.enabled)
        _backgroundView.image = _background;
}

- (void)setDisabledBackground:(UIImage *)disabledBackground
{
    _disabledBackground = disabledBackground;
    if(!self.enabled)
        _backgroundView.image = _disabledBackground;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.underlyingTextField.enabled = enabled;
    
    if(self.enabled)
        _backgroundView.image = self.background;
    else
        _backgroundView.image = self.disabledBackground;
}

#pragma mark - Accessory Views

- (BOOL)_isLeftViewVisible
{
    if(!_leftView)
        return NO;
    
    UITextFieldViewMode mode = self.leftViewMode;
    if(mode == UITextFieldViewModeAlways)
        return YES;
    else if(mode == UITextFieldViewModeNever)
        return NO;
    else if(mode == UITextFieldViewModeWhileEditing && self.editing)
        return YES;
    else if(mode == UITextFieldViewModeUnlessEditing && !self.editing)
        return YES;
    else
        return NO;
}

- (BOOL)_isRightViewVisible
{
    if(!_rightView)
        return NO;
    
    UITextFieldViewMode mode = self.rightViewMode;
    if(mode == UITextFieldViewModeAlways)
        return YES;
    else if(mode == UITextFieldViewModeNever)
        return NO;
    else if(mode == UITextFieldViewModeWhileEditing && self.editing)
        return YES;
    else if(mode == UITextFieldViewModeUnlessEditing && !self.editing)
        return YES;
    else
        return NO;
}

#pragma mark -

- (void)setLeftView:(UIView *)leftView
{
    if(_leftView) {
        [_leftView removeFromSuperview];
    }
    
    _leftView = leftView;
    
    if(_leftView) {
        [self addSubview:_leftView];
        
        [self setNeedsLayout];
    }
}

- (void)setLeftViewMode:(UITextFieldViewMode)leftViewMode
{
    _leftViewMode = leftViewMode;
    
    self.leftView.hidden = ![self _isLeftViewVisible];
    [self setNeedsLayout];
}

- (void)setRightView:(UIView *)rightView
{
    if(_rightView) {
        [_rightView removeFromSuperview];
    }
    
    _rightView = rightView;
    
    if(_rightView) {
        [self addSubview:_rightView];
        
        [self setNeedsLayout];
    }
}

- (void)setRightViewMode:(UITextFieldViewMode)rightViewMode
{
    _rightViewMode = rightViewMode;
    
    self.rightView.hidden = ![self _isRightViewVisible];
    [self setNeedsLayout];
}

#pragma mark -

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    self.leftView.hidden = ![self _isLeftViewVisible];
    self.rightView.hidden = ![self _isRightViewVisible];
    [self setNeedsLayout];
}

#pragma mark - <UITextInputTraits>

@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize enablesReturnKeyAutomatically;
@synthesize keyboardAppearance;
@synthesize keyboardType;
@synthesize returnKeyType;
@synthesize secureTextEntry;
@synthesize spellCheckingType;

#pragma mark - drawing and positioning overrides

- (CGRect)borderRectForBounds:(CGRect)bounds
{
    return bounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGSize cellSize = [self.underlyingTextField.cell cellSizeForBounds:bounds];
    CGRect leftViewFrame = [self leftViewRectForBounds:bounds];
    CGRect rightViewFrame = [self rightViewRectForBounds:bounds];
    CGFloat rightViewArea = CGRectGetWidth(rightViewFrame) > 0.0? CGRectGetWidth(rightViewFrame) + VIEW_MARGIN : 0.0;
    return CGRectMake(CGRectGetMaxX(leftViewFrame) + TEXT_MARGIN,
                      round(CGRectGetMidY(bounds) - cellSize.height / 2.0) - 1.0,
                      CGRectGetWidth(bounds) - ((TEXT_MARGIN * 2.0) + CGRectGetMaxX(leftViewFrame) + rightViewArea),
                      cellSize.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

#pragma mark -

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    UIKitUnimplementedMethod();
    return CGRectZero;
}

#pragma mark -

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    if([self _isLeftViewVisible]) {
        CGRect leftViewFrame = self.leftView.frame;
        leftViewFrame.origin.x = CGRectGetMinX(bounds) + VIEW_MARGIN;
        leftViewFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(leftViewFrame) / 2.0);
        return leftViewFrame;
    }
    
    return CGRectZero;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    if([self _isRightViewVisible]) {
        CGRect rightViewFrame = self.rightView.frame;
        rightViewFrame.origin.x = CGRectGetMaxX(bounds) - (CGRectGetWidth(rightViewFrame) + VIEW_MARGIN);
        rightViewFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(rightViewFrame) / 2.0);
        return rightViewFrame;
    }
    
    return CGRectZero;
}

#pragma mark - Drawing

- (void)drawTextInRect:(CGRect)rect
{
    UIKitUnimplementedMethod();
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    UIKitUnimplementedMethod();
}

#pragma mark - <NSTextFieldDelegate>

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    if(_delegateRespondsTo.textFieldShouldBeginEditing)
        return [_delegate textFieldShouldBeginEditing:self];
    else
        return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if(_delegateRespondsTo.textFieldShouldEndEditing)
        return [_delegate textFieldShouldEndEditing:self];
    else
        return YES;
}

#pragma mark -

- (void)controlTextDidBeginEditing:(NSNotification *)notification
{
    self.editing = YES;
    
    if(self.clearsOnBeginEditing)
        self.text = nil;
    
    if(_delegateRespondsTo.textFieldDidBeginEditing)
        [_delegate textFieldDidBeginEditing:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidBeginEditingNotification object:self];
}

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
    self.editing = NO;
    
    if(_delegateRespondsTo.textFieldDidEndEditing)
        [_delegate textFieldDidEndEditing:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidEndEditingNotification object:self];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
}

#pragma mark -

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if(commandSelector == @selector(insertTab:)) {
        if(([NSEvent modifierFlags] & NSAlternateKeyMask) == NSAlternateKeyMask) {
            [textView insertTabIgnoringFieldEditor:nil];
        } else {
            [self.window _selectNextKeyView];
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark -

- (void)textFieldEntered:(NSTextField *)sender
{
    if(_delegateRespondsTo.textFieldShouldReturn && [_delegate textFieldShouldReturn:self])
        [sender resignFirstResponder];
}

@end

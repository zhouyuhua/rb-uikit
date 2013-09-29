//
//  UITextView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITextView_Private.h"
#import "UIAppKitView.h"
#import "UINSTextView.h"

@implementation UITextView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if((self = [super initWithFrame:frame])) {
        _nativeTextView = [[UINSTextView alloc] initWithFrame:self.bounds];
        
        if(textContainer)
            [_nativeTextView setTextContainer:textContainer];
        
        _nativeTextView.delegate = self;
        [_nativeTextView setFieldEditor:NO];
        [_nativeTextView setHorizontallyResizable:NO];
        [_nativeTextView setVerticallyResizable:YES];
        [_nativeTextView setMaxSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        _adaptorView = [[UIAppKitView alloc] initWithNativeView:_nativeTextView];
        __weak __typeof(self) weakSelf = self;
        _adaptorView.metricChangeObserver = ^(CGRect newFrame) {
            NSLog(@"newFrame: %@", NSStringFromCGRect(newFrame));
            weakSelf.contentSize = newFrame.size;
        };
        [self addSubview:_adaptorView];
        
        
        
        self.editable = YES;
        self.selectable = YES;
        self.allowsEditingTextAttributes = YES;
        
        self.font = [UIFont systemFontOfSize:13.0];
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        
        self.text = @"Test";
        self.contentSize = frame.size;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame textContainer:nil];
}

#pragma mark - Responder Business

- (BOOL)canBecomeFirstResponder
{
    return _nativeTextView.canBecomeKeyView;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (BOOL)_becomeFirstResponderModifyingNativeViewStatus:(BOOL)modifyingNativeViewStatus
{
    BOOL success = [super becomeFirstResponder];
    if(modifyingNativeViewStatus)
        success = [_adaptorView makeNativeViewBecomeFirstResponder] && success;
    
    return success;
}

- (BOOL)_resignFirstResponderModifyingNativeViewStatus:(BOOL)modifyingNativeViewStatus
{
    BOOL success = [super resignFirstResponder];
    if(modifyingNativeViewStatus)
        success = [_adaptorView makeNativeViewResignFirstResponder] && success;
    
    return success;
}

- (BOOL)becomeFirstResponder
{
    return [self _becomeFirstResponderModifyingNativeViewStatus:YES];
}

- (BOOL)resignFirstResponder
{
    return [self _resignFirstResponderModifyingNativeViewStatus:YES];
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeZero;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect adaptorViewFrame = _adaptorView.frame;
    adaptorViewFrame.origin = CGPointZero;
    adaptorViewFrame.size = self.contentSize;
    _adaptorView.frame = adaptorViewFrame;
}

#pragma mark - Configuring the Text Attributes

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    _nativeTextView.backgroundColor = backgroundColor;
}

#pragma mark -

- (void)setText:(NSString *)text
{
    [_nativeTextView setString:text ?: @""];
}

- (NSString *)text
{
    return [_nativeTextView string];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self.textStorage setAttributedString:attributedText];
}

- (NSAttributedString *)attributedText
{
    return [self.textStorage copy];
}

#pragma mark -

- (void)setFont:(UIFont *)font
{
    [_nativeTextView setFont:font];
}

- (UIFont *)font
{
    return [_nativeTextView font];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_nativeTextView setTextColor:textColor];
}

- (UIColor *)textColor
{
    return [_nativeTextView textColor];
}

#pragma mark -

- (void)setEditable:(BOOL)editable
{
    [_nativeTextView setEditable:editable];
}

- (BOOL)isEditable
{
    return [_nativeTextView isEditable];
}

- (void)setAllowsEditingTextAttributes:(BOOL)allowsEditingTextAttributes
{
    //TODO: This is wrong
    [_nativeTextView setRichText:allowsEditingTextAttributes];
}

- (BOOL)allowsEditingTextAttributes
{
    return [_nativeTextView isRichText];
}

#pragma mark -

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [_nativeTextView setAlignment:textAlignment];
}

- (NSTextAlignment)textAlignment
{
    return [_nativeTextView alignment];
}

- (void)setTypingAttributes:(NSDictionary *)typingAttributes
{
    [_nativeTextView setTypingAttributes:typingAttributes];
}

- (NSDictionary *)typingAttributes
{
    return [_nativeTextView typingAttributes];
}

- (void)setLinkTextAttributes:(NSDictionary *)linkTextAttributes
{
    [_nativeTextView setLinkTextAttributes:linkTextAttributes];
}

- (NSDictionary *)linkTextAttributes
{
    return [_nativeTextView linkTextAttributes];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"Separate top-bottom, left-right insets not support");
    [_nativeTextView setTextContainerInset:NSMakeSize(textContainerInset.left, textContainerInset.top)];
}

- (UIEdgeInsets)textContainerInset
{
    NSSize inset = [_nativeTextView textContainerInset];
    return UIEdgeInsetsMake(inset.height, inset.width, 0.0, 0.0);
}

#pragma mark - Working with the Selection

- (void)setSelectedRange:(NSRange)selectedRange
{
    [_nativeTextView setSelectedRange:selectedRange];
}

- (NSRange)selectedRange
{
    return [_nativeTextView selectedRange];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [_nativeTextView scrollRangeToVisible:range];
}

- (void)setSelectable:(BOOL)selectable
{
    [_nativeTextView setSelectable:selectable];
}

- (BOOL)isSelectable
{
    return [_nativeTextView isSelectable];
}

#pragma mark - Accessing Text Kit Objects

- (NSLayoutManager *)layoutManager
{
    return [_nativeTextView layoutManager];
}

- (NSTextContainer *)textContainer
{
    return [_nativeTextView textContainer];
}

- (NSTextStorage *)textStorage
{
    return [_nativeTextView textStorage];
}

#pragma mark - <NSTextViewDelegate>

- (BOOL)textShouldBeginEditing:(NSText *)textObject
{
    return YES;
}

- (BOOL)textShouldEndEditing:(NSText *)textObject
{
    return YES;
}

- (void)textDidBeginEditing:(NSNotification *)notification
{
    [self _becomeFirstResponderModifyingNativeViewStatus:NO];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [self _resignFirstResponderModifyingNativeViewStatus:NO];
}

- (void)textDidChange:(NSNotification *)notification
{
    
}

@end

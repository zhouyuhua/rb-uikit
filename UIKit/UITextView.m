//
//  UITextView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITextView_Private.h"
#import "UIAppKitView.h"
#import "UIWindow.h"
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
        [_nativeTextView setAllowsUndo:YES];
        [_nativeTextView setInsertionPointColor:self.tintColor];
        [_nativeTextView setSelectedTextAttributes:@{NSBackgroundColorAttributeName: [self.tintColor colorWithAlphaComponent:0.5]}];
        [_nativeTextView setAutomaticDataDetectionEnabled:YES];
        
        _adaptorView = [[UIAppKitView alloc] initWithNativeView:_nativeTextView];
        __weak __typeof(self) weakSelf = self;
        _adaptorView.nativeViewSizeChangeObserver = ^(CGRect newFrame) {
            weakSelf.contentSize = newFrame.size;
        };
        [self addSubview:_adaptorView];
        
        
        
        self.editable = YES;
        self.selectable = YES;
        self.allowsEditingTextAttributes = YES;
        
        self.font = [UIFont userFontOfSize:13.0];
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
    return [_adaptorView canNativeViewBecomeFirstResponder];
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
    (void)[self.layoutManager glyphRangeForTextContainer:self.textContainer]; //Force layout
    
    NSRect usedRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    
    return CGSizeMake(MIN(size.width, NSWidth(usedRect)),
                      MIN(size.height, NSHeight(usedRect)));
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
    if(textContainerInset.left != textContainerInset.right ||
       textContainerInset.top != textContainerInset.bottom) {
        UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"Assymetrical text container insets");
    }
    
    [_nativeTextView setTextContainerInset:NSMakeSize(textContainerInset.left + textContainerInset.right,
                                                      textContainerInset.top + textContainerInset.bottom)];
}

- (UIEdgeInsets)textContainerInset
{
    NSSize inset = [_nativeTextView textContainerInset];
    return UIEdgeInsetsMake(inset.height / 2.0,
                            inset.width / 2.0,
                            inset.height / 2.0,
                            inset.width / 2.0);
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

#pragma mark - Delegate

- (void)setDelegate:(id <UITextViewDelegate>)delegate
{
    [super setDelegate:delegate];
    
    _delegateRespondsTo.textViewShouldBeginEditing = [delegate respondsToSelector:@selector(textViewShouldBeginEditing:)];
    _delegateRespondsTo.textViewDidBeginEditing = [delegate respondsToSelector:@selector(textViewDidBeginEditing:)];
    _delegateRespondsTo.textViewShouldEndEditing = [delegate respondsToSelector:@selector(textViewShouldEndEditing:)];
    _delegateRespondsTo.textViewDidEndEditing = [delegate respondsToSelector:@selector(textViewDidEndEditing:)];
    
    _delegateRespondsTo.textViewShouldChangeTextInRangeReplacementText = [delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)];
    _delegateRespondsTo.textViewDidChange = [delegate respondsToSelector:@selector(textViewDidChange:)];
    
    _delegateRespondsTo.textViewDidChangeSelection = [delegate respondsToSelector:@selector(textViewDidChangeSelection:)];
    
    _delegateRespondsTo.textViewShouldInteractWithTextAttachmentInRange = [delegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)];
    _delegateRespondsTo.textViewShouldInteractWithURLInRange = [delegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)];
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
    if(_delegateRespondsTo.textViewShouldBeginEditing)
        return [self.delegate textViewShouldBeginEditing:self];
    else
        return YES;
}

- (BOOL)textShouldEndEditing:(NSText *)textObject
{
    if(_delegateRespondsTo.textViewShouldEndEditing)
        return [self.delegate textViewShouldEndEditing:self];
    else
        return YES;
}

- (void)textDidBeginEditing:(NSNotification *)notification
{
    [self _becomeFirstResponderModifyingNativeViewStatus:NO];
    
    if(_delegateRespondsTo.textViewDidBeginEditing)
        [self.delegate textViewDidBeginEditing:self];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    [self _resignFirstResponderModifyingNativeViewStatus:NO];
    
    if(_delegateRespondsTo.textViewDidEndEditing)
        [self.delegate textViewDidEndEditing:self];
}

- (void)textDidChange:(NSNotification *)notification
{
    if(_delegateRespondsTo.textViewDidChange)
        [self.delegate textViewDidChange:self];
}

#pragma mark -

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex
{
    if(_delegateRespondsTo.textViewShouldInteractWithURLInRange) {
        NSRange range;
        [self.textStorage URLAtIndex:charIndex effectiveRange:&range];
        
        if([self.delegate textView:self shouldInteractWithURL:link inRange:range]) {
            return NO;
        } else {
            //Do nothing.
            return YES;
        }
    }
    
    return NO;
}

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    if(_delegateRespondsTo.textViewDidChangeSelection)
        [self.delegate textViewDidChangeSelection:self];
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    if(_delegateRespondsTo.textViewShouldChangeTextInRangeReplacementText)
        return [self.delegate textView:self shouldChangeTextInRange:affectedCharRange replacementText:replacementString];
    else
        return YES;
}

#pragma mark -

- (NSUndoManager *)undoManagerForTextView:(NSTextView *)view
{
    return self.window.undoManager;
}

#pragma mark - Tint Colors

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    [_nativeTextView setInsertionPointColor:self.tintColor];
    [_nativeTextView setSelectedTextAttributes:@{NSBackgroundColorAttributeName: [self.tintColor colorWithAlphaComponent:0.5]}];
}

#pragma mark - Event Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self _becomeFirstResponderModifyingNativeViewStatus:YES];
    [_nativeTextView moveToEndOfDocument:nil];
    
    [super touchesBegan:touches withEvent:event];
}

@end

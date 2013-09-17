//
//  UISearchBar.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UISearchBar.h"
#import "UITextField.h"
#import "UIImageView.h"
#import "UIImage_Private.h"
#import "UIView_Private.h"

static id MakeIconImagesKey(UISearchBarIcon icon, UIControlState state)
{
    return @(icon + state);
}

@interface UISearchBar () <UITextFieldDelegate> {
    NSMutableDictionary *_iconImages;
    
    struct {
        int searchBarShouldBeginEditing : 1;
        int searchBarTextDidBeginEditing : 1;
        int searchBarShouldEndEditing : 1;
        int searchBarTextDidEndEditing : 1;
        
        int searchBarTextDidChange : 1;
        int searchBarShouldChangeTextInRangeReplacementText : 1;
        
        int searchBarSearchButtonClicked : 1;
        int searchBarBookmarkButtonClicked : 1;
        int searchBarCancelButtonClicked : 1;
        int searchBarResultsListButtonClicked : 1;
        
        int searchBarSelectedScopeButtonIndexDidChange : 1;
    } _delegateRespondsTo;
}

@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UITextField *textField;

@property (nonatomic) UIImageView *magnifyingGlassImageView;
@property (nonatomic) UIButton *_clearButton;

@end

@implementation UISearchBar

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.backgroundView = [UIImageView new];
        [self addSubview:self.backgroundView];
        
        self.textField = [UITextField new];
        self.textField.delegate = self;
        self.textField.background = [UIKitImageNamed(@"UISearchBarBackground", UIImageResizingModeStretch) resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)];
        [self addSubview:self.textField];
        
        self.magnifyingGlassImageView = [[UIImageView alloc] initWithImage:UIKitImageNamed(@"UISearchBarMagnifyingGlass", UIImageResizingModeStretch)];
        self.textField.leftView = self.magnifyingGlassImageView;
        
        _iconImages = [NSMutableDictionary dictionary];
        _iconImages[MakeIconImagesKey(UISearchBarIconSearch, UIControlStateNormal)] = self.magnifyingGlassImageView.image;
        
        self._clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self._clearButton setImage:UIKitImageNamed(@"UISearchBarClearButtonIcon", UIImageResizingModeStretch) forState:UIControlStateNormal];
        [self._clearButton addTarget:self action:@selector(_clearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self._clearButton sizeToFit];
        
        self.tintColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
        
        [self setImage:UIKitImageNamed(@"UISearchBarClearButtonIcon", UIImageResizingModeStretch) forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    }
    
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    
    self.backgroundView.frame = bounds;
    
    CGRect textFieldFrame = self.textField.frame;
    textFieldFrame.size.width = CGRectGetWidth(bounds) - 20.0;
    textFieldFrame.size.height = 31.0;
    textFieldFrame.origin.x = 10.0;
    textFieldFrame.origin.y = round(CGRectGetMidY(bounds) - CGRectGetHeight(textFieldFrame) / 2.0);
    self.textField.frame = textFieldFrame;
}

#pragma mark - First Responder

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}

#pragma mark - Properties

- (void)setDelegate:(id <UISearchBarDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.searchBarShouldBeginEditing = [delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)];
    _delegateRespondsTo.searchBarTextDidBeginEditing = [delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)];
    _delegateRespondsTo.searchBarShouldEndEditing = [delegate respondsToSelector:@selector(searchBarShouldEndEditing:)];
    _delegateRespondsTo.searchBarTextDidEndEditing = [delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)];
    
    _delegateRespondsTo.searchBarTextDidChange = [delegate respondsToSelector:@selector(searchBar:textDidChange:)];
    _delegateRespondsTo.searchBarShouldChangeTextInRangeReplacementText = [delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)];
    
    _delegateRespondsTo.searchBarSearchButtonClicked = [delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)];
    _delegateRespondsTo.searchBarBookmarkButtonClicked = [delegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)];
    _delegateRespondsTo.searchBarCancelButtonClicked = [delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)];
    _delegateRespondsTo.searchBarResultsListButtonClicked = [delegate respondsToSelector:@selector(searchBarResultsListButtonClicked:)];
    
    _delegateRespondsTo.searchBarSelectedScopeButtonIndexDidChange = [delegate respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)];
}

#pragma mark -

- (void)setText:(NSString *)text
{
    self.textField.text = text;
}

- (NSString *)text
{
    return self.textField.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.textField.placeholder = placeholder;
}

- (NSString *)placeholder
{
    return self.textField.placeholder;
}

#pragma mark -

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    [self setShowsCancelButton:showsCancelButton animated:YES];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated
{
    _showsCancelButton = showsCancelButton;
}

#pragma mark - Appearances

- (void)setTintColor:(UIColor *)tintColor
{
    self.backgroundView.backgroundColor = tintColor;
}

- (UIColor *)tintColor
{
    return self.backgroundView.backgroundColor;
}

#pragma mark -

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundView.image = backgroundImage;
}

- (UIImage *)backgroundImage
{
    return self.backgroundView.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        self.backgroundImage = backgroundImage;
}

- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        return self.backgroundImage;
    
    return nil;
}

- (void)setSearchFieldBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state
{
    if(state != UIControlStateNormal && state != UIControlStateDisabled)
        UIKitInvalidParameter(@"state", @"must be either UIControlStateNormal or UIControlStateDisabled");
    
    if(state == UIControlStateNormal)
        self.textField.background = backgroundImage;
    else if(state == UIControlStateDisabled)
        self.textField.disabledBackground = backgroundImage;
}

- (UIImage *)searchFieldBackgroundImageForState:(UIControlState)state
{
    if(state != UIControlStateNormal && state != UIControlStateDisabled)
        UIKitInvalidParameter(@"state", @"must be either UIControlStateNormal or UIControlStateDisabled");
    
    if(state == UIControlStateNormal)
        return self.textField.background;
    else if(state == UIControlStateDisabled)
        return self.textField.disabledBackground;
    else
        return nil;
}

- (void)setImage:(UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    if(iconImage)
        _iconImages[MakeIconImagesKey(icon, state)] = iconImage;
    else
        [_iconImages removeObjectForKey:MakeIconImagesKey(icon, state)];
    
    switch (icon) {
        case UISearchBarIconClear: {
            [self._clearButton setImage:iconImage forState:state];
            break;
        }
            
        case UISearchBarIconSearch: {
            self.magnifyingGlassImageView.image = iconImage;
            break;
        }
            
        case UISearchBarIconBookmark:
        case UISearchBarIconResultsList: {
            break;
        }
    }
}

- (UIImage *)imageForSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    return _iconImages[MakeIconImagesKey(icon, state)] ?: _iconImages[MakeIconImagesKey(icon, UIControlStateNormal)];
}

#pragma mark -

- (void)setScopeBarButtonBackgroundImage:(UIImage *)backgroundImage forState:(UIControlState)state
{
    UIKitUnimplementedMethod();
}

- (UIImage *)scopeBarButtonBackgroundImageForState:(UIControlState)state
{
    UIKitUnimplementedMethod();
    return nil;
}

- (void)setScopeBarButtonDividerImage:(UIImage *)dividerImage forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState
{
    UIKitUnimplementedMethod();
}

- (UIImage *)scopeBarButtonDividerImageForLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState
{
    UIKitUnimplementedMethod();
    return nil;
}

- (void)setScopeBarButtonTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state
{
    UIKitUnimplementedMethod();
}

- (NSDictionary *)scopeBarButtonTitleTextAttributesForState:(UIControlState)state
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark -

- (void)setPositionAdjustment:(UIOffset)adjustment forSearchBarIcon:(UISearchBarIcon)icon
{
    UIKitUnimplementedMethod();
}

- (UIOffset)positionAdjustmentForSearchBarIcon:(UISearchBarIcon)icon
{
    UIKitUnimplementedMethod();
    return UIOffsetZero;
}

#pragma mark - <UITextInputTraits>

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
    _textField.autocapitalizationType = autocapitalizationType;
}

- (UITextAutocapitalizationType)autocapitalizationType
{
    return _textField.autocapitalizationType;
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
    _textField.autocorrectionType = autocorrectionType;
}

- (UITextAutocorrectionType)autocorrectionType
{
    return _textField.autocorrectionType;
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically
{
    _textField.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
}

- (BOOL)enablesReturnKeyAutomatically
{
    return _textField.enablesReturnKeyAutomatically;
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance
{
    _textField.keyboardAppearance = keyboardAppearance;
}

- (UIKeyboardAppearance)keyboardAppearance
{
    return _textField.keyboardAppearance;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _textField.keyboardType = keyboardType;
}

- (UIKeyboardType)keyboardType
{
    return _textField.keyboardType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _textField.returnKeyType = returnKeyType;
}

- (UIReturnKeyType)returnKeyType
{
    return _textField.returnKeyType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _textField.secureTextEntry = secureTextEntry;
}

- (BOOL)isSecureTextEntry
{
    return _textField.secureTextEntry;
}

- (void)setSpellCheckingType:(UITextSpellCheckingType)spellCheckingType
{
    _textField.spellCheckingType = spellCheckingType;
}

- (UITextSpellCheckingType)spellCheckingType
{
    return _textField.spellCheckingType;
}

#pragma mark - Clear Button

- (void)_showClearButton
{
    self.textField.rightView = self._clearButton;
}

- (void)_hideClearButton
{
    self.textField.rightView = nil;
}

- (void)_clearButtonTapped:(UIButton *)sender
{
    if(_delegateRespondsTo.searchBarShouldChangeTextInRangeReplacementText) {
        if(![self.delegate searchBar:self shouldChangeTextInRange:NSMakeRange(0, self.text.length) replacementText:@""])
            return;
    }
    
    self.text = nil;
    [self becomeFirstResponder];
    
    [self _hideClearButton];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_delegateRespondsTo.searchBarShouldBeginEditing)
        return [_delegate searchBarShouldBeginEditing:self];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(_delegateRespondsTo.searchBarTextDidBeginEditing)
        [_delegate searchBarTextDidBeginEditing:self];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(_delegateRespondsTo.searchBarShouldEndEditing)
        return [_delegate searchBarShouldEndEditing:self];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_delegateRespondsTo.searchBarTextDidEndEditing)
        [_delegate searchBarTextDidEndEditing:self];
    
    if(self.text.length == 0)
        [self _hideClearButton];
}

#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL changeText = YES;
    if(_delegateRespondsTo.searchBarShouldChangeTextInRangeReplacementText)
        changeText = [_delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    
    if(changeText && [self.text stringByReplacingCharactersInRange:range withString:string].length > 0) {
        [self _showClearButton];
    } else {
        [self _hideClearButton];
    }
    
    return changeText;
}

#pragma mark -

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(_delegateRespondsTo.searchBarSearchButtonClicked)
        [_delegate searchBarSearchButtonClicked:self];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_delegateRespondsTo.searchBarSearchButtonClicked)
        [_delegate searchBarSearchButtonClicked:self];
    
    return YES;
}

@end

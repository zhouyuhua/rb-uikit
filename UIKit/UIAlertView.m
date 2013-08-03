//
//  UIAlertView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAlertView.h"
#import <objc/runtime.h>

@interface UIAlertView () {
    struct {
        int alertViewClickedButtonAtIndex : 1;
        int alertViewCancel : 1;
        int willPresentAlertView : 1;
        int didPresentAlertView : 1;
        int alertViewWillDismissWithButtonIndex : 1;
        int alertViewDidDismissWithButtonIndex : 1;
        int alertViewShouldEnableFirstOtherButton : 1;
    } _delegateRespondsTo;
}

@property (nonatomic) NSAlert *alert;

#pragma mark - readwrite

@property (nonatomic, readwrite) NSInteger firstOtherButtonIndex;
@property (nonatomic, readwrite, getter=isVisible) BOOL visible;

@end

@implementation UIAlertView {
    NSMutableArray *_buttons;
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.cancelButtonIndex = -1;
        self.firstOtherButtonIndex = -1;
        
        _buttons = [NSMutableArray array];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id <UIAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if((self = [super init])) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        
        [self addButtonWithTitle:cancelButtonTitle];
        self.cancelButtonIndex = 0;
        
        if(otherButtonTitles != nil) {
            self.firstOtherButtonIndex = 1;
            [self addButtonWithTitle:otherButtonTitles];
            
            va_list titles;
            va_start(titles, otherButtonTitles);
            {
                NSString *title;
                while ((title = va_arg(titles, NSString *)) != nil) {
                    [self addButtonWithTitle:title];
                }
            }
            va_end(titles);
        }
    }
    
    return self;
}

#pragma mark - Buttons

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    [_buttons addObject:title];
    return self.numberOfButtons - 1;
}

- (NSInteger)numberOfButtons
{
    return _buttons.count;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    return _buttons[buttonIndex];
}

#pragma mark - Showing

static const char *kSelfReferenceKey = "self";

- (void)show
{
    self.alert = [NSAlert new];
    
    self.alert.messageText = self.title;
    self.alert.informativeText = self.message;
    
    for (NSString *title in _buttons)
        [self.alert addButtonWithTitle:title];
    
    if(_delegateRespondsTo.willPresentAlertView)
        [_delegate willPresentAlertView:self];
    
    self.visible = YES;
    [self.alert beginSheetModalForWindow:[NSApp mainWindow]
                           modalDelegate:self
                          didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) 
                             contextInfo:NULL];
    
    if(_delegateRespondsTo.didPresentAlertView)
        [_delegate didPresentAlertView:self];
    
    objc_setAssociatedObject(self.alert, kSelfReferenceKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    NSInteger buttonIndex = returnCode - 1000;
    if(_delegateRespondsTo.alertViewWillDismissWithButtonIndex)
        [_delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    
    self.visible = NO;
    
    if(_delegateRespondsTo.alertViewDidDismissWithButtonIndex)
        [_delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    
    objc_setAssociatedObject(self.alert, kSelfReferenceKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [NSApp endSheet:[self.alert window]];
}

#pragma mark - Text Fields

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark - Properties

- (void)setDelegate:(id <UIAlertViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.alertViewClickedButtonAtIndex = [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)];
    _delegateRespondsTo.alertViewCancel = [_delegate respondsToSelector:@selector(alertViewCancel:)];
    
    _delegateRespondsTo.willPresentAlertView = [_delegate respondsToSelector:@selector(willPresentAlertView:)];
    _delegateRespondsTo.didPresentAlertView = [_delegate respondsToSelector:@selector(didPresentAlertView:)];
    
    _delegateRespondsTo.alertViewWillDismissWithButtonIndex = [_delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)];
    _delegateRespondsTo.alertViewDidDismissWithButtonIndex = [_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)];
    
    _delegateRespondsTo.alertViewShouldEnableFirstOtherButton = [_delegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)];
}

@end

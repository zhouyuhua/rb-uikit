//
//  UIAlertView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIAlertViewStyle) {
    UIAlertViewStyleDefault = 0,
    UIAlertViewStyleSecureTextInput,
    UIAlertViewStylePlainTextInput,
    UIAlertViewStyleLoginAndPasswordInput
};

@protocol UIAlertViewDelegate;

@interface UIAlertView : UIView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id <UIAlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic, assign) id <UIAlertViewDelegate> delegate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic) NSInteger cancelButtonIndex;

@property(nonatomic, readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used
@property(nonatomic, readonly, getter=isVisible) BOOL visible;

- (void)show;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property(nonatomic, assign) UIAlertViewStyle alertViewStyle;

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

@end

#pragma mark -

@protocol UIAlertViewDelegate <NSObject>
@optional

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)alertViewCancel:(UIAlertView *)alertView;

- (void)willPresentAlertView:(UIAlertView *)alertView;
- (void)didPresentAlertView:(UIAlertView *)alertView;

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;

@end

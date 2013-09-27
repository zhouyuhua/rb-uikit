//
//  UIBarButtonItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIBarButtonItem_Private.h"
#import "UIImage.h"
#import <objc/message.h>

#import "UIButton_Private.h"

static NSString *TitleForSystemItemStyle(UIBarButtonItemStyle style)
{
    UIKitUnimplementedMethod();
    return nil;
}

static UIImage *ImageForSystemItemStyle(UIBarButtonItemStyle style)
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark -

@implementation UIBarButtonItem {
    UIButton *_underlyingButton;
}

/* !Important! Always set the `style` before anything else */

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = style;
        self.image = image;
        self.target = target;
        self.action = action;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = style;
        self.image = image;
        self.target = target;
        self.action = action;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = style;
        self.title = title;
        self.target = target;
        self.action = action;
    }
    
    return self;
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = UIBarButtonItemStyleBordered;
        self.title = TitleForSystemItemStyle(systemItem);
        self.image = ImageForSystemItemStyle(systemItem);
        self.target = target;
        self.action = action;
    }
    
    return self;
}

- (id)initWithCustomView:(UIView *)customView
{
    if((self = [super init])) {
        self.customView = customView;
    }
    
    return self;
}

#pragma mark - Buttons

- (UIButton *)underlyingButton
{
    if(!_underlyingButton) {
        UIButtonType buttonType;
        if((NSInteger)self.style == UIBarButtonItemStyle_Private_Back)
            buttonType = UIButtonType_Private_BackBarButton;
        else
            buttonType = UIButtonType_Private_BarButton;
        _underlyingButton = [UIButton buttonWithType:buttonType];
        
        [_underlyingButton setTitle:self.title forState:UIControlStateNormal];
        
        if((NSInteger)self.style != UIBarButtonItemStyle_Private_Back)
            [_underlyingButton setImage:self.image forState:UIControlStateNormal];
        
        [_underlyingButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _underlyingButton;
}

- (void)sendAction
{
    if(self.target && self.action)
        ((void(*)(id, SEL, id))objc_msgSend)(self.target, self.action, self);
}

#pragma mark -

- (UIView *)view
{
    return self.customView ?: self.underlyingButton;
}

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.underlyingButton setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self.underlyingButton setImage:image forState:UIControlStateNormal];
}

@end

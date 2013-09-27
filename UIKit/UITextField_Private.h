//
//  UITextField_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITextField.h"

@class UINSTextField, UIAppKitView, UIImageView;

@interface UITextField () <NSTextFieldDelegate> {
    @package
    struct {
        int textFieldShouldBeginEditing : 1;
        int textFieldDidBeginEditing : 1;
        int textFieldShouldEndEditing : 1;
        int textFieldDidEndEditing : 1;
        
        int textFieldShouldChangeCharactersInRangeReplacementString : 1;
        
        int textFieldShouldClear : 1;
        int textFieldShouldReturn : 1;
    } _delegateRespondsTo;
}

@property (nonatomic) UIAppKitView *_nativeTextFieldAdaptor;
@property (nonatomic, assign) UINSTextField *_nativeTextField;
@property (nonatomic) UIImageView *backgroundView;

#pragma mark - readwrite

@property (nonatomic, readwrite, getter=isEditing) BOOL editing;

@end

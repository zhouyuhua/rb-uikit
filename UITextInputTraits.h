//
//  UITextInputTraits.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UITextAutocapitalizationTypeNone,
    UITextAutocapitalizationTypeWords,
    UITextAutocapitalizationTypeSentences,
    UITextAutocapitalizationTypeAllCharacters,
} UITextAutocapitalizationType;

typedef enum {
    UITextAutocorrectionTypeDefault,
    UITextAutocorrectionTypeNo,
    UITextAutocorrectionTypeYes,
} UITextAutocorrectionType;

typedef enum {
    UITextSpellCheckingTypeDefault,
    UITextSpellCheckingTypeNo,
    UITextSpellCheckingTypeYes,
} UITextSpellCheckingType;

typedef enum {
    UIKeyboardTypeDefault,
    UIKeyboardTypeASCIICapable,
    UIKeyboardTypeNumbersAndPunctuation,
    UIKeyboardTypeURL,
    UIKeyboardTypeNumberPad,
    UIKeyboardTypePhonePad,
    UIKeyboardTypeNamePhonePad,
    UIKeyboardTypeEmailAddress,
    UIKeyboardTypeDecimalPad,
    UIKeyboardTypeTwitter,
    UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable
} UIKeyboardType;

typedef enum {
    UIKeyboardAppearanceDefault,
    UIKeyboardAppearanceAlert,
} UIKeyboardAppearance;

typedef enum {
    UIReturnKeyDefault,
    UIReturnKeyGo,
    UIReturnKeyGoogle,
    UIReturnKeyJoin,
    UIReturnKeyNext,
    UIReturnKeyRoute,
    UIReturnKeySearch,
    UIReturnKeySend,
    UIReturnKeyYahoo,
    UIReturnKeyDone,
    UIReturnKeyEmergencyCall,
} UIReturnKeyType;

@protocol UITextInputTraits <NSObject>

@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic) UITextAutocorrectionType autocorrectionType;
@property (nonatomic) BOOL enablesReturnKeyAutomatically;
@property (nonatomic) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@property (nonatomic) UITextSpellCheckingType spellCheckingType;

@end

//
//  UINSTextFieldCell.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

UIKIT_EXTERN NSString *const UINSTextFieldDidBecomeFirstResponder;

@class UITextField;

@interface UINSTextField : NSTextField

@property (nonatomic, unsafe_unretained) UITextField *textField;

@end

#pragma mark -

@interface UINSTextFieldCell : NSTextFieldCell

@end

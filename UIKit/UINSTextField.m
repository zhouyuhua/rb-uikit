//
//  UINSTextFieldCell.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINSTextField.h"
#import "UITextField_Private.h"

NSString *const UINSTextFieldDidBecomeFirstResponder = @"UINSTextFieldDidBecomeFirstResponder";

@implementation UINSTextField

+ (Class)cellClass
{
    return [UINSTextFieldCell class];
}

- (BOOL)becomeFirstResponder
{
    BOOL success = [super becomeFirstResponder];
    if(success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UINSTextFieldDidBecomeFirstResponder object:self];
    }
    return success;
}

- (BOOL)resignFirstResponder
{
    return [super resignFirstResponder];
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    if(_textField->_delegateRespondsTo.textFieldShouldChangeCharactersInRangeReplacementString)
        return [_textField.delegate textField:_textField shouldChangeCharactersInRange:affectedCharRange replacementString:replacementString];
    else
        return YES;
}

@end

#pragma mark -

@implementation UINSTextFieldCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(UINSTextField *)controlView
{
    cellFrame = [controlView.textField placeholderRectForBounds:cellFrame];
    
    [super drawWithFrame:cellFrame inView:controlView];
}

- (void)editWithFrame:(NSRect)cellFrame inView:(UINSTextField *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
    cellFrame = [controlView.textField placeholderRectForBounds:cellFrame];
    
    [super editWithFrame:cellFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)cellFrame inView:(UINSTextField *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
    cellFrame = [controlView.textField placeholderRectForBounds:cellFrame];
    
    [super selectWithFrame:cellFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

@end

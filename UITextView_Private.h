//
//  UITextView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITextView.h"

@class UIAppKitView;

@interface UITextView () <NSTextViewDelegate> {
    NSTextView *_nativeTextView;
    UIAppKitView *_adaptorView;
    
    struct {
        int textViewShouldBeginEditing : 1;
        int textViewDidBeginEditing : 1;
        int textViewShouldEndEditing : 1;
        int textViewDidEndEditing : 1;
        
        int textViewShouldChangeTextInRangeReplacementText : 1;
        int textViewDidChange : 1;
        
        int textViewDidChangeSelection : 1;
        
        int textViewShouldInteractWithTextAttachmentInRange : 1;
        int textViewShouldInteractWithURLInRange : 1;
    } _delegateRespondsTo;
}

@end

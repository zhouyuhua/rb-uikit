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
}

@end

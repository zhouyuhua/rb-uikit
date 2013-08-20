//
//  UIResponder.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKitDefines.h"
#import "UIEvent.h"
#import "UIKeyEvent.h"

@interface UIResponder : NSObject

- (UIResponder *)nextResponder;

- (BOOL)canBecomeFirstResponder;
- (BOOL)becomeFirstResponder;

- (BOOL)canResignFirstResponder;
- (BOOL)resignFirstResponder;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)motionBegan:(UIEventSubtype)motionType withEvent:(UIEvent *)event;
- (void)motionMoved:(UIEventSubtype)motionType withEvent:(UIEvent *)event;
- (void)motionEnded:(UIEventSubtype)motionType withEvent:(UIEvent *)event;

- (void)remoteControlReceivedWithEvent:(UIEvent *)event;

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;
- (id)targetForAction:(SEL)action withSender:(id)sender;

@property (nonatomic, readonly) NSUndoManager *undoManager;

@end

#pragma mark -

@interface UIResponder (UIMacAdditions)

- (void)keyDown:(UIKeyEvent *)event;
- (void)keyUp:(UIKeyEvent *)event;

@end

#pragma mark -

@interface NSObject (UIResponderStandardEditActions)   // these methods are not implemented in NSObject

- (void)cut:(id)sender;
- (void)copy:(id)sender;
- (void)paste:(id)sender;
- (void)select:(id)sender;
- (void)selectAll:(id)sender;
- (void)delete:(id)sender;
- (void)makeTextWritingDirectionLeftToRight:(id)sender;
- (void)makeTextWritingDirectionRightToLeft:(id)sender;
- (void)toggleBoldface:(id)sender;
- (void)toggleItalics:(id)sender;
- (void)toggleUnderline:(id)sender;

- (void)increaseSize:(id)sender;
- (void)decreaseSize:(id)sender;

@end

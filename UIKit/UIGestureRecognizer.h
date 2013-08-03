//
//  UIGestureRecognizer.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIKitDefines.h"

@class UITouch, UIView;
@protocol UIGestureRecognizerDelegate;

typedef NS_ENUM(NSInteger, UIGestureRecognizerState) {
    UIGestureRecognizerStatePossible,
    UIGestureRecognizerStateBegan,
    UIGestureRecognizerStateChanged,
    UIGestureRecognizerStateEnded,
    UIGestureRecognizerStateCancelled,
    UIGestureRecognizerStateFailed,
    UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
};

@interface UIGestureRecognizer : NSObject <NSCopying>

@property (nonatomic, assign) id <UIGestureRecognizerDelegate> delegate;
@property (nonatomic, readonly) UIGestureRecognizerState state;
@property (nonatomic, readonly) NSView *view;

#pragma mark -

@property (nonatomic) BOOL cancelsTouchesInView;
@property (nonatomic) BOOL delaysTouchesBegan;
@property (nonatomic) BOOL delaysTouchesEnded;

#pragma mark -

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer;

- (CGPoint)locationInView:(UIView *)view;

- (NSUInteger)numberOfTouches;
- (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(UIView *)view;

@end

@protocol UIGestureRecognizerDelegate <NSObject>
@optional

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end

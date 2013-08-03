//
//  UIGestureRecognizerSubclass.h
//  UIKit
//
//  Copyright (c) 2008-2013, Apple Inc. All rights reserved.
//

#import "UIGestureRecognizer.h"

@interface UIGestureRecognizer (ForSubclassEyesOnly)

@property (nonatomic, readwrite) UIGestureRecognizerState state;

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event;

#pragma mark - To override

- (void)reset;

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

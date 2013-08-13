//
//  UIGestureRecognizer_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIGestureRecognizer.h"

@class UIEvent, UIView;

@interface UIGestureRecognizer () {
    struct {
        int gestureRecognizerShouldBegin : 1;
        int gestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer : 1;
        int gestureRecognizerShouldReceiveTouch : 1;
    } _delegateRespondsTo;
    
    NSMutableSet *_gesturesRequiredToFail;
}

- (BOOL)_wantsGestureEvents;
- (BOOL)_wantsToTrackEvent:(UIEvent *)event;
- (void)_handleEvent:(UIEvent *)event;

- (BOOL)_wantsAutomaticActionSending;
- (void)_sendActions;

@property (nonatomic, weak) UIView *_view;
@property (nonatomic) UIEvent *_currentEvent;
@property (nonatomic) NSArray *_touches;

@property (nonatomic, weak) UIEvent *_lastIgnoredEvent;
@property (nonatomic, weak) UITouch *_lastIgnoredTouch;

#pragma mark - readwrite

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

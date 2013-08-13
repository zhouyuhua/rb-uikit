//
//  UILongPressGestureRecognizer.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UILongPressGestureRecognizer.h"
#import "UIGestureRecognizer_Private.h"

#import "UITouch_Private.h"
#import "UIEvent.h"

@interface UILongPressGestureRecognizer ()

@property (nonatomic, weak) NSTimer *actionTimer;

@end

#pragma mark -

@implementation UILongPressGestureRecognizer

- (id)init
{
    if((self = [super init])) {
        self.minimumPressDuration = 0.5;
        self.numberOfTapsRequired = 1;
        self.allowableMovement = 10.0;
    }
    
    return self;
}

- (void)reset
{
    [super reset];
    
    [self.actionTimer invalidate];
}

- (BOOL)_wantsAutomaticActionSending
{
    return NO;
}

#pragma mark - Properties

- (void)setNumberOfTouchesRequired:(NSInteger)numberOfTouchesRequired
{
    //Do nothing.
}

- (NSInteger)numberOfTouchesRequired
{
    return 1;
}

#pragma mark - Timer

- (void)minimumPressDurationPassed:(NSTimer *)timer
{
    self.state = UIGestureRecognizerStateChanged;
    
    [self _sendActions];
    
    [self reset];
}

#pragma mark - Event Handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateBegan) {
        [self.actionTimer invalidate];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateBegan) {
        UITouch *touch = [touches anyObject];
        CGPoint delta = touch.delta;
        if(ABS(delta.x) > _allowableMovement || ABS(delta.y) > _allowableMovement) {
            [self.actionTimer invalidate];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if(self.state == UIGestureRecognizerStatePossible && touch.tapCount == self.numberOfTapsRequired) {
        self.state = UIGestureRecognizerStateBegan;
        self.actionTimer = [NSTimer scheduledTimerWithTimeInterval:self.minimumPressDuration
                                                            target:self
                                                          selector:@selector(minimumPressDurationPassed:)
                                                          userInfo:nil
                                                           repeats:NO];
    }
}

@end

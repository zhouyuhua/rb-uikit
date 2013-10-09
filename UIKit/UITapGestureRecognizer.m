//
//  UITapGestureRecognizer.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/8/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITapGestureRecognizer.h"

#import "UIGestureRecognizer_Private.h"
#import "UIGestureRecognizerSubclass.h"

#import "UIEvent.h"

@implementation UITapGestureRecognizer {
    NSTimeInterval _timeout;
    __weak NSTimer *_cancelTimer;
    NSUInteger _trackedNumberOfTaps;
}

- (id)init
{
    if((self = [super init])) {
        self.numberOfTapsRequired = 1;
        self.numberOfTouchesRequired = 1;
    }
    
    return self;
}

#pragma mark - Properties

- (void)setNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
{
    _numberOfTapsRequired = numberOfTapsRequired;
    
    _timeout = numberOfTapsRequired * ([NSEvent doubleClickInterval] / 2.0);
}

#pragma mark - Overrides

- (BOOL)_wantsAutomaticActionSending
{
    return NO;
}

#pragma mark - Events

- (void)_cancelFromTimeout
{
    _trackedNumberOfTaps = 0;
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count != self.numberOfTouchesRequired) {
        for (UITouch *touch in touches)
            [self ignoreTouch:touch forEvent:event];
        
        return;
    }
    
    _trackedNumberOfTaps++;
    
    if(!_cancelTimer)
        _cancelTimer = [NSTimer scheduledTimerWithTimeInterval:_timeout
                                                        target:self
                                                      selector:@selector(_cancelFromTimeout)
                                                      userInfo:nil
                                                       repeats:NO];
    
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touches.count != self.numberOfTouchesRequired) {
        for (UITouch *touch in touches)
            [self ignoreTouch:touch forEvent:event];
        
        return;
    }
    
    if(_trackedNumberOfTaps >= self.numberOfTapsRequired) {
        [_cancelTimer invalidate];
        
        self.state = UIGestureRecognizerStateEnded;
        
        [self _sendActions];
    }
}

@end

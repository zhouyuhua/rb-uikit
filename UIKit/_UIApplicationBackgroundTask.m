//
//  _UIApplicationBackgroundTask.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/4/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "_UIApplicationBackgroundTask.h"

@implementation _UIApplicationBackgroundTask

- (instancetype)initWithExpirationHandler:(dispatch_block_t)expirationHandler
{
    if((self = [super init])) {
        self.expirationHandler = expirationHandler;
        
        NSTimeInterval duration = [UIKitConfigurationManager sharedConfigurationManager].backgroundTaskAllowedDuration;
        if(duration > 0.0) {
            self.expirationTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                                    target:self
                                                                  selector:@selector(expire:)
                                                                  userInfo:self
                                                                   repeats:NO];
        }
    }
    
    return self;
}

#pragma mark - Expiration

- (void)expire:(NSTimer *)timer
{
    if(_expirationHandler)
        _expirationHandler();
}

@end

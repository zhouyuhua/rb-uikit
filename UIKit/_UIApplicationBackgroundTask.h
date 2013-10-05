//
//  _UIApplicationBackgroundTask.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/4/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _UIApplicationBackgroundTask : NSObject

- (instancetype)initWithExpirationHandler:(dispatch_block_t)expirationHandler;

#pragma mark - Properties

@property (nonatomic, copy) dispatch_block_t expirationHandler;
@property (nonatomic, weak) NSTimer *expirationTimer;

@end

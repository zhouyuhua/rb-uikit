//
//  UIScreen.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScreen : NSObject

+ (NSArray *)screens;
+ (UIScreen *)mainScreen;

#pragma mark - Properties

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGRect applicationFrame;
@property (nonatomic, readonly) CGFloat scale;

@end

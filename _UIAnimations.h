//
//  UIAnimation.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@interface _UIAnimations : NSObject

- (instancetype)initWithName:(NSString *)name context:(void *)context;

#pragma mark - Properties

@property (nonatomic, copy) NSString *name;
@property (nonatomic) void *context;

#pragma mark -

@property (nonatomic) id delegate;
@property (nonatomic) SEL willStartSelector;
@property (nonatomic) SEL didStopSelector;
@property (nonatomic, copy) void(^completionHandler)(BOOL finished);

#pragma mark -

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval delay;

#pragma mark -

@property (nonatomic) NSDate *startDate;
@property (nonatomic) UIViewAnimationCurve curve;

#pragma mark -

@property (nonatomic) float repeatCount;
@property (nonatomic) BOOL repeatAutoreverses;

#pragma mark -

@property (nonatomic) BOOL beginsFromCurrentState;

#pragma mark - Dispensing Animations

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;

#pragma mark - Committing

- (void)commit;

@end

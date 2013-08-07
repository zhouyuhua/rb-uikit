//
//  UIAction.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIControl.h"

@interface UIAction : NSObject

@property (nonatomic) UIControlEvents events;
@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;

- (void)invokeFromSender:(id)sender;

@end

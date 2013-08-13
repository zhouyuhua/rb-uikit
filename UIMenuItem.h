//
//  UIMenuItem.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIMenuItem : NSObject

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;

@property SEL action;

@property (copy) NSString *title;

@end

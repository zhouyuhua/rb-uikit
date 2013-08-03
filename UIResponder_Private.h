//
//  UIResponder_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIFirstResponderManager <NSObject>

@property (nonatomic, unsafe_unretained) UIResponder *firstResponder;

@end

@interface UIResponder ()

@property (nonatomic) id <UIFirstResponderManager> firstResponderManager;

#pragma mark - readwrite

@property (nonatomic, weak, readwrite) UIResponder *nextResponder;

@end

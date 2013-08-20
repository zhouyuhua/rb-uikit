//
//  UIResponder_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIResponder.h"

@protocol UIFirstResponderManager <NSObject>

@property (nonatomic, unsafe_unretained) UIResponder *currentFirstResponder;

@end

@interface UIResponder ()

@property (nonatomic) id <UIFirstResponderManager> firstResponderManager;

@end

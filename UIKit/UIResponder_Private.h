//
//  UIResponder_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/30/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIResponder.h"

@protocol _UIFirstResponderManager <NSObject>

@property (nonatomic, unsafe_unretained, setter=_setFirstResponder:) UIResponder *_firstResponder;

@end

@interface UIResponder ()

@property (nonatomic, unsafe_unretained, setter=_setFirstResponderManager:) id <_UIFirstResponderManager> _firstResponderManager;

@end

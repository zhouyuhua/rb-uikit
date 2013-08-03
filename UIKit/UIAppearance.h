//
//  UIAppearance.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/19/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UI_APPEARANCE_SELECTOR

#pragma mark -

@protocol UIAppearanceContainer <NSObject>

@end

#pragma mark -

@protocol UIAppearance <NSObject>

+ (instancetype)appearance;
+ (instancetype)appearanceWhenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ...;

@end

//
//  UIWindow_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIWindow.h"
#import "UIResponder_Private.h"

@class UIWindowAppKitHostView;

@interface UIWindow () <NSWindowDelegate>

@property (nonatomic) NSWindow *underlyingWindow;
@property (nonatomic) UIWindowAppKitHostView *hostView;

@end

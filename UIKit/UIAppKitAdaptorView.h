//
//  UIAppKitAdaptorView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class UIAppKitView;

@interface UIAppKitAdaptorView : NSView

- (instancetype)initWithView:(NSView *)view appKitView:(UIAppKitView *)appKitView;

#pragma mark - Properties

@property (nonatomic, weak, readonly) UIAppKitView *appKitView;
@property (nonatomic, readonly, assign) NSView *view;

@end

//
//  UIAppKitView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppKit/AppKit.h>

@class UIAppKitAdaptorView;

@interface UIAppKitView : UIView

- (instancetype)initWithView:(NSView *)view;

#pragma mark - Properties

@property (nonatomic, readonly) UIAppKitAdaptorView *adaptorView;

@end

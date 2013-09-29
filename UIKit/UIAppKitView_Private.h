//
//  UIAppKitView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/28/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppKitView.h"

@interface UIAppKitView () {
    CGRect _lastKnownFrame;
    NSUInteger _suppressSizeChangeMessagesCount;
}

@property (nonatomic, unsafe_unretained) UIScrollView *enclosingScrollView;

#pragma mark -

@property (nonatomic, readwrite) UIAppKitViewGlueNSView *adaptorView;

@end

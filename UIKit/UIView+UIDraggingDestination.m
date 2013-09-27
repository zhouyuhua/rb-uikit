//
//  UIView+UIDraggingDestination.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView+UIDraggingDestination.h"
#import "UIView_Private.h"
#import "UIPasteboard_Private.h"

@interface UIDraggingInfo ()

@property (nonatomic, readwrite) UIWindow *window;
@property (nonatomic, readwrite) UIPasteboard *pasteboard;

@end

@implementation UIDraggingInfo

- (instancetype)initWithNSDraggingInfo:(id <NSDraggingInfo>)draggingInfo window:(UIWindow *)window
{
    NSParameterAssert(draggingInfo);
    NSParameterAssert(window);
    
    if((self = [super init])) {
        self.window = window;
        self.pasteboard = [[UIPasteboard alloc] initWithNativePasteboard:draggingInfo.draggingPasteboard];
    }
    
    return self;
}

@end

#pragma mark -

@implementation UIView (UIDraggingDestination)

- (void)registerForDraggedTypes:(NSArray *)types
{
    if(!_registeredDraggingTypes) {
        _registeredDraggingTypes = [NSMutableArray array];
    }
    
    [_registeredDraggingTypes addObjectsFromArray:types];
}

- (void)unregisterDraggedTypes
{
    [_registeredDraggingTypes removeAllObjects];
}

- (NSArray *)registeredDragTypes
{
    return [_registeredDraggingTypes copy];
}

#pragma mark - Drag & Drop

- (UIDraggingOperation)draggingEntered:(UIDraggingInfo *)info
{
    return UIDraggingOperationNone;
}

- (UIDraggingOperation)draggingUpdated:(UIDraggingInfo *)info
{
    return UIDraggingOperationNone;
}

- (void)draggingExited:(UIDraggingInfo *)info
{
    
}

#pragma mark -

- (BOOL)prepareForDragOperation:(UIDraggingInfo *)info
{
    return NO;
}

- (BOOL)performDragOperation:(UIDraggingInfo *)info
{
    return NO;
}

- (void)concludeDragOperation:(UIDraggingInfo *)info
{
    
}

#pragma mark -

- (void)draggingEnded:(UIDraggingInfo *)info
{
    
}

@end

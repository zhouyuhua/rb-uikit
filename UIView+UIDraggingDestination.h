//
//  UIView+UIDraggingDestination.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@class UIPasteboard;

enum {
    UIDraggingOperationNone = NSDragOperationNone,
    UIDraggingOperationCopy = NSDragOperationCopy,
    UIDraggingOperationLink = NSDragOperationLink,
    UIDraggingOperationGeneric = NSDragOperationGeneric,
    UIDraggingOperationPrivate = NSDragOperationPrivate,
    UIDraggingOperationMove = NSDragOperationMove,
    UIDraggingOperationDelete = NSDragOperationDelete,
    UIDraggingOperationEvery = NSDragOperationEvery
};
typedef NSDragOperation UIDraggingOperation;

@interface UIDraggingInfo : NSObject

- (instancetype)initWithNSDraggingInfo:(id <NSDraggingInfo>)draggingInfo window:(UIWindow *)window;

#pragma mark -

@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, readonly) UIPasteboard *pasteboard;

@end

#pragma mark -

@interface UIView (UIDraggingDestination)

- (void)registerForDraggedTypes:(NSArray *)types;
- (void)unregisterDraggedTypes;

@property (nonatomic, copy, readonly) NSArray *registeredDragTypes;

#pragma mark - Drag & Drop

- (UIDraggingOperation)draggingEntered:(UIDraggingInfo *)info;
- (UIDraggingOperation)draggingUpdated:(UIDraggingInfo *)info;
- (void)draggingExited:(UIDraggingInfo *)info;

#pragma mark -

- (BOOL)prepareForDragOperation:(UIDraggingInfo *)info;
- (BOOL)performDragOperation:(UIDraggingInfo *)info;
- (void)concludeDragOperation:(UIDraggingInfo *)info;

#pragma mark -

- (void)draggingEnded:(UIDraggingInfo *)info;

@end

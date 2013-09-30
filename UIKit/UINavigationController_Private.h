//
//  UINavigationController_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/1/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationController.h"

@interface UINavigationController () {
    NSMutableArray *_viewControllers;
    UIView *_visibleView;
    UINavigationBar *_navigationBar;
    UIToolbar *_toolbar;
    
    id <UIViewControllerContextTransitioning> _currentAnimationContext;
    
    struct {
        int navigationControllerWillShowViewControllerAnimated : 1;
        int navigationControllerDidShowViewControllerAnimated : 1;
        
        int navigationControllerAnimationControllerForOperationFromViewControllerToViewController : 1;
        int navigationControllerInteractionControllerForAnimationController : 1;
    } _delegateRespondsTo;
}

///The view that holds the contents of the controller's children.
@property (nonatomic) UIView *contentView;

@end

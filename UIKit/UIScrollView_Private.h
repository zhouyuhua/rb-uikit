//
//  UIScrollView_Private.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/12/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollView.h"

@class UIScroller, UIAnimator, UIRefreshControl;

@interface UIScrollView () {
    struct {
        int scrollViewDidScroll : 1;
        int scrollViewDidZoom : 1;
        
        int scrollViewWillBeginDragging : 1;
        
        int scrollViewWillEndDraggingWithVelocityTargetContentOffset : 1;
        int scrollViewDidEndDraggingWillDecelerate : 1;
        
        int scrollViewWillBeginDecelerating : 1;
        int scrollViewDidEndDecelerating : 1;
        
        int scrollViewDidEndScrollingAnimation : 1;
        
        int viewForZoomingInScrollView : 1;
        int scrollViewWillBeginZoomingWithView : 1;
        int scrollViewDidEndZoomingWithViewAtScale : 1;
        
        int scrollViewShouldScrollToTop : 1;
        int scrollViewDidScrollToTop : 1;
    } _delegateRespondsTo;
    
    UIRefreshControl *_refreshControl;
}

@property (nonatomic) UIScroller *horizontalScroller;
@property (nonatomic) UIScroller *verticalScroller;

@property (nonatomic, weak) NSTimer *hideScrollersTimer;

@property (nonatomic) BOOL _shouldBounceBack;

@property (nonatomic) UIAnimator *_currentAnimator;

#pragma mark - Animation

- (CGPoint)_constrainContentOffset:(CGPoint)contentOffset forBounceBack:(BOOL)isForBounceBack;
- (CGPoint)_constrainSnapbackTargetContentOffset:(CGPoint)contentOffset velocity:(CGPoint)velocity;

#pragma mark - Refresh Control

- (void)_refreshControlDidEndRefreshing;

#pragma mark - readwrite

@property (nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, readwrite, getter=isTracking) BOOL tracking;
@property (nonatomic, getter=isDragging, readwrite) BOOL dragging;
@property (nonatomic, readwrite, getter=isDecelerating) BOOL decelerating;

@end

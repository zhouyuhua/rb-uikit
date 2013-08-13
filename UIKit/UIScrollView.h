//
//  UIScrollView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@protocol UIScrollViewDelegate;
@class UIPanGestureRecognizer, UIPinchGestureRecognizer;

typedef NS_ENUM(NSInteger, UIScrollViewIndicatorStyle) {
    UIScrollViewIndicatorStyleDefault,
    UIScrollViewIndicatorStyleBlack,
    UIScrollViewIndicatorStyleWhite
};

UIKIT_EXTERN const CGFloat UIScrollViewDecelerationRateNormal;
UIKIT_EXTERN const CGFloat UIScrollViewDecelerationRateFast;

@interface UIScrollView : UIView

@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize contentSize;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic, assign) id<UIScrollViewDelegate> delegate;
@property (nonatomic, getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;
@property (nonatomic) BOOL bounces;
@property (nonatomic) BOOL alwaysBounceVertical;
@property (nonatomic) BOOL alwaysBounceHorizontal;
@property (nonatomic, getter=isPagingEnabled) BOOL pagingEnabled;
@property (nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
@property (nonatomic) UIEdgeInsets scrollIndicatorInsets;
@property (nonatomic) UIScrollViewIndicatorStyle indicatorStyle;
@property (nonatomic) CGFloat decelerationRate;

@property (nonatomic, readonly, getter=isTracking) BOOL tracking;
@property (nonatomic, getter=isDragging, readonly) BOOL dragging;
@property (nonatomic, readonly, getter=isDecelerating) BOOL decelerating;

@property (nonatomic) BOOL delaysContentTouches;
@property (nonatomic) BOOL canCancelContentTouches;

@property (nonatomic) float minimumZoomScale;
@property (nonatomic) float maximumZoomScale;

@property (nonatomic) float zoomScale;
- (void)setZoomScale:(float)scale animated:(BOOL)animated;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

@property (nonatomic) BOOL bouncesZoom;

@property (nonatomic, readonly, getter=isZooming) BOOL zooming;
@property (nonatomic, readonly, getter=isZoomBouncing) BOOL zoomBouncing;

@property (nonatomic) BOOL scrollsToTop;

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view;
- (BOOL)touchesShouldCancelInContentView:(UIView *)view;

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

- (void)flashScrollIndicators;

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly) UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

#pragma mark -

@protocol UIScrollViewDelegate <NSObject>

@optional

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view;
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale;

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;

@end

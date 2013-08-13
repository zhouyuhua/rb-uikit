//
//  UIScrollView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView.h"

@protocol UIScrollViewDelegate;
@class UIPanGestureRecognizer;

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

@property (nonatomic, getter=isDragging) BOOL dragging;

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

- (void)flashScrollIndicators;

@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;

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

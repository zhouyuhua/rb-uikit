//
//  UIScrollView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollView_Private.h"
#import "UIScrollWheelGestureRecognizer.h"

#import "UIScrollViewDecelerationAnimator.h"
#import "UIScrollViewScrollAnimator.h"

#import "UIScroller.h"

const CGFloat UIScrollViewDecelerationRateNormal = 0.33;
const CGFloat UIScrollViewDecelerationRateFast = 0.2;

static CGFloat const UIScrollViewNegativeSpaceScaleFactor = 0.35;

@implementation UIScrollView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.contentSize = frame.size;
        self.bounces = YES;
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = YES;
        
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 1.0;
        
        self.clipsToBounds = YES;
        
        self.panGestureRecognizer = [[UIScrollWheelGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [self addGestureRecognizer:self.panGestureRecognizer];
        
        self.horizontalScroller = [[UIScroller alloc] initWithOrientation:UIScrollerOrientationHorizontal];
        self.horizontalScroller.alpha = 0.0;
        [self addSubview:self.horizontalScroller];
        
        self.verticalScroller = [[UIScroller alloc] initWithOrientation:UIScrollerOrientationVertical];
        self.verticalScroller.alpha = 0.0;
        [self addSubview:self.verticalScroller];
    }
    
    return self;
}

#pragma mark - Properties

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self _constrainContent];
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
    
    [self _constrainContent];
}

- (void)setContentSize:(CGSize)contentSize
{
    _contentSize = contentSize;
    
    [self _constrainContent];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self _constrainContent];
}

#pragma mark -

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateRespondsTo.scrollViewDidScroll = [delegate respondsToSelector:@selector(scrollViewDidScroll:)];
    _delegateRespondsTo.scrollViewDidZoom = [delegate respondsToSelector:@selector(scrollViewDidZoom:)];
    
    _delegateRespondsTo.scrollViewWillBeginDragging = [delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)];
    _delegateRespondsTo.scrollViewWillEndDraggingWithVelocityTargetContentOffset = [delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
    _delegateRespondsTo.scrollViewDidEndDraggingWillDecelerate = [delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
    _delegateRespondsTo.scrollViewWillBeginDecelerating = [delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)];
    _delegateRespondsTo.scrollViewDidEndDecelerating = [delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    _delegateRespondsTo.scrollViewDidEndScrollingAnimation = [delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)];
    
    _delegateRespondsTo.viewForZoomingInScrollView = [delegate respondsToSelector:@selector(viewForZoomingInScrollView:)];
    _delegateRespondsTo.scrollViewWillBeginZoomingWithView = [delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)];
    _delegateRespondsTo.scrollViewDidEndZoomingWithViewAtScale = [delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)];
    
    _delegateRespondsTo.scrollViewShouldScrollToTop = [delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)];
    _delegateRespondsTo.scrollViewDidScrollToTop = [delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)];
}

#pragma mark - Scrolling

- (BOOL)_canScrollVertical
{
    return self.contentSize.height > CGRectGetHeight(self.bounds);
}

- (BOOL)_canScrollHorizontal
{
    return self.contentSize.width > CGRectGetWidth(self.bounds);
}

- (CGPoint)_constrainContentOffset:(CGPoint)contentOffset forBounceBack:(BOOL)isForBounceBack
{
    CGRect bounds = self.bounds;
    
    if((_contentSize.width - contentOffset.x) < CGRectGetWidth(bounds)) {
        contentOffset.x = (_contentSize.width - CGRectGetWidth(bounds));
    }
    
    if((_contentSize.height - contentOffset.y) < CGRectGetHeight(bounds)) {
        contentOffset.y = (_contentSize.height - CGRectGetHeight(bounds));
    }
    
    contentOffset.x = MIN(_contentSize.width, MAX(contentOffset.x, 0.0));
    contentOffset.y = MIN(_contentSize.height, MAX(contentOffset.y, 0.0));
    
    return contentOffset;
}

- (CGSize)_constrainContentSize:(CGSize)contentSize
{
    CGRect bounds = self.bounds;
    if(contentSize.width < CGRectGetWidth(bounds))
        contentSize.width = CGRectGetWidth(bounds);
    
    if(contentSize.height < CGRectGetHeight(bounds))
        contentSize.height = CGRectGetHeight(bounds);
    
    return contentSize;
}

- (void)_constrainContent
{
    _contentSize = [self _constrainContentSize:_contentSize];
    
    _verticalScroller.contentSize = _contentSize;
    _horizontalScroller.contentSize = _contentSize;
    
    self.contentOffset = [self _constrainContentOffset:_contentOffset forBounceBack:NO];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [self setContentOffset:contentOffset animated:NO];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    if(animated) {
        UIScrollViewScrollAnimator *scrollAnimation = [[UIScrollViewScrollAnimator alloc] initWithScrollView:self
                                                                                           fromContentOffset:_contentOffset
                                                                                                          to:contentOffset
                                                                                                    duration:0.3
                                                                                              timingFunction:&UILinearInterpolation];
        [self _runAnimation:scrollAnimation completionHandler:nil];
    } else {
        _contentOffset = contentOffset;
        
        CGRect bounds = self.bounds;
        
        bounds.origin.x = contentOffset.x + _contentInset.left;
        bounds.origin.y = contentOffset.y + _contentInset.top;
        
        self.bounds = bounds;
        
        _horizontalScroller.contentOffset = contentOffset;
        _verticalScroller.contentOffset = contentOffset;
        
        if(_delegateRespondsTo.scrollViewDidScroll)
            [_delegate scrollViewDidScroll:self];
        
        [self setNeedsLayout];
    }
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    CGRect contentRect = CGRectMake(0.0, 0.0, _contentSize.width, _contentSize.height);
    CGRect visibleRect = self.bounds;
    CGRect intersection = CGRectIntersection(rect, contentRect);
    if(!CGRectIsNull(intersection) && !CGRectContainsRect(visibleRect, intersection)) {
        CGPoint scrollPoint = CGPointMake(MAX(0.0, CGRectGetMaxX(rect) - CGRectGetWidth(visibleRect)),
                                          MAX(0.0, CGRectGetMaxY(rect) - CGRectGetHeight(visibleRect)));
        [self setContentOffset:scrollPoint animated:animated];
        [self flashScrollIndicators];
    }
}

#pragma mark -

- (void)flashScrollIndicators
{
    [self _showScrollers];
    self.hideScrollersTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(_hideScrollers)
                                                             userInfo:nil
                                                              repeats:NO];
}

- (void)_showScrollers
{
    [self.hideScrollersTimer invalidate];
    
    if([self _canScrollVertical])
        _verticalScroller.alpha = 1.0;
    
    if([self _canScrollHorizontal])
        _horizontalScroller.alpha = 1.0;
}

- (void)_hideScrollers
{
    [UIView animateWithDuration:UIKitDefaultAnimationDuration animations:^{
        _verticalScroller.alpha = 0.0;
        _horizontalScroller.alpha = 0.0;
    }];
}

#pragma mark - Zooming

- (void)setZoomScale:(float)zoomScale
{
    [self setZoomScale:zoomScale animated:YES];
}

- (void)setZoomScale:(float)scale animated:(BOOL)animated
{
    UIKitUnimplementedMethod();
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated
{
    UIKitUnimplementedMethod();
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = UIEdgeInsetsInsetRect(self.bounds, _scrollIndicatorInsets);
    BOOL bothScrollersVisible = ([self _canScrollHorizontal] && [self _canScrollVertical]);
    
    CGRect verticalScrollerFrame = _verticalScroller.frame;
    verticalScrollerFrame.size = [_verticalScroller sizeThatFits:bounds.size];
    verticalScrollerFrame.origin.x = CGRectGetMaxX(bounds) - CGRectGetWidth(verticalScrollerFrame);
    verticalScrollerFrame.origin.y = CGRectGetMinY(bounds);
    
    if(bothScrollersVisible)
        verticalScrollerFrame.size.height -= UIScrollerTrackArea;
    
    _verticalScroller.frame = verticalScrollerFrame;
    
    CGRect horizontalScrollerFrame = _horizontalScroller.frame;
    horizontalScrollerFrame.size = [_horizontalScroller sizeThatFits:bounds.size];
    horizontalScrollerFrame.origin.x = CGRectGetMinX(bounds);
    horizontalScrollerFrame.origin.y = CGRectGetMaxY(bounds) - CGRectGetHeight(horizontalScrollerFrame);
    
    if(bothScrollersVisible)
        horizontalScrollerFrame.size.width -= UIScrollerTrackArea;
    
    _horizontalScroller.frame = horizontalScrollerFrame;
}

#pragma mark -

- (void)_bringScrollersToFront
{
    [super bringSubviewToFront:_horizontalScroller];
    [super bringSubviewToFront:_verticalScroller];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    
    if(view != _horizontalScroller && view != _verticalScroller)
        [self _bringScrollersToFront];
}

- (void)bringSubviewToFront:(UIView *)view
{
    [super bringSubviewToFront:view];
    
    if(view != _horizontalScroller && view != _verticalScroller)
        [self _bringScrollersToFront];
}

#pragma mark - Animations

- (void)_runAnimation:(UIAnimator *)animation completionHandler:(dispatch_block_t)completionHandler
{
    if(self._currentAnimator)
       [self._currentAnimator stop];
    
    self._currentAnimator = animation;
    
    __weak __typeof(self) me = self;
    self._currentAnimator.completionHandler = ^{
        __typeof(self) strongMe = me;
        
        strongMe._currentAnimator = nil;
        
        if(strongMe->_delegateRespondsTo.scrollViewDidEndScrollingAnimation)
            [strongMe->_delegate scrollViewDidEndScrollingAnimation:strongMe];
        
        if(completionHandler)
            completionHandler();
    };
    [self._currentAnimator run];
}

#pragma mark -

- (void)_bounceBack
{
    self._shouldBounceBack = NO;
    
    [self setContentOffset:[self _constrainContentOffset:_contentOffset forBounceBack:YES] animated:YES];
}

- (void)_decelerateScrollWithVelocity:(CGPoint)velocity
{
    if(_delegateRespondsTo.scrollViewDidEndDraggingWillDecelerate)
        [_delegate scrollViewDidEndDragging:self willDecelerate:YES];
    
    self.decelerating = YES;
    
    UIScrollViewDecelerationAnimator *deceleration = [[UIScrollViewDecelerationAnimator alloc] initWithScrollView:self velocity:velocity];
    self.decelerationRate = deceleration.duration;
    deceleration.targetContentOffset = [self _constrainSnapbackTargetContentOffset:deceleration.targetContentOffset velocity:velocity];
    
    if(_delegateRespondsTo.scrollViewWillBeginDecelerating)
        [_delegate scrollViewWillBeginDecelerating:self];
    
    __weak __typeof(self) me = self;
    [self _runAnimation:deceleration completionHandler:^{
        self.decelerating = NO;
        self.decelerationRate = 0.0;
        
        __typeof(self) strongMe = me;
        if(strongMe->_delegateRespondsTo.scrollViewDidEndDecelerating)
            [strongMe->_delegate scrollViewDidEndDecelerating:self];
    }];
}

- (CGPoint)_constrainSnapbackTargetContentOffset:(CGPoint)targetContentOffset velocity:(CGPoint)velocity
{
    if(_delegateRespondsTo.scrollViewWillEndDraggingWithVelocityTargetContentOffset) {
        [_delegate scrollViewWillEndDragging:self withVelocity:velocity targetContentOffset:&targetContentOffset];
    }
    
    return targetContentOffset;
}

#pragma mark - Gestures

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

#pragma mark -

- (void)_beginDragging
{
    if(_delegateRespondsTo.scrollViewWillBeginDragging)
        [_delegate scrollViewWillBeginDragging:self];
    
    [self._currentAnimator stop];
    self._currentAnimator = nil;
    
    self._shouldBounceBack = NO;
    [self _showScrollers];
    
    self.dragging = YES;
    self.tracking = YES;
}

- (void)_dragBy:(CGPoint)delta
{
    CGPoint originalOffset = self.contentOffset;
    
    CGPoint rawOffset = originalOffset;
    rawOffset.x += delta.x;
    rawOffset.y += delta.y;
    
    CGPoint constrainedOffset = [self _constrainContentOffset:rawOffset forBounceBack:NO];
    if(_bounces) {
        BOOL shouldBounceHorizontal = _alwaysBounceHorizontal && (ABS(rawOffset.x - constrainedOffset.x) > 0);
        if(shouldBounceHorizontal) {
            constrainedOffset.x = originalOffset.x + (UIScrollViewNegativeSpaceScaleFactor * delta.x);
            
            self._shouldBounceBack = YES;
            
            if(constrainedOffset.x < -CGRectGetWidth(self.bounds) / 2.0) {
                constrainedOffset.x = round(-CGRectGetWidth(self.bounds) / 2.0);
            } else if(constrainedOffset.x > _contentSize.width - CGRectGetWidth(self.bounds) / 2.0) {
                constrainedOffset.x = round(_contentSize.width - CGRectGetWidth(self.bounds) / 2.0);
            }
        }
        
        BOOL shouldBounceVertical = _alwaysBounceVertical && (ABS(rawOffset.y - constrainedOffset.y) > 0);
        if(shouldBounceVertical) {
            constrainedOffset.y = originalOffset.y + (UIScrollViewNegativeSpaceScaleFactor * delta.y);
            
            self._shouldBounceBack = YES;
            
            if(constrainedOffset.y < -CGRectGetHeight(self.bounds) / 2.0) {
                constrainedOffset.y = round(-CGRectGetHeight(self.bounds) / 2.0);
            } else if(constrainedOffset.y > _contentSize.height - CGRectGetHeight(self.bounds) / 2.0) {
                constrainedOffset.y = round(_contentSize.height - CGRectGetHeight(self.bounds) / 2.0);
            }
        }
    }
    
    self.contentOffset = constrainedOffset;
}

- (void)_endDraggingWithVelocity:(CGPoint)velocity
{
    self.hideScrollersTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(_hideScrollers)
                                                             userInfo:nil
                                                              repeats:NO];
    
    if(self._shouldBounceBack) {
        if(_delegateRespondsTo.scrollViewDidEndDraggingWillDecelerate)
            [_delegate scrollViewDidEndDragging:self willDecelerate:NO];
        
        [self _bounceBack];
    } else if(!CGPointEqualToPoint(velocity, CGPointZero)) {
        //velocity will come back as a zero point if we're being
        //scrolled from an old-fashioned scroll-wheel device.
        [self _decelerateScrollWithVelocity:velocity];
    }
    
    self.dragging = NO;
    self.tracking = NO;
}


#pragma mark -

- (void)panned:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            [self _beginDragging];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint delta = [pan translationInView:self];
            [self _dragBy:delta];
            [pan setTranslation:CGPointZero inView:self];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [pan velocityInView:self];
            [self _endDraggingWithVelocity:velocity];
            break;
        }
            
        default: {
            break;
        }
    }
}

#pragma mark - Events

- (void)idleScrollTouchesBegan
{
    [self _showScrollers];
}

- (void)idleScrollTouchesEnded
{
    if(self.dragging)
        return;
    
    self.hideScrollersTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                               target:self
                                                             selector:@selector(_hideScrollers)
                                                             userInfo:nil
                                                              repeats:NO];
}

- (void)idleScrollTouchesCanceled
{
    if(self.dragging)
        return;
    
    self.hideScrollersTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                               target:self
                                                             selector:@selector(_hideScrollers)
                                                             userInfo:nil
                                                              repeats:NO];
}

@end

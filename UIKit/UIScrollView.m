//
//  UIScrollView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScrollView.h"
#import "UIScrollWheelGestureRecognizer.h"

#import "UIScroller.h"

const CGFloat UIScrollViewDecelerationRateNormal = 0.3;
const CGFloat UIScrollViewDecelerationRateFast = 0.2;

@interface UIScrollView ()

@property (nonatomic) UIScroller *horizontalScroller;
@property (nonatomic) UIScroller *verticalScroller;

@property (nonatomic, weak) NSTimer *hideScrollersTimer;

#pragma mark - readwrite

@property (nonatomic, readwrite) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation UIScrollView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        self.contentSize = frame.size;
        self.bounces = YES;
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = YES;
        
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

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _contentInset = contentInset;
}

- (void)setContentSize:(CGSize)contentSize
{
    _contentSize = contentSize;
    
    _verticalScroller.contentSize = contentSize;
    _horizontalScroller.contentSize = contentSize;
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

- (CGPoint)_constrainContentOffset:(CGPoint)contentOffset
{
    CGRect bounds = self.bounds;
    
    if((_contentSize.width - contentOffset.x) < CGRectGetWidth(bounds)) {
        contentOffset.x = (_contentSize.width - CGRectGetWidth(bounds));
    }
    
    if((_contentSize.height - contentOffset.y) < CGRectGetHeight(bounds)) {
        contentOffset.y = (_contentSize.height - CGRectGetHeight(bounds));
    }
    
    contentOffset.x = MAX(contentOffset.x, 0.0);
    contentOffset.y = MAX(contentOffset.y, 0.0);
    
    return contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [self setContentOffset:contentOffset animated:YES];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    _contentOffset = contentOffset;
    
    CGRect bounds = self.bounds;
    
    bounds.origin.x = contentOffset.x + _contentInset.left;
    bounds.origin.y = contentOffset.y + _contentInset.top;
    
    self.bounds = bounds;
    
    _horizontalScroller.contentOffset = contentOffset;
    _verticalScroller.contentOffset = contentOffset;
    
    [self setNeedsLayout];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    [self setContentOffset:rect.origin animated:animated];
}

#pragma mark -

- (void)flashScrollIndicators
{
    
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
    [UIView animateWithDuration:0.25 animations:^{
        _verticalScroller.alpha = 0.0;
        _horizontalScroller.alpha = 0.0;
    }];
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
    [self bringSubviewToFront:_horizontalScroller];
    [self bringSubviewToFront:_verticalScroller];
    
    [self setNeedsLayout];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    
    if(view != _horizontalScroller && view != _verticalScroller)
        [self _bringScrollersToFront];
}

#pragma mark - Gestures

- (void)_beginDragging
{
    [self _showScrollers];
}

- (void)_dragBy:(CGPoint)delta
{
    CGPoint originalOffset = self.contentOffset;
    
    CGPoint rawOffset = originalOffset;
    rawOffset.x += delta.x;
    rawOffset.y += delta.y;
    
    CGPoint constrainedOffset = [self _constrainContentOffset:rawOffset];
//    if(_bounces) {
//        BOOL shouldBounceHorizontal = _alwaysBounceHorizontal && (ABS(rawOffset.x - constrainedOffset.x) > 0);
//        if(shouldBounceHorizontal) {
//            constrainedOffset.x = originalOffset.x + (0.05 * delta.x);
//        }
//        
//        BOOL shouldBounceVertical = _alwaysBounceVertical && (ABS(rawOffset.y - constrainedOffset.y) > 0);
//        if(shouldBounceVertical) {
//            constrainedOffset.y = originalOffset.y + (0.05 * delta.y);
//        }
//    }
    
    self.contentOffset = constrainedOffset;
}

- (void)_endDraggingWithVelocity:(CGPoint)velocity
{
    self.hideScrollersTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(_hideScrollers)
                                                             userInfo:nil
                                                              repeats:NO];
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

@end

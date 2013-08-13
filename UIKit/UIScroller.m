//
//  UIScroller.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScroller.h"

CGFloat const UIScrollerTrackArea = 12.0;
CGFloat const UIScrollerMinimumKnobArea = 40.0;

@interface UIScroller ()

@property (nonatomic) UIView *knobView;

@end

#pragma mark -

@implementation UIScroller

- (id)initWithFrame:(CGRect)frame
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithOrientation:(UIScrollerOrientation)orientation
{
    if((self = [super initWithFrame:CGRectZero])) {
        self.orientation = orientation;
        
        self.knobView = [UIView new];
        self.knobView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.knobView.layer.cornerRadius = 4.0;
        self.knobView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        self.knobView.layer.borderWidth = 1.0;
        [self addSubview:self.knobView];
    }
    
    return self;
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    switch (_orientation) {
        case UIScrollerOrientationVertical:
            return CGSizeMake(UIScrollerTrackArea, size.height);
        case UIScrollerOrientationHorizontal:
            return CGSizeMake(size.width, UIScrollerTrackArea);
    }
}

- (void)layoutSubviews
{
    CGRect scrollViewFrame = self.superview.frame;
    CGRect bounds = CGRectInset(self.bounds, 2.0, 2.0);
    
    CGRect knobViewFrame = self.knobView.frame;
    switch (_orientation) {
        case UIScrollerOrientationVertical: {
            if(_contentSize.height == CGRectGetHeight(scrollViewFrame)) {
                knobViewFrame = bounds;
            } else {
                CGFloat knobScale = CGRectGetHeight(scrollViewFrame) / _contentSize.height;
                knobViewFrame.size.height = MAX(UIScrollerMinimumKnobArea, CGRectGetHeight(bounds) * knobScale);
                knobViewFrame.size.width = CGRectGetWidth(bounds);
                
                CGFloat scrollViewHeight = CGRectGetHeight(scrollViewFrame) - (CGRectGetHeight(knobViewFrame) * 2.0 + 8.0);
                CGFloat offset = MAX(0.0, _contentOffset.y / (_contentSize.height - scrollViewHeight));
                knobViewFrame.origin.y = CGRectGetMinY(bounds) + CGRectGetHeight(bounds) * offset;
                knobViewFrame.origin.x = CGRectGetMinX(bounds);
                
                if(CGRectGetMaxY(knobViewFrame) > CGRectGetHeight(bounds)) {
                    knobViewFrame.size.height -= CGRectGetMaxY(knobViewFrame) - CGRectGetHeight(bounds);
                    knobViewFrame.origin.y = CGRectGetMaxY(bounds) - CGRectGetHeight(knobViewFrame);
                } else if(CGRectGetMinY(knobViewFrame) < 0.0) {
                    knobViewFrame.size.height += CGRectGetMinY(knobViewFrame);
                    knobViewFrame.origin.y = 0.0;
                }
            }
            
            break;
        }
        case UIScrollerOrientationHorizontal: {
            if(_contentSize.width == CGRectGetWidth(scrollViewFrame)) {
                knobViewFrame = bounds;
            } else {
                CGFloat knobScale = CGRectGetWidth(scrollViewFrame) / _contentSize.width;
                knobViewFrame.size.width = MAX(UIScrollerMinimumKnobArea, CGRectGetWidth(bounds) * knobScale);
                knobViewFrame.size.height = CGRectGetHeight(bounds);
                
                CGFloat scrollViewWidth = CGRectGetWidth(scrollViewFrame) - (CGRectGetWidth(knobViewFrame) * 2.0 + 8.0);
                CGFloat offset = MAX(0.0, _contentOffset.x / (_contentSize.width - scrollViewWidth));
                knobViewFrame.origin.x = CGRectGetMinX(bounds) + CGRectGetWidth(bounds) * offset;
                knobViewFrame.origin.y = CGRectGetMinY(bounds);
                
                if(CGRectGetMaxX(knobViewFrame) > CGRectGetWidth(bounds)) {
                    knobViewFrame.size.width -= CGRectGetMaxX(knobViewFrame) - CGRectGetWidth(bounds);
                    knobViewFrame.origin.x = CGRectGetMaxX(bounds) - CGRectGetWidth(knobViewFrame);
                } else if(CGRectGetMinX(knobViewFrame) < 0.0) {
                    knobViewFrame.size.width += CGRectGetMinX(knobViewFrame);
                    knobViewFrame.origin.x = 0.0;
                }
            }
            
            break;
        }
    }
    self.knobView.frame = knobViewFrame;
}

#pragma mark - Properties

- (void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    [self layoutSubviews];
}

@end

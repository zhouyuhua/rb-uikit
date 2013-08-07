//
//  UIScroller.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/6/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIScroller.h"

static CGFloat const UIScrollerTrackArea = 12.0;
static CGFloat const UIScrollerMinimumKnobArea = 40.0;

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
                knobViewFrame.size.height = MAX(UIScrollerMinimumKnobArea, CGRectGetHeight(scrollViewFrame) - _contentSize.height);
                knobViewFrame.size.width = CGRectGetWidth(bounds);
                
                CGFloat scrollViewHeight = CGRectGetHeight(scrollViewFrame) - (CGRectGetHeight(knobViewFrame) * 2.0 + 8.0);
                CGFloat offset = _contentOffset.y / (_contentSize.height - scrollViewHeight);
                knobViewFrame.origin.y = CGRectGetMinY(bounds) + CGRectGetHeight(bounds) * offset;
                knobViewFrame.origin.x = CGRectGetMinX(bounds);
            }
            
            break;
        }
        case UIScrollerOrientationHorizontal: {
            if(_contentSize.width == CGRectGetWidth(scrollViewFrame)) {
                knobViewFrame = bounds;
            } else {
                knobViewFrame.size.width = MAX(UIScrollerMinimumKnobArea, CGRectGetWidth(scrollViewFrame) - _contentSize.width);
                knobViewFrame.size.height = CGRectGetHeight(bounds);
                
                CGFloat scrollViewWidth = CGRectGetWidth(scrollViewFrame) - (CGRectGetWidth(knobViewFrame) * 2.0 + 8.0);
                CGFloat offset = _contentOffset.x / (_contentSize.width - scrollViewWidth);
                knobViewFrame.origin.x = CGRectGetMinX(bounds) + CGRectGetWidth(bounds) * offset;
                knobViewFrame.origin.y = CGRectGetMinY(bounds);
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

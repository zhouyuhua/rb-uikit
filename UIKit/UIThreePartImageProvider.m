//
//  UIThreePartImageProvider.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIThreePartImageProvider.h"

@interface UIThreePartImageProvider ()

@property (nonatomic, readwrite) CGFloat leftCap, rightCap;
@property (nonatomic, getter=isVertical) BOOL vertical;
@property (nonatomic) UIImageResizingMode resizingMode;

@end

#pragma mark -

@implementation UIThreePartImageProvider

- (instancetype)initWithProvider:(UIImageProvider *)provider
                         leftCap:(CGFloat)leftCap
                        rightCap:(CGFloat)rightCap
                      isVertical:(BOOL)isVertical
                    resizingMode:(UIImageResizingMode)resizingMode
{
    if((self = [super initWithCGImage:[provider image] scale:[provider scale]])) {
        self.leftCap = leftCap;
        self.rightCap = rightCap;
        self.resizingMode = resizingMode;
        self.vertical = isVertical;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    UIThreePartImageProvider *copy = [super copyWithZone:zone];
    copy.leftCap = self.leftCap;
    copy.rightCap = self.rightCap;
    copy.resizingMode = self.resizingMode;
    return copy;
}

#pragma mark - Drawing

- (void)drawInRect:(CGRect)destinationRect fromRect:(CGRect)fromRect tile:(BOOL)tile
{
    CGSize imageSize = [self imageSize];
    if(_vertical) {
        [super drawInRect:CGRectMake(CGRectGetMinX(destinationRect), CGRectGetMinY(destinationRect), CGRectGetWidth(destinationRect), _leftCap)
                 fromRect:CGRectMake(0.0, 0.0, imageSize.height, _leftCap)
                     tile:NO];
        
        [super drawInRect:CGRectMake(CGRectGetMinX(destinationRect), CGRectGetMinY(destinationRect) + _leftCap, CGRectGetWidth(destinationRect), CGRectGetHeight(destinationRect) - (_leftCap + _rightCap))
                 fromRect:CGRectMake(0.0, _leftCap, imageSize.width, 1.0)
                     tile:(_resizingMode == UIImageResizingModeTile)];
        
        [super drawInRect:CGRectMake(CGRectGetMaxX(destinationRect), CGRectGetMinY(destinationRect) - _rightCap, CGRectGetWidth(destinationRect), _rightCap)
                 fromRect:CGRectMake(0.0, imageSize.height / self.scale - _rightCap, imageSize.width, _rightCap)
                     tile:NO];
    } else {
        [super drawInRect:CGRectMake(CGRectGetMinX(destinationRect), CGRectGetMinY(destinationRect), _leftCap, CGRectGetHeight(destinationRect))
                 fromRect:CGRectMake(0.0, 0.0, _leftCap, imageSize.height)
                     tile:NO];
        
        [super drawInRect:CGRectMake(CGRectGetMinX(destinationRect) + _leftCap, CGRectGetMinY(destinationRect), CGRectGetWidth(destinationRect) - (_leftCap + _rightCap), CGRectGetHeight(destinationRect))
                 fromRect:CGRectMake(_leftCap, 0.0, 1.0, imageSize.height)
                     tile:(_resizingMode == UIImageResizingModeTile)];
        
        [super drawInRect:CGRectMake(CGRectGetMaxX(destinationRect) - _rightCap, CGRectGetMinY(destinationRect), _rightCap, CGRectGetHeight(destinationRect))
                 fromRect:CGRectMake(imageSize.width / self.scale - _rightCap, 0.0, _rightCap, imageSize.height)
                     tile:NO];
    }
}

@end

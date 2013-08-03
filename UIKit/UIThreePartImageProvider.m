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
@property (nonatomic) UIImageResizingMode resizingMode;

@end

#pragma mark -

@implementation UIThreePartImageProvider

- (instancetype)initWithProvider:(UIImageProvider *)provider leftCap:(CGFloat)leftCap rightCap:(CGFloat)rightCap resizingMode:(UIImageResizingMode)resizingMode
{
    if((self = [super initWithCGImage:[provider image] scale:[provider scale]])) {
        self.leftCap = leftCap;
        self.rightCap = rightCap;
        self.resizingMode = resizingMode;
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

@end

//
//  UINavigationBarAppearance.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/20/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINavigationBarAppearance.h"
#import "UIFont.h"
#import "UIColor.h"
#import "UIImage_Private.h"

@implementation UINavigationBarAppearance {
    UIImage *_backgroundImage;
    CGFloat _titleVerticalPositionAdjustment;
}

- (id)init
{
    if((self = [super init])) {
        NSShadow *shadow = [NSShadow new];
        shadow.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        shadow.shadowOffset = CGSizeMake(0.0, 1.0);
        
        self.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0 alpha:0.8],
                                     NSShadowAttributeName: shadow,
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0]};
        
        self.backgroundImage = UIKitImageNamed(@"UINavigationBarBackgroundImage", UIImageResizingModeStretch);
    }
    
    return self;
}

#pragma mark -

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        _backgroundImage = backgroundImage;
}

- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        return _backgroundImage;
    
    return nil;
}

#pragma mark -

- (void)setTitleVerticalPositionAdjustment:(CGFloat)adjustment forBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        _titleVerticalPositionAdjustment = adjustment;
}

- (CGFloat)titleVerticalPositionAdjustmentForBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        return _titleVerticalPositionAdjustment;
    
    return 0.0;
}

@end

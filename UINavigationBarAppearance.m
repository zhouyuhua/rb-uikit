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

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        self.backgroundImage = backgroundImage;
}

- (UIImage *)backgroundImageForBarMetrics:(UIBarMetrics)barMetrics
{
    if(barMetrics == UIBarMetricsDefault)
        return self.backgroundImage;
    
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

UIConcreteAppearanceGeneratePropertyGetter(NSDictionary *, titleTextAttributes, @{ NSForegroundColorAttributeName: [UIColor colorWithWhite:0.0 alpha:0.8],
                                                                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0] })
UIConcreteAppearanceGeneratePropertyGetter(UIImage *, backgroundImage, UIKitImageNamed(@"UINavigationBarBackgroundImage", UIImageResizingModeStretch))

@end

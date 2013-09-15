//
//  UIActivityIndicatorView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/14/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIActivityIndicatorView.h"

/* These match OS X sizes */
static CGSize const kSmallViewSize = {16.0, 16.0};
static CGSize const kLargeViewSize = {32.0, 32.0};

static NSTimeInterval const kAnimationFramesPerSecond = (5.0 / 60.0);

/*
 The following is derived from AMIndeterminateProgressIndicatorCell by Andreas Mayer.
 Copyright 2007 Andreas Mayer. All rights reserved.
 */

#define ConvertAngle(a) (fmod((90.0-(a)), 360.0))

#define DEG2RAD  0.017453292519943295

@interface UIActivityIndicatorView ()

@property (nonatomic, readwrite, getter=isAnimating) BOOL animating;

@end

@implementation UIActivityIndicatorView {
    __weak NSTimer *_animationTimer;
    
    CGFloat _step;
    
    CGFloat _colorRedComponent, _colorGreenComponent, _colorBlueComponent;
}

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    if((self = [self initWithFrame:CGRectZero])) {
        self.activityIndicatorViewStyle = style;
    }
    
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if(self.isAnimating || !self.hidesWhenStopped) {
		NSInteger step = round(_step/kAnimationFramesPerSecond);
        
		CGFloat size = MIN(rect.size.width, rect.size.height);
        CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));;
		
        CGFloat outerRadius;
		CGFloat innerRadius;
		CGFloat strokeWidth = size * 0.08;
		if(size >= 32.0) {
			outerRadius = size * 0.38;
			innerRadius = size * 0.23;
		} else {
			outerRadius = size * 0.48;
			innerRadius = size * 0.27;
		}
        
		NSLineCapStyle previousLineCapStyle = [NSBezierPath defaultLineCapStyle];
		CGFloat previousLineWidth = [NSBezierPath defaultLineWidth];
		{
            [NSBezierPath setDefaultLineCapStyle:NSRoundLineCapStyle];
            [NSBezierPath setDefaultLineWidth:strokeWidth];
            
            CGFloat angle = (self.isAnimating)? (270 + (step * 30)) * DEG2RAD : 270 * DEG2RAD;
            
            for (NSUInteger i = 0; i < 12; i++) {
                [[NSColor colorWithCalibratedRed:_colorRedComponent
                                           green:_colorGreenComponent
                                            blue:_colorBlueComponent
                                           alpha:1.0 - sqrt(i) * 0.25] set];
                
                CGPoint outerPoint = CGPointMake(center.x + cos(angle) * outerRadius,
                                                 center.y + sin(angle) * outerRadius);
                CGPoint innerPoint = CGPointMake(center.x + cos(angle) * innerRadius,
                                                 center.y + sin(angle) * innerRadius);
                [NSBezierPath strokeLineFromPoint:innerPoint toPoint:outerPoint];
                
                angle -= 30 * DEG2RAD;
            }
		}
		[NSBezierPath setDefaultLineCapStyle:previousLineCapStyle];
		[NSBezierPath setDefaultLineWidth:previousLineWidth];
	}
}

#pragma mark - Managing an Activity Indicator

- (void)animationTimerPulse:(NSTimer *)timer
{
    _step = fmod((_step + kAnimationFramesPerSecond), 1.0);
    [self setNeedsDisplay];
}

- (void)startAnimating
{
    if(self.animating)
        return;
    
    self.animating = YES;
    
    _step = 0.0;
    [self setNeedsDisplay];
    
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:kAnimationFramesPerSecond
                                                       target:self
                                                     selector:@selector(animationTimerPulse:)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopAnimating
{
    if(!self.animating)
        return;
    
    self.animating = NO;
    
    [_animationTimer invalidate];
    _step = 0.0;
    [self setNeedsDisplay];
}

#pragma mark -

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;
    [self setNeedsDisplay];
}

#pragma mark - Configuring the Activity Indicator Appearance

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    CGSize newSize;
    switch (activityIndicatorViewStyle) {
        case UIActivityIndicatorViewStyleGray: {
            self.color = [UIColor blackColor];
            newSize = kSmallViewSize;
            
            break;
        }
            
        case UIActivityIndicatorViewStyleWhite: {
            self.color = [UIColor whiteColor];
            newSize = kSmallViewSize;
            
            break;
        }
            
        case UIActivityIndicatorViewStyleWhiteLarge: {
            self.color = [UIColor whiteColor];
            newSize = kLargeViewSize;
            
            break;
        }
    }
    
    CGRect frame = self.frame;
    frame.size = newSize;
    self.frame = frame;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    [[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&_colorRedComponent
                                                                 green:&_colorGreenComponent
                                                                  blue:&_colorBlueComponent
                                                                 alpha:NULL];
    
    [self setNeedsDisplay];
}

@end

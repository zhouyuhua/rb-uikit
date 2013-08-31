//
//  UIView.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIResponder.h"
#import "UIColor.h"
#import "UIAppearance.h"

typedef NS_ENUM(NSInteger, UIViewContentMode) {
    UIViewContentModeScaleToFill,
    UIViewContentModeScaleAspectFit,
    UIViewContentModeScaleAspectFill,
    UIViewContentModeRedraw,
    UIViewContentModeCenter,
    UIViewContentModeTop,
    UIViewContentModeBottom,
    UIViewContentModeLeft,
    UIViewContentModeRight,
    UIViewContentModeTopLeft,
    UIViewContentModeTopRight,
    UIViewContentModeBottomLeft,
    UIViewContentModeBottomRight,
};

typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
    UIViewAutoresizingNone                 = 0,
    UIViewAutoresizingFlexibleLeftMargin   = kCALayerLeftEdge,
    UIViewAutoresizingFlexibleWidth        = kCALayerWidthSizable,
    UIViewAutoresizingFlexibleRightMargin  = kCALayerRightEdge,
    UIViewAutoresizingFlexibleTopMargin    = kCALayerTopEdge,
    UIViewAutoresizingFlexibleHeight       = kCALayerHeightSizable,
    UIViewAutoresizingFlexibleBottomMargin = kCALayerBottomEdge
};

typedef NS_ENUM(NSInteger, UIViewAnimationTransition) {
    UIViewAnimationTransitionNone,
    UIViewAnimationTransitionFlipFromLeft,
    UIViewAnimationTransitionFlipFromRight,
    UIViewAnimationTransitionCurlUp,
    UIViewAnimationTransitionCurlDown,
};

typedef NS_ENUM(NSInteger, UIViewAnimationCurve) {
    UIViewAnimationCurveEaseInOut,         // slow at beginning and end
    UIViewAnimationCurveEaseIn,            // slow at beginning
    UIViewAnimationCurveEaseOut,           // slow at end
    UIViewAnimationCurveLinear
};

typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
    UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
    UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
    UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
    UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
    UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
    UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
    UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
    UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
    UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
    UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
    
    UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
    UIViewAnimationOptionCurveEaseIn               = 1 << 16,
    UIViewAnimationOptionCurveEaseOut              = 2 << 16,
    UIViewAnimationOptionCurveLinear               = 3 << 16,
    
    UIViewAnimationOptionTransitionNone            = 0 << 20, // default
    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
};

typedef NS_ENUM(NSInteger, UIViewTintAdjustmentMode) {
    UIViewTintAdjustmentModeAutomatic,
    
    UIViewTintAdjustmentModeNormal,
    UIViewTintAdjustmentModeDimmed,
};

@class UIWindow, UIGestureRecognizer;

@interface UIView : UIResponder <UIAppearance, NSCoding>

+ (Class)layerClass;

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;
@property (nonatomic) NSInteger tag;
@property (nonatomic, readonly, retain) CALayer *layer;
@property (nonatomic, readonly) UIWindow *window;

#pragma mark - Geometry

@property (nonatomic) CGRect frame;
@property (nonatomic) CGRect bounds;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic) CGFloat contentScaleFactor;

@property (nonatomic,getter=isMultipleTouchEnabled) BOOL multipleTouchEnabled;
@property (nonatomic,getter=isExclusiveTouch) BOOL exclusiveTouch;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;
- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view;
- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
- (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;

@property (nonatomic) BOOL autoresizesSubviews;
@property (nonatomic) UIViewAutoresizing autoresizingMask;

- (CGSize)sizeThatFits:(CGSize)size;
- (void)sizeToFit;

#pragma mark - Subviews

@property (nonatomic, readonly, unsafe_unretained) UIView *superview;
@property (nonatomic, readonly, copy) NSArray *subviews;

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;

- (void)addSubview:(UIView *)view;
- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;

- (void)bringSubviewToFront:(UIView *)view;
- (void)sendSubviewToBack:(UIView *)view;

- (void)didAddSubview:(UIView *)subview;
- (void)willRemoveSubview:(UIView *)subview;

- (void)removeFromSuperview;

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview;
- (void)didMoveToSuperview;
- (void)willMoveToWindow:(UIWindow *)newWindow;
- (void)didMoveToWindow;

- (BOOL)isDescendantOfView:(UIView *)view;
- (UIView *)viewWithTag:(NSInteger)tag;

#pragma mark - Rendering

- (void)drawRect:(CGRect)rect;

- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(CGRect)rect;

@property (nonatomic) BOOL clipsToBounds;
@property (nonatomic, copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, getter=isOpaque) BOOL opaque;
@property (nonatomic) BOOL clearsContextBeforeDrawing;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic) UIViewContentMode contentMode;

#pragma mark - Layout

- (void)setNeedsLayout;
- (void)layoutIfNeeded;
- (void)layoutSubviews;

#pragma mark - Gesture Recognizers

- (void)addGestureRecognizer:(UIGestureRecognizer *)gesture;
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gesture;

@property (nonatomic, readonly, copy) NSArray *gestureRecognizers;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)sender;

#pragma mark - Tint Colors

@property (nonatomic, retain) UIColor *tintColor;

/*
 This property is automatically updated on UIWindow so that
 OS X style non-key-window dimming can take effect. Subclasses
 that need this information should override -[UIView tintColorDidChange].
 */
@property (nonatomic) UIViewTintAdjustmentMode tintAdjustmentMode;

- (void)tintColorDidChange;

@end

@interface UIView (UIViewAnimation)

+ (void)beginAnimations:(NSString *)animationID context:(void *)context;  // additional context info passed to will start/did stop selectors. begin/commit can be nested
+ (void)commitAnimations;                                                 // starts up any animations when the top level animation is commited

// no getters. if called outside animation block, these setters have no effect.
+ (void)setAnimationDelegate:(id)delegate;                          // default = nil
+ (void)setAnimationWillStartSelector:(SEL)selector;                // default = NULL. -animationWillStart:(NSString *)animationID context:(void *)context
+ (void)setAnimationDidStopSelector:(SEL)selector;                  // default = NULL. -animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
+ (void)setAnimationDuration:(NSTimeInterval)duration;              // default = 0.2
+ (void)setAnimationDelay:(NSTimeInterval)delay;                    // default = 0.0
+ (void)setAnimationStartDate:(NSDate *)startDate;                  // default = now ([NSDate date])
+ (void)setAnimationCurve:(UIViewAnimationCurve)curve;              // default = UIViewAnimationCurveEaseInOut
+ (void)setAnimationRepeatCount:(float)repeatCount;                 // default = 0.0.  May be fractional
+ (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;    // default = NO. used if repeat count is non-zero
+ (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState;  // default = NO. If YES, the current view position is always used for new animations -- allowing animations to "pile up" on each other. Otherwise, the last end state is used for the animation (the default).

+ (void)setAnimationTransition:(UIViewAnimationTransition)transition forView:(UIView *)view cache:(BOOL)cache;

+ (void)setAnimationsEnabled:(BOOL)enabled;
+ (BOOL)areAnimationsEnabled;
+ (void)performWithoutAnimation:(void (^)(void))actionsWithoutAnimation;

@end

@interface UIView (UIViewAnimationWithBlocks)

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion; // delay = 0.0, options = 0

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations; // delay = 0.0, options = 0, completion = NULL

/* Performs `animations` using a timing curve described by the motion of a spring. When `dampingRatio` is 1, the animation will smoothly decelerate to its final model values without oscillating. Damping ratios less than 1 will oscillate more and more before coming to a complete stop. You can use the initial spring velocity to specify how fast the object at the end of the simulated spring was moving before it was attached. It's a unit coordinate system, where 1 is defined as travelling the total animation distance in a second. So if you're changing an object's position by 200pt in this animation, and you want the animation to behave as if the object was moving at 100pt/s before the animation started, you'd pass 0.5. You'll typically want to pass 0 for the velocity. */
+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);

+ (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion; // toView added to fromView.superview, fromView removed from its superview

@end

//
//  UIView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIView_Private.h"
#import "UIWindow.h"
#import "UIConcreteAppearance.h"
#import "UIGraphics.h"
#import "UIColor.h"
#import "UIWindow_Private.h"
#import "UIGestureRecognizer_Private.h"

#import "UIAppKitView.h"

@interface UIViewLayoutManager : NSObject

- (id)initWithView:(UIView *)view;

@property (nonatomic, unsafe_unretained) UIView *view;

@end

@implementation UIViewLayoutManager

- (id)initWithView:(UIView *)view
{
    NSParameterAssert(view);
    
    if((self = [super init])) {
        self.view = view;
    }
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [self.view layoutSubviews];
}

@end

#pragma mark -

@implementation UIView {
    UIColor *_tintColor;
    UIViewTintAdjustmentMode _tintAdjustmentMode;
    
    UIViewContentMode _contentMode;
    NSMutableArray *_subviews;
    NSMutableArray *_gestureRecognizers;
}

+ (instancetype)appearance
{
    return (UIView *)[UIConcreteAppearance appearanceForClass:[self class]];
}

+ (instancetype)appearanceWhenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ...
{
    UIKitUnimplementedMethod();
    return nil;
}

#pragma mark - Lifecycle

+ (Class)layerClass
{
    return [CALayer class];
}

- (void)dealloc
{
    while (_subviews.count > 0)
        [_subviews.lastObject removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super init])) {
        self.layer = [self.class.layerClass layer];
        self.layer.delegate = self;
        self.layer.layoutManager = [[UIViewLayoutManager alloc] initWithView:self];
        
        self.contentScaleFactor = 0.0;
        self.backgroundColor = [self.class.appearance backgroundColor];
        self.userInteractionEnabled = YES;
        self.autoresizesSubviews = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        _subviews = [NSMutableArray array];
        
        self._firstResponderManager = self;
        
        self.frame = frame;
        
        [self setNeedsDisplay];
    }
    
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIKitUnimplementedMethod();
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    UIKitUnimplementedMethod();
}

#pragma mark - Geometry

- (void)setFrame:(CGRect)frame
{
    self.layer.frame = frame;
}

- (CGRect)frame
{
    return self.layer.frame;
}

- (void)setBounds:(CGRect)bounds
{
    self.layer.bounds = bounds;
}

- (CGRect)bounds
{
    return self.layer.bounds;
}

- (void)setCenter:(CGPoint)center
{
    self.layer.position = center;
}

- (CGPoint)center
{
    return self.layer.position;
}

+ (NSSet *)keyPathsForValuesAffectingTransform
{
    return [NSSet setWithObjects:@"layer.transform", nil];
}

- (void)setTransform:(CGAffineTransform)transform
{
    self.layer.affineTransform = transform;
}

- (CGAffineTransform)transform
{
    return self.layer.affineTransform;
}

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    if(contentScaleFactor == 0.0)
        contentScaleFactor = [UIScreen mainScreen].scale;
    
    self.layer.contentsScale = contentScaleFactor;
}

- (CGFloat)contentScaleFactor
{
    return self.layer.contentsScale;
}

- (void)setExclusiveTouch:(BOOL)exclusiveTouch
{
    UIKitUnimplementedMethod();
}

- (BOOL)isExclusiveTouch
{
    UIKitUnimplementedMethod();
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if([self pointInside:point withEvent:event] && !self.hidden && self.alpha > 0.1 && self.userInteractionEnabled) {
        __block UIView *result = self;
        [_subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *view, NSUInteger index, BOOL *stop) {
            UIView *insideView = [view hitTest:[view convertPoint:point fromView:self] withEvent:event];
            if(insideView) {
                result = insideView;
                *stop = YES;
                return;
            }
        }];
        
        return result;
    } else {
        return nil;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.layer containsPoint:point];
}

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view
{
    if(!view)
        view = self.window;
    
    return [self.layer convertPoint:point toLayer:view.layer];
}

- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view
{
    if(!view)
        view = self.window;
    
    return [view convertPoint:point toView:self];
}

- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view
{
    return [self.layer convertRect:rect toLayer:view.layer];
}

- (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view
{
    if(!view)
        view = self.window;
    
    return [view convertRect:rect toView:self];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.bounds.size;
}

- (void)sizeToFit
{
    CGRect frame = self.frame;
    frame.size = [self sizeThatFits:CGSizeZero];
    self.frame = frame;
}

#pragma mark - Rendering

- (void)drawRect:(CGRect)rect
{
    //Do nothing.
}

#pragma mark -

- (void)setNeedsDisplay
{
    [self.layer setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect
{
    [self.layer setNeedsDisplayInRect:rect];
}

- (void)setClipsToBounds:(BOOL)clipsToBounds
{
    self.layer.masksToBounds = clipsToBounds;
}

- (BOOL)clipsToBounds
{
    return self.layer.masksToBounds;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (UIColor *)backgroundColor
{
    return self.layer.backgroundColor? [UIColor colorWithCGColor:self.layer.backgroundColor] : nil;
}

- (void)setAlpha:(CGFloat)alpha
{
    self.layer.opacity = alpha;
}

- (CGFloat)alpha
{
    return self.layer.opacity;
}

- (void)setHidden:(BOOL)hidden
{
    self.layer.hidden = hidden;
}

- (BOOL)isHidden
{
    return self.layer.hidden;
}

- (void)setOpaque:(BOOL)opaque
{
    self.layer.opaque = opaque;
}

- (BOOL)isOpaque
{
    return self.layer.opaque;
}

#pragma mark -

- (void)setContentMode:(UIViewContentMode)contentMode
{
    _contentMode = contentMode;
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill: {
            self.layer.contentsGravity = kCAGravityResize;
            break;
        }
            
        case UIViewContentModeScaleAspectFit: {
            self.layer.contentsGravity = kCAGravityResizeAspect;
            break;
        }
            
        case UIViewContentModeScaleAspectFill: {
            self.layer.contentsGravity = kCAGravityResizeAspectFill;
            break;
        }
            
        case UIViewContentModeRedraw: {
            self.layer.contentsGravity = kCAGravityCenter;
            break;
        }
            
        case UIViewContentModeCenter: {
            self.layer.contentsGravity = kCAGravityCenter;
            break;
        }
            
        case UIViewContentModeTop: {
            self.layer.contentsGravity = kCAGravityTop;
            break;
        }
            
        case UIViewContentModeBottom: {
            self.layer.contentsGravity = kCAGravityBottom;
            break;
        }
            
        case UIViewContentModeLeft: {
            self.layer.contentsGravity = kCAGravityLeft;
            break;
        }
            
        case UIViewContentModeRight: {
            self.layer.contentsGravity = kCAGravityRight;
            break;
        }
            
        case UIViewContentModeTopLeft: {
            self.layer.contentsGravity = kCAGravityTopLeft;
            break;
        }
            
        case UIViewContentModeTopRight: {
            self.layer.contentsGravity = kCAGravityTopRight;
            break;
        }
            
        case UIViewContentModeBottomLeft: {
            self.layer.contentsGravity = kCAGravityBottomLeft;
            break;
        }
            
        case UIViewContentModeBottomRight: {
            self.layer.contentsGravity = kCAGravityBottomRight;
            break;
        }
    }
    
    self.layer.needsDisplayOnBoundsChange = (_contentMode == UIViewContentModeRedraw);
}

#pragma mark - Layout

- (void)setAutoresizesSubviews:(BOOL)autoresizesSubviews
{
    _autoresizesSubviews = autoresizesSubviews;
    
    if(_autoresizesSubviews)
        self.layer.autoresizingMask = _autoresizingMask;
    else
        self.layer.autoresizingMask = 0;
}

- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask
{
    _autoresizingMask = autoresizingMask;
    
    if(_autoresizesSubviews)
        self.layer.autoresizingMask = _autoresizingMask;
    else
        self.layer.autoresizingMask = 0;
}

#pragma mark -

- (void)setNeedsLayout
{
    [self.layer setNeedsLayout];
}

- (void)layoutIfNeeded
{
    [self.layer layoutIfNeeded];
}

- (void)layoutSubviews
{
    //Do nothing.
}

#pragma mark - Gesture Recognizers

- (void)addGestureRecognizer:(UIGestureRecognizer *)gesture
{
    if(!_gestureRecognizers) {
        _gestureRecognizers = [NSMutableArray array];
    }
    
    UIGestureRecognizer *gestureCopy = [gesture copy];
    gestureCopy._view = self;
    [_gestureRecognizers addObject:gestureCopy];
}

- (void)removeGestureRecognizer:(UIGestureRecognizer *)gesture
{
    NSUInteger indexOfGesture = [_gestureRecognizers indexOfObject:gesture];
    if(indexOfGesture != NSNotFound) {
        UIGestureRecognizer *gesture = _gestureRecognizers[indexOfGesture];
        gesture._view = nil;
        [_gestureRecognizers removeObjectAtIndex:indexOfGesture];
    }
}

- (NSArray *)gestureRecognizers
{
    return [_gestureRecognizers copy] ?: @[];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)sender
{
    return YES;
}

#pragma mark - Tint Color

- (void)setTintAdjustmentMode:(UIViewTintAdjustmentMode)tintAdjustmentMode
{
    _tintAdjustmentMode = tintAdjustmentMode;
    
    [self tintColorDidChange];
}

- (UIViewTintAdjustmentMode)tintAdjustmentMode
{
    if(_tintAdjustmentMode) {
        return _tintAdjustmentMode;
    } else {
        return _superview.tintAdjustmentMode ?: UIViewTintAdjustmentModeNormal;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    [self tintColorDidChange];
}

- (UIColor *)tintColor
{
    UIColor *tintColor;
    if(_tintColor) {
        tintColor = _tintColor;
    } else if(_superview) {
        tintColor = _superview.tintColor;
    } else {
        tintColor = [UIColor alternateSelectedControlColor];
    }
    
    if(self.tintAdjustmentMode == UIViewTintAdjustmentModeDimmed) {
        //This is special cased to ensure system-matching
        if([tintColor isEqual:[UIColor alternateSelectedControlColor]]) {
            return [UIColor secondarySelectedControlColor];
        }
        
        return [tintColor colorUsingColorSpace:[NSColorSpace genericGrayColorSpace]];
    } else {
        return tintColor;
    }
}

- (void)tintColorDidChange
{
    for (UIView *subview in _subviews)
        [subview tintColorDidChange];
}

#pragma mark - Responder Chain

- (UIResponder *)nextResponder
{
    return (UIResponder *)self._viewController ?: (UIResponder *)self.superview;
}

- (void)_setFirstResponder:(UIResponder *)_firstResponder
{
    if(_superview) {
        _superview._firstResponder = _firstResponder;
    } else {
        __firstResponder = _firstResponder;
    }
}

- (UIResponder *)_firstResponder
{
    return _superview? _superview._firstResponder : __firstResponder;
}

#pragma mark - Subviews

- (NSArray *)subviews
{
    return _subviews;
}

#pragma mark -

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    NSParameterAssert(view);
    
    if(_window)
        [view _viewWillMoveToWindow:_window];
    [view willMoveToSuperview:self];
    
    if([_subviews containsObject:view])
        return; //This is allowed in real UIKit
    
    [_subviews insertObject:view atIndex:index];
    [self.layer insertSublayer:view.layer atIndex:(unsigned int)index];
    view.superview = self;
    view.window = self.window;
    
    if(_window) {
        [view _viewDidMoveToWindow:_window];
        [_window _viewWasAddedToWindow:self];
        
        UIResponder *currentFirstResponder = self._firstResponder;
        self._firstResponderManager = _window;
        
        if(currentFirstResponder) {
            _window._firstResponder = currentFirstResponder;
        }
    }
    
    [view didMoveToSuperview];
    
    [self didAddSubview:view];
}

- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2
{
    UIView *view = self.subviews[index1];
    [view removeFromSuperview];
    
    [self insertSubview:view atIndex:index2];
}

- (void)addSubview:(UIView *)view
{
    NSParameterAssert(view);
    
    [self insertSubview:view atIndex:_subviews.count];
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    NSParameterAssert(view);
    NSParameterAssert(siblingSubview);
    
    NSUInteger indexOfSibling = [_subviews indexOfObject:siblingSubview];
    if(indexOfSibling == NSNotFound) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot insert below view %@ that is not a subview of %@", siblingSubview, self];
    }
    
    [self insertSubview:view atIndex:indexOfSibling - 1];
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    NSParameterAssert(view);
    NSParameterAssert(siblingSubview);
    
    NSUInteger indexOfSibling = [_subviews indexOfObject:siblingSubview];
    if(indexOfSibling == NSNotFound) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot insert above view %@ that is not a subview of %@", siblingSubview, self];
    }
    
    [self insertSubview:view atIndex:indexOfSibling + 1];
}

#pragma mark -

- (void)bringSubviewToFront:(UIView *)view
{
    if(!view)
        return;
    
    NSAssert(view.superview == self, @"Cannot bring view to front that is not child of receiver.");
    
    [_subviews removeObject:view];
    [_subviews addObject:view];
    
    [view.layer removeFromSuperlayer];
    [self.layer addSublayer:view.layer];
}

- (void)sendSubviewToBack:(UIView *)view
{
    if(!view)
        return;
    
    NSAssert(view.superview == self, @"Cannot send view to bacl that is not child of receiver.");
    
    [_subviews removeObject:view];
    [_subviews insertObject:view atIndex:0];
    
    [view.layer removeFromSuperlayer];
    [self.layer insertSublayer:view.layer atIndex:0];
}

#pragma mark -

- (void)removeFromSuperview
{
    if(!_superview)
        return;
    
    [self willMoveToWindow:nil];
    [self willMoveToSuperview:nil];
    [self.superview willRemoveSubview:self];
    
    [self.layer removeFromSuperlayer];
    [self.superview->_subviews removeObject:self];
    self.superview = nil;
    
    self._firstResponderManager = _superview ?: self;
    
    [_window _viewWasRemovedFromWindow:self];
    _window = nil;
    
    [self didMoveToWindow];
    [self didMoveToSuperview];
}

#pragma mark -

- (void)didAddSubview:(UIView *)subview
{
}

- (void)willRemoveSubview:(UIView *)subview
{
}

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview
{
}

- (void)didMoveToSuperview
{
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
}

- (void)didMoveToWindow
{
}

- (BOOL)isDescendantOfView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if(subview == self)
            return YES;
    }
    
    return [self isDescendantOfView:view.superview];
}

- (UIView *)viewWithTag:(NSInteger)tag
{
    __block UIView *result = nil;
    [_subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *subview, NSUInteger index, BOOL *stop) {
        if(subview.tag == tag) {
            result = subview;
            *stop = YES;
        }
    }];
    
    if(!result && self.tag == tag)
        result = self;
    
    return result;
}

#pragma mark -

static void EnumerateSubviews(UIView *view, void(^block)(UIView *subview, NSUInteger depth, BOOL *stop), NSUInteger depth, BOOL *stop)
{
    for (UIView *subview in view.subviews) {
        block(subview, depth, stop);
        if(*stop)
            break;
        
        EnumerateSubviews(subview, block, depth + 1, stop);
    }
}

- (void)_enumerateSubviews:(void(^)(UIView *subview, NSUInteger depth, BOOL *stop))block
{
    BOOL stop = NO;
    EnumerateSubviews(self, block, 0, &stop);
}

- (void)_printSubviews
{
    [self _enumerateSubviews:^(UIView *subview, NSUInteger depth, BOOL *stop) {
        NSMutableString *indentation = [NSMutableString stringWithString:@"+"];
        for (NSUInteger i = 0; i < depth; i++)
            [indentation appendString:@"-"];
        NSLog(@"%@%@", indentation, subview);
    }];
}

#pragma mark - Window

- (void)_viewWillMoveToWindow:(UIWindow *)newWindow
{
    [self willMoveToWindow:newWindow];
    
    _window = newWindow;
    
    UIResponder *currentFirstResponder = self._firstResponder;
    if(currentFirstResponder && !newWindow._firstResponder)
        newWindow._firstResponder = self._firstResponder;
    
    for (UIView *subview in _subviews)
        [subview _viewWillMoveToWindow:newWindow];
}

- (void)_viewDidMoveToWindow:(UIWindow *)window
{
    for (UIView *subview in _subviews)
        [subview _viewDidMoveToWindow:window];
    
    [self didMoveToWindow];
}

- (void)setWindow:(UIWindow *)window
{
    _window = window;
    self.contentScaleFactor = window.screen.scale;
}

#pragma mark -

- (void)_windowDidBecomeKey
{
    self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    
    for (UIView *subview in _subviews)
        [subview _windowDidBecomeKey];
}

- (void)_windowDidResignKey
{
    self.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    
    for (UIView *subview in _subviews)
        [subview _windowDidResignKey];
}

#pragma mark - Using Motion Effects

- (void)addMotionEffect:(UIMotionEffect *)effect
{
    NSParameterAssert(effect);
    
    //Do nothing.
}

- (void)removeMotionEffect:(UIMotionEffect *)effect
{
    //Do nothing.
}

#pragma mark - Capturing a View Snapshot

- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterScreenUpdates
{
    UIKitUnimplementedMethod();
    return nil;
}

- (UIView *)resizableSnapshotViewFromRect:(CGRect)rect afterScreenUpdates:(BOOL)afterScreenUpdates withCapInsets:(UIEdgeInsets)insets
{
    UIKitUnimplementedMethod();
    return nil;
}

- (void)drawViewHierarchyInRect:(CGRect)rect afterScreenUpdates:(BOOL)afterScreenUpdates
{
    UIKitUnimplementedMethod();
}

#pragma mark - <CALayerDelegate>

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    CGRect drawingRect = CGContextGetClipBoundingBox(ctx);
    
    if(_clearsContextBeforeDrawing) {
        CGContextClearRect(ctx, drawingRect);
    }
    
    CGContextSetShouldSmoothFonts(ctx, false);
    CGContextSetShouldSubpixelPositionFonts(ctx, true);
    CGContextSetShouldSubpixelQuantizeFonts(ctx, true);
    
    [[UIColor blackColor] set];
    [self drawRect:drawingRect];
    
    UIGraphicsPopContext();
}

//Continued in UIView_UIViewAnimation.m

@end

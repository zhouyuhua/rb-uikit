//
//  UINSWindow.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/22/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINSWindow.h"

CGFloat const UINSWindowContentCornerRadius = 5.0;

@interface _UINSWindowContentView : NSView

@property (nonatomic) NSView *view;

@end

@implementation _UINSWindowContentView

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor windowBackgroundColor] set];
    [[NSBezierPath bezierPathWithRoundedRect:self.bounds
                                     xRadius:UINSWindowContentCornerRadius
                                     yRadius:UINSWindowContentCornerRadius] fill];
}

#pragma mark - Properties

- (void)setView:(NSView *)view
{
    [self.view removeFromSuperview];
    
    view.frame = self.bounds;
    view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:view];
}

- (NSView *)view
{
    return self.subviews.firstObject;
}

@end

#pragma mark -

@implementation UINSWindow {
    NSRect _prezoomRect;
    
    BOOL _shouldIgnoreMouseMovedEvents;
    NSPoint _initialDragLocation;
    NSPoint _initialDragLocationOnScreen;
    NSRect _initialWindowFrameForDrag;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if(UIKIT_FLAG_IS_SET(aStyle, NSTitledWindowMask))
        aStyle ^= NSTitledWindowMask;
    
    if(!UIKIT_FLAG_IS_SET(aStyle, NSBorderlessWindowMask))
        aStyle ^= NSBorderlessWindowMask;
    
    if((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
        [self setMovableByWindowBackground:YES];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [super setContentView:[_UINSWindowContentView new]];
    }
    
    return self;
}

#pragma mark - Validations

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)item
{
	if([item action] == @selector(performClose:)) {
		if([[self delegate] respondsToSelector:@selector(windowShouldClose:)] &&
		   ![[self delegate] windowShouldClose:self]) {
			return NO;
		}
		
        return UIKIT_FLAG_IS_SET([self styleMask], NSClosableWindowMask);
	} else if([item action] == @selector(performMiniaturize:)) {
        return UIKIT_FLAG_IS_SET([self styleMask], NSMiniaturizableWindowMask);
	} else if([item action] == @selector(performZoom:)) {
        return UIKIT_FLAG_IS_SET([self styleMask], NSResizableWindowMask);
	}
	
	return [super validateUserInterfaceItem:item];
}

#pragma mark - Properties

- (void)setContentView:(NSView *)view
{
    view.layer.cornerRadius = UINSWindowContentCornerRadius;
    
    ((_UINSWindowContentView *)super.contentView).view = view;
}

- (id)contentView
{
    return ((_UINSWindowContentView *)super.contentView).view;
}

#pragma mark -

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}

#pragma mark - Windows Menu Support

- (void)orderWindow:(NSWindowOrderingMode)orderingMode relativeTo:(NSInteger)otherWindowNumber
{
	[super orderWindow:orderingMode relativeTo:otherWindowNumber];
	
	if(![self isExcludedFromWindowsMenu])
		[NSApp addWindowsItem:self title:[self title] filename:NO];
}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	
	if(![self isExcludedFromWindowsMenu] && [self isVisible])
		[NSApp changeWindowsItem:self title:title filename:NO];
}

- (void)close
{
	[super close];
	
	if(![self isExcludedFromWindowsMenu])
		[NSApp removeWindowsItem:self];
}

#pragma mark - Closing

- (BOOL)isClosable
{
	return UIKIT_FLAG_IS_SET([self styleMask], NSClosableWindowMask);
}

- (IBAction)performClose:(id)sender
{
	if(![self isClosable])
		return NSBeep();
	
	if([[self delegate] respondsToSelector:@selector(windowShouldClose:)] &&
	   ![[self delegate] windowShouldClose:self])
	{
		return;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NSWindowWillCloseNotification object:self];
	
	if(self.isZoomed)
		[self performZoom:sender];
	
	[self close];
}

#pragma mark - Minimizing

+ (NSSet *)keyPathsForValuesAffectingIsMiniaturizable
{
	return [NSSet setWithObjects:@"isZoomed", nil];
}

- (BOOL)isMiniaturizable
{
	return !self.isZoomed && UIKIT_FLAG_IS_SET([self styleMask], NSMiniaturizableWindowMask);
}

- (IBAction)performMiniaturize:(id)sender
{
	if(![self isMiniaturizable])
		return NSBeep();
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NSWindowWillMiniaturizeNotification object:self];
	
	if(self.isZoomed)
		[self performZoom:sender];
	
	[self miniaturize:sender];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NSWindowDidMiniaturizeNotification object:self];
}

#pragma mark - Zooming

- (BOOL)isZoomable
{
    return UIKIT_FLAG_IS_SET([self styleMask], NSResizableWindowMask);
}

- (void)performZoom:(id)sender
{
    if(NSEqualRects(_prezoomRect, NSZeroRect)) {
        _prezoomRect = [self frame];
        
        [self setFrame:[[self screen] visibleFrame] display:YES animate:YES];
    } else {
        [self setFrame:_prezoomRect display:YES animate:YES];
        
        _prezoomRect = NSZeroRect;
    }
}

#pragma mark - Events

- (void)mouseUp:(NSEvent *)event
{
	//Save the window's frame.
	if([self frameAutosaveName])
		[self saveFrameUsingName:[self frameAutosaveName]];
	
	_shouldIgnoreMouseMovedEvents = NO;
}

- (void)mouseDragged:(NSEvent *)event
{
	if(![NSApp isActive] || _shouldIgnoreMouseMovedEvents)
		return;
	
	NSRect windowFrame = [self frame];
	NSPoint currentLocationOnScreen = [self convertRectToScreen:(NSRect){[self mouseLocationOutsideOfEventStream], [self frame].size}].origin;
	
    NSPoint newOrigin = NSMakePoint(currentLocationOnScreen.x - _initialDragLocation.x,
                                    currentLocationOnScreen.y - _initialDragLocation.y);
    
    NSRect visibleScreenFrame = [[NSScreen mainScreen] visibleFrame];
    if(newOrigin.y + NSHeight(windowFrame) > NSMaxY(visibleScreenFrame))
        newOrigin.y = NSMaxY(visibleScreenFrame) - NSHeight(windowFrame);
    
    [self setFrameOrigin:newOrigin];
}

- (void)mouseDown:(NSEvent *)event
{
    _shouldIgnoreMouseMovedEvents = ![self isMovableByWindowBackground];
	
	_initialDragLocation = [event locationInWindow];
	_initialDragLocationOnScreen = [self convertRectToScreen:(NSRect){[event locationInWindow], [self frame].size}].origin;
	
	_initialWindowFrameForDrag = [self frame];
}

@end

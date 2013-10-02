//
//  UIMacWindowButtonsView.m
//

#import "UIMacWindowButtonsView.h"
#import "UIBarButtonItem.h"

enum {
	kWindowButtonWidth = 14,
	kWindowButtonHeight = 16,
	kWindowButtonInterButtonPadding = 7,
};

@interface _UIMacWindowButtonsNSView : NSView {
	NSTrackingRectTag _trackingArea;
	BOOL _isRolloverActive;
    
	NSButton *_closeButton;
	NSButton *_minimizeButton;
	NSButton *_zoomButton;
}

///Returns the preferred size of the button view.
+ (NSSize)preferredSize;

///Returns the preferred frame of an instance of BKWindowTitleBarButtonsView.
+ (NSRect)preferredFrameInContentView:(NSView *)contentView;

@end

@implementation _UIMacWindowButtonsNSView

#pragma mark Sizing

+ (NSSize)preferredSize
{
	return NSMakeSize((kWindowButtonWidth * 3) + (kWindowButtonInterButtonPadding * 2), kWindowButtonHeight);
}

+ (NSRect)preferredFrameInContentView:(NSView *)contentView
{
	NSParameterAssert(contentView);
	
	NSRect contentViewFrame = [contentView frame];
	
	NSRect preferredFrame;
	preferredFrame.size = [self preferredSize];
	preferredFrame.origin.x = 8.0;
	preferredFrame.origin.y = NSHeight(contentViewFrame) - NSHeight(preferredFrame) - 4.0;
	
	return preferredFrame;
}

#pragma mark - Destruction

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_closeButton unbind:@"image"];
	[_closeButton unbind:@"alternateImage"];
	[_closeButton unbind:@"enabled"];
	_closeButton = nil;
	
	[_minimizeButton unbind:@"image"];
	[_minimizeButton unbind:@"alternateImage"];
	[_minimizeButton unbind:@"enabled"];
	_minimizeButton = nil;
	
	[_zoomButton unbind:@"image"];
	[_zoomButton unbind:@"alternateImage"];
	[_minimizeButton unbind:@"enabled"];
	_zoomButton = nil;
}

#pragma mark - Initialization

- (id)initWithFrame:(NSRect)frameRect
{
	if((self = [super initWithFrame:frameRect])) {
		NSRect buttonFrame = NSMakeRect(0.0, 0.0, kWindowButtonWidth, kWindowButtonHeight);
		
        const NSUInteger windowStyleMask = (NSTitledWindowMask | 
                                            NSClosableWindowMask | 
                                            NSResizableWindowMask | 
                                            NSMiniaturizableWindowMask);
        
        _closeButton = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:windowStyleMask];
		[_closeButton setFrame:buttonFrame];
        [_closeButton setAction:@selector(performClose:)];
		[self addSubview:_closeButton];
		
		
		buttonFrame.origin.x += NSMaxX(buttonFrame) + kWindowButtonInterButtonPadding;
        _minimizeButton = [NSWindow standardWindowButton:NSWindowMiniaturizeButton forStyleMask:windowStyleMask];
        [_minimizeButton setFrame:buttonFrame];
		[_minimizeButton setAction:@selector(performMiniaturize:)];
		[self addSubview:_minimizeButton];
		
		
		buttonFrame.origin.x += NSMinX(buttonFrame);
        _zoomButton = [NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:windowStyleMask];
        [_zoomButton setFrame:buttonFrame];
		[_zoomButton setAction:@selector(performZoom:)];
		[self addSubview:_zoomButton];
        
        [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                           options:(NSTrackingInVisibleRect |
                                                                    NSTrackingMouseEnteredAndExited|
                                                                    NSTrackingActiveAlways)
                                                             owner:self
                                                          userInfo:nil]];
	}
	
	return self;
}

#pragma mark - Notifications

- (void)windowDidResize:(NSNotification *)notification
{
	if(_trackingArea) {
		[self removeTrackingRect:_trackingArea];
		_trackingArea = 0;
	}
	
	_trackingArea = [self addTrackingRect:[self bounds] owner:self userData:NULL assumeInside:NO];
	
	_isRolloverActive = NO;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    if(_trackingArea) {
		[self removeTrackingRect:_trackingArea];
		_trackingArea = 0;
	}
	
	if([self window]) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:[self window]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeKeyNotification object:[self window]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignKeyNotification object:[self window]];
        
        [_closeButton unbind:@"enabled"];
        [_minimizeButton unbind:@"enabled"];
        [_zoomButton unbind:@"enabled"];
	}
}

- (void)viewDidMoveToWindow
{
	NSWindow *window = [self window];
	if(window) {
		[_closeButton setTarget:window];
		[_closeButton bind:@"enabled" toObject:window withKeyPath:@"isClosable" options:nil];
		
		[_minimizeButton setTarget:window];
		[_minimizeButton bind:@"enabled" toObject:window withKeyPath:@"isMiniaturizable" options:nil];
		
		[_zoomButton setTarget:window];
		[_zoomButton bind:@"enabled" toObject:window withKeyPath:@"isZoomable" options:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(windowDidResize:) 
													 name:NSWindowDidResizeNotification 
												   object:window];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowKeyStatusDidChange:)
                                                     name:NSWindowDidBecomeKeyNotification
                                                   object:[self window]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowKeyStatusDidChange:)
                                                     name:NSWindowDidResignKeyNotification
                                                   object:[self window]];
	} else {
		[_closeButton setTarget:nil];
		[_closeButton unbind:@"enabled"];
		
		[_minimizeButton setTarget:nil];
		[_minimizeButton unbind:@"enabled"];
		
		[_zoomButton setTarget:nil];
		[_zoomButton unbind:@"enabled"];
	}
}

#pragma mark - Behaviors

- (void)windowKeyStatusDidChange:(NSNotification *)notification
{
    [_closeButton setNeedsDisplay];
    [_minimizeButton setNeedsDisplay];
    [_zoomButton setNeedsDisplay];
}

- (BOOL)mouseDownCanMoveWindow
{
	return NO;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
	return YES;
}

#pragma mark - Events

- (void)mouseExited:(NSEvent *)event
{
	_isRolloverActive = NO;
    
    [_closeButton setNeedsDisplay];
    [_minimizeButton setNeedsDisplay];
    [_zoomButton setNeedsDisplay];
}

- (void)mouseEntered:(NSEvent *)event
{
    _isRolloverActive = YES;
    
	[_closeButton setNeedsDisplay];
    [_minimizeButton setNeedsDisplay];
    [_zoomButton setNeedsDisplay];
}

///Must override this private method to provide a rollover state.
///Found on <http://www.cocoabuilder.com/archive/cocoa/280077-best-practices-for-using-standard-window-widgets-in-custom-window.html>
- (BOOL)_mouseInGroup:(NSButton *)widget
{
    return _isRolloverActive;
}

@end

#pragma mark -

@implementation UIMacWindowButtonsView

+ (UIBarButtonItem *)windowButtonsBarItem
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self new]];
}

- (id)init
{
    NSRect frame = {NSZeroPoint, [_UIMacWindowButtonsNSView preferredSize]};
    _UIMacWindowButtonsNSView *nativeView = [[_UIMacWindowButtonsNSView alloc] initWithFrame:frame];
    return [self initWithNativeView:nativeView];
}

@end

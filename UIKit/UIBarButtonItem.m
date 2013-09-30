//
//  UIBarButtonItem.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 7/18/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIBarButtonItem_Private.h"
#import "UIImage.h"
#import <objc/message.h>

#import "UIButton_Private.h"

#import "UIImage_Private.h"
#import "_UIBarButtonFlexibleSpaceItem.h"

static NSString *TitleForSystemItemStyle(UIBarButtonSystemItem style)
{
    switch (style) {
        case UIBarButtonSystemItemDone: {
            return UILocalizedString(@"Done", @"");
        }
        case UIBarButtonSystemItemCancel: {
            return UILocalizedString(@"Cancel", @"");
        }
        case UIBarButtonSystemItemEdit: {
            return UILocalizedString(@"Edit", @"");
        }
        case UIBarButtonSystemItemSave: {
            return UILocalizedString(@"Save", @"");
        }
        case UIBarButtonSystemItemAdd: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemFlexibleSpace:
        case UIBarButtonSystemItemFixedSpace: {
            return nil; // N/A
        }
        case UIBarButtonSystemItemCompose: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemReply: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemAction: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemOrganize: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemBookmarks: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemSearch: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemRefresh: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemStop: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemCamera: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemTrash: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemPlay: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemPause: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemRewind: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemFastForward: {
            return nil; //Has Image
        }
        case UIBarButtonSystemItemUndo: {
            return UILocalizedString(@"Undo", @"");
        }
        case UIBarButtonSystemItemRedo: {
            return UILocalizedString(@"Redo", @"");
        }
        case UIBarButtonSystemItemPageCurl: {
            return nil; //Has Image
        }
    }
}

static UIImage *ImageForSystemItemStyle(UIBarButtonSystemItem style)
{
    switch (style) {
        case UIBarButtonSystemItemDone: {
            return nil; //Has Text
        }
        case UIBarButtonSystemItemCancel: {
            return nil; //Has Text
        }
        case UIBarButtonSystemItemEdit: {
            return nil; //Has Text
        }
        case UIBarButtonSystemItemSave: {
            return nil; //Has Text
        }
        case UIBarButtonSystemItemAdd: {
            return UIKitImageNamed(@"UIBarButtonSystemItemAdd", UIImageResizingModeStretch);
        }
        case UIBarButtonSystemItemFlexibleSpace:
        case UIBarButtonSystemItemFixedSpace: {
            return nil; // N/A
        }
        case UIBarButtonSystemItemCompose: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemCompose");
            return nil;
        }
        case UIBarButtonSystemItemReply: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemReply");
            return nil;
        }
        case UIBarButtonSystemItemAction: {
            return [[UIImage alloc] initWithNSImage:[NSImage imageNamed:NSImageNameShareTemplate]];
        }
        case UIBarButtonSystemItemOrganize: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemOrganize");
            return nil;
        }
        case UIBarButtonSystemItemBookmarks: {
            return [[UIImage alloc] initWithNSImage:[NSImage imageNamed:NSImageNameBookmarksTemplate]];
        }
        case UIBarButtonSystemItemSearch: {
            return UIKitImageNamed(@"UISearchBarMagnifyingGlass", UIImageResizingModeStretch);
        }
        case UIBarButtonSystemItemRefresh: {
            return [[UIImage alloc] initWithNSImage:[NSImage imageNamed:NSImageNameRefreshTemplate]];
        }
        case UIBarButtonSystemItemStop: {
            return [[UIImage alloc] initWithNSImage:[NSImage imageNamed:NSImageNameStopProgressTemplate]];
        }
        case UIBarButtonSystemItemCamera: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemCamera");
            return nil;
        }
        case UIBarButtonSystemItemTrash: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemTrash");
            return nil;
        }
        case UIBarButtonSystemItemPlay: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemPlay");
            return nil;
        }
        case UIBarButtonSystemItemPause: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemPause");
            return nil;
        }
        case UIBarButtonSystemItemRewind: {
            return [[UIImage alloc] initWithNSImage:[NSImage imageNamed:NSImageNameGoLeftTemplate]];
        }
        case UIBarButtonSystemItemFastForward: {
            return [[UIImage alloc] initWithNSImage:[NSImage imageNamed:NSImageNameGoRightTemplate]];
        }
        case UIBarButtonSystemItemUndo: {
            return nil; //Has Text
        }
        case UIBarButtonSystemItemRedo: {
            return nil; //Has Text
        }
        case UIBarButtonSystemItemPageCurl: {
            UIKitWarnUnimplementedMethod(__PRETTY_FUNCTION__, @"UIBarButtonSystemItemPageCurl");
            return nil;
        }
    }
}

#pragma mark -

@implementation UIBarButtonItem {
    UIButton *_underlyingButton;
}

/* !Important! Always set the `style` before anything else */

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = style;
        self.image = image;
        self.target = target;
        self.action = action;
        
        self._systemItem = NSIntegerMax;
        
        [self._itemView sizeToFit];
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = style;
        self.image = image;
        self.target = target;
        self.action = action;
        
        self._systemItem = NSIntegerMax;
        
        [self._itemView sizeToFit];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if((self = [super init])) {
        self.style = style;
        self.title = title;
        self.target = target;
        self.action = action;
        
        self._systemItem = NSIntegerMax;
        
        [self._itemView sizeToFit];
    }
    
    return self;
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action
{
    if(systemItem == UIBarButtonSystemItemFlexibleSpace) {
        return [_UIBarButtonFlexibleSpaceItem sharedFlexibleSpaceItem];
    }
    
    if((self = [super init])) {
        self.style = UIBarButtonItemStyleBordered;
        self.title = TitleForSystemItemStyle(systemItem);
        self.image = ImageForSystemItemStyle(systemItem);
        self.target = target;
        self.action = action;
        
        self._systemItem = systemItem;
        
        if(systemItem == UIBarButtonSystemItemFixedSpace)
            self.customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
        
        [self._itemView sizeToFit];
    }
    
    return self;
}

- (id)initWithCustomView:(UIView *)customView
{
    if((self = [super init])) {
        self.customView = customView;
    }
    
    return self;
}

#pragma mark - Identity

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p style => %ld, title => %@, image => %@>", NSStringFromClass(self.class), self, self.style, self.title, self.image];
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *other = object;
        return (other.style == self.style &&
                [other.title isEqualToString:self.title] &&
                [other.image isEqual:self.image] &&
                other.action == self.action &&
                other.target == self.target);
    }
    
    return NO;
}

#pragma mark - Buttons

- (UIButton *)underlyingButton
{
    if(!_underlyingButton) {
        UIButtonType buttonType;
        if((NSInteger)self.style == UIBarButtonItemStyle_Private_Back)
            buttonType = UIButtonType_Private_BackBarButton;
        else
            buttonType = UIButtonType_Private_BarButton;
        _underlyingButton = [UIButton buttonWithType:buttonType];
        
        [_underlyingButton setTitle:self.title forState:UIControlStateNormal];
        
        if((NSInteger)self.style != UIBarButtonItemStyle_Private_Back)
            [_underlyingButton setImage:self.image forState:UIControlStateNormal];
        
        [_underlyingButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _underlyingButton;
}

- (void)sendAction
{
    if(self.target && self.action)
        ((void(*)(id, SEL, id))objc_msgSend)(self.target, self.action, self);
}

#pragma mark -

- (UIView *)_itemView
{
    return self.customView ?: self.underlyingButton;
}

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.underlyingButton setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self.underlyingButton setImage:image forState:UIControlStateNormal];
}

@end

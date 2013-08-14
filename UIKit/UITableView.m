//
//  UITableView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UITableView_Private.h"

@implementation UITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if((self = [super initWithFrame:frame])) {
        self.style = style;
        
        switch (style) {
            case UITableViewStylePlain:
                self.backgroundColor = [UIColor whiteColor];
                break;
                
            case UITableViewStyleGrouped:
                self.backgroundColor = [UIColor grayColor];
                break;
        }
        
        
        _registeredCellClasses = [NSMutableDictionary dictionary];
        _registeredHeaderFooterClasses = [NSMutableDictionary dictionary];
        
        _reusableCells = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

#pragma mark - Registering Classes

- (void)registerClass:(Class)class forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    NSParameterAssert(class);
    NSParameterAssert(reuseIdentifier);
    
    _registeredCellClasses[reuseIdentifier] = class;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    UIKitUnimplementedMethod();
}

#pragma mark -

- (void)registerClass:(Class)class forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier
{
    NSParameterAssert(class);
    NSParameterAssert(reuseIdentifier);
    
    _registeredHeaderFooterClasses[reuseIdentifier] = class;
}

- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier
{
    UIKitUnimplementedMethod();
}

#pragma mark - Dequeuing Views

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
    UIKitUnimplementedMethod();
    return nil;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);
    
    UITableViewCell *cell = _reusableCells[identifier];
    if(cell) {
        [_reusableCells removeObjectForKey:identifier];
    }
    
    Class cellClass = _registeredCellClasses[identifier];
    if(cellClass) {
        cell = [[cellClass alloc] initWithFrame:CGRectZero reuseIdentifier:identifier];
    }
    
    return cell;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    if(!_registeredCellClasses[identifier])
        [NSException raise:NSInternalInconsistencyException format:@"%s called with reuse identifier %@ that has no registered class", __PRETTY_FUNCTION__, identifier];
    
    return [self dequeueReusableCellWithIdentifier:identifier];
}

#pragma mark - Reloading Data

- (void)reloadData
{
    UIKitUnimplementedMethod();
}

#pragma mark - Layout Information

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    UIKitUnimplementedMethod();
    return 0;
}

- (NSInteger)numberOfSections
{
    UIKitUnimplementedMethod();
    return 0;
}

#pragma mark -

- (CGRect)rectForSection:(NSInteger)section
{
    UIKitUnimplementedMethod();
    return CGRectZero;
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIKitUnimplementedMethod();
    return CGRectZero;
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    UIKitUnimplementedMethod();
    return CGRectZero;
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    UIKitUnimplementedMethod();
    return CGRectZero;
}

@end

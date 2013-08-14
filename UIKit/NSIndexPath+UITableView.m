//
//  NSIndexPath+UITableView.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/13/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "NSIndexPath+UITableView.h"

@implementation NSIndexPath (UITableView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSUInteger const indexes[] = { section, row };
    return [NSIndexPath indexPathWithIndexes:indexes length:2];
}

- (NSInteger)section
{
    return [self indexAtPosition:0];
}

- (NSInteger)row
{
    return [self indexAtPosition:1];
}

@end

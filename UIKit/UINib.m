//
//  UINib.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UINib.h"

NSString *const UINibProxiedObjectsKey = @"UINibProxiedObjectsKey";
NSString *const UINibExternalObjects = @"UINibExternalObjects";

@implementation UINib

#pragma mark - Creating a Nib Object

+ (instancetype)nibWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    UIKitUnimplementedMethod();
    return nil;
}

+ (instancetype)nibWithData:(NSData *)data bundle:(NSBundle *)bundle
{
    UIKitUnimplementedMethod();
    return nil;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Instantiating a Nib

- (NSArray *)instantiateWithOwner:(id)ownerOrNil options:(NSDictionary *)optionsOrNil
{
    UIKitUnimplementedMethod();
    return nil;
}

@end

#pragma mark -

@implementation NSBundle(UIKit)

- (NSArray *)loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options
{
    UIKitUnimplementedMethod();
    return nil;
}

@end

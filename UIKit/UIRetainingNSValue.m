//
//  UIRetainingNSValue.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIRetainingNSValue.h"

@implementation UIRetainingNSValue {
    NSValue *_underlyingValue;
    BOOL _didRetain;
}

- (void)dealloc
{
    if(strcmp([self objCType], @encode(id)) == 0 && _didRetain) {
        NSUInteger bufferSize;
        NSGetSizeAndAlignment([self objCType], &bufferSize, NULL);
        
        Byte buffer[bufferSize];
        [self getValue:buffer];
        
        CFRelease(*(CFTypeRef *)buffer);
    }
}

+ (NSValue *)valueWithBytes:(const void *)value objCType:(const char *)type
{
    UIRetainingNSValue *newValue = [self new];
    newValue->_underlyingValue = [NSValue valueWithBytes:value objCType:type];
    
    if(strcmp(type, @encode(id)) == 0 && *(CFTypeRef *)value) {
        CFRetain(*(CFTypeRef *)value);
        newValue->_didRetain = YES;
    }
    
    return newValue;
}

#pragma mark - Overrides

- (const char *)objCType
{
    return [_underlyingValue objCType];
}

- (void)getValue:(void *)value
{
    [_underlyingValue getValue:value];
}

#pragma mark - Contents

- (BOOL)isNil
{
    if(strcmp([self objCType], @encode(id)) == 0) {
        NSUInteger bufferSize;
        NSGetSizeAndAlignment([self objCType], &bufferSize, NULL);
        
        Byte buffer[bufferSize];
        [self getValue:buffer];
        
        return ((*(CFTypeRef *)buffer) == NULL);
    }
    
    return NO;
}

@end

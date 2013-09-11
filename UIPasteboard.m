//
//  UIPasteboard.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIPasteboard_Private.h"

NSString *const UIPasteboardNameGeneral = @"Apple CFPasteboard general"; //NSGeneralPboard
NSString *const UIPasteboardNameFind = @"Apple CFPasteboard find"; //NSFindPboard

@implementation UIPasteboard

+ (NSMutableDictionary *)_sharedPasteboards
{
    static NSMutableDictionary *_sharedPasteboards;
    if(!_sharedPasteboards) {
        _sharedPasteboards = [NSMutableDictionary dictionary];
    }
    
    return _sharedPasteboards;
}

+ (instancetype)generalPasteboard
{
    return [self pasteboardWithName:UIPasteboardNameGeneral create:YES];
}

+ (instancetype)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create
{
    NSParameterAssert(pasteboardName);
    
    NSMutableDictionary *sharedPasteboards = self._sharedPasteboards;
    UIPasteboard *pasteboard = sharedPasteboards[pasteboardName];
    if(!pasteboard && create) {
        pasteboard = [[UIPasteboard alloc] initWithNativePasteboard:[NSPasteboard pasteboardWithName:pasteboardName]];
        sharedPasteboards[pasteboardName] = pasteboardName;
    }
    
    return pasteboard;
}

+ (instancetype)pasteboardWithUniqueName
{
    NSMutableDictionary *sharedPasteboards = self._sharedPasteboards;
    
    NSPasteboard *uniqueNativePasteboard = [NSPasteboard pasteboardWithUniqueName];
    UIPasteboard *pasteboard = [[UIPasteboard alloc] initWithNativePasteboard:uniqueNativePasteboard];
    sharedPasteboards[pasteboard.name] = pasteboard;
    
    return pasteboard;
}

+ (void)removePasteboardWithName:(NSString *)pasteboardName
{
    NSParameterAssert(pasteboardName);
    
    NSMutableDictionary *sharedPasteboards = self._sharedPasteboards;
    UIPasteboard *pasteboard = sharedPasteboards[pasteboardName];
    if(pasteboard) {
        [pasteboard._nativePasteboard releaseGlobally];
        [sharedPasteboards removeObjectForKey:pasteboardName];
    }
}

#pragma mark -

- (instancetype)initWithNativePasteboard:(NSPasteboard *)pasteboard
{
    NSParameterAssert(pasteboard);
    
    if((self = [super init])) {
        self._nativePasteboard = pasteboard;
    }
    
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Properties

- (NSString *)name
{
    return self._nativePasteboard.name;
}

- (BOOL)isPersistent
{
    return YES;
}

- (NSInteger)changeCount
{
    return self._nativePasteboard.changeCount;
}

#pragma mark - Determining Types of Single Pasteboard Items

- (NSArray *)pasteboardTypes
{
    return [self._nativePasteboard types];
}

- (BOOL)containsPasteboardTypes:(NSArray *)types
{
    return ([self._nativePasteboard availableTypeFromArray:types] != nil);
}

#pragma mark - Getting and Setting Single Pasteboard Items

- (NSData *)dataForPasteboardType:(NSString *)type
{
    return [self._nativePasteboard dataForType:type];
}

- (id)valueForPasteboardType:(NSString *)type
{
    return [self._nativePasteboard propertyListForType:type];
}

- (void)setData:(NSData *)data forPasteboardType:(NSString *)type
{
    [self._nativePasteboard setData:data forType:type];
}

- (void)setValue:(id)value forPasteboardType:(NSString *)type
{
    [self._nativePasteboard setPropertyList:value forType:type];
}

@end

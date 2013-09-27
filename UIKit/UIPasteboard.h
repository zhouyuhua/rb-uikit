//
//  UIPasteboard.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/10/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const UIPasteboardNameGeneral;
UIKIT_EXTERN NSString *const UIPasteboardNameFind;

@interface UIPasteboard : NSObject

+ (instancetype)generalPasteboard;
+ (instancetype)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create;
+ (instancetype)pasteboardWithUniqueName;
+ (void)removePasteboardWithName:(NSString *)pasteboardName;

#pragma mark - Properties

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, getter=isPersistent) BOOL persistent;
@property (nonatomic, readonly) NSInteger changeCount;

#pragma mark - Determining Types of Single Pasteboard Items

- (NSArray *)pasteboardTypes;
- (BOOL)containsPasteboardTypes:(NSArray *)types;

#pragma mark - Getting and Setting Single Pasteboard Items

- (NSData *)dataForPasteboardType:(NSString *)type;
- (id)valueForPasteboardType:(NSString *)type;
- (void)setData:(NSData *)data forPasteboardType:(NSString *)type;
- (void)setValue:(id)value forPasteboardType:(NSString *)type;

@end

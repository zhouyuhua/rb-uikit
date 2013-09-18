//
//  UINib.h
//  UIKit
//
//  Created by Kevin MacWhinnie on 9/17/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const UINibProxiedObjectsKey;
UIKIT_EXTERN NSString *const UINibExternalObjects;

UIKIT_UNIMPLEMENTED @interface UINib : NSObject

#pragma mark - Creating a Nib Object

+ (instancetype)nibWithNibName:(NSString *)name bundle:(NSBundle *)bundle UIKIT_UNIMPLEMENTED;
+ (instancetype)nibWithData:(NSData *)data bundle:(NSBundle *)bundle UIKIT_UNIMPLEMENTED;

#pragma mark - Instantiating a Nib

- (NSArray *)instantiateWithOwner:(id)ownerOrNil options:(NSDictionary *)optionsOrNil UIKIT_UNIMPLEMENTED;

@end

#pragma mark -

@interface NSBundle(UIKit)

- (NSArray *)loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options;

@end

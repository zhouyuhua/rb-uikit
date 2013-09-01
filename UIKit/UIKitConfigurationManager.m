//
//  UIKitConfigurationManager.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 8/31/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIKitConfigurationManager.h"

NSString *const UIKitConfigurationResourceFileName = @"UIKitInfo";

static NSString *ConfigurationPlistKeyToPropertyKey(NSString *key)
{
    if(!key || ![key hasPrefix:@"UI"])
        return nil;
    
    NSMutableString *propertyKey = [key mutableCopy];
    [propertyKey deleteCharactersInRange:NSMakeRange(0, 2)]; //"UI" prefix
    NSString *firstLetter = [[propertyKey substringToIndex:1] uppercaseString];
    [propertyKey deleteCharactersInRange:NSMakeRange(0, 1)];
    [propertyKey insertString:firstLetter atIndex:0];
    return propertyKey;
}

@implementation UIKitConfigurationManager

+ (UIKitConfigurationManager *)sharedConfigurationManager
{
    static UIKitConfigurationManager *sharedConfigurationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfigurationManager = [UIKitConfigurationManager new];
    });
    
    return sharedConfigurationManager;
}

- (id)init
{
    if((self = [super init])) {
        [self setDefaults];
        
        NSURL *configurationLocation = [[NSBundle mainBundle] URLForResource:UIKitConfigurationResourceFileName withExtension:@"plist"];
        if(configurationLocation) {
            NSDictionary *configuration = [NSDictionary dictionaryWithContentsOfURL:configurationLocation];
            NSAssert(configuration != nil, @"Could not read configuration file");
            
            [configuration enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
                @try {
                    [self setValue:value forKey:ConfigurationPlistKeyToPropertyKey(key)];
                } @catch (NSException *e) {
                    if(![e.name isEqualToString:NSUndefinedKeyException])
                        @throw;
                    
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                   reason:[NSString stringWithFormat:@"The key %@ is unsupported by %@", key, self.class]
                                                 userInfo:nil];
                }
            }];
        }
    }
    
    return self;
}

- (void)setDefaults
{
    
}

@end

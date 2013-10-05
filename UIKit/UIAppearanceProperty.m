//
//  UIAppearanceProperty.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIAppearanceProperty.h"
#import "UIRetainingNSValue.h"

static SEL GetterSelectorFromSetterSelector(SEL setterSelector)
{
    NSMutableString *getterString = [NSStringFromSelector(setterSelector) mutableCopy];
    [getterString deleteCharactersInRange:NSMakeRange(0, 3)]; //set
    
    NSString *firstCharacterLowercased = [[getterString substringWithRange:NSMakeRange(0, 1)] lowercaseString];
    [getterString replaceCharactersInRange:NSMakeRange(0, 1) withString:firstCharacterLowercased];
    
    NSRange rangeOfColonFor = [getterString rangeOfString:@":for"];
    if(rangeOfColonFor.location != NSNotFound) {
        [getterString deleteCharactersInRange:NSMakeRange(rangeOfColonFor.location, 1)]; // :
        
        NSString *fUppercased = [[getterString substringWithRange:NSMakeRange(rangeOfColonFor.location, 1)] uppercaseString];
        [getterString replaceCharactersInRange:NSMakeRange(rangeOfColonFor.location, 1) withString:fUppercased];
    } else {
        [getterString deleteCharactersInRange:NSMakeRange(getterString.length - 1, 1)]; // :
    }
    
    return NSSelectorFromString(getterString);
}

@implementation UIAppearanceProperty

- (instancetype)initWithSetterMethod:(Method)method
{
    NSParameterAssert(method);
    
    if((self = [super init])) {
        self.setterSelector = method_getName(method);
        self.getterSelector = GetterSelectorFromSetterSelector(_setterSelector);
        
        char returnType[255];
        method_getReturnType(method, returnType, sizeof(returnType));
        NSMutableString *setterTypeEncoding = [NSMutableString stringWithUTF8String:returnType];
        NSMutableString *getterTypeEncoding = [NSMutableString string];
        for (unsigned int index = 0, count = method_getNumberOfArguments(method); index < count; index++) {
            char argumentType[255];
            method_getArgumentType(method, index, argumentType, sizeof(argumentType));
            
            NSString *argumentTypeString = [NSString stringWithUTF8String:argumentType];
            [setterTypeEncoding appendString:argumentTypeString];
            
            if(index == 2) {
                [getterTypeEncoding insertString:argumentTypeString atIndex:0];
            } else {
                [getterTypeEncoding appendString:argumentTypeString];
            }
        }
        
        self.setterTypeEncoding = setterTypeEncoding;
        self.getterTypeEncoding = getterTypeEncoding;
    }
    
    return self;
}

#pragma mark - Identity

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UIAppearanceProperty class]]) {
        UIAppearanceProperty *otherProperty = (UIAppearanceProperty *)object;
        return (sel_isEqual(self.setterSelector, otherProperty.setterSelector) &&
                [self.setterTypeEncoding isEqualToString:otherProperty.setterTypeEncoding] &&
                sel_isEqual(self.getterSelector, otherProperty.getterSelector) &&
                [self.getterTypeEncoding isEqualToString:otherProperty.getterTypeEncoding]);
    }
    
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p setter: %@ (%@), getter: %@ (%@)>", NSStringFromClass(self.class), self, self.setterTypeEncoding, NSStringFromSelector(self.setterSelector), self.getterTypeEncoding, NSStringFromSelector(self.getterSelector)];
}

#pragma mark - Application

- (void)applyToInstance:(id)instance withValue:(UIRetainingNSValue *)value axisValues:(NSArray *)axisValues
{
    NSParameterAssert(value);
    NSParameterAssert(axisValues);
    
    if(!instance)
        return;
    
    NSMethodSignature *methodSignature = [instance methodSignatureForSelector:_setterSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:instance];
    [invocation setSelector:_setterSelector];
    
    NSUInteger setterValueSize;
    NSGetSizeAndAlignment([value objCType], &setterValueSize, NULL);
    Byte setterValueBuffer[setterValueSize];
    [value getValue:setterValueBuffer];
    
    [invocation setArgument:setterValueBuffer atIndex:2];
    
    NSUInteger index = 3;
    for (NSValue *value in axisValues) {
        NSUInteger axisValueSize;
        NSGetSizeAndAlignment([value objCType], &axisValueSize, NULL);
        Byte axisValueBuffer[axisValueSize];
        [value getValue:axisValueBuffer];
        
        [invocation setArgument:axisValueBuffer atIndex:index];
        
        index++;
    }
    
    [invocation invoke];
}

@end

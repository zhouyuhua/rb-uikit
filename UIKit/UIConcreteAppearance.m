//
//  UIConcreteAppearance.m
//  UIKit
//
//  Created by Kevin MacWhinnie on 10/5/13.
//  Copyright (c) 2013 Roundabout Software, LLC. All rights reserved.
//

#import "UIConcreteAppearance.h"
#import <stdarg.h>
#import <objc/runtime.h>
#import "UIAppearanceProperty.h"

#import "NSObject+UIAppearance.h"
#import "UIRetainingNSValue.h"

static BOOL IsAppearanceSetterSelector(SEL selector)
{
    static NSRegularExpression *matchingExpression;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        matchingExpression = [NSRegularExpression regularExpressionWithPattern:@"set([\\w]+):(for.+)?$"
                                                                       options:kNilOptions
                                                                         error:NULL];
    });
    
    NSString *selectorString = NSStringFromSelector(selector);
    return ([matchingExpression rangeOfFirstMatchInString:selectorString
                                                  options:kNilOptions 
                                                    range:NSMakeRange(0, selectorString.length)].location != NSNotFound);
}

static BOOL IsSelectorBlackListed(SEL selector)
{
    NSString *selectorString = NSStringFromSelector(selector);
    return (([selectorString rangeOfString:@"_"].location != NSNotFound) ||
            [selectorString isEqualToString:@"setDelegate:"] ||
            ([selectorString hasPrefix:@"set"] && ![selectorString hasSuffix:@":"]));
}

@interface UIConcreteAppearance ()

@property (nonatomic, assign) Class _class;
@property (nonatomic, copy) NSArray *_containerPath;
@property (nonatomic, copy) NSArray *_properties;
@property (nonatomic) NSMutableDictionary *_values;

@end

@implementation UIConcreteAppearance

+ (NSMutableArray *)sharedInstances
{
    static NSMutableArray *sharedInstances;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstances = [NSMutableArray array];
    });
    
    return sharedInstances;
}

+ (instancetype)sharedInstanceForClass:(Class)class containedIn:(NSArray *)containerPath
{
    NSMutableArray *sharedInstances = [self sharedInstances];
    for (UIConcreteAppearance *appearance in sharedInstances) {
        if(appearance._class == class && [containerPath isEqualToArray:appearance._containerPath])
            return appearance;
    }
    
    UIConcreteAppearance *newAppearance = [[UIConcreteAppearance alloc] initWithClass:class containedIn:containerPath];
    [sharedInstances addObject:newAppearance];
    return newAppearance;
}

#pragma mark -

+ (id)appearanceForClass:(Class)class containedIn:(Class <UIAppearanceContainer>)ContainerClass, ...
{
    va_list args;
    va_start(args, ContainerClass);
    
    id appearance = [self appearanceForClass:class containedIn:ContainerClass arguments:args];
    
    va_end(args);
    
    return appearance;
}

+ (id)appearanceForClass:(Class)class containedIn:(Class <UIAppearanceContainer>)ContainerClass arguments:(va_list)arguments
{
    NSMutableArray *containerPath = [NSMutableArray array];
    if(ContainerClass) {
        [containerPath addObject:ContainerClass];
        
        Class container;
        while ((container = va_arg(arguments, Class)) != nil) {
            [containerPath addObject:container];
        }
    }
    
    return [self sharedInstanceForClass:class containedIn:containerPath];
}

- (instancetype)initWithClass:(Class)class containedIn:(NSArray *)containerPath
{
    NSParameterAssert(class);
    NSParameterAssert(containerPath);
    
    if((self = [super init])) {
        self._class = class;
        self._containerPath = containerPath;
        self._values = [NSMutableDictionary dictionary];
        
        NSMutableArray *properties = [NSMutableArray array];
        
        Class currentClass = class;
        while (currentClass != nil) {
            unsigned int methodCount;
            Method *methods = class_copyMethodList(currentClass, &methodCount);
            for (unsigned int index = 0; index < methodCount; index++) {
                Method method = methods[index];
                SEL methodSelector = method_getName(method);
                
                if(IsSelectorBlackListed(methodSelector))
                    continue;
                
                if(IsAppearanceSetterSelector(methodSelector)) {
                    [properties addObject:[[UIAppearanceProperty alloc] initWithSetterMethod:method]];
                }
            }
            
            currentClass = class_getSuperclass(currentClass);
        }
        
        self._properties = properties;
    }
    
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Identity

- (NSUInteger)hash
{
    return [self._class hash] ^ [self._containerPath hash];
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[UIConcreteAppearance class]]) {
        UIConcreteAppearance *appearance = (UIConcreteAppearance *)object;
        
        return (appearance._class == self._class &&
                [appearance._containerPath isEqualToArray:appearance._containerPath]);
    }
    
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p class => %@, containerPath => %@>", NSStringFromClass(self.class), self, self._class, [self._containerPath componentsJoinedByString:@" -> "]];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@:%p class => %@, containerPath => %@ values => %@>", NSStringFromClass(self.class), self, self._class, [self._containerPath componentsJoinedByString:@" -> "], self._values];
}

#pragma mark - Axis Values

- (NSMutableDictionary *)_axisValuesForGetterSelector:(SEL)selector
{
    NSString *key = NSStringFromSelector(selector);
    NSMutableDictionary *values = self._values[key];
    if(!values) {
        values = [NSMutableDictionary dictionary];
        self._values[key] = values;
    }
    
    return values;
}

- (id)_keyForSetterAxisValues:(NSArray *)values
{
    return [values subarrayWithRange:NSMakeRange(1, values.count - 1)];
}

#pragma mark - Forwarding

- (UIAppearanceProperty *)_propertyForSelector:(SEL)selector
{
    for (UIAppearanceProperty *property in self._properties) {
        if(sel_isEqual(property.getterSelector, selector) ||
           sel_isEqual(property.setterSelector, selector)) {
            return property;
        }
    }
    
    return nil;
}

- (BOOL)_isSelectorForSetter:(SEL)selector
{
    return [NSStringFromSelector(selector) hasPrefix:@"set"];
}

#pragma mark -

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:selector];
    if(!methodSignature) {
        if([self _propertyForSelector:selector])
            methodSignature = [__class instanceMethodSignatureForSelector:selector];
    }
    
    return methodSignature;
}

- (BOOL)respondsToSelector:(SEL)selector
{
    BOOL responds = [super respondsToSelector:selector];
    if(!responds) {
        if([self _propertyForSelector:selector])
            responds = [__class instancesRespondToSelector:selector];
    }
    
    return responds;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    UIAppearanceProperty *property = [self _propertyForSelector:selector];
    if(property) {
        NSMutableArray *axisValues = [NSMutableArray array];
        
        NSMethodSignature *methodSignature = [invocation methodSignature];
        for (NSUInteger index = 2, count = [methodSignature numberOfArguments]; index < count; index++) {
            const char *type = [methodSignature getArgumentTypeAtIndex:index];
            
            NSUInteger bufferSize;
            NSGetSizeAndAlignment(type, &bufferSize, NULL);
            
            Byte buffer[bufferSize];
            [invocation getArgument:buffer atIndex:index];
            
            [axisValues addObject:[UIRetainingNSValue valueWithBytes:buffer objCType:type]];
        }
        
        if([self _isSelectorForSetter:selector]) {
            NSMutableDictionary *values = [self _axisValuesForGetterSelector:property.getterSelector];
            UIRetainingNSValue *value = axisValues[0];
            if([value isNil]) {
                [values removeObjectForKey:[self _keyForSetterAxisValues:axisValues]];
            } else {
                values[[self _keyForSetterAxisValues:axisValues]] = axisValues[0];
            }
        } else {
            NSMutableDictionary *values = [self _axisValuesForGetterSelector:property.getterSelector];
            UIRetainingNSValue *value = values[axisValues];
            
            NSUInteger bufferSize;
            NSGetSizeAndAlignment([value objCType], &bufferSize, NULL);
            Byte buffer[bufferSize];
            [value getValue:buffer];
            
            [invocation setReturnValue:buffer];
        }
    } else {
        [super forwardInvocation:invocation];
    }
}

@end

#pragma mark -

void UIConcreteAppearanceApply(UIConcreteAppearance *appearance, id instance)
{
    NSCParameterAssert(instance);
    
    if(!appearance || ![appearance isKindOfClass:[UIConcreteAppearance class]])
        return;
    
    NSCAssert([instance isKindOfClass:appearance._class], @"Class mismatch");
    
    for (UIAppearanceProperty *property in appearance._properties) {
        NSDictionary *values = [appearance _axisValuesForGetterSelector:property.getterSelector];
        [values enumerateKeysAndObjectsUsingBlock:^(NSArray *axisValues, UIRetainingNSValue *value, BOOL *stop) {
            [property applyToInstance:instance withValue:value axisValues:axisValues];
        }];
    }
}

BOOL UIConcreteAppearanceHasValueFor(UIConcreteAppearance *appearance, SEL getterSelector)
{
    if(!appearance || ![appearance isKindOfClass:[UIConcreteAppearance class]])
        return NO;
    
    return ([appearance _propertyForSelector:getterSelector] != nil);
}

NSArray *UIConcreteAppearanceGetContainerPathForInstance(id containee)
{
    NSMutableArray *containerPath = [NSMutableArray array];
    Class container;
    while ((container = [containee _appearanceContainer]) != nil) {
        [containerPath addObject:container];
        
        containee = [container _appearanceContainer];
    }
    
    return containerPath;
}

UIConcreteAppearance *UIConcreteAppearanceForInstance(id instance)
{
    if(!instance || ![instance conformsToProtocol:@protocol(UIAppearance)])
        return nil;
    
    return [UIConcreteAppearance sharedInstanceForClass:[instance class]
                                            containedIn:UIConcreteAppearanceGetContainerPathForInstance(instance)];
}

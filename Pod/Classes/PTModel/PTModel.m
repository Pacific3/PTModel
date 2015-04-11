//
//  PTModel.m
//  PTModel
//
//  Created by Oscar Swanros on 3/25/15.
//  Copyright (c) 2015 Oscar Swanros. All rights reserved.
//

#import "PTModel.h"
#import <objc/runtime.h>

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

// MARK - PTModelManager

@interface PTModelManager : NSObject
@property (nonatomic, strong) NSArray *instances;
@end

@interface PTModelManager () {
    NSString *__path;
    NSArray *__instances;
}
@end

@implementation PTModelManager

+ (instancetype)sharedManager
{
    static PTModelManager *__instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __instance = [[PTModelManager alloc] init];
    });
    
    return __instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        __path = [documentsDir stringByAppendingPathComponent:@"data.dat"];
    }
    
    return self;
}

- (void)loadInstances
{
    __instances = [NSKeyedUnarchiver unarchiveObjectWithFile:__path];
    
    if (!__instances) {
        __instances = [NSArray array];
    }
}

- (NSArray *)instances;
{
    [self loadInstances];
    
    return __instances;
}

- (BOOL)addInstance:(PTModel *)instance
{
    if (instance) {
        [self loadInstances];
        
        NSMutableArray *instances = [NSMutableArray arrayWithArray:self.instances];
        [instances addObject:instance];
        
        return [NSKeyedArchiver archiveRootObject:[NSArray arrayWithArray:instances] toFile:__path];
    }
    
    return NO;
}

- (BOOL)removeInstance:(PTModel *)instance
{
    if (!instance) {
        return NO;
    }
    
    [self loadInstances];
    
    __block BOOL res;
    
    NSMutableArray *instances = [NSMutableArray arrayWithArray:self.instances];
    [instances enumerateObjectsUsingBlock:^(PTModel *mod, NSUInteger idx, BOOL *stop) {
        if ([mod isEqual:instance]) {
            *stop = YES;
            
            [instances removeObjectAtIndex:idx];
            res = [NSKeyedArchiver archiveRootObject:instances toFile:__path];
        }
    }];
    
    return res;
}

- (BOOL)isInstanceSaved:(PTModel *)instance
{
    if (!instance) {
        return NO;
    }
    
    [self loadInstances];
    if ([self.instances containsObject:instance]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)clear
{
    [self loadInstances];
    
    return [NSKeyedArchiver archiveRootObject:nil toFile:__path];
}

@end

@interface PTModel () <NSCoding>
@end

@implementation PTModel

+ (NSArray *)allInstances;
{
    return [PTModelManager sharedManager].instances;
}

+ (NSArray *)instancesFilteredWithPredicate:(NSPredicate *)predicate;
{
    return [[self allInstances] filteredArrayUsingPredicate:predicate];
}

+ (BOOL)removeAllInstances;
{
    return [[PTModelManager sharedManager] clear];
}

- (BOOL)save;
{
    [[PTModelManager sharedManager] addInstance:self];
    
    return NO;
}

- (BOOL)remove;
{
    return [[PTModelManager sharedManager] removeInstance:self];
}

- (BOOL)isEqual:(id)object
{
    __block BOOL eq;
    [self enumerateObjectKeysWithBlock:^(NSString *key) {
        eq = [[self valueForKey:key] isEqual:[object valueForKey:key]];
    }];
    
    return eq;
}


#pragma mark - Misc

- (NSString *)randomStringWithLength:(int)len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self enumerateObjectKeysWithBlock:^(NSString *key) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self enumerateObjectKeysWithBlock:^(NSString *key) {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

- (void)enumerateObjectKeysWithBlock:(void (^)(NSString *key))block
{
    if (block) {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        
        for (NSInteger i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            
            block(key);
        }
        
        free(properties);
    }
}

@end

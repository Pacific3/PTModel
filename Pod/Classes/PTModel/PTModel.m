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
    _instances = [NSKeyedUnarchiver unarchiveObjectWithFile:__path];
    
    if (!_instances) {
        _instances = [NSArray array];
    }
}

- (NSArray *)instances;
{
    [self loadInstances];
    
    return _instances;
}

- (BOOL)addInstance:(PTModel *)instance
{
    if (instance) {
        [self loadInstances];
        
        NSMutableArray *instances = [NSMutableArray arrayWithArray:self.instances];
        [instances addObject:instance];
        
        return [NSKeyedArchiver archiveRootObject:instances toFile:__path];
    }
    
    return NO;
}

- (BOOL)updateInstance:(PTModel *)instance
{
    if (!instance) {
        return NO;
    }
    
    [self loadInstances];
    
    __block BOOL replaced;
    
    NSMutableArray *instances = [NSMutableArray arrayWithArray:self.instances];
    [instances enumerateObjectsUsingBlock:^(PTModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:instance]) {
            *stop = YES;
            
            [instances replaceObjectAtIndex:idx withObject:instance];
            replaced = [NSKeyedArchiver archiveRootObject:instances toFile:__path];
        }
    }];
    
    return replaced;
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

- (BOOL)clear
{
    return [NSKeyedArchiver archiveRootObject:nil toFile:__path];
}

@end

@interface PTModel () <NSCoding>
@property (nonatomic, readwrite) NSString *guid;
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

+ (instancetype)instanceWithId:(NSString *)instanceId
{
    id object = [[[self allInstances] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guid = %@", instanceId]] firstObject];
    if (object) {
        return object;
    }
    
    return nil;
}

+ (BOOL)removeAllInstances;
{
    return [[PTModelManager sharedManager] clear];
}

- (BOOL)save;
{
    if ([self.guid isEqualToString:@""] || !self.guid) { // Going to be saved for the first time
        do {
            self.guid = [self randomStringWithLength:20];
        } while (![self isUniqueGUID:self.guid]);
        
        return [[PTModelManager sharedManager] addInstance:self];
    }
    
    return [[PTModelManager sharedManager] updateInstance:self];
}

- (BOOL)remove;
{
    return [[PTModelManager sharedManager] removeInstance:self];
}

- (BOOL)isEqual:(PTModel *)object
{
    return [self.guid isEqualToString:object.guid];
}


#pragma mark - Misc

- (NSString *)randomStringWithLength:(int)len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

- (BOOL)isUniqueGUID:(NSString *)guid
{
    return [[self class] instancesFilteredWithPredicate:[NSPredicate predicateWithFormat:@"_guid == %@", guid]].count == 0;
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
        unsigned int subcount;
        unsigned int supercount;
        
        unsigned int count;
        objc_property_t *subProperties = class_copyPropertyList([self class], &subcount);
        objc_property_t *superProperties = class_copyPropertyList([self superclass], &supercount);
        
        count = subcount + supercount;
        objc_property_t *properties = malloc(count * sizeof(objc_property_t*));
        
        memcpy(properties, subProperties, subcount * sizeof(objc_property_t*));
        memcpy(properties + subcount, superProperties, supercount * sizeof(objc_property_t*));
        
        for (NSInteger i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            
            block(key);
        }
        
        free(properties);
    }
}

@end

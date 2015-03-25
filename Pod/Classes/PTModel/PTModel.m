//
//  PTModel.m
//  PTModel
//
//  Created by Oscar Swanros on 3/25/15.
//  Copyright (c) 2015 Oscar Swanros. All rights reserved.
//

#import "PTModel.h"
#import <objc/runtime.h>

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

@end

@interface PTModel () <NSCoding>
@end

@implementation PTModel

+ (NSArray *)allInstances;
{
    return [[PTModelManager alloc] init].instances;
}

+ (NSArray *)instancesFilteredWithPredicate:(NSPredicate *)predicate;
{
    return [[self allInstances] filteredArrayUsingPredicate:predicate];
}

- (BOOL)save;
{
    return [[[PTModelManager alloc] init] addInstance:self];
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        
        for (NSInteger i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *key = [NSString stringWithUTF8String:property_getName(property)];
            
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
        
        free(properties);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (NSUInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    free(properties);
}

@end

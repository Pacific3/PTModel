//
//  PTModel.h
//  PTModel
//
//  Created by Oscar Swanros on 3/25/15.
//  Copyright (c) 2015 Oscar Swanros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTModel : NSObject
@property (nonatomic, readonly) NSString *guid;

+ (NSArray *)allInstances;
+ (NSArray *)instancesFilteredWithPredicate:(NSPredicate *)predicate;
+ (instancetype)instanceWithId:(NSString *)instanceId;
+ (BOOL)removeAllInstances;

- (BOOL)save;
- (BOOL)remove;
@end

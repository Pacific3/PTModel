//
//  PTModel.h
//  PTModel
//
//  Created by Oscar Swanros on 3/25/15.
//  Copyright (c) 2015 Oscar Swanros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTModel : NSObject
@property (nonatomic, readonly) NSString *_guid;

+ (NSArray *)allInstances;
+ (NSArray *)instancesFilteredWithPredicate:(NSPredicate *)predicate;

- (BOOL)save;
- (BOOL)remove;

+ (BOOL)removeAllInstances;

@end

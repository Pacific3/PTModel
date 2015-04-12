//
//  PTModel.h
//  PTModel
//
//  Created by Oscar Swanros on 3/25/15.
//  Copyright (c) 2015 Oscar Swanros. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @c PTModel is a simple object store for persisting data on iOS applications.
 To use @c PTModel, you just need to subclass it:
 
 @code
 // Record.h
 #import <PTModel/PTModel.h>
 
 @interface Record : PTModel
 @property (nonatomic, copy) NSString *title;
 @property (nonatomic, copy) NSString *band;
 @end
 
 
 // Record.m
 #import "Record.h"
 
 @implementation Record
 @end
 @endcode
 */
@interface PTModel : NSObject
/**
 The global ID used to identify objects.
 */
@property (nonatomic, readonly) NSString *guid;

/**
 @return @c NSArray* containing all the instances of the object saved to the store.
 */
+ (NSArray *)allInstances;

/**
 Call this method to get a filtered @c NSArray* of your objects using a predicate.
 Usage:
 
 @code
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", @"Divine Discontent"];
 Record *retrievedRecord = [[Record instancesFilteredWithPredicate:predicate] firstObject];
 @endcode
 
 @param predicate A @c NSPredicate* instance defining the filtering criteria.
 @return @c NSArray* containing the results for the query.
 @warning  @c predicate must not be @c nil.
 */
+ (NSArray *)instancesFilteredWithPredicate:(NSPredicate *)predicate;

/**
 Call this method to retrieve a specific instance from the object store.
 
 Each instance of your subclass has a @c guid property that is set right before the object is first saved. This is a unique ID, and you can use it to retrieve a specific object.
 
 Usage:
 
 @code
 Record *retrievedRecord = [Record instanceWithId:savedRecord.guid];
 @endcode
 
 @param instanceId A @c NSString* that represents a known ID of an object on the store.
 @return @c instancetype of your subclass, given that the passed @c instanceId existed on the store.
 */
+ (instancetype)instanceWithId:(NSString *)instanceId;

/**
 Deletes all instances of your subclass that are saved on the store.
 
 @return @c BOOL representing wether the clean-up was completed successfully.
 */
+ (BOOL)removeAllInstances;

/**
 Saves the current instance to the object store. Right before saving it, the instance gest a @c guid set.
 
 If @c save is called on an instance that was already saved to the store, it will update the instance on the store.
 
 Usage:
 @code
 Record *newRecord = [Record new]; // Create a new object
 newRecord.title = @"Divine Discontent";
 newRecord.band = @"Sixpence None The Richer";
 
 [newRecord save]; // Save your object to the store
 @endcode
 
 @return @c BOOL represeting wether the save/update operation was completed successfully.
 */
- (BOOL)save;

/**
 Deletes the instance from the store.
 
 Usage:
 
 @code
 [myRecord remove];
 @endcode
 
 @return @c BOOL represeting wether the object was removed from the object store succesfully.
 */
- (BOOL)remove;

@end

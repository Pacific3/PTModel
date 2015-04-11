//
//  PTModelTests.m
//  PTModelTests
//
//  Created by Oscar Swanros on 03/25/2015.
//  Copyright (c) 2014 Oscar Swanros. All rights reserved.
//

#import "PTModel.h"

@interface PTmodelTest : PTModel
@property (nonatomic, copy) NSString *testString;
@end
@implementation PTmodelTest
@end

SpecBegin(InitialSpecs)

describe(@"Saving objects", ^{
    
    beforeEach(^{
        [PTmodelTest removeAllInstances];
    });

    it(@"Can create an object and save it", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"test!";
        
        expect([test save]).to.equal(TRUE);
    });
    
    it(@"Can retrieve an object by querying for it", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"test!";
        
        [test save];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"testString = %@", @"test!"];
        PTmodelTest *retrieved = (PTmodelTest *)[[PTmodelTest instancesFilteredWithPredicate:pred] firstObject];
        
        expect(retrieved.testString).to.equal(@"test!");
    });
    
    it(@"Can retrieve an object by its id", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"tes11!";
        
        [test save];
        
        PTmodelTest *retrieved = [PTmodelTest instanceWithId:test.guid];
        
        expect(retrieved.testString).to.equal(@"tes11!");
    });
    
    it(@"Can remove an object", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"test!";
        
        [test save];
        expect([PTmodelTest allInstances].count).to.equal(1);
        
        
        [test remove];
        expect([PTmodelTest allInstances].count).to.equal(0);
    });
    
    it(@"Can remove all objects", ^{
        PTmodelTest *test1 = [[PTmodelTest alloc] init];
        test1.testString = @"Test1";
        
        [test1 save];
        PTmodelTest *test2 = [[PTmodelTest alloc] init];
        test2.testString = @"Test1";
        
        [test2 save];
        PTmodelTest *test3 = [[PTmodelTest alloc] init];
        test2.testString = @"Test1";
        
        [test3 save];
        
        expect([PTmodelTest allInstances].count).to.equal(3);
        
        [PTmodelTest removeAllInstances];
        
        expect([PTmodelTest allInstances].count).to.equal(0);
    });
    
    it(@"Can update an object", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"test!";
        
        [test save];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"testString = %@", @"test!"];
        PTmodelTest *retrieved = [[PTmodelTest instancesFilteredWithPredicate:predicate] firstObject];
        
        expect(retrieved.testString).to.equal(@"test!");
        
        test.testString = @"updated!";
        [test save];
        
        NSPredicate *updatedPredicate = [NSPredicate predicateWithFormat:@"testString = %@", @"updated!"];
        retrieved = [[PTmodelTest instancesFilteredWithPredicate:updatedPredicate] firstObject];
        
        expect(retrieved.testString).to.equal(@"updated!");
    });

});

SpecEnd

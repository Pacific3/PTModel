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

    it(@"Can create an object and save it", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"test!";
        
        expect([test save]).to.equal(TRUE);
    });
    
    it(@"Can retrieve an object", ^{
        PTmodelTest *test = [[PTmodelTest alloc] init];
        test.testString = @"test!";
        
        [test save];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"testString = %@", @"test!"];
        PTmodelTest *retrieved = (PTmodelTest *)[[PTmodelTest instancesFilteredWithPredicate:pred] firstObject];
        
        expect(retrieved.testString).to.equal(test.testString);
    });

});

SpecEnd

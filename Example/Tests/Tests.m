//
//  PTModelTests.m
//  PTModelTests
//
//  Created by Oscar Swanros on 03/25/2015.
//  Copyright (c) 2014 Oscar Swanros. All rights reserved.
//

#import "PTModel.h"

SpecBegin(InitialSpecs)

describe(@"these will fail", ^{

    it(@"can do maths", ^{
        expect(1).to.equal(2);
    });

    it(@"can read", ^{
        expect(@"number").to.equal(@"string");
    });
    
});

SpecEnd

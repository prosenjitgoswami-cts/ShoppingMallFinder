//
//  ShoppingMallFinderTests.m
//  ShoppingMallFinderTests
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NearbyShoppingCentreListPresenter.h"

@interface ShoppingMallFinderTests : XCTestCase

@end

@implementation ShoppingMallFinderTests


- (void)testThatSearchResultHasDataWithValidLocation {
    
    id <NearbyShoppingCentreListProtocol> presenter =  [NearbyShoppingCentreListPresenter new];
    CLLocation *demoLocation = [[CLLocation alloc]initWithLatitude:37.33233141 longitude:-122.03121860];
    
    __block NSArray *_results = nil;
    
    XCTestExpectation *exception = [self expectationWithDescription:@"CallBack"];
    
    [presenter getNearbyShoppingCentreForLocation:demoLocation completion:^(BOOL success, NSArray * results) {
        
        _results = results;
        [exception fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {}];

    XCTAssertTrue(_results.count);

    
}

- (void)testThatSearchResultHasNoData_ForInvalidLocation {
	
	id <NearbyShoppingCentreListProtocol> presenter =  [NearbyShoppingCentreListPresenter new];
	CLLocation *invalidLocation = [[CLLocation alloc]initWithLatitude:91.0 longitude:183.0];
	
	
	__block NSArray *_results = nil;
	
	XCTestExpectation *exception = [self expectationWithDescription:@"CallBack"];
	
	[presenter getNearbyShoppingCentreForLocation:invalidLocation completion:^(BOOL success, NSArray * results) {
		
		_results = results;
		[exception fulfill];
		
	}];
	[self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {}];
	
	XCTAssertFalse(_results.count);
	
}

- (void)testThatSearchResultHasNoData_ForALocatonWhereNoShoppingCentreAvailable {
	
	id <NearbyShoppingCentreListProtocol> presenter =  [NearbyShoppingCentreListPresenter new];

	CLLocation *noShoppingCentreLocation = [[CLLocation alloc]initWithLatitude:89.0 longitude:0.0];
	
	
	__block NSArray *_results = nil;
	
	XCTestExpectation *exception = [self expectationWithDescription:@"CallBack"];
	
	[presenter getNearbyShoppingCentreForLocation:noShoppingCentreLocation completion:^(BOOL success, NSArray * results) {
		
		_results = results;
		[exception fulfill];
		
	}];
	[self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {}];
	
	XCTAssertFalse(_results.count);
	
}

@end

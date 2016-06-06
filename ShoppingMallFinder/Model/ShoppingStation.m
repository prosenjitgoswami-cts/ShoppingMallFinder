//
//  ShoppingStation.m
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import "ShoppingStation.h"

@implementation ShoppingStationLocation

@end

@implementation ShoppingStation

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shoppingStationLocation = [[ShoppingStationLocation alloc]init];
    }
    return self;
}

/**
 *  Init
 *
 *  @param name       Lccation name
 *  @param address    Lccation address
 *  @param coordinate Lccation coordinate
 *
 *  @return Return Self
 */

- (nonnull instancetype)initWithName:(nullable NSString *)name
           address:(nullable NSString *)address
        coordinate:(CLLocationCoordinate2D)coordinate {
   
    self = [super init];
   
    if (self) {
        self.shoppingStationLocation = [[ShoppingStationLocation alloc]init];
        
        self.name = name;
		self.title = name;
		self.subtitle = address;
        self.shoppingStationLocation.address = address;
        self.shoppingStationLocation.coordinate = coordinate;
        
    }
    return self;
}

#pragma mark - Getter Method

/**
 *  Get CLLocationCoordinate2D
 *
 *  @return coordinate as CLLocationCoordinate2D
 */
- (CLLocationCoordinate2D)coordinate {
    return self.shoppingStationLocation.coordinate;
}

/**
 *  Get title
 *
 *  @return title as NSString
 */
- (NSString *)title {
    return self.name;
}

/**
 *  Get address
 *
 *  @return Address as NSString
 */
- (NSString  * _Nullable )getAddress {
    return self.shoppingStationLocation.address;
}
@end

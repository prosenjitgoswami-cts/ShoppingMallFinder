//
//  ShoppingStation.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface ShoppingStationLocation : NSObject {
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong,nullable) NSString *address;

@end


@interface ShoppingStation : NSObject<MKAnnotation>

@property (nonatomic,strong,nullable) NSString *name;
@property (nonatomic,strong,nullable) ShoppingStationLocation *shoppingStationLocation;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;


/**
 *  Init
 *
 *  @param name       Lccation name
 *  @param address    Lccation address
 *  @param coordinate Lccation coordinate
 *
 *  @return Return Self as ShoppingStation instants
 */
- (nonnull instancetype)initWithName:(nullable NSString *)name
                             address:(nullable NSString *)address
                          coordinate:(CLLocationCoordinate2D)coordinate;

/**
 *  Get address
 *
 *  @return Address as NSString
 */
- (NSString  * _Nullable )getAddress;
@end

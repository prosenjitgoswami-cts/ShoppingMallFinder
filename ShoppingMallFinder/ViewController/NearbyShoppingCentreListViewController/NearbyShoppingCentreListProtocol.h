//
//  NearbyShoppingCentreListProtocol.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ShoppingStation.h"
#import "Foursquare2.h"

@protocol NearbyShoppingCentreListProtocol <NSObject>


/**
 *  Fetch the Nearby Shopping Centre Details
 *
 *  @param location   Current Location as CLLocation
 *  @param completion Completion with Success as BOOL and Results as NSArray
 */

- (void)getNearbyShoppingCentreForLocation:( CLLocation * _Nullable)location
                  completion:(void( ^ _Nullable )(BOOL success, NSArray* _Nullable results))completion;

/**
 *  Get Location Information with respect to new CLLocation instants
 *
 *  @param newLocation       Instants of CLLocation
 *  @param completionHandler completionHandler with placemarks as NSArray, Error as NSError, Address as NSString
 */
- (void)getLocationInformationWithLocation:(CLLocation * _Nullable) newLocation
						 completionHandler:(void(^_Nullable)(NSArray * _Nullable placemarks, NSError * _Nullable error, NSDictionary* _Nullable addressInfoDict, NSString* _Nullable errorMessage))completionHandler;

/**
 *  Check that Location manager is authorized or not.
 *
 *
 */
- (BOOL)isLocationManagerAuthorized;


/**
 *  Check that Network connection available or not
 *
 */
- (BOOL)isReachable;


/**
 *  Get error message text
 *
 *  @param error Corrosponding error instant
 *
 */
- (nullable NSString *)getErrorMessageText:(nullable NSError *)error;
@end

//
//  CLLocation+ShoppingLocationFinder.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (ShoppingLocationFinder)

/**
 *  Check a location with respect to another location
 *
 *  @param newLocation New Locatiom
 *
 *  @return if Same Location 'Yes' else 'No'
 */

- (BOOL)isSameLocationWithLocation:(CLLocation *)newLocation;

@end

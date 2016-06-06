//
//  CLLocation+ShoppingLocationFinder.m
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import "CLLocation+ShoppingLocationFinder.h"

@implementation CLLocation (ShoppingLocationFinder)

- (BOOL)isSameLocationWithLocation:(CLLocation *)newLocation {
    
    return  self.coordinate.latitude == newLocation.coordinate.latitude
    && self.coordinate.longitude == newLocation.coordinate.longitude;
}
@end

//
//  LocationProviderHelper.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 26/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationProviderHelper : NSObject

+ (nonnull instancetype)sharedManager;

/**
 *  Initialize Location Manager
 *
 *  @param delegate   CLLocationManager Delegate
 *  @param completion Callback With CLLocationManager instant and isinitialized value
 */
- (void) initializeLocationManagerWithDelegate:(nonnull id)delegate
                                    completion:(void(^ _Nullable)( CLLocationManager *_Nullable locationManager, BOOL isinitialized))completion;


/**
 *  Open Settings
 */
- (void)openSettings;


/**
 *  Check Location mana ger authorized Or not
 */
+ (BOOL)isLocationManagerAuthorized;


/**
 *  Check that Network connection available or not
 *
 */
+ (BOOL)isReachable;



/**
 *  Get error message
 *
 *  @param error Corrosponding error
 *
 */

+ (nullable NSString *)getErrorMessageText:(nullable NSError *)error;
@end

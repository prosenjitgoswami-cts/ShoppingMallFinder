//
//  LocationProviderHelper.m
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 26/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import "LocationProviderHelper.h"
#import "Reachability.h"
#import "Constants.h"

@interface LocationProviderHelper ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationProviderHelper

static Reachability* reachability;
static LocationProviderHelper *sharedMyManager = nil;

/**
 *  sharedManager
 *
 *  @return return Self as LocationProviderHelper instant
 */

+ (nonnull instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
   
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
		[LocationProviderHelper createNetworkReachabilityNotification];

    });
    
    return sharedMyManager;
}

#pragma mark - Designated Initializer

- (instancetype)init {
    
	if(!sharedMyManager) {
		
		sharedMyManager = [super init];
		[LocationProviderHelper createNetworkReachabilityNotification];
	}
	
    return sharedMyManager;
}

+ (instancetype)new {
    
    return [LocationProviderHelper sharedManager];
}

#pragma mark - Internet Connection

/**
 *  Start notify reachability
 */
+ (void)createNetworkReachabilityNotification
{
	if(!reachability) {
		
		reachability = [Reachability reachabilityForInternetConnection];
		[reachability startNotifier];
	}
	
}


/**
 *  Check that Network connection available or not
 *
 */
+ (BOOL)isReachable
{
	return  [reachability isReachable];
}



#pragma mark - Public Method
/**
 *  Initialize Location Manager
 *
 *  @param delegate   CLLocationManager Delegate
 *  @param completion Callback With CLLocationManager instant and isinitialized value
 */

- (void) initializeLocationManagerWithDelegate:(nonnull id)delegate completion:(void(^ _Nullable)( CLLocationManager *_Nullable locationManager, BOOL isinitialized))completion {
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = delegate;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ) {
            
            /**
             * We never ask for authorization. Let's request it.
             */
            [self.locationManager requestWhenInUseAuthorization];
            
            if(completion)
                completion(self.locationManager, YES);
            
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            /**
             * We have authorization. Let's update location.
             */
            [self.locationManager startUpdatingLocation];
            
            if(completion)
                completion(self.locationManager, YES);
        } else {
            if(completion)
                completion(self.locationManager, NO);
        }
    } else {
        /**
         *  This is iOS 7 case
         */
        [self.locationManager startUpdatingLocation];
        
        if(completion)
            completion(self.locationManager, YES);
    }
}

/**
 *  Open Settings
 */

- (void)openSettings {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


/**
 *  Check Location manager authorized Or not
 */
+ (BOOL)isLocationManagerAuthorized {
	
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	
	
	return (status == kCLAuthorizationStatusAuthorizedWhenInUse
			|| status == kCLAuthorizationStatusAuthorizedAlways
			);
}

/**
 *  Get error message
 *
 *  @param error Corrosponding error 
 */

+ (nullable NSString *)getErrorMessageText:(nullable NSError *)error {
	
	NSString *message = @"";
	
	if(![LocationProviderHelper isReachable]) {
		
		message = kMessageCLErrorNetwork;
		
	} else {
		
		switch (error.code) {
				
			case kCLErrorLocationUnknown:
				
				message = kMessageCLErrorLocationUnknown;
				
				break;
			case kCLErrorDenied:
				
				message = kMessageCLErrorDenied;
				break;
				
			case kCLErrorNetwork:
				
				message = kMessageCLErrorNetwork;
				
				break;
				
			case kCLErrorGeocodeFoundNoResult:
			case kCLErrorGeocodeFoundPartialResult:
			case kCLErrorGeocodeCanceled:
				message = kMessageCLErrorGeocode;
				break;
				
				
			default:
				break;
		}
	}
	return message;
}
@end

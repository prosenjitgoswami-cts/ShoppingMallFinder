	//
	//  NearbyShoppingCentreListPresenter.m
	//  ShoppingMallFinder
	//
	//  Created by Prsenjit Goswami on 25/05/16.
	//  Copyright © 2016 Cognizant. All rights reserved.
	//

#import "NearbyShoppingCentreListPresenter.h"
#import "LocationProviderHelper.h"

@interface NearbyShoppingCentreListPresenter () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation NearbyShoppingCentreListPresenter

#pragma mark - Public Method


/**
 *  Fetch the Nearby Shopping Centre Details
 *
 *  @param location   Current Location as CLLocation
 *  @param completion Completion with  Success as BOOL and Results as NSArray
 */

- (void)getNearbyShoppingCentreForLocation:( CLLocation * _Nullable)location
								completion:(void( ^ _Nullable )(BOOL success, NSArray* _Nullable results))completion {
	
	
	/**
	 * If location is null, then Return
	 */
	if(location == nil) {
		
		/**
		 * Return in MainThread
		 */
		dispatch_main_async_safeBlock(^{
			
			if(completion)
				completion (NO, nil);
		});
		return;
	}
	
	
	/**
	 *  ***Here We want to get the nere by Shops wise result****
	 *  ***We only want to get shops result, so We passed 'shops' in section***
	 
	 
	 * @param Latitude: Latitude of Location
	 * @param longitude: longitude of Location
	 
	 * @param near: required unless ll is provided. A string naming a place in the world. If the near string is not geocodable, returns a failed_geocode error. Otherwise, searches within the bounds of the geocode and adds a geocode object to the response.
	 
	 * @param accuracyLL: Accuracy of latitude and longitude, in meters.
	 
	 * @param accuracyAlt: Altitude of the user's location, in meters.
	 
	 * @param query: A term to be searched against a venue's tips, category, etc. The query parameter has no effect when a section is specified.
	 
	 * @param limit: Number of results to return, up to 50.
	 
	 * @param offset: Used to page through results.
	 
	 * @param radius: Radius to search within, in meters. If radius is not specified, a suggested radius will be used based on the density of venues in the area.
	 
	 * ------------------------------------Section---------------------------------------
	 
	 *  @param :  One of food, drinks, coffee, shops, arts, outdoors, sights, trending or specials, nextVenues (venues frequently visited after a given venue), or topPicks (a mix of recommendations generated without a query from the user). Choosing one of these limits results to venues with the specified category or property.
	 
	 * ---------------------------------------------------------------------------------
	 
	 * @param novelty: Pass new or old to limit results to places the acting user hasn't been or has been, respectively. Omitting this parameter returns a mixture of old and new venues.
	 
	 * @param sortByDistance: Boolean flag to sort the results by distance instead of relevance.
	 
	 * @param openNow: Boolean flag to only include venues that are open now. This prefers official provider hours but falls back to popular check-in hours.
	 
	 * @param venuePhotos:  Boolean flag to include a photo in the response for each venue, if one is available. Default is 0 (no photos). Photos are returned as part of the venue JSON object.
	 
	 * @param price:  Comma separated list of price points. Currently the valid range of price points are [1,2,3,4], 1 being the least expensive, 4 being the most expensive. For food venues, in the United States, 1 is < $10 an entree, 2 is $10-$20 an entree, 3 is $20-$30 an entree, 4 is > $30 an entree.
	 
	 * @param callback: Callback results and success
	 
	 */
	
	
	__weak typeof(self) weakSelf = self;
	
	[Foursquare2 venueExploreRecommendedNearByLatitude:@(location.coordinate.latitude)
											 longitude:@(location.coordinate.longitude)
												  near:nil
											accuracyLL:nil
											  altitude:nil
										   accuracyAlt:nil
												 query:nil
												 limit:nil
												offset:nil
												radius:@(kDefaultRadiusInMeters)
											   section:kSectionTypeShop
											   novelty:nil
										sortByDistance:YES
											   openNow:YES
										   venuePhotos:NO
												 price:nil
											  callback:^(BOOL success, id result) {
												  
												  if (success) {
													  
													  NSDictionary *dic = result;
													  
													  id  response = [dic valueForKeyPath:@"response.groups.items.venue"];
													  
													  if(response && [response isKindOfClass:[NSArray class]]) {
														  
														  NSArray * responsResults = (NSArray *)response;
														  
														  if(responsResults &&  responsResults.count) {
															  
															  /**
															   * process data in othre thread and return callback should in main thread
															   */
															  
															  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
																  
																  NSArray* results  = [weakSelf processResultsData:[responsResults firstObject]];
																  
																  /**
																   * Return in MainThread
																   */
																  
																  dispatch_async(dispatch_get_main_queue(), ^{
																	  
																	  if(results && results.count) {
																		  
																		  if(completion)
																			  completion (YES, results);
																	  } else {
																		  
																		  if(completion)
																			  completion (NO, nil);
																	  }
																  });
															  });
														  }
													  }
													  
												  } else {
													  
													  /**
													   * Return in MainThread
													   */
													  dispatch_main_async_safeBlock (^{
														  
														  if(completion)
															  completion (NO, nil
																		  );
														  
													  });
												  }
											  }];
}


/**
 *  Get Location Information with respect to new CLLocation instants
 *
 *  @param newLocation       Instants of CLLocation
 *  @param completionHandler completionHandler with placemarks as NSArray, Error as NSError, Address as NSString
 */
- (void)getLocationInformationWithLocation:(CLLocation * _Nullable) newLocation
						 completionHandler:(void(^_Nullable)(NSArray * _Nullable placemarks, NSError * _Nullable error, NSDictionary* _Nullable addressInfoDict, NSString* _Nullable errorMessage))completionHandler {
	
	
	
	
	CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
	[geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
		
		
		void(^completion)(NSArray * _Nullable placemarks, NSError * _Nullable error, NSDictionary* _Nullable addressInfoDict);
		
		completion = ^(NSArray * _Nullable placemarks, NSError * _Nullable error, NSDictionary* _Nullable addressInfoDict) {
			
			
			NSString *errorMessage = [self getErrorMessageText:error];
			
			
			dispatch_main_async_safeBlock (^{
				
				if(completionHandler)
					completionHandler(placemarks,error,addressInfoDict,errorMessage);
			});
			
		};
		
		
		if (error || placemarks == nil || placemarks.count ==0 ){
			
			if(completion)
				completion(nil,error,nil);
			return;
			
		}
		
		CLPlacemark *placemark = [placemarks objectAtIndex:0];
		
		if (!placemark){
			
			if(completion)
				completion(nil,error,nil);
			return;
		}
		
		
		NSMutableString *address = [NSMutableString stringWithString:@""];
		
		NSMutableDictionary *_addressInfoDict = [NSMutableDictionary dictionary];
		
		if(placemark.name) {
			
			[_addressInfoDict setObject:placemark.name forKey:kName];
		}
		
		if(placemark.locality)
			[address appendStringWithCommaSeparator:placemark.locality];
		
		if(placemark.subLocality)
			[address appendStringWithCommaSeparator:placemark.subLocality];
		
		
		if(placemark.subThoroughfare)
			[address appendStringWithCommaSeparator:placemark.locality];
		
		if(placemark.country)
			[address appendStringWithCommaSeparator:placemark.country];
		
		if(placemark.postalCode)
			[address appendStringWithCommaSeparator:placemark.postalCode];
		
		
		if(address && ![address isNULLString]) {
			
			[_addressInfoDict setObject:address forKey:kAddress];

		}
		
		if(_addressInfoDict.count) {
		
			if(completion)
				completion(placemarks,error,_addressInfoDict);

		} else {
			
			if(completion)
				completion(placemarks,error,nil);
		}
		
	}];
}

/**
 *  Check that Location manager is authorized or not.
 *
 */
- (BOOL)isLocationManagerAuthorized {
	
	return [LocationProviderHelper isLocationManagerAuthorized];
}

/**
 *  Check that Network connection available or not
 *
 */
- (BOOL)isReachable {
	
	return [LocationProviderHelper isReachable];
}



#pragma mark - Private Method

/**
 *  Process the fetched data from API
 *
 *  @param shoppingCentreDetails Fetched Data as NSArray
 *
 *  @return Lists of results having 'ShoppingStation' objecct(s)
 */


- (nullable NSArray *)processResultsData:(nullable NSArray *)shoppingCentreDetails {
	
	NSMutableArray *processResults = [NSMutableArray array];
	
	NSInteger maxLimit = 0;
	
	for (NSDictionary *shoppingCentre  in shoppingCentreDetails) {
		
		/**
		 *  Maximun 15 venues will need to display
		 */
		if(maxLimit >= kNumberOfMaxLimit)
			continue;
		
		NSString *centreId = nil;
		
		NSArray *categories = shoppingCentre[kCategories];
		NSDictionary *categoriesDict = categories.firstObject;
		
		if (categoriesDict && [[categoriesDict allKeys]containsObject:kID]) {
			
			centreId = categoriesDict[kID];
		}
		
		/**
		 *  Get All result with have same id as '4bf58dd8d48988d1fd941735' Shopping Mall
		 */
		if(![centreId isNULLString]  && ![centreId isEqualToString:kIDShoppingMall])
			{
			continue;
			}
		
		NSString *name = shoppingCentre[kName];
		
		
		/**
		 *  First check the 'formattedAddresses' key value  in Location Dictionary
		 */
		NSArray *formattedAddresses = shoppingCentre[kLocation][kFormattedAddress];
		

		NSString *address = [self getFormattedAddress:formattedAddresses];
		
		/**
		 *  If formattedAddresses is null, then check 'address'	key value 
		 */
		if(!address || [address isNULLString])
			address = shoppingCentre[kLocation][kAddress];
		
		address = (address && ![address isNULLString]) ? address : @"";
		
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([shoppingCentre[kLocation][kLatitude] doubleValue],                                                                               [shoppingCentre[kLocation][kLongitude] doubleValue]);
		
		
		if(name && ![name isNULLString]) {
			
			ShoppingStation *shoppingStation = [[ShoppingStation alloc]initWithName:name                                                                            address:address coordinate:coordinate];
			
			[processResults addObject:shoppingStation];
			
			maxLimit += 1;
		}
		
	}
	
	return processResults;
}

/**
 *  Get formated Address
 *
 *  @param formattedAddressInfos Details of formattedAddress
 *
 */
- (NSString *)getFormattedAddress:(NSArray *)formattedAddressInfos
{
	
	NSMutableString *formattedAddress = [NSMutableString stringWithString:@""];
	
	for (NSString *obj in formattedAddressInfos) {
		
		[formattedAddress appendStringWithCommaSeparator:obj];
	}
	
	return formattedAddress;

}
/**
 *  Get error message
 *
 *  @param error Corrosponding error
 */

- (nullable NSString *)getErrorMessageText:(nullable NSError *)error {
	
	
	return [LocationProviderHelper getErrorMessageText:error];
}
@end

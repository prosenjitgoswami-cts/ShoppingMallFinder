//
//  Constants.h
//  ShoppingMallFinder
//
//  Created by Prsenjit Goswami on 25/05/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

#import "CLLocation+ShoppingLocationFinder.h"
#import "NSString+ShoppingMallFinder.h"
#import "UIAlertController+ShoppingMallFinder.h"


/**
 * 'dispatch_main_async_safeBlock' makes the block executes always in main thread
 *
 */
#define dispatch_main_async_safeBlock(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


/**
 * Enum
 */
typedef enum {
    kList = 0,
    kMap= 1,

}SegmentControlIndex;


/**
 * All Foursquare Constant Value
 */
static NSString* kClientId = @"5MP2HTKCJPI2MUMQKWRUJGXOFCABWX5U0CKHKSB1V5JUFXNZ";
static NSString* kSecretKey = @"HXUPJGCIGF2KDJJD3NTCKKBB3Z4AL1QYUE5DICXAF11GGL4V";
static NSString* kCallBackURL = @"ShoppingMallFinder://foursquare";
static CGFloat kDefaultRadiusInMeters = 20000.0;
static NSString* kSectionTypeShop = @"shops";
static CGFloat kNumberOfMaxLimit = 15;


/**
 *  Message Text
 */
static NSString* kMessageNoAuthorization = @"Please turn on your location settings and try again";
static NSString* kMessageNoDataFound = @"No data found";

static NSString* kDataLoadingMessage = @"Please wait...";

static NSString* kMessageCLErrorLocationUnknown= @"Location is currently unknown, Please try again";
static NSString* kMessageCLErrorDenied= @"Access to location has been denied by the user";
static NSString* kMessageCLErrorNetwork = @"Internet connection is not available, It will differ location accuracy";
static NSString* kMessageCLErrorGeocode = @"Location is currently unknown, Please check location settings";

/**
 * Button Title Text
 */
static NSString* kAltButtonTitleCancel = @"Cancel";
static NSString* kAltButtonTitleSettings = @"Settings";
static NSString* kAltButtonTitleOK = @"Ok";


/**
 * SegmentControl Button Title Text
 */
static NSString* kSegmentControlButtonTitleList = @"List";
static NSString* kSegmentControlButtonTitleMap = @"Map";


/**
 * Dictionary Key
 */
static NSString* kName = @"name";
static NSString* kID = @"id";
static NSString* kCategories = @"categories";
static NSString* kLocation = @"location";
static NSString* kDistance = @"distance";
static NSString* kAddress = @"address";
static NSString* kLongitude = @"lng";
static NSString* kLatitude = @"lat";
static NSString* kIDShoppingMall = @"4bf58dd8d48988d1fd941735";
static NSString* kFormattedAddress = @"formattedAddress";

/**
 * General
 */
static CGFloat kAnimationtime = 1.0f;

/**
 * Image Name
 */

static NSString* kUserLocationAnnotationImage = @"UserLocationAnnotationImage";
static NSString* kMallPlaceMarkAnnotationImage = @"MallPlaceMarkAnnotationImage";



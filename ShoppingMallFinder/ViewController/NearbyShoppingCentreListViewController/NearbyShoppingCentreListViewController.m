	//
	//  NearbyShoppingCentreListViewController.m
	//  ShoppingMallFinder
	//
	//  Created by Prsenjit Goswami on 25/05/16.
	//  Copyright © 2016 Cognizant. All rights reserved.
	//

#import "NearbyShoppingCentreListViewController.h"
#import "NearbyShoppingCentreListPresenter.h"
#import "ProgressHud.h"
#import "LocationProviderHelper.h"
#import "Constants.h"
@interface NearbyShoppingCentreListViewController () < CLLocationManagerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *errorMessageShowLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) ProgressHUD *progressHud;

@property (strong, nonatomic) id <NearbyShoppingCentreListProtocol> presenter;
@property (strong, nonatomic) NSArray *shoppingCenters;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *previousLocation;
@property (assign, nonatomic) BOOL isLocationSearching;
@property (assign, nonatomic) NSInteger selectedSegmentIndex ;
@property (strong, nonatomic) NSString *currentLocatationName ;

@end

@implementation NearbyShoppingCentreListViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad{
	
	[super viewDidLoad];
	
	self.presenter = [self getPresenter];
	
	[self initialUISetup];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	/**
	 * Location Manager set up
	 */
	[self locationManagerSetUp];
	
}

#pragma mark Dealloc

- (void) dealloc {
	
	_shoppingCenters = nil;
	_presenter = nil;
	_previousLocation = nil;
	_progressHud = nil;
	_locationManager = nil;
}


#pragma mark - Private Method

#pragma mark - Setter Nethod


/**
 * Set LocationInformation with currentLocationLabel in Label
 */
-(void)setCurrentLocatationName:(NSString *)currentLocatationName {
	
	_currentLocatationName = currentLocatationName;
	_currentLocationLabel.text = _currentLocatationName;
	
}

/**
 *  Reload Map And TableView
 */

- (void)reloadMapAndTableView {
	
	
	__weak typeof(self) weakSelf = self;

		// UI update in main thread
	dispatch_main_async_safeBlock (^{
		
		/**
		 *  Process Annotations
		 */
		[weakSelf proccessAnnotations];
		
		/**
		 *Reload Data
		 */
		[weakSelf.listTableView reloadData];
	});
	
}

#pragma mark Create UI

/**
 *  Set up UI
 */

-(void)initialUISetup {
	
	
	self.mapView.alpha = 0.0;
	self.listTableView.alpha = 1.0;
	self.errorMessageShowLabel.text = @"";
	
	self.selectedSegmentIndex = 0;
}


#pragma mark  Set up location manager

/**
 *  Set up location manager
 */

- (void) locationManagerSetUp {
	
	__weak typeof(self) weakSelf = self;
	
	[[LocationProviderHelper sharedManager] initializeLocationManagerWithDelegate:self completion:^( CLLocationManager *_Nullable locationManager, BOOL isinitialized) {
		
		weakSelf.locationManager = locationManager;
		weakSelf.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		weakSelf.mapView.showsUserLocation = YES;
		if(!isinitialized) {
			
			/**
			 * Show show User error alert when LocationManager is not initialized
			 */
			[weakSelf showUserErrorAlert];
			
		}
	}];
}

/**
 *  Updating Location
 */

- (void)updatingLocation
{
	if(self.locationManager && [CLLocationManager locationServicesEnabled]) {
		[self.locationManager startUpdatingLocation];
	}
}
#pragma mark Get Presenter

/**
 *  Get Presenter
 *
 *  @return NearbyShoppingCentreListPresenter as NearbyShoppingCentreListPresenter
 */

- (id <NearbyShoppingCentreListProtocol> )getPresenter {
	
	return  [NearbyShoppingCentreListPresenter new];
}

#pragma mark  User Error message and Alert

/**
 *  Show  error alert when location manager is not athorization
 */

- (void)showUserErrorAlert {
	
	
 dispatch_main_async_safeBlock (^{
	 
	 
	 
	 
	 
	 _currentLocationLabel.text = kMessageNoAuthorization;
	 
	 UIAlertController *alertController  = [UIAlertController showAlertControllerWithTitle:nil
																				   message:kMessageNoAuthorization defaultButtonTitle:kAltButtonTitleSettings cancelButtonTitle:kAltButtonTitleCancel defaultHandler:^(UIAlertAction *action) {
																					   [[LocationProviderHelper sharedManager] openSettings];
																				   }
																			 cancelHandler:nil];
	 
	 [self presentViewController:alertController animated:YES completion:nil];
 });
}


#pragma mark Set up location annotation in map

/**
 *  Set up map visible region
 *
 *  @param newLocation New CLLocation object
 */

- (void)setupMapForLocatoion:(CLLocation *)newLocation {
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.2;
	span.longitudeDelta = 0.2;
	CLLocationCoordinate2D location;
	location.latitude = newLocation.coordinate.latitude;
	location.longitude = newLocation.coordinate.longitude;
	region.span = span;
	region.center = location;
	[self.mapView setRegion:region animated:YES];
}

/**
 *  Remove previous annotations and plot new annotations in map
 */

- (void)proccessAnnotations {
	
	[self removeAllAnnotationExceptOfCurrentUser];
	[self.mapView addAnnotations:self.shoppingCenters];
}

/**
 *    Remove previous annotations in map
 */

- (void)removeAllAnnotationExceptOfCurrentUser {
	NSMutableArray *annotationForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
	if ([self.mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
		[annotationForRemove removeObject:self.mapView.annotations.lastObject];
	} else {
		for (id <MKAnnotation> annot_ in self.mapView.annotations) {
			if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
				[annotationForRemove removeObject:annot_];
				break;
			}
		}
	}
	
	[self.mapView removeAnnotations:annotationForRemove];
}

#pragma mark Progress Loader

/**
 *  Show progress loader with message
 *
 *  @param message User define message
 */

-(void)showProgressLoaderWithMessage:(NSString *)message {
	
	
	if(!_progressHud) {
		
		_progressHud = [ProgressHUD showHUDAddedTo:self.view animated:YES];
		
	}
	
	_progressHud.labelText = message;
}

/**
 *  Hide and remove progress loader with message
 *
 */

-(void)hideProgressLoader {
	
	if(_progressHud)  {
		
		void(^completion)(void) = ^{
			
			[_progressHud removeFromSuperview];
			_progressHud = nil;
		};
		
		
		[_progressHud hide:NO afterDelay:0.4f];
		[_progressHud setCompletionBlock:completion];
		
	}
}


#pragma mark Segment Control Click Event

/**
 *  SegmentedControl Clicked Event
 *
 *  @param segment SegmentedControl
 */
- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
	
	
	
	if(self.selectedSegmentIndex == sender.selectedSegmentIndex) return;
	
	
	__weak typeof(self) weakSelf = self;
	
	[self toggleViewOnSegmentControlClicked:sender.selectedSegmentIndex completion:^{
		
		if(![weakSelf.presenter isLocationManagerAuthorized]) {
			
			[weakSelf showUserErrorAlert];
			
			[weakSelf reloadMapAndTableView];
			
		} else {
			
			/**
			 * Get LocationInformation with location and Display in Label
			 */
			[self updateWithLocationInformationOrMessageMessage:nil];
			[weakSelf reloadMapAndTableView];
			
			[weakSelf updatingLocation];
			
		}
		
		weakSelf.selectedSegmentIndex = sender.selectedSegmentIndex;
	}];
	
	
}

/**
 *  Toggole view on segment control clicked
 *
 *  @param index Index of selected Segment contron index
 */


- (void)toggleViewOnSegmentControlClicked:(NSInteger)index
							   completion:(void(^)(void))completion {
	
	
	__weak typeof(self) weakSelf = self;
	
	BOOL isListSelected = (index == kList);
	
	weakSelf.listTableView.alpha = isListSelected ;
	weakSelf.mapView.alpha = !weakSelf.listTableView.alpha ;
	
	
	[UIView transitionWithView: self.containerView
					  duration:kAnimationtime
					   options:(index == kMap )? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
					animations:^{
						
						if(isListSelected)
							weakSelf.mapView.alpha = 0.0;
						else
							weakSelf.listTableView.alpha = 0.0;
						
					} completion:^(BOOL finished) {
						
						if(completion)
							completion ();
					}];
	
}


#pragma mark  Update Message

/**
 *  It will update the Message in differnt condition
 *
 */
- (void)updateWithLocationInformationOrMessageMessage:(void(^ _Nullable)(NSString * _Nullable message, NSString *_Nullable errorMessage))completion {
	
	
	__weak typeof(self) weakSelf = self;
	
	
	[self.presenter getLocationInformationWithLocation:self.previousLocation completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error, NSDictionary* _Nullable addressInfoDict, NSString* _Nullable errorMessage)
	 {
	 
	
	 /**
	  * Turn off showsUserLocation when internet is not available
	  * because it will differ location accuracy
	  */
	 self.mapView.showsUserLocation = [self.presenter isReachable];
	 
	 
	 
	 NSMutableString *address = [NSMutableString stringWithString:@""];
	 
	 if(addressInfoDict && addressInfoDict[kName])
		 {
		 [address appendStringWithCommaSeparator: addressInfoDict [kName]];
		 
		 }
	 
	 if(addressInfoDict && addressInfoDict [kAddress])
		 {
		 [address appendStringWithCommaSeparator: addressInfoDict [kAddress]];
		 
		 }
	 
	 if(error == nil && address && ![address isNULLString]) {
		 
		 [weakSelf setCurrentLocatationName:address];
		 
		 
		 if(completion)
			 completion (address, nil);
		 
	 } else {
		 
		 self.previousLocation = nil;
		 self.shoppingCenters  = nil;
		 
		 [weakSelf setCurrentLocatationName:errorMessage];
		 
		 if(completion)
			 completion (errorMessage, nil);
	 }
	 
	 }];
	
}


#pragma mark - Location Manager Delegate
#pragma mark -


/**
 *  LocationManager did update with newLocation and oldLocation
 */

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray<CLLocation *> *)locations {
	
	
	/**
	 *  Get new locations
	 */
	CLLocation *newLocation = nil;
	
	if(locations.count) {
		
		newLocation = [locations firstObject];
	}
	
	
	
	/**
	 *  When Location is searching its return
	 */
	if(self.isLocationSearching || !newLocation) return;
	
	/**
	 * When new location is not available, its return
	 */
	if(self.previousLocation && [self.previousLocation isSameLocationWithLocation:newLocation]) return;
	
	/**
	 * Stop location Manager UpdatingLocation
	 */
	[self.locationManager stopUpdatingLocation];
	
	
	/**
	 * Show Progress Loader
	 */
	[self showProgressLoaderWithMessage:kDataLoadingMessage];
	
	self.isLocationSearching = YES;
	
	__weak typeof(self) weakSelf = self;
	
	
	
	[self.presenter getNearbyShoppingCentreForLocation:newLocation completion:^(BOOL success, NSArray * result) {
		
		
		/**
		 * Assign results in 'shoppingCenters' array
		 */
		weakSelf.shoppingCenters =  result;
		
		
		/**
		 *  Reload Map and Table view
		 */
		[weakSelf reloadMapAndTableView];
		
		
		/**
		 * Set up Map visible region
		 */
		[weakSelf setupMapForLocatoion:newLocation];
		
		
		
		/**
		 * Assign New Location
		 */
		weakSelf.previousLocation = newLocation;
		
		
		/**
		 * Get LocationInformation with location and Display in Label
		 */
		[self updateWithLocationInformationOrMessageMessage:^(NSString * _Nullable message, NSString * _Nullable errorMessage) {
			
			/**
			 * Hide and Remove ProgressLoader
			 */
			[weakSelf hideProgressLoader];
			
			
			/**
			 * Re initialise 'isLocationSearching'
			 */
			weakSelf.isLocationSearching = NO;
			
			
		}];
		
	}];
}


/**
 * LocationManager did fail with error
 */

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	
	/**
	 * Stop location Manager UpdatingLocation
	 */
	[self.locationManager stopUpdatingLocation];
	
	
	/**
	 * update Message
	 */
	[self updateWithLocationInformationOrMessageMessage:nil];
	
	
	/**
	 * Reload Map and table view
	 */
	[self reloadMapAndTableView];
}


/**
 *  LocationManager did change authorization status
 */

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse
		|| status == kCLAuthorizationStatusAuthorizedAlways) {
		
		self.previousLocation = nil;
		
		/**
		 * Start UpdatingL ocation
		 */
		[manager startUpdatingLocation];
	}
}

#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView *userAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
	
	if (userAnnotationView == nil)  {
		userAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
	}
	else
		userAnnotationView.annotation = annotation;
	
	userAnnotationView.enabled = YES;
	userAnnotationView.canShowCallout = YES;
	
	if(userAnnotationView.annotation == mapView.userLocation) {
		
		/**
		 * Set user location annotation Image
		 */
		userAnnotationView.image = [UIImage imageNamed:@"UserLocationAnnotationImage"];
		
		/**
		 * Get Current location name
		 */
		CLLocation *location = [[CLLocation alloc]initWithLatitude:mapView.userLocation.coordinate.latitude longitude:mapView.userLocation.coordinate.longitude];
		
		__weak typeof(self) weakSelf = self;
		
		[self.presenter getLocationInformationWithLocation:location completionHandler:^(NSArray * _Nullable placemarks, NSError * _Nullable error, NSDictionary* _Nullable addressInfoDict, NSString* _Nullable errorMessage) {
			
			
		 /**
		  * Turn off showsUserLocation when internet is not available
		  * because it will differ location accuracy
		  */
		 self.mapView.showsUserLocation = [self.presenter isReachable];
		 
		 NSMutableString *address = [NSMutableString stringWithString:@""];
		 
			
			if(addressInfoDict && addressInfoDict[kName]) {
			 
			 weakSelf.mapView.userLocation.title =  addressInfoDict[kName];
			 [address appendStringWithCommaSeparator: addressInfoDict [kName]];
			 
			 }
		 
		 if(addressInfoDict && addressInfoDict [kAddress]) {
			
			 weakSelf.mapView.userLocation.subtitle =  addressInfoDict [kAddress];
			 [address appendStringWithCommaSeparator: addressInfoDict [kAddress]];
			 
			 }
		 
		 [weakSelf setCurrentLocatationName:address];
		 
			
		 }];
		
	} else {
		
		/**
		 * Set mall placeMark location annotation Image
		 */
		userAnnotationView.image = [UIImage imageNamed:@"MallPlaceMarkAnnotationImage"];
		
		
	}
	
	
	
	return userAnnotationView;
	
	
}
#pragma mark - Table view data source
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger rows = self.shoppingCenters.count;
	
	_errorMessageShowLabel.alpha = (rows==0)? 1 : 0;
	
	tableView.alpha = _errorMessageShowLabel.alpha ? 0.2 : 1.0;
	
	if(rows==0)
		_errorMessageShowLabel.text = kMessageNoDataFound;
	
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(!cell) {
		
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
		
	}
	
	if(indexPath.row < self.shoppingCenters.count) {
		
		ShoppingStation *shoppingCentre = self.shoppingCenters[indexPath.row];
		
		if(shoppingCentre && shoppingCentre.name.length) {
			
			
			/**
			 * ShoppingCentre Name
			 */
			NSString *placeName  = shoppingCentre.name;
			placeName = (placeName && ![placeName isNULLString]) ? placeName : @"";
			
			
			/**
			 *  Set 'Name' value in cell textLabel
			 */
			cell.textLabel.text = placeName;
			
			/**
			 * ShoppingCentre Address
			 */
			NSString *address = shoppingCentre.getAddress;
			
			/**
			 * Set 'Address' value in cell detailTextLabel
			 */
			if(address && ![address isNULLString]) {
				cell.detailTextLabel.text = address;
			}
		}
	}
	
	
	/**
	 * Set cell selectionStyle
	 */
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	
	/**
	 * Set cell backgroundColor
	 */
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}


@end

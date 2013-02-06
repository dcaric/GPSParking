//
//  WhereIAmView.m
//  LocalWeather
//
//  Created by Dario Caric on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WhereIAmView.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "SampleConstants.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


/*
@implementation CLLocationManager (TemporaryHack)

- (void)hackLocationFix
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil]; 
}

- (void)startUpdatingLocation
{
    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
}
@end
*/

@implementation WhereIAmView
@synthesize labelTown1;
@synthesize labelTown2;
@synthesize labelTown3;
@synthesize labelTown4;
@synthesize button;

@synthesize mapView;

@synthesize textTable, textTop;
@synthesize SMS;

@synthesize adBannerView;

@synthesize locationManager;


@synthesize labelTel, labelZone, labelPrice, labelZone1;
@synthesize adBanner = adBanner_;

//@synthesize file;
//@synthesize fileIndex;
//@synthesize fileZonePri;
//@synthesize fileZoneZone;
//@synthesize fileZoneTown;
//@synthesize fileZoneTel;
//@synthesize fileZoneStreet;



int alertType;

UIAlertView *progressAlert;

float latitudeNew;
float longitudeNew;

NSString *country;
NSString *town;
NSString *city;
NSString *street, *oldstreet;
NSString *number;
BOOL flagAlert = FALSE;

NSString *priceGlobal;

bool parkingZoneB = FALSE;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




// Here we're creating a simple GADRequest and whitelisting the simulator
// and two devices for test ads. You should request test ads during development
// to avoid generating invalid impressions and clicks.
- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    //Make the request for a test ad
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,                               // Simulator
                           nil];
    
    return request;
    
    
}

#pragma mark GADBannerViewDelegate impl

// Since we've received an ad, let's go ahead and set the frame to display it.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
   // NSLog(@"Received ad");
    
    [UIView animateWithDuration:1.0 animations:^ {
        adView.frame = CGRectMake(0.0, 48.0, 320.0, 100.0);
        
        
    }];
    
    
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
   // NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [banner setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [banner setHidden:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Do any additional setup after loading the view from its nib.
 
    
/*    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0, 45.0, 320.0, 95.0)];
    adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
    adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [adBannerView setHidden:YES];
    adBannerView.delegate = self;
*/
    
    // load image into UIButton **************************************************************
	[button addTarget:self action:@selector(loadURL) forControlEvents:UIControlEventTouchUpInside];

    
    GADRequest *request = [GADRequest request];
    
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,                                           // Simulator
                           @"dfae22c03d980e656787d6af5e3249e8bd881110",                                          // Test iOS Device
                           nil];
    
    // Note that the GADBannerView checks its frame size to determine what size
    // creative to request.
    
    //Initialize the banner off the screen so that it animates up when displaying
    self.adBanner = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 48.0, 320.0, 100.0)];
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
    // before compiling.
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self createRequest]];   
    
    [self.view addSubview:adBannerView];
    
    textTable.layer.cornerRadius = 10;
    textTop.layer.cornerRadius = 10;
 

    
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
    
    
    self.title = NSLocalizedString(@"GPS lociranje", @"");
    


}

/*
-(IBAction) loadUrl2:(id) sender
{
    
   // NSLog(@"loadUrl2");
    
	
	// save web url **********************************************************************
	NSString *url =[NSString stringWithFormat:@"http://www.dcapps.net"];    // set url to correct table	
	NSURL *updateWEB = [NSURL URLWithString:url];
	[[UIApplication sharedApplication] openURL:updateWEB];
}
*/



-(IBAction) sendInAppSMS:(id) sender
{

    
    if ([labelZone.text isEqualToString:@""])
    {
        UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"Pričekajte da GPS locira ulicu."
                                                                message: nil
                                                               delegate: self
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
        [progressAlert show];
    }
    
    
    else if (parkingZoneB == FALSE) {
        UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"Za ovu ulicu ne postoji usluga SMS parkinga."
                                                                message: nil
                                                               delegate: self
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
        [progressAlert show];
    }
    

        
    else
    {
       // myTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(sendSMS) userInfo:nil repeats:NO];
        
        halfHour = false;
        alertType = 2;
        
        if ([labelTown1.text isEqualToString:@"City of Zagreb"] && [labelZone1.text isEqualToString:@"1"])
        {
            UIAlertView *MyAlerView = [[UIAlertView alloc] initWithTitle:@"Želite li platiti 30min ili 1h"
                                                                 message:@"" delegate:self cancelButtonTitle:@"30min" otherButtonTitles:@"1h", nil];
            
            [MyAlerView show];
            
        }
        else if ([labelTown1.text isEqualToString:@"Zagreb"] && [labelZone1.text isEqualToString:@"1"])
        {
            UIAlertView *MyAlerView = [[UIAlertView alloc] initWithTitle:@"Želite li platiti 30min ili 1h"
                                                                 message:@"" delegate:self cancelButtonTitle:@"30min" otherButtonTitles:@"1h", nil];
            
            [MyAlerView show];
            
        }
        else [self sendSMS];
    }
}


-(void) sendSMS
{
    
    NSString *carTable;
    
    // find registration to send ***********************************************
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Mylist16.plist"];
    
   NSArray *file = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    int arraySeize = [file count];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
         
   
    for (int i=0; i<arraySeize; i++) {
        
        articleArray[i] = [file objectAtIndex:i];
        [array addObject:articleArray[i]];
    }
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"Index16.plist"];
    
    NSString * strIndex;
    BOOL thereIsMarkedCar = FALSE;
    
    NSArray *fileIndex = [[NSArray alloc] initWithContentsOfFile:fullFileName];
//    int arraySeizeIndex = [fileIndex count];

    for (int i=0; i<arraySeize; i++) {
        
        strIndex = [fileIndex objectAtIndex:i];
        checkArray[i] = [strIndex intValue];
    }
    
    for (int i=0; i<arraySeize; i++) {
        if (checkArray[i] == 1) {
                carTable = articleArray[i];
                thereIsMarkedCar = TRUE;
        }
    }
        
    
    
     if (halfHour) carTable = [[NSString alloc] initWithFormat:@"%@%@", carTable, @"#30"];
    
    if (thereIsMarkedCar == TRUE) {
        
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = carTable;
            controller.recipients = [NSArray arrayWithObjects:labelTel.text, nil];
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
    }
    
    else
    {
        alertType = 3;
        UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"Nemate ni jedne tablice auta markirane."
                                                                message: nil
                                                               delegate: self
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
        [progressAlert show];

        
    }

    

}





- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	SMS.highlighted = NO;
	switch (result)
	{
		case MessageComposeResultCancelled:
			SMS.text = @"Plačanje je otkazano";
		//	NSLog(@"Result: canceled");

            

            

			break;
		case MessageComposeResultSent:
        {
            SMS.text = @"Poruka poslana";
            //	NSLog(@"Result: sent");
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.yyyy"];
            
            NSString *strDate=[formatter stringFromDate:[NSDate date]];
            //NSString *strDate = [formatter stringFromDate:datePicker.date];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryPath = [paths objectAtIndex:0];
            NSString *fullFileName = [documentsDirectoryPath
                                      stringByAppendingPathComponent:@"Date.plist"];
            
            
            NSArray *fileDate = [[NSArray alloc] initWithContentsOfFile:fullFileName];
            
            NSString *dateStr = [fileDate objectAtIndex:0];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            if ([dateStr length] == 0) {
                [array addObject:strDate];
                [array writeToFile:fullFileName atomically:NO];
                
            }
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath
                            stringByAppendingPathComponent:@"Sum.plist"];
            
            NSArray *fileSum = [[NSArray alloc] initWithContentsOfFile:fullFileName];
            NSString *sumStr = [fileSum objectAtIndex:0];
            
            
            int sumInt = [sumStr intValue];
            
            priceGlobal = [labelPrice.text stringByReplacingOccurrencesOfString:@"Cijena je " withString:@""];
            priceGlobal = [priceGlobal stringByReplacingOccurrencesOfString:@" HRK" withString:@""];
            
            int priceNow = [priceGlobal intValue];
            
            sumInt = sumInt + priceNow;
            sumStr = [NSString stringWithFormat:@"%u",sumInt];
            array = [[NSMutableArray alloc] init];
            [array addObject:sumStr];
            [array writeToFile:fullFileName atomically:NO];

        }
			break;
            
            
		case MessageComposeResultFailed:
		//	SMS.text = @"Neuspjelo slanje";
		//	NSLog(@"Result: failed");
			break;
		default:
		//	SMS.text = @"Uspješno plačanje";
		//	NSLog(@"Result: not sent");
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    if (![CLLocationManager locationServicesEnabled]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location servis je isključen u vašim postavkama"
                    message:@"'Možete koristiti zone spremljene u Favorite listi."
                    delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil];
        [alert show];     
    }    

    
/*
    MKUserLocation *userLocation = mapView.userLocation;
    
    if (!userLocation.location) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location servis je isključen u vašim postavkama." 
                                                        message:@"Možete koristiti zone spremljene u Favorite listi." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
*/
    else {
        

    
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Lociranje ..."
												message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	
	[progressAlert show];
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the progressAlert
	indicator.center = CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 50);
	[indicator startAnimating];
	[progressAlert addSubview:indicator];
    
    flagAlert = FALSE;
    
    [locationManager startUpdatingLocation];

    oldstreet = @"";

    parkingZoneB = FALSE;
    labelTown1.text =  @"";
    labelTown2.text =  @"";
    labelTown3.text =  @"";
    labelTown4.text =  @"";
    
    labelTel.text =  @"";
    labelPrice.text =  @"";
    labelZone.text =  @"";
    labelZone1.text =  @"";
    SMS.text =  @"";

    myTimer9 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(stopGPS) userInfo:nil repeats:NO];

//    NSLog(@"viewdidapper");
    }

}

/*
- (IBAction) whereIAm
{
    
    parkingZoneB = FALSE;
    labelTown1.text =  @"";
    labelTown2.text =  @"";
    labelTown3.text =  @"";
    labelTown4.text =  @"";

    labelTel.text =  @"";
    labelPrice.text =  @"";
    labelZone.text =  @"";
    labelZone1.text =  @"";
    SMS.text =  @"";

    

    progressAlert = [[UIAlertView alloc] initWithTitle:@"Lociranje ..."
												message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	
	[progressAlert show];
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the progressAlert
	indicator.center = CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 50);
	[indicator startAnimating];
	[progressAlert addSubview:indicator];

    
//    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    [locationManager startUpdatingLocation];
      [self stopGPS];
    
}
*/

- (IBAction) stopGPS
{
    if (!(flagAlert)) {
        [progressAlert dismissWithClickedButtonIndex:0 animated:YES];     
        flagAlert = TRUE;
    }
    
//    [locationManager stopUpdatingLocation];


    myTimer10 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(stopGPS) userInfo:nil repeats:NO];
    //NSLog(@"stopGPS");
    
    street = [street stringByReplacingOccurrencesOfString:@" 0" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 1" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 2" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 3" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 4" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 5" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 6" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 7" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 8" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" 9" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"0" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"1" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"2" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"3" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"4" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"5" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"6" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"7" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"8" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@"9" withString:@""];

    
    street = [street stringByReplacingOccurrencesOfString:@"-" withString:@""];
    street = [street stringByReplacingOccurrencesOfString:@" -" withString:@""];


// this part is set only during testing ********************
//    city = @"City of Zagreb";
//    city = @"Zagreb";
//    street = @"Izidora Kršnjavoga";
//    street = @"Maksimirska cesta 12";
// *********************************************************    

    
    labelTown1.text = city;
    labelTown2.text = country;
    labelTown3.text = street;

    
    // here should be part for php scripts to fetch parking zone and price ************
    
    NSString *cityEncode = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                               NULL,
                                                                               (CFStringRef)city,
                                                                               NULL,
                                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                               kCFStringEncodingUTF8 );	
    
    NSString *streetEncode = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)street,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8 );
    
    
   // NSLog(@"oldstreet =%@",oldstreet);
   // NSLog(@"street =%@",street);
    
    
    if (![oldstreet isEqualToString:street])
    {

        oldstreet = street;
        
    
        NSString *longitideStr = [NSString stringWithFormat:@"%6.5f",longitudeNew];
        NSString *latitudeStr = [NSString stringWithFormat:@"%6.5f",latitudeNew];
        
// for testing
//        latitudeStr = @"45.8190";
        
//        NSLog(@"latitude = %@",latitudeStr);

    
        NSString *urlbase = @"http://www.dcapps.net/checkforparking1.php?city=";
        NSString *urlstr = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@", urlbase, cityEncode, @"&street=", streetEncode, @"&latitude=", latitudeStr, @"&longitude=", longitideStr];
    
//    NSLog(@"URL = %@", urlstr);
    

    
    
        NSURL *url = [[NSURL alloc] initWithString:urlstr];
        NSString *updatePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"parkingzone.plist"];
        NSData *myData = [NSData dataWithContentsOfURL:url]; 	
        [myData writeToFile:updatePath atomically:NO];

    
    
    // ********************************************************************************
    
    
        NSArray *fileZone = [[NSArray alloc] initWithContentsOfFile:updatePath];
    
    
    
        NSString *zone = [fileZone objectAtIndex:0];
        NSString *tel = [fileZone objectAtIndex:1];
        NSString *price = [fileZone objectAtIndex:2];
    
        labelZone1.text = zone;  // new

    
//    NSLog(@"zone = %@", zone);
    
        if (![zone isEqualToString:@"NA"]) {
            zone =[[NSString alloc] initWithFormat:@"%@%@", @"Nalazite se u zoni ", zone];
            price =[[NSString alloc] initWithFormat:@"%@%@%@", @"Cijena je ", price, @" HRK"];
            priceGlobal = price;

        
            labelZone.text = zone;
            labelTel.text = tel;
            labelPrice.text = price;

        
        
            parkingZoneB = TRUE;
        }
    
        else
        {
            labelZone.text = @"Za ovu ulicu nema";
            labelPrice.text = @"SMS parkinga";
            parkingZoneB = FALSE;

        }




    }
}


// this delegate is called when the app successfully finds your current location

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
//{
//    
//    NSLog(@"location");
//    
//    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
//    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
//    geoCoder.delegate = self;
//    [geoCoder start];
//    
//    
//    latitudeNew = newLocation.coordinate.latitude;
//	  longitudeNew = newLocation.coordinate.longitude;
//
//
//}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    [self.locationManager stopUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
        MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
        geoCoder.delegate = self;
        [geoCoder start];
           
        latitudeNew = newLocation.coordinate.latitude;
        longitudeNew = newLocation.coordinate.longitude;
    }
    

    else {
        
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * placemark in placemarks) {
                
                latitudeNew = newLocation.coordinate.latitude;
                longitudeNew = newLocation.coordinate.longitude;

                
                country = placemark.country;
                street = placemark.thoroughfare;
//                city = placemark.subLocality ;
                city = placemark.locality ;
                

                
            }    
        }];
        
    }

}




-(IBAction) saveInFavorite:(id) sender
{
  if (parkingZoneB == TRUE) {
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"ZoneTown.plist"];
    
    
    NSArray *fileZoneTown = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    int arraySeize = [fileZoneTown count];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        favoriteArray[i] = [fileZoneTown objectAtIndex:i];
        [array addObject:favoriteArray[i]];
    }
      
      
    [array addObject:labelTown1.text];
    [array writeToFile:fullFileName atomically:NO];
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"ZoneStreet.plist"];
    
    
    NSArray *fileZoneStreet = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    arraySeize = [fileZoneStreet count];
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        
        favoriteStArray[i] = [fileZoneStreet objectAtIndex:i];
        [array addObject:favoriteStArray[i]];
    }
    [array addObject:labelTown3.text];
    [array writeToFile:fullFileName atomically:NO];

    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZoneTel.plist"];
    
    
    NSArray *fileZoneTel = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    arraySeize = [fileZoneTel count];
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        
        favoriteStArray[i] = [fileZoneTel objectAtIndex:i];
        [array addObject:favoriteStArray[i]];
    }
    [array addObject:labelTel.text];
    [array writeToFile:fullFileName atomically:NO];

    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZonePrice.plist"];
    
    
    NSArray *fileZonePri = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    arraySeize = [fileZonePri count];
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        
        favoritePriArray[i] = [fileZonePri objectAtIndex:i];
        [array addObject:favoritePriArray[i]];
    }
    [array addObject:labelPrice.text];
    [array writeToFile:fullFileName atomically:NO];

    
    
    

    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZoneZone.plist"];
    
    
    NSArray *fileZoneZone = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    arraySeize = [fileZoneZone count];
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        
        favoriteZonArray[i] = [fileZoneZone objectAtIndex:i];
        [array addObject:favoriteZonArray[i]];
    }
    [array addObject:labelZone1.text];
    [array writeToFile:fullFileName atomically:NO];


}
    
  else
  {
      UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"To nije ispravna parking zona."
                                                              message: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"OK"
                                                    otherButtonTitles: nil];
      [progressAlert show];
    
  }


}


// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}
// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        MKPlacemark * myPlacemark = placemark;
        // with the placemark you can now retrieve the city name
        city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
        country = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryKey];
        street = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStreetKey];
    }
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}



- (void)viewDidDisappear:(BOOL)animated
{
    
   // NSLog(@"viewdiddisapper");
    [locationManager stopUpdatingLocation];
    [myTimer10 invalidate];

    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (IBAction) reportZone
{
    
    
    if ([labelZone.text isEqualToString:@""])
    {
        UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"Pričekajte da GPS locira ulicu."
                                                                message: nil
                                                               delegate: self
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
        [progressAlert show];
    }
    

    else
    {
        
        alertType = 1;
        
        UIAlertView *insertScore = [UIAlertView new];
        [insertScore setDelegate:self];
        [insertScore setTitle:@"Da li se radi o gradovima Split, Zagreb, Osijek ili Rijeka"];
        [insertScore addButtonWithTitle:@"Ne"];
        [insertScore addButtonWithTitle:@"Da"];
        //    [[insertScore textField] setDelegate:self];
        
        [insertScore show];     
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alertType == 2)
    {
        if (buttonIndex == 0)
        {
            
            halfHour = TRUE;
            [self sendSMS];
        }
        else
        {
           [self sendSMS];
        }
    }
    else if (alertType == 3)
    {

        // do nothing
    }
    else
    {
        if (buttonIndex == 1)
        {
            
           myTimer1 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showEmailModalView10) userInfo:nil repeats:NO];
        }
        else
        {
            
        }
    }
}

/*
- (IBAction) showEmailModalView10
{
    
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //    [locationManager startUpdatingLocation];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showEmailModalView100) userInfo:nil repeats:NO];
    
    
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Priprema maila ..." 
												message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	
	[progressAlert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the progressAlert
	indicator.center = CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 50);
	[indicator startAnimating];
	[progressAlert addSubview:indicator];
    
    
}
*/


- (void) showEmailModalView100 {
    
    
    [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    //    [locationManager stopUpdatingLocation];
    
    
    NSString *strLatitude = [NSString stringWithFormat:@"%10.5f",latitudeNew];
    NSString *strLongitude = [NSString stringWithFormat:@"%10.5f",longitudeNew];
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self; // <- very important step if you want feedbacks on what the user did with your email sheet
    
    //    NSString *meiladdress = @"dcaric@me.com";
    
    [picker setSubject:@"GPSParking 3.0"];
    //    [picker setToRecipients:meiladdress];
    [picker setToRecipients:[NSArray arrayWithObject:@"dcaric@me.com"]];
    
    // Fill out the email body text
    //    NSString *body = @"&body=";
    //NSString *emailBody = mainStr;
    //    [NSString stringWithFormat:@"d", @"dario", pageLink, iTunesLink];
    //    [NSString stringWithFormat:@"d"];
    
    NSString *mainStr = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"Unesite u bazu podataka i ovo parkirno mjesto.", @"\n", @"\n", @"latitude= ", strLatitude, @"\n", @"longitude= ", strLongitude, @"\n", @"Grad=", city, @"\n", @"Ulica=", street, @"\n", @"\n", @"==============================", @"\n"];	    
    
    
    NSString *emailbody = mainStr;
    
    [picker setMessageBody:emailbody isHTML:NO]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentModalViewController:picker animated:YES];

    
    
    
}

/*
- (IBAction) showEmailModalView20 {

        //  save url for new app **********************************************************************
        NSError* error;
        NSString *url=[NSString stringWithFormat:@"%@", @"http://www.dcapps.net"];	
        NSURL *updateWEB = [NSURL URLWithString:url];
        NSString *strUrl = [NSString stringWithContentsOfURL:updateWEB encoding:NSASCIIStringEncoding error:&error];
        
        // save web url **********************************************************************
        url=[NSString stringWithFormat:@"%@", strUrl];	
        updateWEB = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:updateWEB];
    
   // NSLog(@"showEmailModalView20");
    
}
*/


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error "
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}



@end

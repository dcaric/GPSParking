//
//  InfoView.m
//  CroForecast
//
//  Created by Dario Caric on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoView.h"


@implementation InfoView


@synthesize button;
@synthesize textTable;
@synthesize textTable1;
@synthesize textTable2;
@synthesize country;
@synthesize town, city, street, number;


/*
NSString *country;
NSString *town;
NSString *city;
NSString *street;
NSString *number;
*/

float latitudeNew;
float longitudeNew;
int alertType;


UIAlertView *progressAlert;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (IBAction) showEmailModalView10
{
    
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    [locationManager startUpdatingLocation];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showEmailModalView100) userInfo:nil repeats:NO];

    
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Lociranje ..." 
												message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
	
	[progressAlert show];

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the progressAlert
	indicator.center = CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 50);
	[indicator startAnimating];
	[progressAlert addSubview:indicator];

    
}




- (IBAction) showEmailModalView20 {
    
    
   
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
    
    NSString *mainStr = @"";	    
    
    
    NSString *emailbody = mainStr;
    
    [picker setMessageBody:emailbody isHTML:NO]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentModalViewController:picker animated:YES];
    
    
    
    
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geoCoder.delegate = self;
    [geoCoder start];

    
	latitudeNew = newLocation.coordinate.latitude;
	longitudeNew = newLocation.coordinate.longitude;
	
}



// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    //    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}
// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    MKPlacemark * myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
//    country = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryKey];
    street = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStreetKey];

    number = [placemark addressDictionary];
//	NSLog(@"The geocoder has returned: %@", [placemark addressDictionary]);

    
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);
}



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
        
        NSString *mainStr = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"Unesite u bazu podataka i ovo parkirno mjesto.", @"\n", @"\n", @"latitude= ", strLatitude, @"\n", @"longitude= ", strLongitude, @"\n", @"Grad=", city, @"\n", @"Ulica=", street, @"\n", @"row tekst:", @"\n", @"==============================", number, @"\n",@"==============================", @"\n"];	    
    
    
        NSString *emailbody = mainStr;
        
        [picker setMessageBody:emailbody isHTML:NO]; // depends. Mostly YES, unless you want to send it as plain text (boring)
        
        picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
        
        [self presentModalViewController:picker animated:YES];

    
        

    
}


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



- (IBAction) reportZone
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


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
  
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Info";
    textTable.layer.cornerRadius = 10;
    textTable1.layer.cornerRadius = 10;
    textTable2.layer.cornerRadius = 10;


    //[button setImage:[UIImage imageNamed:@"title.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(loadURL) forControlEvents:UIControlEventTouchUpInside];
    
    

}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}
*/


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    
  
    
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd.MM.yyyy"];
	
    NSString *strDate=[formatter stringFromDate:[NSDate date]];
	//NSString *strDate = [formatter stringFromDate:datePicker.date];
	lblDate.text = strDate;	
    */
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Date.plist"];
    
    NSArray *fileDate = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    lblDate.text = [fileDate objectAtIndex:0];

    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Sum.plist"];
    
    NSArray *fileSum = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    NSString *sumTemp = [fileSum objectAtIndex:0];
    sumTemp =[[NSString alloc] initWithFormat:@"%@%@", sumTemp, @" HRK"];
    lblSum.text = sumTemp;

    
}






- (IBAction) deleteAll;
{
    alertType = 0;
    
    UIAlertView *insertScore = [UIAlertView new];
    [insertScore setDelegate:self];
    [insertScore setTitle:@"Resetiraj brojač"];
    [insertScore addButtonWithTitle:@"Odustani"];
    [insertScore addButtonWithTitle:@"Potvrdi"];
//    [[insertScore textField] setDelegate:self];
    
    [insertScore show];     
    


}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
    if (alertType == 0) {
     if (buttonIndex == 1)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryPath = [paths objectAtIndex:0];
            NSString *fullFileName = [documentsDirectoryPath 
                                      stringByAppendingPathComponent:@"Date.plist"];
            
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:@""];
            [array writeToFile:fullFileName atomically:NO];
            
            lblDate.text = @"";
            
            
            
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath 
                            stringByAppendingPathComponent:@"Sum.plist"];
            
            array = [[NSMutableArray alloc] init];
            [array addObject:@""];
            [array writeToFile:fullFileName atomically:NO];
            
            
            lblSum.text = @" 0 HRK";
            
        }
        
        else
        {
            //NSLog(@"cancel");
            
            
        }
        
    }
    
   else if (alertType == 1) {
       if (buttonIndex == 1)
       {
       
           myTimer1 = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showEmailModalView10) userInfo:nil repeats:NO];
       }
       else
       {
           
       }
       
       
   }
}


- (void) loadURL
{
	
	
	// save web url **********************************************************************
	NSString *url =[NSString stringWithFormat:@"http://www.dcapps.net"];    // set url to correct table	
	NSURL *updateWEB = [NSURL URLWithString:url];
	[[UIApplication sharedApplication] openURL:updateWEB];
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

@end

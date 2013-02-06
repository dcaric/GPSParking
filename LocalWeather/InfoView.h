//
//  InfoView.h
//  CroForecast
//
//  Created by Dario Caric on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface InfoView : UIViewController
<MKReverseGeocoderDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate>
{
    CLLocationManager *locationManager;

    NSTimer *myTimer;
    NSTimer *myTimer1;

    IBOutlet UIButton *button;

    IBOutlet UITextView *textTable;
    IBOutlet UITextView *textTable1;
    IBOutlet UITextView *textTable2;
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblSum;
    
    NSString *country;
    NSString *town;
    NSString *city;
    NSString *street;
    NSString *number;

}
@property (nonatomic, retain)  NSString *country;
@property (nonatomic, retain)  NSString *town;
@property (nonatomic, retain)  NSString *city;
@property (nonatomic, retain)  NSString *street;
@property (nonatomic, retain)  NSString *number;


@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UITextView *textTable;
@property (nonatomic, retain) IBOutlet UITextView *textTable1;
@property (nonatomic, retain) IBOutlet UITextView *textTable2;


- (IBAction) deleteAll;
- (IBAction) reportZone;

@end

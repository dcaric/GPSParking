//
//  WhereIAmView.h
//  LocalWeather
//
//  Created by Dario Caric on 6/18/11.
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
#import <iAd/iAd.h>
#import "GADBannerViewDelegate.h"

@class GADBannerView, GADRequest;


@interface WhereIAmView : UIViewController 
<GADBannerViewDelegate, ADBannerViewDelegate, MFMessageComposeViewControllerDelegate, MKReverseGeocoderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *SMS;

    
    GADBannerView *adBanner_;

    ADBannerView *adBannerView;

    CLLocationManager *locationManager;
	NSTimer *myTimer;
    NSTimer *myTimer1;
    NSTimer *myTimer9;
    NSTimer *myTimer10;
    
    IBOutlet UITextView *textTable;
    IBOutlet UITextView *textTop;
    NSString *articleArray [100];
    int checkArray [100];

//    NSArray *file;
//    NSArray *fileIndex;
//    NSArray *fileZonePri;
//    NSArray *fileZoneZone;
//    NSArray *fileZoneTown;
//    NSArray *fileZoneStreet;
//    NSArray *fileZoneTel;
    
    
    NSString *favoriteArray [100];
    NSString *favoriteStArray [100];
    NSString *favoriteTelArray [100];
    NSString *favoritePriArray [100];
    NSString *favoriteZonArray [100];

    
	IBOutlet UILabel *labelTown1;
	IBOutlet UILabel *labelTown2;
	IBOutlet UILabel *labelTown3;
	IBOutlet UILabel *labelTown4;

	IBOutlet UIButton *button;


    IBOutlet UILabel *labelZone;
    IBOutlet UILabel *labelZone1;
	IBOutlet UILabel *labelTel;
	IBOutlet UILabel *labelPrice;
    
    IBOutlet MKMapView *mapView;

    NSString *rowArray [500];
    
    BOOL halfHour;

}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property(nonatomic, retain) ADBannerView *adBannerView;

@property (nonatomic, retain) CLLocationManager *locationManager;  

@property (nonatomic, retain) IBOutlet UILabel *labelZone;
@property (nonatomic, retain) IBOutlet UILabel *labelZone1;
@property (nonatomic, retain) IBOutlet UILabel *labelTel;
@property (nonatomic, retain) IBOutlet UILabel *labelPrice;

@property(nonatomic, retain) GADBannerView *adBanner;

- (GADRequest *)createRequest;


//@property (nonatomic, retain) NSArray *file;
//@property (nonatomic, retain) NSArray *fileIndex;
//@property (nonatomic, retain) NSArray *fileZonePri;
//@property (nonatomic, retain) NSArray *fileZoneZone;
//@property (nonatomic, retain) NSArray *fileZoneTown;
//@property (nonatomic, retain) NSArray *fileZoneStreet;
//@property (nonatomic, retain) NSArray *fileZoneTel;


@property (nonatomic,retain) UILabel *SMS;

@property (nonatomic, retain) IBOutlet UITextView *textTable;
@property (nonatomic, retain) IBOutlet UITextView *textTop;

//- (IBAction) whereIAm;
@property (nonatomic, retain) IBOutlet UILabel *labelTown1;
@property (nonatomic, retain) IBOutlet UILabel *labelTown2;
@property (nonatomic, retain) IBOutlet UILabel *labelTown3;
@property (nonatomic, retain) IBOutlet UILabel *labelTown4;


-(IBAction) sendInAppSMS:(id) sender;
-(IBAction) saveInFavorite:(id) sender;
//-(IBAction) showEmailModalView20;
//-(IBAction) loadUrl2:(id) sender;

@end

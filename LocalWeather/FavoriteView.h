//
//  ListViewController.h
//  Supermarket
//
//  Created by Dario Caric on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

#define kFillingComponent  0
#define kBreadComponent  1


@interface FavoriteView : UIViewController
<UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, UIWebViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

{
    /*	NSArray *file;
     NSArray *fileIndex;
     NSArray *filePrice;
     NSArray *fileAmount;
     NSArray *fileMainDate;
     */
    
    IBOutlet UILabel *SMS;

	UIButton *selectButton;
	UISwitch				*switchCtl;
	UISwitch				*switchCtl1;
    
	NSArray					*dataSourceArray;
    
    NSString *articleArray [100];
    int checkArray [100];
    float priceArray [100];
    float amountArray [100];
    NSString *mainDataArray [100];
    
    
    NSArray *fillingTypes;
	NSArray *breadTypes;
    
    
    
    
    IBOutlet UITableView *tableView1;
	NSTimer *myTimer;
	NSTimer *myTimer1;
	NSTimer *myTimer2;
    
    IBOutlet UILabel *label;
    IBOutlet UILabel *labelSum;
	UIPickerView		*myPickerView;
	NSArray				*pickerViewArray;
	UIDatePicker *datePicker;
    
	IBOutlet UIWebView *webUrl;
    IBOutlet UITextView *textFrame;
    
    
    NSString *favoriteArray [100];
    NSString *favoriteStArray [100];
    NSString *favoriteTelArray [100];
    NSString *favoritePriArray [100];
    NSString *favoriteZonArray [100];

    
/*
    NSArray *fileZoneTown;
    NSArray *fileZoneStreet;
    NSArray *fileZoneTel;
    NSArray *fileZonePri;
    NSArray *fileZoneZone;
*/    
    
    
}

/*
@property (nonatomic, retain) NSArray *fileZoneTown;
@property (nonatomic, retain) NSArray *fileZoneStreet;
@property (nonatomic, retain) NSArray *fileZoneTel;
@property (nonatomic, retain) NSArray *fileZonePri;
@property (nonatomic, retain) NSArray *fileZoneZone;
*/


@property (nonatomic,retain) UILabel *SMS;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;


@property (nonatomic, retain, readonly) UIButton *selectButton;
@property (nonatomic, retain, readonly) UISwitch *switchCtl;
@property (nonatomic, retain, readonly) UISwitch *switchCtl1;
@property (retain, nonatomic) UIWebView *webUrl;

@property (nonatomic, retain) NSArray *dataSourceArray;
//@property (nonatomic, retain) IBOutlet UITableView *myList;
@property (nonatomic, retain) IBOutlet UITextView *textFrame;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UILabel *labelSum;
@property (nonatomic, retain) UIPickerView *myPickerView;
@property (nonatomic, retain) NSArray *pickerViewArray;
@property (nonatomic, retain) UIDatePicker *datePicker;

@property (nonatomic,retain)  NSArray *fillingTypes;
@property (nonatomic,retain)  NSArray *breadTypes;

//- (IBAction) deleteOptions;
// - (IBAction) showAlertView;
//- (IBAction) saveTable;
//- (IBAction) selectSupermarket:(id)sender;

//- (IBAction) sendToSarver;

//- (IBAction)allMarkers:(id)sender;

@end

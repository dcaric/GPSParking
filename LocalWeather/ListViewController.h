//
//  ListViewController.h
//  Supermarket
//
//  Created by Dario Caric on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFillingComponent  0
#define kBreadComponent  1


@interface ListViewController : UIViewController
<UITextFieldDelegate, UIActionSheetDelegate>

{


	NSArray					*dataSourceArray;
    
    NSString *articleArray [100];
    NSString *articleArrayName [100];
    int checkArray [100];

//    NSArray *file;
//    NSArray *fileIndex;
    
    
    NSArray *fillingTypes;
	NSArray *breadTypes;

    
    
//    NSMutableArray *array;

    IBOutlet UITableView *tableView1;
	NSTimer *myTimer;
	NSTimer *myTimer1;
	NSTimer *myTimer2;
    
    IBOutlet UILabel *label;
    IBOutlet UITextField *textField1;

    IBOutlet UILabel *labelSum;
	UIPickerView		*myPickerView;
	NSArray				*pickerViewArray;
	UIDatePicker *datePicker;

	IBOutlet UIWebView *webUrl;
    IBOutlet UITextView *textFrame;


}
//@property (nonatomic, retain) NSArray *file;
//@property (nonatomic, retain) NSArray *fileIndex;


@property (nonatomic, retain) IBOutlet UITableView *tableView1;

@property (nonatomic, retain) NSArray *dataSourceArray;
@property (nonatomic, retain) IBOutlet UITextView *textFrame;

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextField *textField1;


- (IBAction) deleteOptions;
- (IBAction) showAlertView;



@end

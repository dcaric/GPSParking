//
//  ListViewController.m
//  Supermarket
//
//  Created by Dario Caric on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoriteView.h"
//#import "Constants.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <QuartzCore/QuartzCore.h>

@implementation FavoriteView

@synthesize dataSourceArray;
@synthesize labelSum;
@synthesize label;
@synthesize selectButton;
@synthesize switchCtl;
@synthesize switchCtl1;
@synthesize tableView1;
@synthesize myPickerView;
@synthesize pickerViewArray;
@synthesize datePicker;
@synthesize fillingTypes;
@synthesize breadTypes;


/*
@synthesize fileZoneTown;
@synthesize fileZoneStreet;
@synthesize fileZoneTel;
@synthesize fileZonePri;
@synthesize fileZoneZone;
*/

UIAlertView *progressAlert;


@synthesize SMS;

int arraySeize;
int arraySizeMainDate;
int globalIndex;
int sheetType;
int alertType;
int globalCheck1 = 0;


int arraySeizeWhole;

NSString *globalPrice;
NSString *supermarketName;
int articleCounter;
@synthesize webUrl;
@synthesize textFrame;


//  Set up for Activity indicator BEGIN *************************************************

#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
    self.webUrl.delegate = self; // setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webUrl stopLoading];   // in case the web view is still loading its content
    self.webUrl.delegate = nil;  // disconnect the delegate as the webview is hidden
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // starting the load, show the activity indicator in the status bar
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



//  Set up for Activity indicator END *************************************************



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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    tableView1.backgroundColor = [UIColor clearColor];
	tableView1.alpha = 0.99;
    textFrame.layer.cornerRadius = 10;
    
    
    globalCheck1 = 0 ;
    

    
    self.title = NSLocalizedString(@"Favorite", @"");
    
    
    
	self.editing = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"ZoneTown.plist"];
    
    NSArray *fileZoneTown = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    arraySeize = [fileZoneTown count];
    
    for (int i=0; i<arraySeize; i++) {
        
        favoriteArray[i] = [fileZoneTown objectAtIndex:i];
    }
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZoneStreet.plist"];
    
    NSArray *fileZoneStreet = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    
    for (int i=0; i<arraySeize; i++) {
        
        favoriteStArray[i] = [fileZoneStreet objectAtIndex:i];
    }
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZoneTel.plist"];
    
    NSArray *fileZoneTel = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    
    for (int i=0; i<arraySeize; i++) {
        
        favoriteTelArray[i] = [fileZoneTel objectAtIndex:i];
    }
    
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZonePrice.plist"];
    
    NSArray *fileZonePri = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    
    for (int i=0; i<arraySeize; i++) {
        
        favoritePriArray[i] = [fileZonePri objectAtIndex:i];
    }
    
    
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"ZoneZone.plist"];
    
    NSArray *fileZoneZone = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    
    for (int i=0; i<arraySeize; i++) {
        
        favoriteZonArray[i] = [fileZoneZone objectAtIndex:i];
    }
   
    [tableView1 reloadData];
    

}









- (void)viewDidUnload
{
    [super viewDidUnload];
    
	selectButton = nil;
    
    self.dataSourceArray = nil;	// this will release and set to nil
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// *********************************************************************************

/*
- (IBAction) deleteOptions
{
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self cancelButtonTitle:@"Poništi" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Briši selektirane", @"Briši sve", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
    //	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}
*/







// TABLE **********************************************************************************************

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //	return file.count;
    return arraySeize;
    
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    /*
     UITableViewCell	*cell =
     [tableView dequeueReusableCellWithIdentifier:@"cell"];
     
     // create a cell
     if (cell == nil)
     {
     cell = [[UITableViewCell alloc]
     initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:@"cell"];
     
     }
     */
    
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    
    cell = [self getCellContentView:CellIdentifier];
    // retrieve image
    /*
     NSString *imagefile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"checkboxempty"];
     UIImage *ui = [[UIImage alloc] initWithContentsOfFile:imagefile];
     
     cell.imageView.image = ui;
     */
    
    
    //	cell.textLabel.text = articleArray [indexPath.row];
    
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
    // UIImage *lblTemp2 = (UIImage *)[cell viewWithTag:2];
    UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
    UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];

    //	UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
	
    //    cell.textLabel.text = [articleArray objectAtIndex:indexPath.row];
    
	lblTemp2.text = favoriteArray [indexPath.row];
    lblTemp1.text = favoriteStArray [indexPath.row];    
    lblTemp3.text = favoritePriArray [indexPath.row];   
    NSString *zoneStr = favoriteZonArray [indexPath.row];  
    zoneStr =[[NSString alloc] initWithFormat:@"%@%@", @"Zona ", zoneStr];
    lblTemp4.text = zoneStr;
	
	//cell.textColor = [UIColor yellowColor];
	//cell.font = [UIFont systemFontOfSize:14.0];
	
    
    
	// set subtitle text
	//cell.detailTextLabel.text=@"Subtitle go here";
	
	// accessory type

	
	// return cell
	return cell;
	
}


- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 320, 90);
	CGRect Label1Frame = CGRectMake(15, 23, 290, 33);
	CGRect Label2Frame = CGRectMake(15, 3, 290, 20);
    CGRect Label3Frame = CGRectMake(15, 40, 200, 50);
    CGRect Label4Frame = CGRectMake(200, 40, 290, 50);
//	CGRect Label3Frame = CGRectMake(200, 3, 290, 30);
//	CGRect Label4Frame = CGRectMake(200, 20, 290, 50);
	UILabel *lblTemp;
	
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier];
	
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
    //	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.font = [UIFont systemFontOfSize:18];
	[cell.contentView addSubview:lblTemp];
	lblTemp.textColor = [UIColor purpleColor];
    //	lblTemp.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:216.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    lblTemp.backgroundColor = [UIColor clearColor];
    
	
	//Initialize Label with tag 2.
	
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:18];
	lblTemp.textColor = [UIColor blackColor];
    //	lblTemp.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:216.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    lblTemp.backgroundColor = [UIColor clearColor];
    
	[cell.contentView addSubview:lblTemp];
	
	
	//Initialize Label with tag 3.
	
	lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	lblTemp.tag = 3;
	lblTemp.font = [UIFont systemFontOfSize:16];
	lblTemp.textColor = [UIColor redColor];
    //	lblTemp.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:216.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    lblTemp.backgroundColor = [UIColor clearColor];
    
	[cell.contentView addSubview:lblTemp];
	

    
    //Initialize Label with tag 4.
	
	lblTemp = [[UILabel alloc] initWithFrame:Label4Frame];
	lblTemp.tag = 4;
	lblTemp.font = [UIFont systemFontOfSize:16];
	lblTemp.textColor = [UIColor redColor];
    //	lblTemp.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:216.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    lblTemp.backgroundColor = [UIColor clearColor];
    
	[cell.contentView addSubview:lblTemp];
	 
	
	
	return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//[self.navigationController pushViewController:self.ditailSearchResult animated:YES];
	
	//Engine *myEngine = [Engine sharedInstance];
	
	//int arraySeizeInt = [(arraySeize / 2) intValue];
	
	
    for (int i=0; i<arraySeize; i++) {
		
		if (indexPath.row == i) {
            
            globalIndex= indexPath.row;
            
            /*
             UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"IBRIŠI OVAJ RED"
             message: @""
             delegate: self
             cancelButtonTitle: @"ODUSTANI"
             otherButtonTitles: @"BRIŠI", nil];
             [progressAlert show];
             */
            sheetType = 0;
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self cancelButtonTitle:@"Odustani" destructiveButtonTitle:@"Izbriši red" otherButtonTitles:@"Plati parking", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            //            [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
            [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
            
			
			
		}
	}
    
	
}



#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sheetType == 0) {
        
        
        if (buttonIndex == 0)
        {

            
            arraySeize--;
            for (int i=0; i<arraySeize; i++) {
                
                if (i >= globalIndex) {
                    favoriteArray[i] = favoriteArray[i+1];
                    favoriteStArray[i] = favoriteStArray[i+1];
                    favoriteTelArray[i] = favoriteTelArray[i+1];
                    favoritePriArray[i] = favoritePriArray[i+1];
                    favoriteZonArray[i] = favoriteZonArray[i+1];
                    
                    
                }
            }
            

            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryPath = [paths objectAtIndex:0];
            NSString *fullFileName = [documentsDirectoryPath 
                                      stringByAppendingPathComponent:@"ZoneTown.plist"];
            
            
            
            NSMutableArray *arrayS = [[NSMutableArray alloc] init];
            for (int i=0; i<arraySeize; i++) {
                [arrayS addObject:favoriteArray[i]];
            }
            [arrayS writeToFile:fullFileName atomically:NO];
            
            
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath 
                            stringByAppendingPathComponent:@"ZoneStreet.plist"];
            
            
            
            arrayS = [[NSMutableArray alloc] init];
            for (int i=0; i<arraySeize; i++) {
                [arrayS addObject:favoriteStArray[i]];
            }
            [arrayS writeToFile:fullFileName atomically:NO];
            
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath 
                            stringByAppendingPathComponent:@"ZoneTel.plist"];
            
            arrayS = [[NSMutableArray alloc] init];
            for (int i=0; i<arraySeize; i++) {
                [arrayS addObject:favoriteTelArray[i]];
            }
            [arrayS writeToFile:fullFileName atomically:NO];
            
            
            
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath 
                            stringByAppendingPathComponent:@"ZonePrice.plist"];
            
            arrayS = [[NSMutableArray alloc] init];
            for (int i=0; i<arraySeize; i++) {
                [arrayS addObject:favoritePriArray[i]];
            }
            [arrayS writeToFile:fullFileName atomically:NO];
            
            
            
            
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath 
                            stringByAppendingPathComponent:@"ZoneZone.plist"];
            
            arrayS = [[NSMutableArray alloc] init];
            for (int i=0; i<arraySeize; i++) {
                [arrayS addObject:favoriteZonArray[i]];
            }
            [arrayS writeToFile:fullFileName atomically:NO];
            
            
            
            [tableView1 reloadData];
            
            
        }
        
        else if (buttonIndex == 1)
        {

            
            myTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(sendSMS) userInfo:nil repeats:NO];

        }
        
        else
        {
            //NSLog(@"cancel");
        }
        
        
    }
    
    
    if (sheetType == 1)
    {
        if (buttonIndex == 0)
        {
            if (checkArray[globalIndex] == 0) {
                checkArray[globalIndex] = 1;
            }
            else
            {
                checkArray[globalIndex] = 0;
            }
            
            for (int i=0; i<arraySeize; i++) {
                if (i != globalIndex) {
                    checkArray[i] = 0;
                }
            }
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectoryPath = [paths objectAtIndex:0];
            NSString *fullFileName = [documentsDirectoryPath 
                                      stringByAppendingPathComponent:@"Index16.plist"];
            
            NSString *strIndex;
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<arraySeize; i++) {
                strIndex = [NSString stringWithFormat:@"%u",checkArray[i]];
                [array addObject:strIndex];
            }
            [array writeToFile:fullFileName atomically:NO];
            
            //        myTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(checkSum) userInfo:nil repeats:NO]; 
            
            
            [tableView1 reloadData];
            
        }
        if (buttonIndex == 1)
        {
            myTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(alertArticleName) userInfo:nil repeats:NO];
        }
        else
        {
            //NSLog(@"cancel");
        }
        
        
    }
    
    
    if (sheetType == 2)
    {
        if (buttonIndex == 0)
        {
            NSInteger fillingRow = [myPickerView selectedRowInComponent:kFillingComponent];
            supermarketName = [fillingTypes objectAtIndex:fillingRow];
            
            myTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(sendToServerProcedure) userInfo:nil repeats:NO];   
            
            
            
            
        }
        if (buttonIndex == 1)
        {
            
        }
        else
        {
            //NSLog(@"cancel");
        }
        
        
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
    
    if (thereIsMarkedCar == TRUE) {
        
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = carTable;
            controller.recipients = [NSArray arrayWithObjects:favoriteTelArray[globalIndex], nil];
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
    }
    
    else
    {
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
            
            NSMutableArray *arrayA = [[NSMutableArray alloc] init];
            
            if ([dateStr length] == 0) {
                [arrayA addObject:strDate];
                [arrayA writeToFile:fullFileName atomically:NO];
            }
            
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDirectoryPath = [paths objectAtIndex:0];
            fullFileName = [documentsDirectoryPath
                            stringByAppendingPathComponent:@"Sum.plist"];
            
            NSArray *fileSum = [[NSArray alloc] initWithContentsOfFile:fullFileName];
            NSString *sumStr = [fileSum objectAtIndex:0];
            
            int sumInt = [sumStr intValue];
            
            NSString *priceStr = [favoritePriArray[globalIndex] stringByReplacingOccurrencesOfString:@"Cijena je " withString:@""];
            priceStr = [priceStr stringByReplacingOccurrencesOfString:@" HRK" withString:@""];
            
            int priceNow = [priceStr intValue];
            
            sumInt = sumInt + priceNow;
            sumStr = [NSString stringWithFormat:@"%u",sumInt];
            arrayA = [[NSMutableArray alloc] init];
            [arrayA addObject:sumStr];
            [arrayA writeToFile:fullFileName atomically:NO];
        }
            
			break;
		case MessageComposeResultFailed:
			//SMS.text = @"Neuspjelo slanje";
            //	NSLog(@"Result: failed");
			break;
		default:
			//SMS.text = @"Uspješno plačanje";
            //	NSLog(@"Result: not sent");
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}


/*
- (void) editSheet
{
    sheetType = 1;
    
    NSString *strMarker;
    
    if (checkArray[globalIndex] == 1) {
        strMarker = @"Ukloni marker";
    }
    else
    {
        strMarker = @"Stavi marker";
        
    }
//    NSString *strPriceOne = [NSString stringWithFormat:@"%7.2f",priceArray[globalIndex]];
//    NSString *strAmountOne = [NSString stringWithFormat:@"%7.2f",amountArray[globalIndex]];
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:strMarker otherButtonTitles:@"Izmijeni tablicu", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    // [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}
*/



#pragma mark UIAlertViewDelegate methods 

/*
- (IBAction) saveTable
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Mylist16.plist"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        [array addObject:articleArray[i]];
    }
    [array writeToFile:fullFileName atomically:NO];
    
    
}
 */

// ******************************************************************************************************


- (void)action:(id)sender
{
	//NSLog(@"UIButton was clicked");
}

// ********************************************************************************************



#pragma mark -
#pragma mark UIPickerViewDelegate



/*
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init]];
 //[formatter setDateFormat:@"MMM dd, yyyy"];
 [formatter setDateFormat:@"yyyy-MM-dd"];
 
 NSString *strDate = [formatter stringFromDate:myPickerView.date];
 labelCalendar.text = strDate;	
 }
 */


/*
-(IBAction)selectSupermarket:(id)sender 
{
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Provjera internet veze..." 
                                                message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
    [progressAlert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the progressAlert
    indicator.center = CGPointMake(progressAlert.bounds.size.width / 2, progressAlert.bounds.size.height - 40);
    [indicator startAnimating];
    [progressAlert addSubview:indicator];
    
    
    NSString *urlAddress = @"http://www.dcapps.net/supermarket.txt";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webUrl loadRequest:requestObj];
}
 */

-(void)selectSheet
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Index16.plist"];
    
    NSString * strIndex;
    int counter = 0;
    NSArray *fileIndex = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    
    for (int i=0; i<arraySeize; i++) {
        
        strIndex = [fileIndex objectAtIndex:i];
        if ([strIndex isEqualToString:@"1"]) {
            counter++;
        }
        
    }
    
    
    if (counter != 0) 
    {    
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        
        sheetType = 2;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                      initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Selektiraj supermarket gdje su artikli kupljeni", @"")]
                                      delegate:self cancelButtonTitle:@"Odustani" destructiveButtonTitle:nil otherButtonTitles:@"Potvrdi", nil];
        //	[actionSheet showInView:self.view];
        [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
        
        //UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        myPickerView = [[UIPickerView alloc] init];
        
        myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
        
        // this view controller is the data source and delegate
        myPickerView.delegate = self;
        myPickerView.dataSource = self;
        [actionSheet addSubview:myPickerView];
        
        NSInteger fillingRow = [myPickerView selectedRowInComponent:kFillingComponent];
        supermarketName = [fillingTypes objectAtIndex:fillingRow];
        
        
        
        
        
        //	myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(setDate1) userInfo:nil repeats:YES];
    }
    else
    {
        // write ALERT **************************************************************************	
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Upozorenje!"
                                                            message: @"Nema markiranih artikala na listi."
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
        
    }
	
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	if (component == kBreadComponent)
		return[self.breadTypes count];
	return[self.fillingTypes count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView
			titleForRow:(NSInteger)row
		   forComponent:(NSInteger)component 
{
	if (component == kBreadComponent)
		return [self. breadTypes objectAtIndex:row];
	return [self.fillingTypes objectAtIndex:row];
}



#pragma mark -
#pragma mark UITextViewDelegate
/*
- (void)clearAction:(id)sender
{
	// finish typing text/dismiss the keyboard by removing it as the first responder
	//
	// self.navigationItem.rightBarButtonItem = nil;	// this will remove the "save" button
    
    arraySeize = 0;
    for (int i=0; i<arraySeize; i++) {
        
        articleArray[i] = @"";
        checkArray[i] = 0;
        priceArray[i] = 0.0;
        amountArray[i] = 0.0;
        
    }
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Mylist16.plist"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        [array addObject:articleArray[i]];
    }
    [array writeToFile:fullFileName atomically:NO];
 
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"Index16.plist"];
    
    NSString *strIndex;
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        strIndex = [NSString stringWithFormat:@"%u",checkArray[i]];
        [array addObject:strIndex];
    }
    [array writeToFile:fullFileName atomically:NO];
 
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"Price16.plist"];
    
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        strIndex = [NSString stringWithFormat:@"%7.2f",priceArray[i]];
        [array addObject:strIndex];
    }
    [array writeToFile:fullFileName atomically:NO];
    
    
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [paths objectAtIndex:0];
    fullFileName = [documentsDirectoryPath 
                    stringByAppendingPathComponent:@"Amount16.plist"];
    
    
    array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        strIndex = [NSString stringWithFormat:@"%7.2f",amountArray[i]];
        [array addObject:strIndex];
    }
    [array writeToFile:fullFileName atomically:NO];
 
    
    //    myTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(checkSum) userInfo:nil repeats:NO]; 
    [tableView1 reloadData];
    
    
    
}
*/


/*
- (IBAction)allMarkers:(id)sender
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Index16.plist"];
    
    NSString *strIndex;
    
    globalCheck1;
    if (globalCheck1 == 0) {
        globalCheck1 = 1;
    }
    else
    {
        globalCheck1 = 0;
    }
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<arraySeize; i++) {
        checkArray[i] = globalCheck1;
        strIndex = [NSString stringWithFormat:@"%u",checkArray[i]];
        [array addObject:strIndex];
    }
    [array writeToFile:fullFileName atomically:NO];
    //    myTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(checkSum) userInfo:nil repeats:NO];
    [tableView1 reloadData];
    
    
    
}
*/





@end

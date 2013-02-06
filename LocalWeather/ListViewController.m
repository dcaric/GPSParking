//
//  ListViewController.m
//  Supermarket
//
//  Created by Dario Caric on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
//#import "Constants.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <QuartzCore/QuartzCore.h>

@implementation ListViewController

@synthesize dataSourceArray;
@synthesize label;
@synthesize tableView1;

//@synthesize file;
//@synthesize fileIndex;


UIAlertView *progressAlert;

int arraySeize;
int arraySizeMainDate;
int globalIndex;
int sheetType;
int alertType;
int internetConnection = 0;
int globalCheck = 0;

NSString *globalPrice;
NSString *supermarketName;
int articleCounter;
@synthesize textFrame;

@synthesize textField1;



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

    
    globalCheck = 0 ;

    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *fullFileName = [documentsDirectoryPath 
                              stringByAppendingPathComponent:@"Mylist16.plist"];

    NSArray *file = [[NSArray alloc] initWithContentsOfFile:fullFileName];
    arraySeize = [file count];
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
    
    NSArray *fileIndex = [[NSArray alloc] initWithContentsOfFile:fullFileName];

    for (int i=0; i<arraySeize; i++) {

       strIndex = [fileIndex objectAtIndex:i];
        checkArray[i] = [strIndex intValue];
    }


     
    self.title = NSLocalizedString(@"Auta", @"");

    
   
	self.editing = NO;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    

    self.dataSourceArray = nil;	// this will release and set to nil

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
// *********************************************************************************


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
        [ui release];
     */

    
//	cell.textLabel.text = articleArray [indexPath.row];

	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
//	UIImage *lblTemp2 = (UIImage *)[cell viewWithTag:2];
//	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    
     //	UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
	
//    cell.textLabel.text = [articleArray objectAtIndex:indexPath.row];
    
    
//    NSLog(@"table= %@",articleArray [indexPath.row]);

    
	lblTemp1.text = articleArray [indexPath.row];    // date
//	lblTemp2.text = [file objectAtIndex:indexPath.row ];    // date
//	lblTemp3.text = [file1 objectAtIndex:indexPath.row];  // text, comment
	
	cell.textLabel.textColor = [UIColor yellowColor];
	cell.textLabel.font = [UIFont systemFontOfSize:14.0];
	
    
    
	// set subtitle text
	//cell.detailTextLabel.text=@"Subtitle go here";
	
	// accessory type
    if (checkArray[indexPath.row] == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// return cell
	return cell;
	
}


- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 320, 60);
	CGRect Label1Frame = CGRectMake(15, 15, 270, 25);
	CGRect Label2Frame = CGRectMake(15, 3, 270, 10);
	//CGRect Label3Frame = CGRectMake(20, 60, 290, 25);
	UILabel *lblTemp;
	
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier];
	
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
    //	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.font = [UIFont systemFontOfSize:18];
	[cell.contentView addSubview:lblTemp];
	lblTemp.textColor = [UIColor blackColor];
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
	/*
	 lblTemp = [[UILabel alloc] initWithFrame:Label3Frame];
	 lblTemp.tag = 3;
	 [cell.contentView addSubview:lblTemp];
	 lblTemp.textColor = [UIColor blueColor];
	 lblTemp.backgroundColor = [UIColor colorWithRed:182.0f/255.0f green:237.0f/255.0f blue:189.0f/255.0f alpha:1.0f];
	 [lblTemp release];
	 */
	
	
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
                                                                     delegate:self cancelButtonTitle:@"Odustani" destructiveButtonTitle:@"Izbriši tablicu auta" otherButtonTitles:@"Uredi", nil];
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
            articleArray[i] = articleArray[i+1];
            checkArray[i] = checkArray[i+1];


        }
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
      
      
      
      
      
      
    [tableView1 reloadData];


	}
    
    if (buttonIndex == 1)
    {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(editSheet) userInfo:nil repeats:NO];
 

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
    

UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:strMarker otherButtonTitles:@"Izmijeni tablicu", nil];
actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
// [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}


#pragma mark UIAlertViewDelegate methods 



- (IBAction) showAlertView
{
    

    alertType = 0;
    
    
    UIAlertView *MyAlerView = [[UIAlertView alloc] initWithTitle:@"Upiši tablicu bez razmaka"
                                                         message:@"" delegate:self cancelButtonTitle:@"Poništi" otherButtonTitles:@"Potvrdi", nil];
    MyAlerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [MyAlerView show];
    
    
    
    
}


- (IBAction) showAlertViewName
{
    
    
    alertType = 1;
    
    UIAlertView *MyAlerView = [[UIAlertView alloc] initWithTitle:@"Upiši ime auta"
                                                         message:@"" delegate:self cancelButtonTitle:@"Poništi" otherButtonTitles:@"Potvrdi", nil];
    MyAlerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [MyAlerView show];

    
    
    
    
}

- (IBAction) alertArticleName
{
    
    alertType = 5;
    
    
    UIAlertView *MyAlerView = [[UIAlertView alloc] initWithTitle:@"Izmijeni tablicu"
                                                         message:@"" delegate:self cancelButtonTitle:@"Odustani" otherButtonTitles:@"Potvrdi", nil];
    MyAlerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [MyAlerView show];
    
  
    
   

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
//    NSLog(@"%@",[[alertView textField] text]);
    
 if (alertType == 5) {
        
    
    
    if (buttonIndex == 1)
    {
        NSString *strLabel = [[alertView textFieldAtIndex:0] text];
        
//        NSString *strLabel = [[NSString alloc] initWithFormat:@"%@", [[alertView textField] text]];

        articleArray[globalIndex] = strLabel;
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *fullFileName = [documentsDirectoryPath 
                                  stringByAppendingPathComponent:@"Mylist16.plist"];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<arraySeize; i++) {
            [array addObject:articleArray[i]];
        }
        [array writeToFile:fullFileName atomically:NO];

        
        
        NSArray *file = [[NSArray alloc] initWithContentsOfFile:fullFileName];
        arraySeize = [file count];
        for (int i=0; i<arraySeize; i++) {
            articleArray[i] = [file objectAtIndex:i];
        }
        
        
        [tableView1 reloadData];
        
    }
    
    else
    {
        //NSLog(@"cancel");
        
        
    }
 }
    
else if (alertType == 0)
 {
     if (buttonIndex == 1)
     {
         

         
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentsDirectoryPath = [paths objectAtIndex:0];
         NSString *fullFileName = [documentsDirectoryPath 
                                   stringByAppendingPathComponent:@"Mylist16.plist"];

         
         
         NSArray *file = [[NSArray alloc] initWithContentsOfFile:fullFileName];
         arraySeize = [file count];
         for (int i=0; i<arraySeize; i++) {
             articleArray[i] = [file objectAtIndex:i];
         }
         
         
         NSString *strLabel = [[alertView textFieldAtIndex:0] text];

//         NSString *strLabel = [[NSString alloc] initWithFormat:@"%@", [[alertView textField] text]];
         
         articleArray[arraySeize] = strLabel;
         
         checkArray[arraySeize] = 0;
         
         arraySeize++;
         
         
         
         
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
         
         
         
         
//         documentsDirectoryPath = [paths objectAtIndex:0];
         fullFileName = [documentsDirectoryPath 
                                   stringByAppendingPathComponent:@"Mylist16.plist"];

         file = [[NSArray alloc] initWithContentsOfFile:fullFileName];
         arraySeize = [file count];
         for (int i=0; i<arraySeize; i++) {
             articleArray[i] = [file objectAtIndex:i];
         }

         
         [tableView1 reloadData];
     }
     
     
     else
     {
         //NSLog(@"cancel");
     }

    
 }
    
    
    
else if (alertType == 1)
{
    if (buttonIndex == 1)
    {
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *fullFileName = [documentsDirectoryPath 
                                  stringByAppendingPathComponent:@"Mylist16.plist"];
        
        
        
        NSArray *file = [[NSArray alloc] initWithContentsOfFile:fullFileName];
        arraySeize = [file count];
        for (int i=0; i<arraySeize; i++) {
            articleArray[i] = [file objectAtIndex:i];
        }
        
        
        NSString *strLabel = [[alertView textFieldAtIndex:0] text];

//        NSString *strLabel = [[NSString alloc] initWithFormat:@"%@", [[alertView textField] text]];
        
        articleArray[arraySeize] = strLabel;
        
        checkArray[arraySeize] = 0;
        
        arraySeize++;
        
        
        
        
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
        
        
        
        
        [tableView1 reloadData];
    }
    
    
    else
    {
        //NSLog(@"cancel");
    }
    
    
}

}





@end

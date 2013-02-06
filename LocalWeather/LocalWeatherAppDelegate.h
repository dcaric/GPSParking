//
//  LocalWeatherAppDelegate.h
//  LocalWeather
//
//  Created by Dario Caric on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalWeatherAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
	UITabBarController *myNavController;
    IBOutlet UITableView *tableView;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *myNavController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

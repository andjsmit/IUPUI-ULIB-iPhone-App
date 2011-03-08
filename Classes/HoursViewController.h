//
//  HoursViewController.h
//  IUPUI_UL
//
//  Created by Andy Smith on 2/21/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HoursViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	
	IBOutlet UILabel *hoursMessage;
	NSString *todaysHours;
	NSString *regularHours;
	IBOutlet UITableView *menuTable; 


}

@property (nonatomic, retain) UILabel *hoursMessage;
@property (nonatomic, retain) NSString *todaysHours;
@property (nonatomic, retain) NSString *regularHours;
@property (nonatomic, retain) UITableView *menuTable;

@end

//
//  HoursViewController.m
//  IUPUI_UL
//
//  Created by Andy Smith on 2/21/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "HoursViewController.h"
#import "HoursExceptionsViewController.h"
#import "HoursByDateViewController.h"
#import "Hours.h"

@implementation HoursViewController

@synthesize hoursMessage, todaysHours, regularHours, menuTable;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

//Required TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 4;	
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//Hours Menu
	switch (indexPath.row) {
	    case 0:
			cell.textLabel.text = @"Today's Hours";
			break;
		case 1:
			cell.textLabel.text = @"Regular Hours";
			break;
		case 2:
			cell.textLabel.text = @"Exceptions";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		case 3:
			cell.textLabel.text = @"Hours by Date";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		default:
			cell.textLabel.text = @"Extra Cell";
			break;
	}    
    return cell;  	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
		case 0:
		{
			//Today's Hours
			hoursMessage.text = [self todaysHours];
			break;			
		}
		case 1:
		{
			//Regular hours
			hoursMessage.text = [self regularHours];
			break;
		}
		case 2:
		{
			//Excpetions
			HoursExceptionsViewController *exceptionsViewController = [[HoursExceptionsViewController alloc] 
																	   initWithNibName:@"HoursExceptionsViewController" 
																	   bundle:nil];
			[self.navigationController pushViewController:exceptionsViewController animated:YES];
			[exceptionsViewController release];
			break;
		}
		case 3:
		{
			//Excpetions
			HoursByDateViewController *byDateViewController = [[HoursByDateViewController alloc] 
																	   initWithNibName:@"HoursByDateViewController" bundle:nil];
			[self.navigationController pushViewController:byDateViewController animated:YES];
			[byDateViewController release];
			break;
		}
		default:
			break;
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	//NSString *todaysDate = @"2011-04-24";
	//Hours *hours = [[Hours alloc] initWithDate:todaysDate];
	Hours *hours = [[Hours alloc] init];
	[self setTodaysHours:[hours todayHours]];
	[self setRegularHours:[hours displayRegularHours]];
	[hours release];
	
	hoursMessage.text = [self todaysHours];
	
	NSIndexPath *ip = [NSIndexPath indexPathForRow: 0 inSection:0];
	[menuTable selectRowAtIndexPath:ip animated:NO scrollPosition:UITableViewScrollPositionTop];
	
	self.title = @"Hours";
}

#pragma mark -
#pragma mark Memory management

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

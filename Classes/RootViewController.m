//
//  RootViewController.m
//  IUPUI_UL
//
//  Created by Andy Smith on 2/21/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "RootViewController.h"
#import "HoursViewController.h"
#import "ComputersViewController.h"
#import "NewsViewController.h"
#import "RoomsWebViewController.h"
#import "Weather.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	
	Weather *weather = [[Weather alloc] init];
	[weather queryService:[NSString stringWithFormat:@"indianapolis"]];
	self.title = @"IUPUI University Library";
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//[weather release];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	
	//Main Menu
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Hours";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 1:
			cell.textLabel.text = @"Available Computers";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 2:
			cell.textLabel.text = @"News & Events";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 3:
			cell.textLabel.text = @"Study Rooms";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 4:
			cell.textLabel.text = @"Mobile Research";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;

		default:
			cell.textLabel.text = @"Extra Cell";
			break;
	}
	
	//cell.textLabel.text = @"Library Hours";

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
		case 0:
		{
			//Hours
			HoursViewController *hoursVC = [[HoursViewController alloc] initWithNibName:@"HoursViewController" bundle:nil];
			[self.navigationController pushViewController:hoursVC animated:YES];
			[hoursVC release];
			break;
		}
		case 1:
		{
			//Computers
			ComputersViewController *computersVC = [[ComputersViewController alloc] initWithType:@"building"];
			[self.navigationController pushViewController:computersVC animated:YES];
			[computersVC release];
			break;
		}
		case 2:
		{
			//News and Events
			NewsViewController *newsVC = [[NewsViewController alloc] init];
			[self.navigationController pushViewController:newsVC animated:YES];
			[newsVC release];
			break;
		}
	    case 3:
		{
			RoomsWebViewController *roomsWVC = [[RoomsWebViewController alloc] init];
			[[self navigationController] pushViewController:roomsWVC animated:YES];
			//Following line for testing only -- Bypasses problem of invalid certificate.
			[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"134.68.173.205"];
			NSURL *url = [NSURL URLWithString:@"https://134.68.173.205/openrooms"];
			NSURLRequest *req = [NSURLRequest requestWithURL:url];
			[[roomsWVC webView] loadRequest:req];
			[[roomsWVC navigationItem] setTitle:@"Study Rooms"];
			break;
		}
		default:
			break;
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
    [super dealloc];
}


@end


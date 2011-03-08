//
//  ComputersViewController.m
//  IUPUI_UL
//
//  Created by Andy Smith on 3/4/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "ComputersViewController.h"
#import "Computers.h"


@implementation ComputersViewController

@synthesize type, name, locations;

#pragma mark -
#pragma mark Initializers

- (id)initWithNibName:(NSString *)n bundle:(NSBundle *)b
{
    return [self init];
}

- (id)initWithType:(NSString *)t withName:(NSString *)n
{
    [super initWithNibName:@"ComputersViewController" bundle:nil];
    [self setType:t];
	[self setName:n];
    return self;	
}

- (id)initWithType:(NSString *)t
{
    [super initWithNibName:@"ComputersViewController" bundle:nil];
    [self setType:t];
	[self setName:nil];
    return self;	
}

- (id)init
{
    [super initWithNibName:@"ComputersViewController" bundle:nil];
    [self setType:@"default"];
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Set title and locations
	Computers *computers;
	if ([type isEqualToString:@"default"] || [type isEqualToString:@"building"]) {
		self.title = @"Building";
		computers = [[Computers alloc] init];
		[self setLocations:[computers locations]];
	} else if ([type isEqualToString:@"floor"]) {
		self.title = [name stringByAppendingString:@" Floor"];
		computers = [[Computers alloc] initWithFloor:name];
		[self setLocations:[computers locations]];
	}
	//self.title = type;
	
	//Set Locations
	//Computers *computers = [[Computers alloc] init];
	//[self setLocations:[computers locations]];
	
	[computers release];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self locations] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    /*
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Second";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		case 1:
			cell.textLabel.text = @"Building";
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			break;
		default:
			cell.textLabel.text = @"Extra Cell";
			break;
	}
	cell.textLabel.text = [labels objectForKey:@"label"];
	cell.detailTextLabel.text = [labels objectForKey:@"detailLabel"];
	*/
	
	NSDictionary *labels = [locations objectAtIndex:indexPath.row];
	for (id labelKey in labels) {
		if ([type isEqualToString:@"building"] || [type isEqualToString:@"default"]) {
			cell.textLabel.text = [labelKey stringByAppendingString:@" Floor"];
		} else {
			cell.textLabel.text = labelKey;
	    }
		NSDictionary *data = [labels objectForKey:labelKey];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"( %@ / %@ )", 
									 [data objectForKey:@"avail"], 
									 [data objectForKey:@"total"]]; 
	}
	
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

	
	if ([type isEqualToString:@"floor"]) {
		//Floor Display
		
	} else {
		//Building Display
		
		NSDictionary *labels = [locations objectAtIndex:indexPath.row];
		for (id labelKey in labels) {
			ComputersViewController *computersVC = [[ComputersViewController alloc] initWithType:@"floor" withName:labelKey];
			[self.navigationController pushViewController:computersVC animated:YES];
			[computersVC release];
		/*	
			cell.textLabel.text = labelKey;
			NSDictionary *data = [labels objectForKey:labelKey];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"( %@ / %@ )", 
										 [data objectForKey:@"avail"], 
										 [data objectForKey:@"total"]]; 
		*/
		}
		
	}

	/*
	switch (indexPath.row) {
		case 0:
		{
			//Computers
			ComputersViewController *computersVC = [[ComputersViewController alloc] initWithType:@"second"];
			[self.navigationController pushViewController:computersVC animated:YES];
			[computersVC release];
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
		default:
			break;
	}
	*/
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end


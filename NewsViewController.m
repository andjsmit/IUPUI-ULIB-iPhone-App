//
//  NewsViewController.m
//  IUPUI_UL
//
//  Created by Andy Smith on 3/10/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsChannel.h"

@implementation NewsViewController

#pragma mark -
#pragma mark My Methods

- (void)fetchEntries{
	
	[xmlData release];
	xmlData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString:@"http://www.ulib.iupui.edu/views/news_feed"];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
	
}

- (id)initWithStyle:(UITableViewStyle)style {
	
	self = [super initWithStyle:style];
	[self fetchEntries];
	return self;
	
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
	
	[xmlData appendData:data];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
	
	//NSString *xmlCheck = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(@"xmlCheck = %@", xmlCheck);
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	
	[[self tableView] reloadData];
	
	[xmlData release];
	xmlData = nil;
	[connection release];
	connection = nil;
	
	NSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel shortDescription]);
	
	
	
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
	
	[connection release];
	connection = nil;
	[xmlData release];
	xmlData = nil;
	NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
	UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:errorString 
								  delegate:nil 
								  cancelButtonTitle:@"OK" 
								  destructiveButtonTitle:nil 
								  otherButtonTitles:nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];

}

- (void)parser:(NSXMLParser *)parser 
	didStartElement:(NSString *)elementName 
	namespaceURI:(NSString *)namespaceURI 
	qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict 
{
	
	NSLog(@"%@ found a %@ element", self, elementName);
	if ([elementName isEqual:@"channel"]) {
		[channel release];
		channel = [[NewsChannel alloc] init];
		[channel setParentParserDelegate:self];
		[parser setDelegate:channel];
	}
	
}

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
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


//
//  Computers.m
//  IUPUI_UL
//
//  Created by Andy Smith on 3/4/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "Computers.h"
#import "XPathQuery.h"


@implementation Computers

@synthesize locations, type, name, filter;

- (id)initWithFloor: (NSString *)floor filterBy: (NSString *)filterType {
	
	//Floor by Lab
	if (self = [super init]) {
		
		//Set filter
		[self setFilter:filterType];
		
		//Set type
		[self setType:@"floor"];
		
		//Set name
		[self setName:floor];
		
		//Get data from URL for locations
		NSURL *seatsURL = [NSURL URLWithString:@"http://ulib.iupui.edu/utility/seats.php?show=locations"];
		NSData *data = [NSData dataWithContentsOfURL:seatsURL];
		//Parse XML Data
		//Using XPathQuery ( http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html )
		NSString *seatsQuery;
		NSArray *seatsNodes;
		
		seatsQuery = @"//seat";
		seatsNodes = PerformXMLXPathQuery(data, seatsQuery);
		//NSLog(@"Array : %@",seatsNodes);
		
		NSMutableArray *tempLocations = [[NSMutableArray alloc] initWithCapacity:3];
		for (NSDictionary *seatNode in seatsNodes) {
			NSMutableDictionary *locInfo = [[NSMutableDictionary alloc] initWithCapacity:11];
			NSString *locName;
			//Get location info
			bool floorCheck = false;
			for (NSDictionary *seatAttribute in [seatNode objectForKey:@"nodeAttributeArray"]){
				/*
				 NSLog(@"Name - %@ | Value - %@", 
				 [seatAttribute objectForKey:@"attributeName"], 
				 [seatAttribute objectForKey:@"nodeContent"]);
				 */
				if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"lab"]) {
					locName = [seatAttribute objectForKey:@"nodeContent"];
					//NSLog(@"Location Name - %@", locName);
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					//NSLog(@"Available - %@ | Total - %@", [availableTotal objectAtIndex:0], [availableTotal objectAtIndex:1]);
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"windows-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"win_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"win_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"mac-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"mac_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"mac_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"dual-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"dual_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"dual_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"wheelchair-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"wheel_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"wheel_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"floorplan"]){
					[locInfo setObject:[seatAttribute objectForKey:@"nodeContent"] forKey:@"map_url"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"floor"]) {
					NSString *floor = [seatAttribute objectForKey:@"nodeContent"];
					if ([floor isEqualToString:[self name]]) {
						floorCheck = true;
					}
				}
			}
			//Add Location to tempory locations if from right floor
			if (floorCheck) {
				NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:locInfo, locName, nil];
				[tempLocations addObject:tempDict];
				[tempDict release];
			}
			
			//Clean up
			[locInfo release];
			
		}
		//Set Locations
		[self setLocations:tempLocations];
		NSLog(@"%@",[self locations]);
	
	}
	return (self);
}

- (id)initWithFloor: (NSString *)floor{

	return [self initWithFloor:floor filterBy:@"Any"];
	
}

- (id)initWithLab: (NSString *)lab filterBy: (NSString *)filterType {
	
	//Individual Lab
	if (self = [super init]) {
		
		//Set filter
		[self setFilter:filterType];
		
		//Get URL
		//URL = http://ulib.iupui.edu/utility/seats.php?show=locations
		
		
		
	}	
	return (self);
}

- (id)initWithLab: (NSString *)lab {

	return [self initWithLab:lab filterBy:@"Any"];
	
}

- (id)initFilterBy: (NSString *)filterType{

	//Building by Floor
	if (self = [super init]) {
		//Set type
		[self setType:@"building"];
		 
		//Set name
		[self setName:@"Building"];
		 
		//Set filter
		[self setFilter:filterType];
	
		//Get data from URL for locations
		NSURL *seatsURL = [NSURL URLWithString:@"http://ulib.iupui.edu/utility/seats.php"];
		NSData *data = [NSData dataWithContentsOfURL:seatsURL];
		//Parse XML Data
		//Using XPathQuery ( http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html )
		NSString *seatsQuery;
		NSArray *seatsNodes;
		
		seatsQuery = @"//seat";
		seatsNodes = PerformXMLXPathQuery(data, seatsQuery);
		//NSLog(@"Array : %@",seatsNodes);
		
		NSMutableArray *tempLocations = [[NSMutableArray alloc] initWithCapacity:3];
		for (NSDictionary *seatNode in seatsNodes) {
			NSMutableDictionary *locInfo = [[NSMutableDictionary alloc] initWithCapacity:11];
			NSString *locName;
			//Get location info
			for (NSDictionary *seatAttribute in [seatNode objectForKey:@"nodeAttributeArray"]){
				/*
				NSLog(@"Name - %@ | Value - %@", 
					  [seatAttribute objectForKey:@"attributeName"], 
					  [seatAttribute objectForKey:@"nodeContent"]);
                */
				if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"lab"]) {
					
					locName = [[seatAttribute objectForKey:@"nodeContent"] 
							   stringByReplacingOccurrencesOfString:@" Floor" 
							   withString:@""];
					//NSLog(@"Location Name - %@", locName);
				
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					//NSLog(@"Available - %@ | Total - %@", [availableTotal objectAtIndex:0], [availableTotal objectAtIndex:1]);
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"windows-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"win_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"win_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"mac-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"mac_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"mac_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"dual-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"dual_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"dual_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"wheelchair-availability"]){
					NSArray *availableTotal = [[seatAttribute objectForKey:@"nodeContent"] componentsSeparatedByString:@"/"];
					[locInfo setObject:[availableTotal objectAtIndex:0] forKey:@"wheel_avail"];
					[locInfo setObject:[availableTotal objectAtIndex:1] forKey:@"wheel_total"];
				} else if ([[seatAttribute objectForKey:@"attributeName"] isEqualToString:@"floorplan"]){
					[locInfo setObject:[seatAttribute objectForKey:@"nodeContent"] forKey:@"map_url"];
				}
			}
			//Add Location to tempory locations
			NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:locInfo, locName, nil];
			[tempLocations addObject:tempDict];
			
			//Clean up
			[locInfo release];
			[tempDict release];
		}
		//Set Locations
		[self setLocations:tempLocations];
		NSLog(@"%@",[self locations]);
	
		
		//Clean up
		[tempLocations release];
	}
	return (self);
}

- (id)init {
	
	return [self initFilterBy:@"Any"];

}

@end

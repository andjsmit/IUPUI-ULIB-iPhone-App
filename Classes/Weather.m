//
//  Weather.m
//  IUPUI_UL
//
//  Created by Andy Smith on 4/8/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "Weather.h"
#import "XPathQuery.h"


@implementation Weather

@synthesize location, date;
@synthesize currentIcon, currentTemp, currentWind, currentHumidity, currentCondition;
@synthesize days, icons, temps, conditions;

#pragma mark Instance Methods
-(void) queryService:(NSString *)city {
	
	responseData = [[NSMutableData data] retain];
	
	NSString *url = [NSString stringWithFormat:@"http://www.google.com/ig/api?weather=%@",city];
	weatherURL = [[NSURL URLWithString:url] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:weatherURL];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Retrieves the content of a XML node
-(NSString *)fetchContent:(NSArray *)nodes {

	NSString *result = @"";
	for (NSDictionary *node in nodes) {
		for (id key in node) {
			if ([key isEqualToString:@"nodeContent"]) {
				result = [node objectForKey:key];
			}
		}
	}
	return result;
}

// Retrieves an array of conent values from an XML nodes
-(void)populateArray:(NSMutableArray *)array fromNodes:(NSArray *)nodes {
	
	for (NSDictionary *node in nodes) {
		for (id key in node) {
			if ([key isEqualToString:@"nodeContent"]) {
				[array addObject:[node objectForKey:key]];
			}
		}
	}
	
}

#pragma mark NSURLConnection Delegate Methods

-(NSURLRequest *)connection:(NSURLConnection *)connection 
			willSendRequest:(NSURLRequest *)request 
		   redirectResponse:(NSURLResponse *)redirectResponse 
{

	[weatherURL autorelease];
	weatherURL = [[request URL] retain];
	return request;
	
}

-(void)connection:(NSURLConnection *)connection 
  didReceiveResponse:(NSURLResponse *)response
{
	
	[responseData setLength:0];
	
}

-(void)connection:(NSURLConnection *)connection 
   didReceiveData:(NSData *)data
{

	[responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection 
 didFailWithError:(NSError *)error
{
	NSLog(@"Connection Error = %@",error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {

	/*
	NSString *content = [[NSString alloc]
	  initWithBytes:[responseData bytes] 
	  length:[responseData length] 
	  encoding:NSUTF8StringEncoding];
	NSLog(@"Data = %@", content);
	*/
	
	//Parsing Code
	days = [[NSMutableArray alloc] init];
	icons = [[NSMutableArray alloc] init];
	temps = [[NSMutableArray alloc] init];
	conditions = [[NSMutableArray alloc] init];
	
	NSString *xpathQueryString;
	NSArray *nodes;
	
	//Location
	xpathQueryString = @"//forecast_information/city/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	location = [self fetchContent:nodes];
	NSLog(@"Location = %@", location);
	
	//Date
	xpathQueryString = @"//forecast_information/forecast_date/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	date = [self fetchContent:nodes];
	NSLog(@"Date = %@", date);
	
	//  --- Current Conditions --- //
	
	//Icon
	xpathQueryString = @"//current_conditions/icon/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    for (NSDictionary *node in nodes) {
		for (id key in node) {
			if ([key isEqualToString:@"nodeContent"]) {
				currentIcon = [NSString stringWithFormat:@"http://www.google.com%@", [node objectForKey:key]];
			}
		}
	}
	NSLog(@"Current Icon = %@", currentIcon);
	
	//Temp
	NSString *temp_f;
	NSString *temp_c;
	xpathQueryString = @"//current_conditions/temp_f/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	temp_f = [self fetchContent:nodes];
	xpathQueryString = @"//current_conditions/temp_c/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	temp_c = [self fetchContent:nodes];
	currentTemp = [NSString stringWithFormat:@"%@F (%@C)", temp_f, temp_c];
	NSLog(@"Current Temp = %@", currentTemp);
	
	//Humidity
	xpathQueryString = @"//current_conditions/humidity/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	currentHumidity = [self fetchContent:nodes];
	NSLog(@"Current Humidity = %@", currentHumidity);
	
	//Wind
	xpathQueryString = @"//current_conditions/wind_condition/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	currentWind = [self fetchContent:nodes];
	NSLog(@"Current Wind = %@", currentWind);	
	
	//Condition
	xpathQueryString = @"//current_conditions/condition/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	currentCondition= [self fetchContent:nodes];
	NSLog(@"Current Condition = %@", currentCondition);	
	
	
	// --- Forcast --- //
	
	//Days
	xpathQueryString = @"//forecast_conditions/day_of_week/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	[self populateArray:days fromNodes:nodes];
	NSLog(@"Forecast Days = %@", days);
	
	//Icons
	xpathQueryString = @"//forecast_conditions/icon/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	for (NSDictionary *node in nodes) {
		for (id key in node) {
			if ([ key isEqualToString:@"nodeContent"]) {
				[icons addObject:[NSString stringWithFormat:@"http://www.google.com%@", [node objectForKey:key]]];
			}
		}
	}
	NSLog(@"Forecast Icons = %@", icons);
	
	//High & Lows
	NSMutableArray *highs = [[NSMutableArray alloc] init];
	NSMutableArray *lows = [[NSMutableArray alloc] init];
	
	xpathQueryString = @"//forecast_conditions/high/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	[self populateArray:highs fromNodes:nodes];
	xpathQueryString = @"//forecast_conditions/low/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	[self populateArray:lows fromNodes:nodes];
	for (int i=0; i < highs.count; i++) {
		[temps addObject:[NSString stringWithFormat:@"%@F/%@F", [highs objectAtIndex:i], [lows objectAtIndex:i]]];
	}
	NSLog(@"Forecast Temps = %@", temps);
	[highs release];
	[lows release];
	
	//Conditions
	xpathQueryString = @"//forecast_conditions/condition/@data";
	nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
	[self populateArray:conditions fromNodes:nodes];
	NSLog(@"Forecast Conditions = %@", conditions);	
	
}

-(void)dealloc {

	[responseData release];
	[weatherURL release];
	[location release];
	[date release];
	[currentIcon release];
	[currentTemp release];
	[currentWind release];
	[currentHumidity release];
	[currentCondition release];
	[days release];
	[icons release];
	[temps release];
	[conditions release];
	[super dealloc];
}

@end

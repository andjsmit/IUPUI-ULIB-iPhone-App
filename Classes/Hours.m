//
//  Hours.m
//  IUPUI_UL
//
//  Created by Andy Smith on 3/2/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "Hours.h"
#import "XPathQuery.h"


@implementation Hours
@synthesize todayHours, regularHours, exceptions, todayDate;

- (id)initWithDate:(NSString *)date{
	if (self = [super init]) {
		//***Set Date***
		[self setTodayDate:date];
		
		//***Get Exceptions***
		NSMutableArray *expArry= [[NSMutableArray alloc] init];
		
		//  Get File Path
		NSString *hoursFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/ulib_hours.xml"];
		//  Get XML Data From File
		NSData *data = [NSData dataWithContentsOfFile:hoursFilePath];		
		//  Parse XML Data
		//  Uses XPathQuery ( http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html )
		NSString *exceptionsQuery;
		NSArray *exceptionsNodes;
		
		exceptionsQuery = @"//exceptions/date";
		exceptionsNodes = PerformXMLXPathQuery(data, exceptionsQuery);
		//NSLog(@"Array : %@",nodes);
		
		NSString *expDate;
		NSString *expOpen;
		NSString *expClose;
		NSString *expDescription;
		
		for (NSDictionary *dateNode in exceptionsNodes) {
			for (id dateKey in dateNode){
				if ([dateKey isEqualToString:@"nodeAttributeArray"]) {
					for (NSDictionary *attrNode in [dateNode objectForKey:dateKey]) {
						//NSLog(@"Date : %@", [attrNode objectForKey:@"nodeContent"]);
						expDate = [attrNode objectForKey:@"nodeContent"];
					}				
				}
				else if ([dateKey isEqualToString:@"nodeChildArray"]){
					for (NSDictionary *childNode in [dateNode objectForKey:dateKey]) {
						//NSLog(@"%@ : %@", [childNode objectForKey:@"nodeName"],[childNode objectForKey:@"nodeContent"]);
						if ([[childNode objectForKey:@"nodeName"] isEqualToString:@"open"]) {
							expOpen = [childNode objectForKey:@"nodeContent"];
						} else if ([[childNode objectForKey:@"nodeName"] isEqualToString:@"close"]) {
							expClose = [childNode objectForKey:@"nodeContent"];
						} else if ([[childNode objectForKey:@"nodeName"] isEqualToString:@"description"]) {
							expDescription = [childNode objectForKey:@"nodeContent"];
						}
					}
				}
			}
			//  Put results in array
			//NSLog(@"Final Date => %@", expDate);
			//NSLog(@"Final Open => %@",expOpen);
			//NSLog(@"Final Close => %@",expClose);
			//NSLog(@"Final Description => %@",expDescription);
			NSString *expLabel = [NSString stringWithFormat:@"%@ (%@ - %@)",expDate, expOpen, expClose];
			NSString *expDetailLabel = [NSString stringWithFormat:@"%@", expDescription];
			//NSLog(@"%@", expLabel);
			NSDictionary *expResults;
			expResults = [NSDictionary dictionaryWithObjectsAndKeys:
						  expLabel,       @"label", 
						  expDetailLabel, @"detailLabel", 
						  expDate,        @"date",
						  expOpen,        @"open",
						  expClose,       @"close",nil];
			[expArry addObject:expResults];
		}
		//***Set Exceptions***
		[self setExceptions:expArry];
		[expArry release];
		
		//***Get Regular Hours***
		NSMutableDictionary *dayHours;
		dayHours = [NSMutableDictionary dictionaryWithCapacity:7];
		NSString *regularHoursQuery;
		NSArray *regularHoursNodes;
		regularHoursQuery = @"//regular_hours/hours";
		regularHoursNodes = PerformXMLXPathQuery(data, regularHoursQuery);
		//NSLog(@"Array : %@",nodes);
		for (NSDictionary *node in regularHoursNodes) {
			NSString *start_date;
			NSString *end_date;
			NSDictionary *dateAttributes = [node objectForKey:@"nodeAttributeArray"];
			for (NSDictionary *startEndNodes in dateAttributes) {
				if ([[startEndNodes objectForKey:@"attributeName"] isEqualToString:@"start_date"]) {
					start_date = [startEndNodes objectForKey:@"nodeContent"];
				} else if ([[startEndNodes objectForKey:@"attributeName"] isEqualToString:@"end_date"]){
					end_date = [startEndNodes objectForKey:@"nodeContent"];
				}
			}
			if ([start_date compare:[self todayDate] options:NSNumericSearch] != NSOrderedDescending &&
				[end_date compare:[self todayDate] options:NSNumericSearch] != NSOrderedAscending) {
				//Current Date Range - Get Hours for Display
				NSDictionary *dayHoursNodes = [node objectForKey:@"nodeChildArray"];
				for (NSDictionary *dayHoursNode in dayHoursNodes) {
					NSString *openHour;
					NSString *closeHour;
					NSString *day;
					NSDictionary *dayDict = [[dayHoursNode objectForKey:@"nodeAttributeArray"] objectAtIndex:0];
					//NSLog(@"dayDict - %@",dayDict);
					day = [dayDict objectForKey:@"nodeContent"];
					NSDictionary *hoursNodes = [dayHoursNode objectForKey:@"nodeChildArray"];
					for (NSDictionary *hourNode in hoursNodes) {
						if ([[hourNode objectForKey:@"nodeName"] isEqualToString:@"open"]) {
							openHour = [hourNode objectForKey:@"nodeContent"];
						} else if ([[hourNode objectForKey:@"nodeName"] isEqualToString:@"close"]) {
							closeHour = [hourNode objectForKey:@"nodeContent"];
						}
					}
					NSString *hours = [NSString stringWithFormat:@"%@ - %@", openHour, closeHour];
					//NSLog(@"hours - %@ : day - %@", hours, day);
					[dayHours setObject:hours forKey:day];
				}
				//
				//NSLog(@"dayHours - %@",dayHours);
				//currentHours = @"Found Range!";
			}
		}
        //***Set Regular Hours***
		[self setRegularHours:dayHours];
		
		//***Get Today's Hours***
		//Check for exceptions
		NSMutableString *currentHours = [NSString stringWithFormat:@"FALSE"];
		for (NSDictionary *day in [self exceptions]) {
			if ([[day objectForKey:@"date"] isEqualToString:[self todayDate]]) {
				currentHours = [day objectForKey:@"label"];
			}
		}
		if ([currentHours isEqualToString:@"FALSE"]) {
			//No Matching Exceptions
			//Get Day of week
			NSDateFormatter *dateFromStringFormatter = [[NSDateFormatter alloc] init];
			[dateFromStringFormatter setDateFormat:@"yyyy-MM-dd"];
			NSDate *date = [dateFromStringFormatter dateFromString:[self todayDate]];
			NSDateFormatter *dayOfWeekFormatter = [[NSDateFormatter alloc] init];  
			[dayOfWeekFormatter setDateFormat:@"EEEE"];
			NSString *dayOfWeek;
			dayOfWeek = [dayOfWeekFormatter stringFromDate:date];
			[dateFromStringFormatter release];
			[dayOfWeekFormatter release];									   
			//Set hours to match day of week
			currentHours = [NSString stringWithFormat:@"%@ - %@", dayOfWeek, [[self regularHours] objectForKey:dayOfWeek]];
		}
		
		//***Set Today's Hours***
		[self setTodayHours:currentHours];
		
	}
	return (self);
}

- (id)init{
	
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dateStr = [formatter stringFromDate:date];
	[formatter release];
	
	return [self initWithDate:dateStr];
	
}

- (NSString*)displayRegularHours{

	return [NSString stringWithFormat:@"Display RH - %@",[self regularHours]];
	//return @"Regular Hours ....";
}

@end

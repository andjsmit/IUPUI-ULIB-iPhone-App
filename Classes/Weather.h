//
//  Weather.h
//  IUPUI_UL
//
//  Created by Andy Smith on 4/8/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Weather : NSObject {
	
	//Google Weather Service
	NSMutableData *responseData;
	NSURL *weatherURL;
	
	//Location info
	NSString *location;
	NSString *date;
	
	//Current Conditions
	UIImage *currentIcon;
	NSString *currentTemp;
	NSString *currentHumidity;
	NSString *currentWind;
	NSString *currentCondition;
	
	//Forcast Conditions
	NSMutableArray *days;
	NSMutableArray *icons;
	NSMutableArray *temps;
	NSMutableArray *conditions;

}

@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *date;

@property (nonatomic,retain) UIImage *currentIcon;
@property (nonatomic,retain) NSString *currentTemp;
@property (nonatomic,retain) NSString *currentHumidity;
@property (nonatomic,retain) NSString *currentWind;
@property (nonatomic,retain) NSString *currentCondition;

@property (nonatomic,retain) NSMutableArray *days;
@property (nonatomic,retain) NSMutableArray *icons;
@property (nonatomic,retain) NSMutableArray *temps;
@property (nonatomic,retain) NSMutableArray *conditions;

-(void)queryService:(NSString *)city;

@end

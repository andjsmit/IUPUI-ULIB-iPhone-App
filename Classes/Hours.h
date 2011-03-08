//
//  Hours.h
//  IUPUI_UL
//
//  Created by Andy Smith on 3/2/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Hours : NSObject {
	
	NSString *todayHours;
	NSDictionary *regularHours;
	NSArray *exceptions;
	NSString *todayDate;

}

@property (nonatomic, retain) NSString *todayHours;
@property (nonatomic, copy) NSDictionary *regularHours;
@property (nonatomic, retain) NSArray *exceptions;
@property (nonatomic, retain) NSString *todayDate;

- (id)initWithDate:(NSString *)today;
- (NSString*) displayRegularHours;

@end

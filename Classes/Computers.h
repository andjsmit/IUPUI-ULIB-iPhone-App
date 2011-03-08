//
//  Computers.h
//  IUPUI_UL
//
//  Created by Andy Smith on 3/4/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Computers : NSObject {
	
	NSArray *locations;
	NSString *type;
	NSString *name;
	NSString *filter;

}

@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *filter;

- (id)initWithFloor: (NSString *)floor;
- (id)initWithFloor:(NSString *)floor filterBy:(NSString *)filterType;
- (id)initWithLab: (NSString *)lab;
- (id)initWithLab:(NSString *)lab filterBy:(NSString *)filterType;
- (id)initFilterBy:(NSString *)filterType;

@end

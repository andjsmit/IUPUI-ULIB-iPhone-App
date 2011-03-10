//
//  NewsChannel.h
//  IUPUI_UL
//
//  Created by Andy Smith on 3/10/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsChannel : NSObject <NSXMLParserDelegate> {
	
	NSMutableString *currentString;
	
	NSString *title;
	NSString *shortDescription;
	NSMutableArray *items;
	
	id parentParserDelegate;

}
@property (nonatomic, assign) id parentParserDelegate;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *shortDescription;
@property (nonatomic, retain) NSMutableArray *items;

@end

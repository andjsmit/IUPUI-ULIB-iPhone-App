//
//  NewsItem.h
//  IUPUI_UL
//
//  Created by Andy Smith on 3/14/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsItem : NSObject <NSXMLParserDelegate> {
	
	NSString *title;
	NSString *link;
	NSMutableString *currentString;

	id parentParserDelegate;
}
@property (nonatomic, assign) id parentParserDelegate;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;


@end

//
//  NewsViewController.h
//  IUPUI_UL
//
//  Created by Andy Smith on 3/10/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsChannel;


@interface NewsViewController : UITableViewController <NSXMLParserDelegate> {
	
	NSURLConnection *connection;
	NSMutableData *xmlData;

	NewsChannel *channel;
}

- (void) fetchEntries;

@end

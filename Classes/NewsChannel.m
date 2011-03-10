//
//  NewsChannel.m
//  IUPUI_UL
//
//  Created by Andy Smith on 3/10/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "NewsChannel.h"


@implementation NewsChannel
@synthesize items, title, shortDescription, parentParserDelegate;

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict 
{
	NSLog(@"\t%@ found a %@ element", self, elementName);
	if ([elementName isEqual:@"title"]) {
		currentString = [[NSMutableString alloc] init];
		[self setTitle:currentString];
	} else if ([elementName isEqual:@"description"]) {
		currentString = [[NSMutableString alloc] init];
		[self setShortDescription:currentString];
	}
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	
	[currentString release];
	currentString = nil;
	
	if ([elementName isEqual:@"channel"]) {
		[parser setDelegate:parentParserDelegate];
	}
	
}
	
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)str {

	[currentString appendString:str];

}






- (id)init {
	
	self = [super init];
	
	items = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)dealloc {
	
	[items release];
	[title release];
	[shortDescription release];
	
	[super dealloc];
}

@end

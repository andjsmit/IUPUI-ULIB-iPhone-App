//
//  NewsWebViewController.m
//  IUPUI_UL
//
//  Created by Andy Smith on 3/14/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import "NewsWebViewController.h"


@implementation NewsWebViewController

- (void)loadView {
	
	UIWebView *wv = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[wv setScalesPageToFit:YES];
	
	[self setView:wv];
	[wv release];
}

- (UIWebView *)webView{
	
	return (UIWebView *)[self view];
}
	

@end

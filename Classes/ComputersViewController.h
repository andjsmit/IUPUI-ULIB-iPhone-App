//
//  ComputersViewController.h
//  IUPUI_UL
//
//  Created by Andy Smith on 3/4/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ComputersViewController : UITableViewController {

	NSString* type;
	NSString* name;
	NSArray* locations;
	
	IBOutlet UIImageView* mapView;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) UIImageView *mapView;

- (id)initWithType:(NSString *)t;
- (id)initWithType:(NSString *)t withName:(NSString *)n;

- (IBAction)filterSelect:(id)sender;

@end

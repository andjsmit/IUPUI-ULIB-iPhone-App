//
//  HoursByDateViewController.h
//  IUPUI_UL
//
//  Created by Andy Smith on 2/23/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HoursByDateViewController : UIViewController {
	
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UIButton *selectDate;
	IBOutlet UILabel *hoursDisplay;

}

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIButton *selectDate;
@property (nonatomic, retain) UILabel *hoursDisplay;

-(IBAction)updateHours: (id)sender;

@end

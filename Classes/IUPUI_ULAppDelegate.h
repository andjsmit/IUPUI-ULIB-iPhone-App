//
//  IUPUI_ULAppDelegate.h
//  IUPUI_UL
//
//  Created by Andy Smith on 2/21/11.
//  Copyright 2011 IUPUI University Library. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUPUI_ULAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end


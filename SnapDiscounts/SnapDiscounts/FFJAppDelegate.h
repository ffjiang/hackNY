//
//  FFJAppDelegate.h
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFJMapViewController.h"
#import "FFJPreferencesViewController.h"

@interface FFJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FFJMapViewController *mvc;

@property (strong, nonatomic) FFJPreferencesViewController *pvc;

@end

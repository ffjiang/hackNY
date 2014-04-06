//
//  FFJVenueViewController.h
//  SnapDiscounts
//
//  Created by Frank Jiang on 6/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFJMapViewController.h"

@interface FFJVenueViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *venueInfoLabel;

@property (weak, nonatomic) FFJMapViewController *mapSuperview;

- (void)swipeDown:(id)sender;

@end

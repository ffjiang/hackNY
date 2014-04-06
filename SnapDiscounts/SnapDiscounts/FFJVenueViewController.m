//
//  FFJVenueViewController.m
//  SnapDiscounts
//
//  Created by Frank Jiang on 6/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import "FFJVenueViewController.h"

@interface FFJVenueViewController ()

@end

@implementation FFJVenueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialisation
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swipeDown:(id)sender
{
    NSLog(@"hi");
    CGRect frame = [self.view frame];
    frame.origin.y = [self.view frame].size.height;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                      animations:^{
                          [self.view setFrame:frame];
                      }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

@end

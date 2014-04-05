//
//  FFJMapViewController.m
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import "FFJMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface FFJMapViewController ()

@property (strong, nonatomic) GMSMapView *mapView;

@property (strong, nonatomic) IBOutlet UILabel *locLabel;

@end

@implementation FFJMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = @"Map";
        
        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that image on the tab bar item
        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.clController = [[FFJCoreLocationController alloc] init];
    self.clController.delegate = self;
    [self.clController.locMgr startUpdatingLocation];
    
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86, 151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 3.0 / 5.0) camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.view addSubview:self.mapView];

    // Creates a marker in the center of the map
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = self.clController.locMgr.location.coordinate;
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;
}

- (void)locationUpdate:(CLLocation *)location
{
    self.locLabel.text = [location description];
}

- (void)locationError:(NSError *)error
{
    self.locLabel.text = [error description];
}

@end

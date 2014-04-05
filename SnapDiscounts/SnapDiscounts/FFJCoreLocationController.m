//
//  FFJCoreLocationController.m
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import "FFJCoreLocationController.h"
#import <CoreLocation/CoreLocation.h>

@implementation FFJCoreLocationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locMgr = [[CLLocationManager alloc] init]; // Create new instance of locMgr
        self.locMgr.delegate = self; // Set the delegate as self (for safety)
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // Check if the class assigning itself as the delegate conforms to our protocol.
    // If not, the message will go nowhere. Not good.
    if ([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        [self.delegate locationUpdate:newLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Check if the class assigning itself as the delegate conforms to our protocol.
    // If not, the message will go nowhere. Not good.
    if ([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        [self.delegate locationError:error];
    }
}

@end

//
//  FFJCoreLocationController.h
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate

- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here

- (void)locationError:(NSError *)error; // Any errors are sent here

@end

@interface FFJCoreLocationController : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locMgr;
@property (assign, nonatomic) id delegate;

@end

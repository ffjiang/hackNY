//
//  FFJMapViewController.h
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFJCoreLocationController.h"

@interface FFJMapViewController : UIViewController <CoreLocationControllerDelegate>

@property (strong, nonatomic) FFJCoreLocationController *clController;

- (void)setOAuthStatus:(NSString *)resultText;

@end

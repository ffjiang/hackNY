//
//  FFJDetailViewController.h
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFJDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

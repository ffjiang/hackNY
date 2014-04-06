//
//  FFJMapViewController.m
//  SnapDiscounts
//
//  Created by Frank Jiang on 5/4/14.
//  Copyright (c) 2014 Frank Jiang. All rights reserved.
//

#import "FFJMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FSOAuth.h"
#import "FFJVenueViewController.h"

@interface FFJMapViewController ()

@property (strong, nonatomic) GMSMapView *mapView;

@property (strong, nonatomic) IBOutlet UILabel *locText;

@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@property (strong, nonatomic) IBOutlet UIButton *findVenuesButton;

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *clientSecret;
@property (strong, nonatomic) NSString *callbackURIString;

@property (strong, nonatomic) NSString *authToken;

@end

@implementation FFJMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        // set up clientID and callbackURIString
        self.clientID = @"VEBYEW4KU5IDVTY4VDMKIIYHQKMKOJVW5UYXA0IVDWAMHW1Q";
        self.clientSecret = @"WO5KT2G0YLVHMMH2KFY0TBYT2ZXSOU3XT5JLH3EI1ILACQEZ";
        self.callbackURIString = @"snapdiscounts://foursquare";
        
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
    // Find venues button should not appear until connected to Foursquare
    [self.findVenuesButton removeFromSuperview];
    
    self.clController = [[FFJCoreLocationController alloc] init];
    self.clController.delegate = self;
    [self.clController.locMgr startUpdatingLocation];
    
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86, 151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.clController.locMgr.location.coordinate.latitude
                                                            longitude:self.clController.locMgr.location.coordinate.longitude
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
    self.locText.text = [location description];
}

- (void)locationError:(NSError *)error
{
    self.locText.text = [error description];
}

- (void)connectTapped:(id)sender
{
    // Connect to Foursquare
    
    
    FSOAuthStatusCode statusCode = [FSOAuth authorizeUserUsingClientId:self.clientID
                                                     callbackURIString:self.callbackURIString
                                                  allowShowingAppStore:YES];
    
    NSString *resultText = nil;
    
    switch (statusCode) {
        case FSOAuthStatusSuccess:
            resultText = @"OAuth Success";
            break;
        case FSOAuthStatusErrorInvalidCallback: {
            resultText = @"Invalid callback URI";
            break;
        }
        case FSOAuthStatusErrorFoursquareNotInstalled: {
            resultText = @"Foursquare not installed";
            break;
        }
        case FSOAuthStatusErrorInvalidClientID: {
            resultText = @"Invalid client id";
            break;
        }
        case FSOAuthStatusErrorFoursquareOAuthNotSupported: {
            resultText = @"Installed FSQ app does not support oauth";
            break;
        }
        default: {
            resultText = @"Unknown status code returned";
            break;
        }
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", resultText];
    
}

- (NSString *)errorMessageForCode:(FSOAuthErrorCode)errorCode {
    NSString *resultText = nil;
    
    switch (errorCode) {
        case FSOAuthErrorNone: {
            break;
        }
        case FSOAuthErrorInvalidClient: {
            resultText = @"Invalid client error";
            break;
        }
        case FSOAuthErrorInvalidGrant: {
            resultText = @"Invalid grant error";
            break;
        }
        case FSOAuthErrorInvalidRequest: {
            resultText =  @"Invalid request error";
            break;
        }
        case FSOAuthErrorUnauthorizedClient: {
            resultText =  @"Invalid unauthorized client error";
            break;
        }
        case FSOAuthErrorUnsupportedGrantType: {
            resultText =  @"Invalid unsupported grant error";
            break;
        }
        case FSOAuthErrorUnknown:
        default: {
            resultText =  @"Unknown error";
            break;
        }
    }
    
    return resultText;
}

- (void)handleURL:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"snapdiscounts"]) {
        FSOAuthErrorCode errorCode;
        NSString *accessCode = [FSOAuth accessCodeForFSOAuthURL:url error:&errorCode];;
        
        NSString *resultText = nil;
        if (errorCode == FSOAuthErrorNone) {
            resultText = [NSString stringWithFormat:@"Access code: %@", accessCode];

            [FSOAuth requestAccessTokenForCode:accessCode
                                  clientId:self.self.clientID
                         callbackURIString:self.callbackURIString
                              clientSecret:self.clientSecret
                           completionBlock:^(NSString *authToken, BOOL requestCompleted, FSOAuthErrorCode errorCode) {
                               
                               NSString *resultText = nil;
                               if (requestCompleted) {
                                   if (errorCode == FSOAuthErrorNone) {
                                       self.authToken = authToken;
                                       resultText = [NSString stringWithFormat:@"Auth Token: %@", authToken];
                                   }
                                   else {
                                       resultText = [self errorMessageForCode:errorCode];
                                   }
                               }
                               else {
                                   resultText = @"An error occurred when attempting to connect to the Foursquare server.";
                               }
                           }];
            
        } else {
            resultText = [self errorMessageForCode:errorCode];
        }
        self.resultLabel.text = [NSString stringWithFormat:@"Result: %@", resultText];
        [self.connectButton removeFromSuperview];
        [self.view addSubview: self.findVenuesButton];
    }
}

- (void)findVenuesTapped:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMDD"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&oauth_token=%@&v=%@",            self.clController.locMgr.location.coordinate.latitude,
                                       self.clController.locMgr.location.coordinate.longitude,
                                       self.authToken,
                                        date];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
 //   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
   /* NSData *response1 = [NSURLConnection sendAsynchronousRequest:request
                                                           queue:queue
                                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                                   // code
                                               }] */
    
    NSData *response2 = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&urlResponse
                                                          error:&requestError];

    NSError *jsonError;
    
    id response2AsJSON = [NSJSONSerialization JSONObjectWithData:response2
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    if (jsonError) {
        self.locText.text = @"Error converting to JSON";
    } else {
        FFJVenueViewController *vvc = [[FFJVenueViewController alloc] init];
        // Set reference to self so that vvc can call dismissViewController on its own
        vvc.mapSuperview = self;
        
        [self.view addSubview:vvc.view];

        CGRect frame = [self.view frame];
        
        frame.origin.y = [self.view frame].size.height;
        [vvc.view setFrame:frame];
        frame.origin.y = 0.0;
        
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [vvc.view setFrame:frame];
                         }
                         completion: ^(BOOL finished) {
                             
                         }];
        
        
        vvc.venueInfoLabel.text = [response2AsJSON description];
        self.view.userInteractionEnabled = YES;
        
        UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:vvc.view action:@selector(swipeDown:)];
        downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [downRecognizer setNumberOfTouchesRequired:1];
        [vvc.view addGestureRecognizer:downRecognizer];
        
        vvc.view.userInteractionEnabled = YES;
    }
}

@end

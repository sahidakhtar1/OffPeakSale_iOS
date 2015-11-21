//
//  AALocationHandler.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 26/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALocationHandler.h"

@implementation AALocationHandler
NSString* const NOTIFICATION_LOCATION_UPDATED = @"loc_updt";
- (id)init
{
    self = [super init];
    if (self) {
        
        [self intializeDefaults];
    }
    return self;
}

-(void)intializeDefaults
{

    if([CLLocationManager locationServicesEnabled])
    {
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
       // self.locationManager.distanceFilter = 100;
    
    // Set a movement threshold for new events.
    //self.locationManager.distanceFilter = 1000; // meters
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization]; 
        }
        
    [self.locationManager startUpdatingLocation];
        NSLog(@"location updated started");
    }else{
        [AAAppGlobals sharedInstance].showLocationOffalert = true;
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location updated faild = %@",error);
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        switch ([error code]) {
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
            case kCLErrorDenied:
            {
                [AAAppGlobals sharedInstance].showLocationOffalert = true;
                [self.locationManager stopUpdatingLocation];
                self.locationManager.delegate = nil;
                break;
            }
                
            case kCLErrorLocationUnknown:
                
            default:
                break;
        }
    } else {
        // We handle all non-CoreLocation errors here
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    NSLog(@"==================");
     NSLog(@"location updated");
     NSLog(@"==================");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_UPDATED object:nil];
    [AAAppGlobals sharedInstance].showLocationOffalert = false;
}
@end

//
//  AALocationHandler.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 26/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALocationHandler : NSObject <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) CLLocation* currentLocation;
extern NSString* const NOTIFICATION_LOCATION_UPDATED;
extern NSString* const NOTIFICATION_LOCATION_DENIED;
@end

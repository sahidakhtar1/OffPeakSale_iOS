//
//  AALocationHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALocationHelper.h"

@implementation AALocationHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_ERROR_MESSAGE_KEY = @"errorMessage";
static NSString* const DEFAULT_ERROR_MESSAGE = @"Unable to connect to network. Please try again";
static NSString* const ENDPOINT = @"consumer_profile.php";
static NSString* const JSON_LATITUDE_KEY = @"lat";
static NSString* const JSON_LONGITUDE_KEY = @"long";
static NSString* const JSON_DEVICE_TOKEN_KEY = @"device_token";
static NSString* const JSON_EMAIL_KEY = @"email";
static NSString* const JSON_DEVICE_KEY = @"device";

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    }
    return self;
}

-(void)sendLocationInformationWithCompletionBlock : (void(^)(NSDictionary*))success andFailure : (void(^)(NSString*))failure
{
    
    
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:[[AAAppGlobals sharedInstance].consumer JSONDictionaryLocationRepresentation]  copyItems:YES];
    
    [params setObject:[NSNumber numberWithDouble:[AAAppGlobals sharedInstance].longitude] forKey:JSON_LONGITUDE_KEY];
    [params setObject:[NSNumber numberWithDouble:[AAAppGlobals sharedInstance].latitude] forKey:JSON_LATITUDE_KEY];
    [params setObject:[NSNumber numberWithInteger:1] forKey:JSON_DEVICE_KEY];
    [params setObject:[AAAppGlobals sharedInstance].deviceToken forKey:JSON_DEVICE_TOKEN_KEY];
    if([AAAppGlobals sharedInstance].consumer)
        [params setObject:[AAAppGlobals sharedInstance].consumer.email forKey:JSON_EMAIL_KEY];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
     //NSLog(@"%@",params);
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"send_device_token.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        //NSLog(@"%@",response);
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                success(response);
            }
            else
            {
                if([response objectForKey:JSON_ERROR_CODE_KEY])
                {
                    failure([response objectForKey:JSON_ERROR_MESSAGE_KEY]);
                }
                else
                {
                    failure(DEFAULT_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            failure(DEFAULT_ERROR_MESSAGE);
        }
        
    } withFailureBlock:^(NSError *error) {
        failure(DEFAULT_ERROR_MESSAGE);
    }];
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOCATION_UPDATED object:nil];
}


-(void)locationUpdated
{
    if([AAAppGlobals sharedInstance].consumer)
    {
        [AAAppGlobals sharedInstance].consumer.longitude = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude;
        
        [AAAppGlobals sharedInstance].consumer.latitude = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude;
    }
    [AAAppGlobals sharedInstance].longitude = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude;

     [AAAppGlobals sharedInstance].latitude = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude;
    
    //NSLog(@"Location longitiude %f",[AAAppGlobals sharedInstance].longitude);
    
        dispatch_async([AAAppGlobals sharedInstance].backgroundQueue, ^{
            [self sendLocationInformationWithCompletionBlock:^(NSDictionary *response) {
                
            } andFailure:^(NSString * errorMessage) {
                
            }    ];});
    
    
    
}
@end

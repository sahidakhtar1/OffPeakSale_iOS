//
//  AASplashPageHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 22/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AASplashPageHelper.h"

@implementation AASplashPageHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_SPLASH_SCREEN_URL_KEY = @"splashImage";


+(void)getSplashScreenImageWithCompletionBlock : (void(^)(void))success andFailure:(void(^)(NSString*))failure
{
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY, nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getSplash.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                [AASplashPageHelper populateSplashScreenInfo:response];
                success();
            }
            else
            {
                failure(@"Network failure");
            }
        }
        else
        {
            failure(@"Network failure");
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog( @"Network failure" );
    }];
}

+(void)populateSplashScreenInfo : (NSDictionary*)response
{
    if([AAAppGlobals sharedInstance].retailer)
    {
    
        [AAAppGlobals sharedInstance].retailer.splashScreenURLString = [response objectForKey:JSON_SPLASH_SCREEN_URL_KEY];
                
        
        
    }
    
}
@end

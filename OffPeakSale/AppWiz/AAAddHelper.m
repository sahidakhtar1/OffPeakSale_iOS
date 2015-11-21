//
//  AAAddHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAAddHelper.h"

@implementation AAAddHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_ERROR_MESSAGE_KEY = @"errorMessage";


static NSString* const JSON_PUBLISHER_ID_KEY = @"publisherId";
static NSString* const PUBLISHER_ID_ERROR_MESSAGE = @"Failed to get publisher id";
+(void)getPublisherIdFromServerWithCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getPublisherId.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                [self processResponse:response];
                success();
            }
            else
            {
                if([response objectForKey:JSON_ERROR_CODE_KEY])
                {
                    failure([response objectForKey:JSON_ERROR_MESSAGE_KEY]);
                }
                else
                {
                    failure(PUBLISHER_ID_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            failure( PUBLISHER_ID_ERROR_MESSAGE);
        }
        
    } withFailureBlock:^(NSError *error) {
        failure(PUBLISHER_ID_ERROR_MESSAGE);
    }];
    
}

+(void)processResponse:(NSDictionary*)response
{
    if([response objectForKey:JSON_PUBLISHER_ID_KEY])
    {
        [AAAppGlobals sharedInstance].addPublisherId = [response objectForKey:JSON_PUBLISHER_ID_KEY];
        [[NSUserDefaults standardUserDefaults] setValue:[response objectForKey:JSON_PUBLISHER_ID_KEY] forKey:USER_DEFAULTS_ADD_PUBLISHER_ID_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end

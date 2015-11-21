//
//  AAConsumerProfileHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAConsumerProfileHelper.h"

@implementation AAConsumerProfileHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_TIMESTAMP = @"latestTime";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_ERROR_MESSAGE_KEY = @"errorMessage";
static NSString* const DEFAULT_ERROR_MESSAGE = @"Unable to connect to network. Please try again";
static NSString* const ENDPOINT = @"consumer_profile.php";
+(void)saveConsumerProfileWithDictionary: (NSDictionary*)dictConsumerProfileJSON withCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictConsumerProfileJSON copyItems:YES];
    int timestamp = [[NSDate date] timeIntervalSince1970];
    [params setObject:[NSNumber numberWithInt:timestamp] forKey:JSON_TIMESTAMP];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:ENDPOINT withParams:params withSuccessBlock:^(NSDictionary *response) {
        
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                success();
            }
            else
            {
                if([response objectForKey:JSON_ERROR_MESSAGE_KEY])
                {
                    [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
                    failure([response objectForKey:JSON_ERROR_MESSAGE_KEY]);
                    
                }
                else
                {
                    [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
                    failure(DEFAULT_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
            failure(DEFAULT_ERROR_MESSAGE);
        }
        
    } withFailureBlock:^(NSError *error) {
        [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
        failure(DEFAULT_ERROR_MESSAGE);
    }];
    
}

+(void)saveCommercialProfileWithDictionary: (NSDictionary*)dictConsumerProfileJSON isNewUser:(BOOL)isNewUser withCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictConsumerProfileJSON copyItems:YES];
    int timestamp = [[NSDate date] timeIntervalSince1970];
    [params setObject:[NSNumber numberWithInt:timestamp] forKey:JSON_TIMESTAMP];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    NSString *methodname;
    if (isNewUser) {
        methodname = @"consumer_register.php";
    }else{
        methodname = @"consumer_commercial_profile.php";
    }
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:methodname withParams:params withSuccessBlock:^(NSDictionary *response) {
        
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                success();
            }
            else
            {
                if([response objectForKey:JSON_ERROR_MESSAGE_KEY])
                {
                    [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
                    failure([response objectForKey:JSON_ERROR_MESSAGE_KEY]);
                    
                }
                else
                {
                    [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
                    failure(DEFAULT_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
            failure(DEFAULT_ERROR_MESSAGE);
        }
        
    } withFailureBlock:^(NSError *error) {
        [AAConsumerProfileHelper addToRetryQueue:params withEndpoint:ENDPOINT];
        failure(DEFAULT_ERROR_MESSAGE);
    }];
    
}

+(void)addToRetryQueue : (NSDictionary*)param withEndpoint:(NSString*)endpoint
{
    [[AAAppGlobals sharedInstance].retryQueue addFailedRequest:[NSDictionary dictionaryWithObjectsAndKeys:param,FAILED_REQUEST_PARAMS,endpoint,FAILED_REQUEST_ENDPOINT, nil]];
}

@end

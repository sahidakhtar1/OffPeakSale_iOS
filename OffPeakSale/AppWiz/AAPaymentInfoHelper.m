//
//  AAPaymentInfoHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPaymentInfoHelper.h"

@implementation AAPaymentInfoHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_ERROR_MESSAGE_KEY = @"errorMessage";
NSString* const JSON_PAYMENT_PRODUCT_ID_KEY = @"prod_id";
NSString* const JSON_PAYMENT_QUANTITY_KEY = @"quantity";
NSString* const JSON_PAYMENT_ORDER_AMOUT_KEY = @"order_amount";
NSString* const JSON_PAYMENT_STATUS_KEY = @"payment_status";
static NSString* const ENDPOINT = @"place_order.php";
static NSString* const DEFAULT_ERROR_MESSAGE = @"Unable to connect to network. Please try again";
+(void)sendPaymentInfoWithDictionary: (NSDictionary*)dictPaymentJSON
                            endPoint:(NSString*)endPoint
                withCompletionBlock : (void(^)(NSDictionary*))success
                         andFailure : (void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictPaymentJSON copyItems:YES];
    
    
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    if (endPoint == nil) {
        endPoint =ENDPOINT;
    }
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:endPoint withParams:params withSuccessBlock:^(NSDictionary *response) {
        
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
                    //[AAPaymentInfoHelper addToRetryQueue:params withEndpoint:ENDPOINT];
                    failure(DEFAULT_ERROR_MESSAGE);
                }
                else
                {
                    //[AAPaymentInfoHelper addToRetryQueue:params withEndpoint:ENDPOINT];
                    failure(DEFAULT_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            [AAPaymentInfoHelper addToRetryQueue:params withEndpoint:ENDPOINT];
           
            failure(DEFAULT_ERROR_MESSAGE);
        }
       
    } withFailureBlock:^(NSError *error) {
        [AAPaymentInfoHelper addToRetryQueue:params withEndpoint:ENDPOINT];
        failure(DEFAULT_ERROR_MESSAGE);
    }];
    
}

+(void)addToRetryQueue : (NSDictionary*)param withEndpoint:(NSString*)endpoint
{
    [[AAAppGlobals sharedInstance].retryQueue addFailedRequest:[NSDictionary dictionaryWithObjectsAndKeys:param,FAILED_REQUEST_PARAMS,endpoint,FAILED_REQUEST_ENDPOINT, nil]];
}

@end

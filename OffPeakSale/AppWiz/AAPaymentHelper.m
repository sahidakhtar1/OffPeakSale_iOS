//
//  AAPaymentHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 6/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPaymentHelper.h"

@implementation AAPaymentHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_ERROR_MESSAGE_KEY = @"errorMessage";
 NSString* const JSON_SUCCESS_PAYPAL_URL_KEY = @"successUrl";
 NSString* const JSON_ERROR_PAYPAL_URL_KEY = @"cancelUrl";

NSString* const JSON_PAYPAL_TOKEN_KEY = @"token";
static NSString* const PAYPAL_TOKEN_ERROR_MESSAGE = @"Unable to process transaction";
+(void)getPaypalTokenFromServerWithProductInfo:(NSDictionary*)dictProductInformation withCompletionBlock : (void(^)(NSDictionary*))success andFailure : (void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictProductInformation copyItems:YES];
    
    
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    NSString *endPoint;
    if ([AAAppGlobals sharedInstance].cod) {
        endPoint = @"enquiryMail.php";
    }else{
        if ([[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"]) {
            endPoint = @"veritrans_token.php";
        }else{
            endPoint = @"paypal_token.php";
        }
        
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
                    failure([response objectForKey:JSON_ERROR_MESSAGE_KEY]);
                }
                else
                {
                    failure(PAYPAL_TOKEN_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            failure( PAYPAL_TOKEN_ERROR_MESSAGE);
        }
        
    } withFailureBlock:^(NSError *error) {
        failure(PAYPAL_TOKEN_ERROR_MESSAGE);
    }];
    
}
+(void)purchaseByCreditWithProductInfo:(NSDictionary*)dictProductInformation withCompletionBlock : (void(^)(NSDictionary*))success andFailure : (void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictProductInformation copyItems:YES];
    
    
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"credit_terms_pay.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        
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
                    failure(PAYPAL_TOKEN_ERROR_MESSAGE);
                }
            }
        }
        else
        {
            failure( PAYPAL_TOKEN_ERROR_MESSAGE);
        }
        
    } withFailureBlock:^(NSError *error) {
        failure(PAYPAL_TOKEN_ERROR_MESSAGE);
    }];
    
}




@end

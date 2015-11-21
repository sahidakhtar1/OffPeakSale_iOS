//
//  AAShippingChargeHelper.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 01/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAShippingChargeHelper.h"

@implementation AAShippingChargeHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
+(void)getShippingChargeForCountry:(NSString*)countryId
               withCompletionBlock:(void (^)(void))success
                        andFailure:(void (^)(NSString *))failure{
   NSDictionary* params = [[NSDictionary alloc]
                           initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,
                           countryId,@"country_id", nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getShippingCharges.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if ([response valueForKey:JSON_ERROR_CODE_KEY]) {
            if ([[response valueForKey:JSON_ERROR_CODE_KEY] integerValue] == 1) {
                NSString *ship_amt = [response valueForKey:@"ship_amt"];
                NSString *free_amt = [response valueForKey:@"free_amt"];
                [AAAppGlobals sharedInstance].shippingCharge = ship_amt;
                [AAAppGlobals sharedInstance].freeAmount = [free_amt floatValue];
            }else{
                [AAAppGlobals sharedInstance].shippingCharge = 0;
                //[AAAppGlobals sharedInstance].freeAmount = 0;
            }
        }
        success();
    } withFailureBlock:^(NSError *error) {
        failure(@"Unable to connect to network. Please try again");
    }];
}
@end

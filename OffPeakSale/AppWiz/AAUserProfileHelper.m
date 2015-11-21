//
//  AAUserProfileHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/9/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAUserProfileHelper.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
@implementation AAUserProfileHelper
+(void)getUserProfilewithCompletionBlock:(void (^)(void))success
                              andFailure:(void (^)(NSString *))failure{
    NSDictionary* params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,
                            [AAAppGlobals sharedInstance].consumer.email,@"email", nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getConsumerProfile.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if ([response valueForKey:JSON_ERROR_CODE_KEY]) {
            if ([[response valueForKey:JSON_ERROR_CODE_KEY] integerValue] == 1) {
                NSDictionary *data = [response objectForKey:@"data"];
                if (data != nil) {
                    if ([data valueForKey:@"rewardPoints"]) {
                        [AAAppGlobals sharedInstance].reward_points = [NSString stringWithFormat:@"%@",[data valueForKey:@"rewardPoints"]];
                    }
                }
                
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

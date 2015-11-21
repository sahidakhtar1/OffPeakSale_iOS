//
//  AARedeemRewardsHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/10/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARedeemRewardsHelper.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
@implementation AARedeemRewardsHelper
+(void)redeemReward:(NSString*)rewards
        withCompletionBlock:(void (^)(NSString *))success
                 andFailure:(void (^)(NSString *))failure{
    NSDictionary* params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,
                            rewards,@"redeemPoints",
                            [AAAppGlobals sharedInstance].consumer.email,@"email",nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"redeemRewards.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if ([response valueForKey:JSON_ERROR_CODE_KEY]) {
            if ([[response valueForKey:JSON_ERROR_CODE_KEY] integerValue] == 1) {
                
                [AAAppGlobals sharedInstance].rewardPointsRedeemed = rewards;
                success([NSString stringWithFormat:@"You have redeemed %@ points", rewards]);
            }else{
                failure([response valueForKey:@"errorMessage"]);

            }
        }
        
    } withFailureBlock:^(NSError *error) {
        failure(@"Unable to reedeem the points.");
    }];
}
@end

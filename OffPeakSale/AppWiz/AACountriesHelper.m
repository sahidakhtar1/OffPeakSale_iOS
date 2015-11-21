//
//  AACountriesHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACountriesHelper.h"

@implementation AACountriesHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
+(void)getCountriesFromServerWithCompletionBlock:(void (^)(NSMutableArray *))success andFailure:(void (^)(NSString *))failure
{
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getCountries.php" withParams:nil withSuccessBlock:^(NSArray *response) {
        success(response.mutableCopy);
    } withFailureBlock:^(NSError *error) {
        failure(@"Unable to connect to network. Please try again");
    }];
}
+(void)getIndustriesFromServerWithCompletionBlock:(void (^)(NSMutableArray *))success andFailure:(void (^)(NSString *))failure
{
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getIndustries.php" withParams:nil withSuccessBlock:^(NSArray *response) {
        success(response.mutableCopy);
    } withFailureBlock:^(NSError *error) {
        failure(@"Unable to connect to network. Please try again");
    }];
}


@end

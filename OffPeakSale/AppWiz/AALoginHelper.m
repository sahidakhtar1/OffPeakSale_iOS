//
//  AALoginHelper.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 24/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALoginHelper.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
#import "AAConsumer.h"
@implementation AALoginHelper

+(void)processForgotPaswordWithCompletionBlock : (void(^)(NSString*))success andFailure : (void(^)(NSString*)) failure withParams:(NSDictionary*)params{
    
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"api_forgot_password.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                success([response objectForKey:@"errorMessage"] );
            }
            else
            {
                failure([response objectForKey:@"errorMessage"]);
            }
        }
        else
        {
            failure(@"Invalid input");
        }
        
        
    } withFailureBlock:^(NSError *error) {
        failure(error.description);
    }];
   
}
+(void)processLoginWithCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*)) failure withParams:(NSDictionary*)params{
    
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"consumer_login.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                [AALoginHelper processProfileData:response];
                success();
            }
            else
            {
                failure([response objectForKey:@"errorMessage"]);
            }
        }
        else
        {
            failure(@"Invalid input");
        }
        
        
    } withFailureBlock:^(NSError *error) {
        failure(error.description);
    }];
    
}
+(void)processProfileData:(NSDictionary*)response{
    if ([response objectForKey:@"data"]) {
        NSDictionary *dataDict = [response objectForKey:@"data"];
        AAConsumer *consumer=[AAAppGlobals sharedInstance].consumer;
        if (consumer == nil) {
            consumer = [[AAConsumer alloc] init];
        }
        if ([dataDict objectForKey:@"address"]) {
            consumer.address = [dataDict objectForKey:@"address"];
        }
        if ([dataDict objectForKey:@"city"]) {
            consumer.city = [dataDict objectForKey:@"city"];
        }
        if ([response objectForKey:@"country"]) {
            consumer.country = [response objectForKey:@"country"];
        }
        if ([dataDict objectForKey:@"fname"]) {
            consumer.firstName = [dataDict objectForKey:@"fname"];
        }
        if ([dataDict objectForKey:@"lname"]) {
            consumer.lastName = [dataDict objectForKey:@"lname"];
        }
        if ([dataDict objectForKey:@"dob"]) {
            consumer.dateOfBirth = [dataDict objectForKey:@"dob"];
        }
        if ([dataDict objectForKey:@"email"]) {
            consumer.email = [dataDict objectForKey:@"email"];
        }
        if ([dataDict objectForKey:@"gender"]) {
            consumer.gender = [dataDict objectForKey:@"gender"];
        }
        if ([dataDict objectForKey:@"mobile_num"]) {
            consumer.mobileNumber = [[dataDict objectForKey:@"mobile_num"] integerValue];
        }
        
        if ([dataDict objectForKey:@"zip"]) {
            consumer.zip = [[dataDict objectForKey:@"zip"] integerValue];
        }
        if ([dataDict objectForKey:@"rewardPoints"]) {
            consumer.rewardPoints = [dataDict objectForKey:@"rewardPoints"];
        }
        
        [AAAppGlobals sharedInstance].consumer = consumer;
        
    }
}
@end

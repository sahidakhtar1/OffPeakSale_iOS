//
//  AAFeedbackHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 1/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFeedbackHelper.h"

@implementation AAFeedbackHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
NSString* const JSON_FEEDBACK_CONSUMER_EMAIL_KEY = @"email";
NSString* const JSON_FEEDBACK_SUB_KEY = @"feedbackSub";
NSString* const JSON_FEEDBACK_MSG_KEY = @"feedbackMsg";
static NSString* const DEFAULT_FEEDBACK_FAILED_MESSAGE = @"Unable to send feedback information. Please try again later.";
static NSString* const DEFAULT_FEEDBACK_SUCCESS_MESSAGE = @"Thank you for your feedback.";
NSString* const JSON_FRIEND_NAME_KEY = @"frndName";
NSString* const JSON_FRIEND_EMAIL_KEY = @"frndEmail";
NSString* const JSON_FRIEND_MOBILE_KEY = @"frndMobile";
static NSString* const JSON_APP_STORE_URL_KEY = @"downloadUrl";
static NSString* const DEFAULT_REFER_FRIEND_FAILED_MESSAGE = @"Unable to send information. Please try again later.";
static NSString* const DEFAULT_REFER_FRIEND_SUCCESS_MESSAGE = @"Thank you for the referral";

static NSString* const JSON_FEEDBACK_IMAGE_KEY = @"feedbackImage";
+(void)sendFeedbackInformationToServer:(NSDictionary*)dictFeedbackInformation withCompletionBlock : (void(^)(NSString*))success andFailure:(void(^)(NSString*))failure
{
     NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictFeedbackInformation copyItems:YES];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
     [params setObject:ITUNES_URL forKey:JSON_APP_STORE_URL_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"feedback_mail.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                
                success(DEFAULT_FEEDBACK_SUCCESS_MESSAGE);
            }
            else
            {
                failure(DEFAULT_FEEDBACK_FAILED_MESSAGE);
            }
        }
        else
        {
            failure(DEFAULT_FEEDBACK_FAILED_MESSAGE);
        }
    } withFailureBlock:^(NSError *error) {
       failure( DEFAULT_FEEDBACK_FAILED_MESSAGE);
    }];
}
+(void)sendReferFriendToServer:(NSDictionary*)dictReferFriendInformation withCompletionBlock : (void(^)(NSString*))success andFailure:(void(^)(NSString*))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:dictReferFriendInformation copyItems:YES];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
     [params setObject:ITUNES_URL forKey:JSON_APP_STORE_URL_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"refer_mail.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                
                success(DEFAULT_REFER_FRIEND_SUCCESS_MESSAGE);
            }
            else
            {
                failure(DEFAULT_REFER_FRIEND_FAILED_MESSAGE);
            }
        }
        else
        {
            failure(DEFAULT_REFER_FRIEND_FAILED_MESSAGE);
        }
    } withFailureBlock:^(NSError *error) {
        failure( DEFAULT_REFER_FRIEND_FAILED_MESSAGE);
    }];
}


+(void)getFeedbackGiftFromServerWithCompletionBlock : (void(^)(void))success andFailure:(void(^)(void))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getFeedbackGift.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                [AAFeedbackHelper updateFeedback:response];
                success();
            }
            else
            {
                failure();
            }
        }
        else
        {
            failure();
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog(@"Network failure");
    }];
}

+(void)updateFeedback : (NSDictionary*)response
{
    if([response objectForKey:JSON_FEEDBACK_IMAGE_KEY])
    {
        [[AAAppGlobals sharedInstance].feedback setFeedBackGiftUrlString:[response objectForKey:JSON_FEEDBACK_IMAGE_KEY]];
    }
    if([response objectForKey:@"feedbackOption1"])
    {
        [[AAAppGlobals sharedInstance].feedback setFeedbackOption1:[response objectForKey:@"feedbackOption1"]];
    }else{
        [[AAAppGlobals sharedInstance].feedback setFeedbackOption1:@"Like"];
    }
    if([response objectForKey:@"feedbackOption2"])
    {
        [[AAAppGlobals sharedInstance].feedback setFeedbackOption2:[response objectForKey:@"feedbackOption2"]];
    }else{
        [[AAAppGlobals sharedInstance].feedback setFeedbackOption2:@"Dislike"];
    }
    if([response objectForKey:@"feedbackOption3"])
    {
        [[AAAppGlobals sharedInstance].feedback setFeedbackOption3:[response objectForKey:@"feedbackOption3"]];
    }else{
        [[AAAppGlobals sharedInstance].feedback setFeedbackOption3:@"Reservation"];
    }
    
    
    NSData *dataFeedback = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].feedback];
    
    [[NSUserDefaults standardUserDefaults] setObject:dataFeedback    forKey:USER_DEFAULTS_FEEDBACK_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

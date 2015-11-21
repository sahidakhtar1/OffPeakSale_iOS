//
//  AALoyaltyHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALoyaltyHelper.h"

@implementation AALoyaltyHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";

static NSString* const JSON_LOYALTY_IMAGE_KEY = @"loyaltyImage";
NSString* const JSON_MERCHANT_PASSWORD_KEY = @"merchantPwd";
static NSString* const JSON_TERMS_COND_KEY = @"termsCond";
static NSString* const JSON_FB_URL_KEY = @"fbUrl";
static NSString* const DEFAULT_LOYALTY_FAILED_MESSAGE = @"Network failure";
static NSString* const DEFAULT_LOYALTY_SUCCESS_MESSAGE = @"Success";
static NSString* const JSON_FBICONDISPLAY_KEY = @"fbIconDisplay";


+(void)getLoyaltyInformationFromServerWithCompletionBlock : (void(^)(void))success andFailure:(void(^)(void))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getLoyaltyInfo.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                [AALoyaltyHelper updateLoyalty:response];
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
        failure();
    }];
}

+(void)updateLoyalty : (NSDictionary*)response
{
    if([response objectForKey:JSON_FB_URL_KEY])
    {
        [[AAAppGlobals sharedInstance].loyalty setFacebookPageUrl:[response objectForKey:JSON_FB_URL_KEY]];
    }
    if([response objectForKey:JSON_LOYALTY_IMAGE_KEY])
    {
        [[AAAppGlobals sharedInstance].loyalty setLoyaltyImageUrlString:[response objectForKey:JSON_LOYALTY_IMAGE_KEY]];
    }
    if([response objectForKey:JSON_TERMS_COND_KEY])
    {
        [[AAAppGlobals sharedInstance].loyalty setTermsCondtitions:[response objectForKey:JSON_TERMS_COND_KEY]];
    }
    if([response valueForKey:JSON_FBICONDISPLAY_KEY])
    {
        [[AAAppGlobals sharedInstance].loyalty setFbIconDisplay:[response valueForKey:JSON_FBICONDISPLAY_KEY]];
    }
    if([response valueForKey:@"instagramDisplay"])
    {
        [[AAAppGlobals sharedInstance].loyalty setInstagramDisplay:[response valueForKey:@"instagramDisplay"]];
    }
    if([response valueForKey:@"instagramUrl"])
    {
        [[AAAppGlobals sharedInstance].loyalty setInstagramUrl:[response valueForKey:@"instagramUrl"]];
    }
    
    
    
    NSData *dataLoyalty = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].loyalty];
    
    [[NSUserDefaults standardUserDefaults] setObject:dataLoyalty    forKey:USER_DEFAULTS_LOYALTY_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)authenticateMerchantFromServerWithParams: (NSDictionary*)authenticationParams withCompletionBlock : (void(^)(void))success andFailure:(void(^)(void))failure
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:authenticationParams copyItems:YES];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"loyalty_pwd.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
               
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
        failure();
    }];
}
@end

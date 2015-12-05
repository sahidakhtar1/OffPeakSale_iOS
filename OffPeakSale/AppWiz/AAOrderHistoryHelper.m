//
//  AAOrderHistoryHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAOrderHistoryHelper.h"
#import "AAOrderHistoryObject.h"
@implementation AAOrderHistoryHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
+(void)getOrderHostory:(NSString*)emailID withCompletionBlock : (void(^)(NSDictionary *))success andFailure : (void(^)(NSString*)) failure{
    if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ORDERHISTORY_KEY])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ORDERHISTORY_KEY];
        NSDictionary *obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        success(obj);
    }
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,emailID,@"email", nil];
    [[AAAppGlobals sharedInstance].networkHandler
     sendJSONRequestToServerWithEndpoint:@"getAllOrders.php"
               withParams:params
         withSuccessBlock:^(NSDictionary *response) {
             if([response objectForKey:JSON_ERROR_CODE_KEY])
             {
                 if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
                 {
                     
                     if([response objectForKey:JSON_DATA_KEY] )
                     {
                         NSDictionary *obj = [response objectForKey:JSON_DATA_KEY];
                         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
                         [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_DEFAULTS_ORDERHISTORY_KEY];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         success(obj);
                     }
                     else
                     {
                         failure(@"Invalid input");
                     }
                 }
                 else
                 {
                     failure(@"Invalid input");
                 }
                 
             }else
             {
                 failure(@"Invalid input");
             }
         } withFailureBlock:^(NSError *error) {
             failure(error.description);
         }];
}
@end

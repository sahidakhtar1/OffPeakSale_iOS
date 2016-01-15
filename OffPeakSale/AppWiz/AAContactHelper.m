//
//  AAContactHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 12/12/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAContactHelper.h"

@implementation AAContactHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
+(void)sendContactMailWithName:(NSString*)name
                       emailId:(NSString*)emailId
                       subject:(NSString*)subject
                    andMessage:(NSString*)msg
          withCompletionBlock : (void(^)(NSString *))success
                   andFailure : (void(^)(NSString*)) failure{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    [params setObject:emailId forKey:@"email"];
//    [params setObject:subject forKey:@"subjects"];
    [params setObject:msg forKey:@"comments"];
    [params setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    
    [[AAAppGlobals sharedInstance].networkHandler
     sendJSONRequestToServerWithEndpoint:@"contactMail.php"
     withParams:params
     withSuccessBlock:^(NSDictionary *response) {
         if([response objectForKey:JSON_ERROR_CODE_KEY])
         {
             if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
             {
                 
                 if([response objectForKey:@"errorMessage"] )
                 {
                     success([response objectForKey:@"errorMessage"]);
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

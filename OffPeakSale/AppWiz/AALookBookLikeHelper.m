//
//  AALookBookLikeHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/17/15.
//  Copyright (c) 2015 Vignesh Badrinath Krishna. All rights reserved.
//

#import "AALookBookLikeHelper.h"

@implementation AALookBookLikeHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
+(void)lookBookLikeItem:(NSString*)itemId withCompletionBlock : (void(^)( NSString*,NSString*))success andFailure : (void(^)(NSString*)) failure{
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,itemId,@"id", nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"lookbook_like.php"
               withParams:params
         withSuccessBlock:^(NSDictionary *response) {
             if([response objectForKey:JSON_ERROR_CODE_KEY])
             {
                 NSString *errorMessage;
                 if ([response objectForKey:@"errorMessage"]) {
                     errorMessage = [response objectForKey:@"errorMessage"];
                 }
                 if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
                 {
                     
                     NSString *likeCount ;
                     if ([response objectForKey:@"likesCnt"]) {
                         likeCount = [response objectForKey:@"likesCnt"];
                     }
                     if ([response objectForKey:@"errorMessage"]) {
                         errorMessage = [response objectForKey:@"errorMessage"];
                     }
                     if (likeCount != nil) {
                         success(likeCount,errorMessage);
                     }else{
                         failure(errorMessage);
                     }
                 }
                 else
                 {
                     failure(errorMessage);
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

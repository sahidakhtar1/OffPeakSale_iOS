//
//  AALookBookHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 10/16/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALookBookHelper.h"
#import "AALookBookResponseObject.h"
#import "AALookBookObject.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
@implementation AALookBookHelper
+(void)getLookBookDataWithCompletionBlock : (void(^)(AALookBookResponseObject *))success andFailure : (void(^)(NSString*)) failure{
    if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_LOOKBOOK_KEY])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_LOOKBOOK_KEY];
        AALookBookResponseObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        success(obj);
    }
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY, nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getLookBook.php"
               withParams:params
         withSuccessBlock:^(NSDictionary *response) {
             if([response objectForKey:JSON_ERROR_CODE_KEY])
             {
                 if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
                 {
                     
                     if([response objectForKey:JSON_DATA_KEY] )
                     {
                        AALookBookResponseObject *obj = [AALookBookHelper populateLookBookObject:response];
                         success(obj);
                          NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
                         [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_DEFAULTS_LOOKBOOK_KEY];
                         [[NSUserDefaults standardUserDefaults] synchronize];
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
+(AALookBookResponseObject*)populateLookBookObject:(NSDictionary*)response{
    AALookBookResponseObject *obj = [[AALookBookResponseObject alloc] init];
    obj.lookBookItems = [[NSMutableArray alloc] init];
    NSArray *arr = [response objectForKey:JSON_DATA_KEY];
    for (NSDictionary *dict in arr) {
        AALookBookObject *lookBoook = [[AALookBookObject alloc] init];
        if([dict objectForKey:@"id"])
        {
            lookBoook.itemId = [dict objectForKey:@"id"];
        }
        if([dict objectForKey:@"imgUrl"])
        {
            lookBoook.imgUrl = [dict objectForKey:@"imgUrl"];
        }
        if([dict objectForKey:@"title"])
        {
            lookBoook.title = [dict objectForKey:@"title"];
        }
        
        if([dict objectForKey:@"caption"])
        {
            lookBoook.caption = [dict objectForKey:@"caption"];
        }
        if([dict objectForKey:@"description"])
        {
            lookBoook.desc = [dict objectForKey:@"description"];
        }
        if([dict objectForKey:@"likesCnt"])
        {
            lookBoook.likesCnt = [dict objectForKey:@"likesCnt"];
        }
        [obj.lookBookItems addObject:lookBoook];
    }
    return obj;
}
@end

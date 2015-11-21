//
//  AACategoryHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/11/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACategoryHelper.h"
#import "AACategoryDataModel.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
@implementation AACategoryHelper
+(void)refreshEshopCategoryWithCompletionBlock : (void(^)(void))success{
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getCategories.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        [self parseCategoryObject:[response objectForKey:@"data"]];
        success();
    } withFailureBlock:^(NSError *error) {
        //NSLog( @"Network failure" );
    }];
}
+(void)parseCategoryObject:(NSArray*)data{
    [[AAAppGlobals sharedInstance].arrCategory removeAllObjects];
    for (int i = 0; i < [data count]; i++) {
        NSDictionary* dict = [data objectAtIndex:i];
        AACategoryDataModel *category = [[AACategoryDataModel alloc] init];
        category.categoryId = [dict valueForKey:@"id"];
        category.categoryName = [dict valueForKey:@"category_name"];
        [[AAAppGlobals sharedInstance].arrCategory addObject:category];
    }
    NSData *archivedata = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].arrCategory];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedata forKey:USER_DEFAULTS_ESHOP_KEY];
    [defaults synchronize];
}
@end

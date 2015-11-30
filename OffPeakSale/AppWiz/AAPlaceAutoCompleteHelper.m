//
//  AAPlaceAutoCompleteHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/30/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAPlaceAutoCompleteHelper.h"

@implementation AAPlaceAutoCompleteHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//+(void)refreshEshopInformationForCategory:(NSString*)cid
//                               searchText:(NSString*)keyword
//                                   sortBy:(NSString*)sortBy
//                                   forLat:(NSString*)latitude
//                                  andLong:(NSString*)longitude
//                     WithCompletionBlock : (void(^)(void))success
//{
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
//    [dict setValue:latitude forKey:@"consumer_lat"];
//    [dict setValue:longitude forKey:@"consumer_long"];
//    //    if (cid != nil) {
//    //       [dict setValue:cid forKey:@"cid"];
//    //    }
//    if (keyword != nil) {
//        [dict setValue:keyword forKey:@"keyword"];
//    }
//    //    if (sortBy != nil && keyword == nil) {
//    //        [dict setValue:sortBy forKey:@"sortBy"];
//    //    }
//    //    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,
//    //                            [AAAppGlobals sharedInstance].customerEmailID,@"email", nil];
//    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getProducts.php" withParams:dict withSuccessBlock:^(NSDictionary *response) {
//        success();
//        if (keyword == nil && sortBy != nil && [sortBy isEqualToString:@"rate"]) {
//            
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].categoryList];
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:data forKey:cid];
//            [defaults synchronize];
//            
//        }
//    } withFailureBlock:^(NSError *error) {
//        //NSLog( @"Network failure" );
//    }];
//}
@end

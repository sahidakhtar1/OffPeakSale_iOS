//
//  AAPushNotificationHandler.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPushNotificationHandler.h"

@implementation AAPushNotificationHandler
static NSString* const PUSH_NOTIFICATION_MSG_KEY = @"msg";
static NSString* const PUSH_NOTIFICATION_FILE_URL_KEY = @"imageUrl";
static NSString* const PUSH_NOTIFICATION_FILE_TYPE_KEY = @"pnType";
static NSString* const PUSH_NOTIFICATION_APS_KEY = @"aps";
static NSString* const PUSH_NOTIFICATION_BADGE_NO_KEY = @"badge";

+(AAVoucher*)processUserInfoDictionary :(NSDictionary*)userInfo
{
    NSLog(@"%@",userInfo);
    
    if([userInfo objectForKey:PUSH_NOTIFICATION_FILE_URL_KEY] && [userInfo objectForKey:PUSH_NOTIFICATION_FILE_TYPE_KEY])
    {
        
        NSDictionary* dictImageURL = [userInfo objectForKey:PUSH_NOTIFICATION_FILE_URL_KEY];
        
//        if([dictImageURL objectForKey:PUSH_NOTIFICATION_MSG_KEY])
//        {
        
        NSString* fileUrlString = [userInfo objectForKey:PUSH_NOTIFICATION_FILE_URL_KEY];
        if(![[AAAppGlobals sharedInstance].voucherList doesVoucherExistWithURl:fileUrlString])
        {
            NSString* fileUrlString = [dictImageURL objectForKey:PUSH_NOTIFICATION_MSG_KEY];
            AAVoucher* voucher = [[AAVoucher alloc]init];
            voucher.voucherFileUrl = fileUrlString;
            voucher.voucherFileType = [dictImageURL objectForKey:PUSH_NOTIFICATION_FILE_TYPE_KEY];
            if ([userInfo objectForKey:@"pid"]) {
                voucher.pid  = [userInfo objectForKey:@"pid"];
            }
            if (voucher.voucherFileType) {
                [[AAAppGlobals sharedInstance].voucherList addVoucher:voucher];
                NSData *dataVouchers = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].voucherList];
                
                [[NSUserDefaults standardUserDefaults] setObject:dataVouchers    forKey:USER_DEFAULTS_VOUCHERS_KEY];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        
        return voucher;
        }
//        }
        
    }
    if([userInfo objectForKey:PUSH_NOTIFICATION_APS_KEY])
    {
        NSDictionary* aps = [userInfo objectForKey:PUSH_NOTIFICATION_APS_KEY];
        if([aps objectForKey:PUSH_NOTIFICATION_BADGE_NO_KEY])
        {
            [AAPushNotificationHandler updateApplicationBadgeNumber:[[aps objectForKey:PUSH_NOTIFICATION_BADGE_NO_KEY] intValue]-1];
        }
        
    }
    return nil;
}




+(void)updateApplicationBadgeNumber : (int)badgeNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}
@end

//
//  AAPushNotificationHandler.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAVoucher.h"
@interface AAPushNotificationHandler : NSObject
+(AAVoucher*)processUserInfoDictionary:(NSDictionary*)userInfo;
@end

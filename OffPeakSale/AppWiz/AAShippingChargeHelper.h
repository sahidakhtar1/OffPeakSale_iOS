//
//  AAShippingChargeHelper.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 01/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAShippingChargeHelper : NSObject
+(void)getShippingChargeForCountry:(NSString*)countryId
               withCompletionBlock:(void (^)(void))success
                        andFailure:(void (^)(NSString *))failure;
@end

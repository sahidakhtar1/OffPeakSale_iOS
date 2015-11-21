//
//  AALoyaltyHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALoyaltyHelper : NSObject
extern NSString* const JSON_MERCHANT_PASSWORD_KEY;
+(void)getLoyaltyInformationFromServerWithCompletionBlock : (void(^)(void))success andFailure:(void(^)(void))failure;
+(void)authenticateMerchantFromServerWithParams: (NSDictionary*)authenticationParams withCompletionBlock : (void(^)(void))success andFailure:(void(^)(void))failure;
@end

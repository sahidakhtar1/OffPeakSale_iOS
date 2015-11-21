//
//  AAPaymentHelper.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 6/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAPaymentHelper : NSObject
extern NSString* const JSON_PAYPAL_TOKEN_KEY;
extern NSString* const JSON_SUCCESS_PAYPAL_URL_KEY;
extern NSString* const JSON_ERROR_PAYPAL_URL_KEY;
+(void)getPaypalTokenFromServerWithProductInfo:(NSDictionary*)dictProductInformation withCompletionBlock : (void(^)(NSDictionary*))success andFailure : (void(^)(NSString*))failure;
+(void)purchaseByCreditWithProductInfo:(NSDictionary*)dictProductInformation withCompletionBlock : (void(^)(NSDictionary*))success andFailure : (void(^)(NSString*))failure;
@end

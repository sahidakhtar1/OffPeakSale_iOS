//
//  AAPaymentInfoHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAPaymentInfoHelper : NSObject
+(void)sendPaymentInfoWithDictionary: (NSDictionary*)dictPaymentJSON
                            endPoint:(NSString*)endPoint
                withCompletionBlock : (void(^)(NSDictionary*))success
                         andFailure : (void(^)(NSString*))failure;

extern NSString* const JSON_PAYMENT_PRODUCT_ID_KEY ;
extern NSString* const JSON_PAYMENT_QUANTITY_KEY;
extern NSString* const JSON_PAYMENT_ORDER_AMOUT_KEY;
extern NSString* const JSON_PAYMENT_STATUS_KEY;
@end

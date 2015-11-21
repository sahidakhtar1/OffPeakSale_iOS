//
//  AAPaymentHandler.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 25/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalMobile.h"
#import "AAPaymentHelper.h"
#import "AAPaymentHandlerDelegate.h"
#import "AAPayPalPaymentViewController.h"
@interface AAPaymentHandler : NSObject <PayPalPaymentDelegate,AAPayPalPaymentViewControllerDelegate>

extern NSString* const PAYMENT_AMOUNT_KEY;
extern NSString* const PAYMENT_CURRENCT_CODE_KEY;
extern NSString* const PAYMENT_PRODUCT_SHORT_DESCRIPTION_KEY;
extern NSString* const PAYER_ID_KEY;
extern NSString* const PAYMENT_QUANTITY_KEY ;
extern NSString* const PAYMENT_EMAIL_KEY;
extern NSString* const PAYMENT_PRODUCT_ID_KEY;
extern NSString* const ERROR_PAYMENT_FAILED_MSG;
@property (nonatomic,strong) UIViewController<AAPaymentHandlerDelegate>* paymentHandlerDelegate;
@property (nonatomic, strong) NSString *mPayPalToken;

-(NSString*)makePaymentWithDetails:(NSDictionary*)details;
-(void)initiateConnection;
-(NSString*)makePaymentByCreditWithDetails:(NSDictionary*)details ;
@end

//
//  AAPaymentHandler.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 25/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPaymentHandler.h"
#import "ActivityIndicator.h"
@implementation AAPaymentHandler

@synthesize mPayPalToken;
#define PAYPAL_ENVIRONMENT_SANDBOX

NSString* const PAYPAL_CLIENT_ID = @"Ad9oqxBPNSZU0607XLaSnMVraIcPL2og0tvumf9DvXrb6e2WL-S5T01wlozs";
NSString* const PAYPAL_RECEIVER_EMAIL = @"manager-facilitator@apps-authority.com";

NSString* const PAYMENT_QUANTITY_KEY = @"quantity";
NSString* const PAYMENT_EMAIL_KEY = @"email";
NSString* const PAYMENT_PRODUCT_ID_KEY = @"productId";
NSString* const PAYMENT_AMOUNT_KEY = @"amount";
NSString* const PAYMENT_CURRENCT_CODE_KEY = @"currencyCode";
NSString* const PAYMENT_PRODUCT_SHORT_DESCRIPTION_KEY = @"shortDescription";
NSString* const PAYER_ID_KEY = @"payerId";
NSString* const PAYMENT_MODE=@"paypalMode";
static NSString* const ERROR_INCORRECT_PAYMENT_AMOUNT_MSG = @"The amount to be paid for the product is incorrect";

static NSString* const ERROR_INCORRECT_PRODUCT_INFORMATION_MSG = @"Product information not provided";



NSString* const ERROR_PAYMENT_FAILED_MSG = @"Transaction could be not be completed. Please try again later";

-(NSString*)makePaymentWithDetails:(NSDictionary*)details {
    [[ActivityIndicator sharedActivityIndicator] show];
    
    [AAPaymentHelper getPaypalTokenFromServerWithProductInfo:details withCompletionBlock:^(NSDictionary *response) {
        [[ActivityIndicator sharedActivityIndicator] hide];
        if ([AAAppGlobals sharedInstance].cod) {
            [self.paymentHandlerDelegate onPaymentSuccess:nil];
        }else{
            NSString *veritUrl = nil;
            if ([[AAAppGlobals sharedInstance].retailer.enablePay isEqualToString:@"1"]) {
                NSString* paypalToken = [response objectForKey:JSON_PAYPAL_TOKEN_KEY];
                self.mPayPalToken = paypalToken;
            }else{
                veritUrl = [response objectForKey:@"redirectUrl"];
            }
           
            NSString *paymentMode = [response objectForKey:PAYMENT_MODE];
            AAPayPalPaymentViewController* vcPayPalPaymentViewController = [self.paymentHandlerDelegate.storyboard instantiateViewControllerWithIdentifier:@"AAPayPalPaymentViewController"];
            [vcPayPalPaymentViewController setUrlPayPalProduct:[AAPaymentHandler getPayPayProductUrlWithToken:self.mPayPalToken andMode:paymentMode]];
            [vcPayPalPaymentViewController setPaypalPaymentDelegate:self];
            [vcPayPalPaymentViewController setPaypalFailureURLString:[response objectForKey:JSON_ERROR_PAYPAL_URL_KEY]];
            [vcPayPalPaymentViewController setVeritRedirectUrl:veritUrl];
            [vcPayPalPaymentViewController setPaypalSuccessURLString:[response objectForKey:JSON_SUCCESS_PAYPAL_URL_KEY]];
            [self.paymentHandlerDelegate presentViewController:vcPayPalPaymentViewController animated:YES completion:^{
                
            }];
        }
        
    } andFailure:^(NSString *errMessage) {
        [[ActivityIndicator sharedActivityIndicator] hide];
        [self.paymentHandlerDelegate onPaymentFailure:errMessage];
    }];
    
   
    
    
   /* PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [details objectForKey:PAYMENT_AMOUNT_KEY];
    payment.currencyCode = [details objectForKey:PAYMENT_CURRENCT_CODE_KEY];
    payment.shortDescription = [details objectForKey:PAYMENT_PRODUCT_SHORT_DESCRIPTION_KEY];
   
    // Check whether payment is processable.
    if (!payment.processable) {
        if (payment.amount < 0)
        {
            return ERROR_INCORRECT_PAYMENT_AMOUNT_MSG;
        }
        
        if([payment.shortDescription length]==0)
        {
            return ERROR_INCORRECT_PRODUCT_INFORMATION_MSG;
        }
        return @"Payment error";
    }
    
#ifdef PAYPAL_ENVIRONMENT_SANDBOX
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentSandbox];
#elif defined(PAYPAL_ENVIRONMENT_LIVE)
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentProduction];
#endif
    // Provide a payerId that uniquely identifies a user within the scope of your system,
    // such as an email address or user ID.
    NSString *aPayerId = [details objectForKey:PAYER_ID_KEY];
    
    // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
    // from the previous step, and a PayPalPaymentDelegate to handle the results.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:PAYPAL_CLIENT_ID
                                                                    receiverEmail:PAYPAL_RECEIVER_EMAIL
                                                                          payerId:aPayerId
                                                                          payment:payment
                                                                         delegate:self];
    
    // Present the PayPalPaymentViewController.
    //paymentViewController.hideCreditCardButton = YES;
    [self.paymentHandlerDelegate presentViewController:paymentViewController animated:YES completion:nil];
    */
    return nil;
}

-(NSString*)makePaymentByCreditWithDetails:(NSDictionary*)details {
    
    
    [AAPaymentHelper getPaypalTokenFromServerWithProductInfo:details withCompletionBlock:^(NSDictionary *response) {
        NSString* paypalToken = [response objectForKey:JSON_PAYPAL_TOKEN_KEY];
        NSString *paymentMode = [response objectForKey:PAYMENT_MODE];
        AAPayPalPaymentViewController* vcPayPalPaymentViewController = [self.paymentHandlerDelegate.storyboard instantiateViewControllerWithIdentifier:@"AAPayPalPaymentViewController"];
        [vcPayPalPaymentViewController setUrlPayPalProduct:[AAPaymentHandler getPayPayProductUrlWithToken:paypalToken andMode:paymentMode]];
        [vcPayPalPaymentViewController setPaypalPaymentDelegate:self];
        [vcPayPalPaymentViewController setPaypalFailureURLString:[response objectForKey:JSON_ERROR_PAYPAL_URL_KEY]];
        [vcPayPalPaymentViewController setPaypalSuccessURLString:[response objectForKey:JSON_SUCCESS_PAYPAL_URL_KEY]];
        [self.paymentHandlerDelegate presentViewController:vcPayPalPaymentViewController animated:YES completion:^{
            
        }];
    } andFailure:^(NSString *errMessage) {
        [self.paymentHandlerDelegate onPaymentFailure:errMessage];
    }];
    
    
    
    
    /* PayPalPayment *payment = [[PayPalPayment alloc] init];
     payment.amount = [details objectForKey:PAYMENT_AMOUNT_KEY];
     payment.currencyCode = [details objectForKey:PAYMENT_CURRENCT_CODE_KEY];
     payment.shortDescription = [details objectForKey:PAYMENT_PRODUCT_SHORT_DESCRIPTION_KEY];
     
     // Check whether payment is processable.
     if (!payment.processable) {
     if (payment.amount < 0)
     {
     return ERROR_INCORRECT_PAYMENT_AMOUNT_MSG;
     }
     
     if([payment.shortDescription length]==0)
     {
     return ERROR_INCORRECT_PRODUCT_INFORMATION_MSG;
     }
     return @"Payment error";
     }
     
     #ifdef PAYPAL_ENVIRONMENT_SANDBOX
     [PayPalPaymentViewController setEnvironment:PayPalEnvironmentSandbox];
     #elif defined(PAYPAL_ENVIRONMENT_LIVE)
     [PayPalPaymentViewController setEnvironment:PayPalEnvironmentProduction];
     #endif
     // Provide a payerId that uniquely identifies a user within the scope of your system,
     // such as an email address or user ID.
     NSString *aPayerId = [details objectForKey:PAYER_ID_KEY];
     
     // Create a PayPalPaymentViewController with the credentials and payerId, the PayPalPayment
     // from the previous step, and a PayPalPaymentDelegate to handle the results.
     PayPalPaymentViewController *paymentViewController;
     paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:PAYPAL_CLIENT_ID
     receiverEmail:PAYPAL_RECEIVER_EMAIL
     payerId:aPayerId
     payment:payment
     delegate:self];
     
     // Present the PayPalPaymentViewController.
     //paymentViewController.hideCreditCardButton = YES;
     [self.paymentHandlerDelegate presentViewController:paymentViewController animated:YES completion:nil];
     */
    return nil;
}


-(void)initiateConnection
{
#ifdef PAYPAL_ENVIRONMENT_SANDBOX
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentSandbox];
#elif defined(PAYPAL_ENVIRONMENT_LIVE)
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentProduction];
#endif
    [PayPalPaymentViewController prepareForPaymentUsingClientId:PAYPAL_CLIENT_ID];
}

+(NSURL*)getPayPayProductUrlWithToken :(NSString*)token andMode:(NSString*)paymentMode
{
    NSURL* urlPayPalProduct;
#ifdef PAYPAL_ENVIRONMENT_SANDBOX
   
#elif defined(PAYPAL_ENVIRONMENT_LIVE)
#endif
    if ([paymentMode compare:@"Sandbox" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        urlPayPalProduct =  [NSURL URLWithString:[NSString stringWithFormat: @"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token=%@",token]];
    }else{
        urlPayPalProduct =  [NSURL URLWithString:[NSString stringWithFormat: @"https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token=%@",token]];
    }
    return urlPayPalProduct;
}



#pragma mark - paypal callbacks
-(void)payPalPaymentDidCancel
{
    
    // Dismiss the PayPalPaymentViewController.
    [self.paymentHandlerDelegate dismissViewControllerAnimated:YES completion:nil];
}

-(void)payPalPaymentDidComplete:(PayPalPayment *)completedPayment
{
   
    
    NSDictionary* proofOfPayment = [completedPayment.confirmation objectForKey:@"proof_of_payment"];
    NSDictionary* adaptivePayment = [proofOfPayment objectForKey:@"adaptive_payment"];
    NSDictionary* paymentResponseDict = [[NSDictionary alloc] initWithObjectsAndKeys:[adaptivePayment objectForKey:@"payment_exec_status"],@"payment_state",nil];
    [self.paymentHandlerDelegate  dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - PayPal View controller callbacks
-(void)onPaymentFinished:(BOOL)success placeOderUrl:(NSString*)url
{
    if(success)
    {
        [self.paymentHandlerDelegate dismissViewControllerAnimated:YES completion:^{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"success" forKey:@"paymen_status"];
            [dict setValue:self.mPayPalToken forKey:@"invoiceId"];
            [dict setValue:url forKey:@"place_order_url"];
            [self.paymentHandlerDelegate onPaymentSuccess:dict];
        }];
    }
    else
    {
        
        [self.paymentHandlerDelegate dismissViewControllerAnimated:YES completion:^{
            [self.paymentHandlerDelegate onPaymentFailure:ERROR_PAYMENT_FAILED_MSG];        }];
    }
}

@end

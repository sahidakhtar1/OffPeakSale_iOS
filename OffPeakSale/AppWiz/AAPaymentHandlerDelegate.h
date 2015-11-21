//
//  AAPaymentHandlerDelegate.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 25/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAPaymentHandlerDelegate <NSObject>
-(void)onPaymentSuccess: (NSDictionary*)response;
-(void)onPaymentFailure: (NSString*)errMessage;
@end

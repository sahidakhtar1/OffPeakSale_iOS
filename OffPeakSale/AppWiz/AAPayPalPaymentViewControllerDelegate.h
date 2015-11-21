//
//  AAPayPalPaymentViewControllerDelegate.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 7/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AAPayPalPaymentViewControllerDelegate <NSObject>
-(void)onPaymentFinished: (BOOL) success placeOderUrl:(NSString*)url;
@end

//
//  AAMerchanAuthenticationPopupViewDelegate.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AAScannerViewController;
@protocol AAMerchantAuthenticationPopupViewDelegate <NSObject>
-(void)enableMerchantMode:(BOOL)enable;
-(void)presentScanner:(AAScannerViewController*)scannerVC;
@end

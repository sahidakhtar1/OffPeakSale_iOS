//
//  AAMerchantAuthenticationPopupView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAThemePopupView.h"
#import "AAThemeValidationTextField.h"
#import "AAMerchantAuthenticationPopupViewDelegate.h"
#import "AALoyaltyHelper.h"
@interface AAMerchantAuthenticationPopupView : AAThemePopupView

@property (nonatomic,strong) AAThemeValidationTextField* tfPassword;
@property (nonatomic,weak) id<AAMerchantAuthenticationPopupViewDelegate> merchantAuthenticatDelegate;

//Creates and returns the merchant popup view given the background frame for the popup
+(AAMerchantAuthenticationPopupView*)createMerchantAuthenticationPopupViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect withPadding:(float)padding;
@end

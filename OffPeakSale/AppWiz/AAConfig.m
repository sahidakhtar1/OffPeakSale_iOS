//
//  AAConfig.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 13/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAConfig.h"

@implementation AAConfig
NSString* const KEY_SELECTED_CURRENCY = @"keySelectedCurrency";
NSString* const PNKEY = @"kPnOn";
NSString* const RETAILER_ID = @"MerchantA1";
NSString* const DESFAULT_DISCOUNT_TYPE = @"Percentage";//@"UC003343434";
NSString* const KEY_IS_LOGGED_IN = @"kLoggedIn";
#ifdef DEV
//NSString* const BASE_URL = @"http://223.25.237.175/appwizlive/";
NSString* const BASE_URL = @"http://inceptionlive.com/"
#elif LIVE
//NSString* const BASE_URL = @"http://appwizlive.com/";
//NSString* const BASE_URL = @"http://appwiz.cloudapp.net/";
//NSString* const BASE_URL = @"http://inceptionlive.com//";
NSString* const BASE_URL = @"http://smartcommerce.asia/";
//NSString* const BASE_URL = @"http://119.81.207.36/";
#endif
NSString* const ITUNES_URL = @"https://itunes.apple.com/app/id793924538?ls=1&mt=8";


@end

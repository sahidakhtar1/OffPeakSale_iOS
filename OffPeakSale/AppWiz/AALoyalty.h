//
//  AALoyalty.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALoyalty : NSObject
extern NSInteger const MAX_COUPON_COUNT;
@property (nonatomic,strong) NSString* loyaltyImageUrlString;
@property (nonatomic,strong) NSString* facebookPageUrl;
@property (nonatomic,strong) NSString* termsCondtitions;
@property (nonatomic) NSInteger couponCount;
@property (nonatomic) NSString* fbIconDisplay;
@property (nonatomic) NSString* instagramDisplay;
@property (nonatomic,strong) NSString* instagramUrl;

@end

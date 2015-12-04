//
//  AARetailer.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AARetailerStores.h"
@interface AARetailer : NSObject

extern NSString* const RETAILER_FILE_TYPE_IMAGE;
extern NSString* const RETAILER_FILE_TYPE_VIDEO;
extern NSString* const RETAILER_FILE_TYPE_YOUTUBE_VIDEO;
extern NSString* const START_TIMER;
extern NSString* const STOP_TIMER;
@property (nonatomic,copy) NSString* retailerName;
@property (nonatomic,copy) NSString* retailerFileType;
@property (nonatomic,copy) NSString* retailerPoweredBy;
@property (nonatomic,copy) NSString* retailerFile;
@property (nonatomic,copy) NSString* retailerTextColorHexString;
@property (nonatomic,copy) NSString* retailerHeaderColorHexString;
@property (nonatomic,copy) NSString* splashScreenURLString;
@property (nonatomic,copy) NSString* companyLogo;
@property (nonatomic, copy) NSString* backdropType;
@property (nonatomic, copy) NSString* backdropFile;
@property (nonatomic, copy) NSString* backdropColor1;
@property (nonatomic, copy) NSString* backdropColor2;
@property (nonatomic, copy) NSString* enablePassword;
@property (nonatomic, copy) NSString* retailerAppType;

@property (nonatomic, copy) NSString* enableRewards;
@property (nonatomic, copy) NSString* defaultCurrency;
@property (nonatomic, copy) NSString* allowedCurrencies;
@property (nonatomic, copy) NSString* enableCreditCode;
@property (atomic, copy) NSString* enablePay;
@property (atomic, copy) NSString* enableVerit;
@property (nonatomic, copy) NSString* enableCOD;
@property (nonatomic, copy) NSString* appIconColor;
@property (nonatomic, copy) NSString* enableFeatured;
@property (nonatomic, copy) NSString* enableRating;
@property (nonatomic, copy) NSString* aboutUrl;
@property (nonatomic, copy) NSString* termsUrl;
@property (nonatomic, copy) NSString* enableDelivery;
@property (nonatomic, copy) NSString* deliveryDays;
@property (nonatomic, copy) NSString* deliveryHours;
@property (nonatomic, copy) NSString* enableCollection;
@property (nonatomic, copy) NSString* collectionDays;
@property (nonatomic, copy) NSString* collectionHours;
@property (nonatomic, copy) NSString* collectionTimeSlots;
@property (nonatomic, copy) NSString* collectionAddress;
@property (nonatomic, copy) NSString* deliveryType;
@property (nonatomic, copy) NSString* collectionType;
@property (nonatomic, copy) NSString* enableGiftWrap;
@property (nonatomic, copy) NSString* gift_price;
@property (nonatomic, copy) NSString* enableDiscovery;


@property (nonatomic, copy) NSString* instagramUrl;
@property (nonatomic, copy) NSString* instagramDisplay;
@property (nonatomic, copy) NSString* fbIconDisplay;
@property (nonatomic, copy) NSString* fbUrl;

@property (nonatomic,strong) NSMutableArray* stores;
@property (nonatomic,strong) NSMutableArray* home_imgArray;
@property (nonatomic,strong) NSMutableArray* products;
@property (nonatomic, strong) NSMutableArray* featuredStores;
@property (nonatomic, strong) NSString *iosVersion;
@property (nonatomic, strong) NSArray *menuList;
@property (nonatomic, strong) NSString *calendarUrl;
@property (nonatomic, strong) NSMutableArray *tutorialSlides;

-(void)addRetailerStore:(AARetailerStores*)retailerStore;
@end

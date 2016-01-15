//
//  AARetailer.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARetailer.h"

@implementation AARetailer
NSString* const RETAILER_FILE_TYPE_IMAGE = @"Image";
NSString* const RETAILER_FILE_TYPE_VIDEO = @"Video";
NSString* const RETAILER_FILE_TYPE_YOUTUBE_VIDEO = @"youtube";
NSString* const START_TIMER = @"startTimer";
NSString* const STOP_TIMER = @"startTimer";
@synthesize retailerHeaderColorHexString =  retailerHeaderColorHexString_;
@synthesize retailerTextColorHexString = retailerTextColorHexString_;
@synthesize companyLogo,backdropType,backdropFile,backdropColor1,backdropColor2,enablePassword,retailerAppType;
- (id)init
{
    self = [super init];
    if (self) {
        self.retailerFile = @"";
        self.retailerName = @"";
        self.retailerFileType = @"";
        self.retailerHeaderColorHexString = @"";
        self.retailerTextColorHexString = @"";
        self.splashScreenURLString = @"";
        self.retailerPoweredBy = @"";
        self.companyLogo = @"";
        self.backdropType = @"";
        self.backdropFile = @"";
        self.iosVersion = @"";
        self.stores = [[NSMutableArray alloc] init];
        self.home_imgArray = [[NSMutableArray alloc] init];
        self.products = [[NSMutableArray alloc] init];
        self.featuredStores = [[NSMutableArray alloc] init];
        self.tutorialSlides = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)addRetailerStore:(AARetailerStores*)retailerStore
{
    [self.stores addObject:retailerStore];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.retailerFile forKey:@"retailerFile"];
    [encoder encodeObject:self.retailerName forKey:@"retailerName"];
    [encoder encodeObject:self.retailerFileType forKey:@"retailerFileType"];
    [encoder encodeObject:self.retailerHeaderColorHexString forKey:@"retailerHeaderColor"];
    [encoder encodeObject:self.retailerTextColorHexString forKey:@"retailerTextColor"];
    [encoder encodeObject:self.splashScreenURLString forKey:@"splashScreenURLString"];
    [encoder encodeObject:self.stores forKey:@"retailerStores"];
    [encoder encodeObject:self.home_imgArray forKey:@"home_imgArray"];
    [encoder encodeObject:self.products forKey:@"products"];
    [encoder encodeObject:self.featuredStores forKey:@"featuredStores"];
    [encoder encodeObject:self.retailerPoweredBy forKey:@"retailerPoweredBy"];
    [encoder encodeObject:self.companyLogo forKey:@"companyLogo"];
    [encoder encodeObject:self.backdropType forKey:@"backdropType"];
    [encoder encodeObject:self.backdropFile forKey:@"backdropFile"];
    [encoder encodeObject:self.backdropColor1 forKey:@"backdropColor1"];
    [encoder encodeObject:self.backdropColor2 forKey:@"backdropColor2"];
    [encoder encodeObject:self.enablePassword forKey:@"enablePassword"];
    [encoder encodeObject:self.retailerAppType forKey:@"retailerAppType"];
    [encoder encodeObject:self.enableRating forKey:@"enableRating"];
    [encoder encodeObject:self.termsUrl forKey:@"termsUrl"];
    [encoder encodeObject:self.aboutUrl forKey:@"aboutUrl"];
    [encoder encodeObject:self.enableDelivery forKey:@"enableDelivery"];
    [encoder encodeObject:self.deliveryDays forKey:@"deliveryDays"];
    [encoder encodeObject:self.deliveryHours forKey:@"deliveryHours"];
    [encoder encodeObject:self.iosVersion forKey:@"iosVersion"];
    
    [encoder encodeObject:self.instagramDisplay forKey:@"instagramDisplay"];
    [encoder encodeObject:self.fbIconDisplay forKey:@"fbIconDisplay"];
    [encoder encodeObject:self.instagramUrl forKey:@"instagramUrl"];
    [encoder encodeObject:self.fbUrl forKey:@"fbUrl"];
    
    [encoder encodeObject:self.enableRewards forKey:@"enableRewards"];
    [encoder encodeObject:self.defaultCurrency forKey:@"defaultCurrency"];
    [encoder encodeObject:self.allowedCurrencies forKey:@"allowedCurrencies"];
    [encoder encodeObject:self.enableCreditCode forKey:@"enableCreditCode"];
    [encoder encodeObject:self.enablePay forKey:@"enablePay"];
    [encoder encodeObject:self.enableVerit forKey:@"enableVerit"];
    [encoder encodeObject:self.enableCOD forKey:@"enableCOD"];
    [encoder encodeObject:self.appIconColor forKey:@"appIconColor"];
    [encoder encodeObject:self.enableFeatured forKey:@"enableFeatured"];
    
    [encoder encodeObject:self.enableCollection forKey:@"enableCollection"];
    [encoder encodeObject:self.collectionDays forKey:@"collectionDays"];
    [encoder encodeObject:self.collectionHours forKey:@"collectionHours"];
    [encoder encodeObject:self.collectionTimeSlots forKey:@"collectionTimeSlots"];
    [encoder encodeObject:self.collectionAddress forKey:@"collectionAddress"];
    [encoder encodeObject:self.menuList forKey:@"menuList"];
    [encoder encodeObject:self.calendarUrl forKey:@"calendarUrl"];
    [encoder encodeObject:self.deliveryType forKey:@"deliveryType"];
    [encoder encodeObject:self.collectionType forKey:@"collectionType"];
    
    [encoder encodeObject:self.enableGiftWrap forKey:@"enableGiftWrap"];
    [encoder encodeObject:self.gift_price forKey:@"gift_price"];
    [encoder encodeObject:self.enableDiscovery forKey:@"enableDiscovery"];
    [encoder encodeObject:self.tutorialSlides forKey:@"tutorialSlides"];
    [encoder encodeObject:self.button_color forKey:@"button_color"];
    [encoder encodeObject:self.contactAddr forKey:@"contactAddr"];
    [encoder encodeObject:self.contactPhone forKey:@"contactPhone"];
    [encoder encodeObject:self.contactName forKey:@"contactName"];
    [encoder encodeObject:self.contactInstr forKey:@"contactInstr"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.retailerFile = [decoder decodeObjectForKey:@"retailerFile"];
        self.retailerName = [decoder decodeObjectForKey:@"retailerName"];
        self.retailerFileType = [decoder decodeObjectForKey:@"retailerFileType"];
        self.retailerHeaderColorHexString = [decoder decodeObjectForKey:@"retailerHeaderColor"];
        self.retailerTextColorHexString = [decoder decodeObjectForKey:@"retailerTextColor"];
        self.splashScreenURLString = [decoder decodeObjectForKey:@"splashScreenURLString"];
        self.stores = [decoder decodeObjectForKey:@"retailerStores"];
        self.home_imgArray = [decoder decodeObjectForKey:@"home_imgArray"];
        self.products = [decoder decodeObjectForKey:@"products"];
        self.featuredStores = [decoder decodeObjectForKey:@"featuredStores"];
        self.retailerPoweredBy = [decoder decodeObjectForKey:@"retailerPoweredBy"];
        self.companyLogo = [decoder decodeObjectForKey:@"companyLogo"];
        self.backdropType = [decoder decodeObjectForKey:@"backdropType"];
        self.backdropFile = [decoder decodeObjectForKey:@"backdropFile"];
        self.backdropColor1 = [decoder decodeObjectForKey:@"backdropColor1"];
        self.backdropColor2 = [decoder decodeObjectForKey:@"backdropColor2"];
        self.enablePassword = [decoder decodeObjectForKey:@"enablePassword"];
        self.retailerAppType = [decoder decodeObjectForKey:@"retailerAppType"];
        self.enableRating = [decoder decodeObjectForKey:@"enableRating"];
        self.termsUrl = [decoder decodeObjectForKey:@"termsUrl"];
        self.aboutUrl = [decoder decodeObjectForKey:@"aboutUrl"];
        self.enableDelivery = [decoder decodeObjectForKey:@"enableDelivery"];
        self.deliveryDays = [decoder decodeObjectForKey:@"deliveryDays"];
        self.deliveryHours = [decoder decodeObjectForKey:@"deliveryHours"];
        self.iosVersion = [decoder decodeObjectForKey:@"iosVersion"];
        
        self.instagramDisplay = [decoder decodeObjectForKey:@"instagramDisplay"];
        self.fbIconDisplay = [decoder decodeObjectForKey:@"fbIconDisplay"];
        self.instagramUrl = [decoder decodeObjectForKey:@"instagramUrl"];
        self.fbUrl = [decoder decodeObjectForKey:@"fbUrl"];
        
        self.enableRewards = [decoder decodeObjectForKey:@"enableRewards"];
        self.defaultCurrency = [decoder decodeObjectForKey:@"defaultCurrency"];
        self.allowedCurrencies = [decoder decodeObjectForKey:@"allowedCurrencies"];
        self.enableCreditCode = [decoder decodeObjectForKey:@"enableCreditCode"];
        self.enablePay = [decoder decodeObjectForKey:@"enablePay"];
        self.enableVerit = [decoder decodeObjectForKey:@"enableVerit"];
        self.enableCOD = [decoder decodeObjectForKey:@"enableCOD"];
        self.appIconColor = [decoder decodeObjectForKey:@"appIconColor"];
        self.enableFeatured = [decoder decodeObjectForKey:@"enableFeatured"];
        
        self.enableCollection = [decoder decodeObjectForKey:@"enableCollection"];
        self.collectionDays = [decoder decodeObjectForKey:@"collectionDays"];
        self.collectionHours = [decoder decodeObjectForKey:@"collectionHours"];
        self.collectionTimeSlots = [decoder decodeObjectForKey:@"collectionTimeSlots"];
        self.collectionAddress = [decoder decodeObjectForKey:@"collectionAddress"];
        self.menuList = [decoder decodeObjectForKey:@"menuList"];
        self.calendarUrl = [decoder decodeObjectForKey:@"calendarUrl"];
        self.deliveryType = [decoder decodeObjectForKey:@"deliveryType"];
        self.collectionType = [decoder decodeObjectForKey:@"collectionType"];
        self.enableGiftWrap = [decoder decodeObjectForKey:@"enableGiftWrap"];
        self.gift_price = [decoder decodeObjectForKey:@"gift_price"];
        self.enableDiscovery = [decoder decodeObjectForKey:@"enableDiscovery"];
        self.tutorialSlides = [decoder decodeObjectForKey:@"tutorialSlides"];
        self.button_color = [decoder decodeObjectForKey:@"button_color"];
        self.contactAddr = [decoder decodeObjectForKey:@"contactAddr"];
        self.contactPhone = [decoder decodeObjectForKey:@"contactPhone"];
        self.contactName = [decoder decodeObjectForKey:@"contactName"];
        self.contactInstr = [decoder decodeObjectForKey:@"contactInstr"];
    }
    return self;
}

-(void)setRetailerHeaderColorHexString:(NSString *)retailerHeaderColorHexString
{
    unsigned
    int hexRetailerHeaderColor = [AAUtils getHexFromHexString:retailerHeaderColorHexString];
    [AAColor sharedInstance].retailerThemeBackgroundColor = UIColorFromRGB(hexRetailerHeaderColor);
    retailerHeaderColorHexString_ = retailerHeaderColorHexString;
}

-(void)setRetailerTextColorHexString:(NSString *)retailerTextColorHexString
{
    unsigned
    int hexRetailerTextColor = [AAUtils getHexFromHexString:retailerTextColorHexString];
    [AAColor sharedInstance].retailerThemeTextColor = UIColorFromRGB(hexRetailerTextColor);

    retailerTextColorHexString_ = retailerTextColorHexString;
    
}

-(void)setButton_color:(NSString *)retailerButtonColorHexString
{
    unsigned
    int hexRetailerTextColor = [AAUtils getHexFromHexString:retailerButtonColorHexString];
    [AAColor sharedInstance].buttonBgColor = UIColorFromRGB(hexRetailerTextColor);
    
    
}


@end

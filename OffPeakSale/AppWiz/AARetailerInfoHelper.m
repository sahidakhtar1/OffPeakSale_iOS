//
//  AARetailerInfoHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARetailerInfoHelper.h"
#import "AAMediaItem.h"
#import "AAEShopProductOptions.h"
#import "AAFeaturedStoreObject.h"
@implementation AARetailerInfoHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
static NSString* const JSON_HEADER_COLOR_KEY = @"headerColor";
static NSString* const JSON_RETAILER_TEXT_COLOR_KEY = @"retailerTextColor";
static NSString* const JSON_RETAILER_NAME_KEY = @"retailerName";
static NSString* const JSON_RETAILER_FILE_TYPE_KEY = @"retailerFileType";
static NSString* const JSON_RETAILER_FILE_KEY = @"retailerFile";
static NSString* const JSON_RETAILER_POWERED_BY_KEY = @"poweredBy";
static NSString* const JSON_RETAILER_STORES_KEY = @"retailerStores";
static NSString* const JSON_RETAILER_HOME_IMAGES_KEY = @"home_imgArray";
static NSString* const JSON_RETAILER_PRODUCTS_KEY = @"products";
static NSString* const JSON_RETAILER_STORE_ADDRESS_KEY = @"storeAddress";
static NSString* const JSON_RETAILER_SPLASH_SCREEN_KEY = @"splashImage";
static NSString* const JSON_RETAILER_STORE_CONTACT_KEY = @"storeContact";
static NSString* const JSON_RETAILER_STORE_LATITUDE_KEY = @"latitude";
static NSString* const JSON_RETAILER_STORE_LONGITUDE_KEY = @"longitude";
static NSString* const JSON_RETAILER_COMPANYLOGO_KEY =@"companyLogo";
static NSString* const JSON_RETAILER_BACKDROPTYPE_KEY =@"backdropType";
static NSString* const JSON_RETAILER_BACKDROPFILE_KEY =@"backdropFile";
static NSString* const JSON_RETAILER_BACKDROPCOLOR1_KEY =@"backdropColor1";
static NSString* const JSON_RETAILER_BACKDROPCOLOR2_KEY =@"backdropColor2";
static NSString* const JSON_ENABLEPASSWORD_KEY =@"enablePassword";
static NSString* const JSON_RETAILAPPTYPE_KEY = @"retailerAppType";
static NSString* const JSON_RETAILFONT_KEY = @"siteFont";
static NSString* const JSON_TERMS_OF_USE = @"termsUrl";
static NSString* const JSON_RETAILER_HOME_IMAGES_FILEPATH_KEY = @"filePath";
static NSString* const JSON_RETAILER_HOME_IMAGES_FILETYPE_KEY = @"fileType";

static NSString* const JSON_PRODUCT_DESCRIPTION_KEY = @"desc";
static NSString* const JSON_PRODUCT_WORKING_INFORMATION_KEY = @"how_it_works";
static NSString* const JSON_PRODUCT_ID_KEY = @"id";
static NSString* const JSON_PRODUCT_NAME_KEY = @"name";
static NSString* const JSON_PRODUCT_OLD_PRICE_KEY = @"old_price";
static NSString* const JSON_PRODUCT_NEW_PRICE_KEY = @"new_price";
static NSString* const JSON_PRODUCT_IMAGE_KEY = @"product_img";
static NSString* const JSON_PRODUCT_SHORT_DESCRIPTION_KEY = @"short_desc";

+(void)processRetailerInformationWithCompletionBlock : (void(^)(void))success andFailure : (void(^)(NSString*)) failure
{
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY, nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getRetailerInfo.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                
                if([response objectForKey:JSON_DATA_KEY] )
                {
                     [AARetailerInfoHelper populateRetailerInfo:response];
                    success();
                }
                else
                {
                    failure(@"Invalid input");
                }
            }
            else
            {
                failure(@"Invalid input");
            }
        }
        else
        {
            failure(@"Invalid input");
        }
       
        
    } withFailureBlock:^(NSError *error) {
        failure(error.description);
    }];
}

+(void)populateRetailerInfo : (NSDictionary*)response
{
  
                NSDictionary* dictRetailer = [response objectForKey:JSON_DATA_KEY];
                
                AARetailer* retailer = [[AARetailer alloc] init];
                if([dictRetailer objectForKey:JSON_HEADER_COLOR_KEY])
                {
                    retailer.retailerHeaderColorHexString = [dictRetailer objectForKey:JSON_HEADER_COLOR_KEY];
                   
                }
                if([dictRetailer objectForKey:JSON_RETAILER_TEXT_COLOR_KEY])
                {
                    retailer.retailerTextColorHexString = [dictRetailer objectForKey:JSON_RETAILER_TEXT_COLOR_KEY];
                  
                   
                }
                if([dictRetailer objectForKey:@"appStoreUrl"])
                {
                    [AAAppGlobals sharedInstance].appStoreUrl = [dictRetailer objectForKey:@"appStoreUrl"];
                    
                    
                }
    
                if([dictRetailer objectForKey:@"iosVersion"])
                {
                    retailer.iosVersion = [dictRetailer objectForKey:@"iosVersion"];
                    
                    
                }
                if ([dictRetailer objectForKey:JSON_RETAILFONT_KEY]) {
                    [[AAAppGlobals sharedInstance] getNormalFont:[dictRetailer objectForKey:JSON_RETAILFONT_KEY]];
                }
                if ([dictRetailer objectForKey:JSON_TERMS_OF_USE]) {
                    [AAAppGlobals sharedInstance].termsConditions = [dictRetailer objectForKey:JSON_TERMS_OF_USE];
                    retailer.termsUrl = [dictRetailer objectForKey:JSON_TERMS_OF_USE];
                }
                if ([dictRetailer objectForKey:@"aboutUrl"]) {
                    retailer.aboutUrl = [dictRetailer objectForKey:@"aboutUrl"];
                }

    
                if ([response objectForKey:@"isSSL"]) {
                    [AAAppGlobals sharedInstance].isSSL = [NSString stringWithFormat:@"%@",[response objectForKey:@"isSSL"]];
                }
                if([dictRetailer objectForKey:JSON_RETAILER_NAME_KEY])
                {
                    retailer.retailerName = [dictRetailer objectForKey:JSON_RETAILER_NAME_KEY];
                }
                if ([dictRetailer objectForKey:JSON_RETAILER_COMPANYLOGO_KEY]) {
                    retailer.companyLogo = [dictRetailer objectForKey:JSON_RETAILER_COMPANYLOGO_KEY];
                }
                if ([dictRetailer objectForKey:JSON_RETAILER_BACKDROPTYPE_KEY]) {
                    retailer.backdropType = [dictRetailer objectForKey:JSON_RETAILER_BACKDROPTYPE_KEY];
                }
                if ([dictRetailer objectForKey:JSON_RETAILER_BACKDROPFILE_KEY]) {
                    retailer.backdropFile = [dictRetailer objectForKey:JSON_RETAILER_BACKDROPFILE_KEY];
                }
                if ([dictRetailer objectForKey:JSON_RETAILER_BACKDROPCOLOR1_KEY]) {
                    retailer.backdropColor1 = [dictRetailer objectForKey:JSON_RETAILER_BACKDROPCOLOR1_KEY];
                }
                if ([dictRetailer objectForKey:JSON_RETAILER_BACKDROPCOLOR2_KEY]) {
                    retailer.backdropColor2 = [dictRetailer objectForKey:JSON_RETAILER_BACKDROPCOLOR2_KEY];
                }
                if([dictRetailer objectForKey:JSON_RETAILER_POWERED_BY_KEY])
                {
                    retailer.retailerPoweredBy = [dictRetailer objectForKey:JSON_RETAILER_POWERED_BY_KEY];
                }
    
                if([dictRetailer objectForKey:@"menuList"])
                {
                    retailer.menuList = [dictRetailer objectForKey:@"menuList"];
                }
                if([dictRetailer objectForKey:@"calendarUrl"])
                {
                    retailer.calendarUrl = [dictRetailer objectForKey:@"calendarUrl"];
                }

//                if ([dictRetailer objectForKey:JSON_ENABLEPASSWORD_KEY]) {
//                    retailer.enablePassword = [dictRetailer objectForKey:JSON_ENABLEPASSWORD_KEY];
//                }
                if([dictRetailer objectForKey:JSON_RETAILAPPTYPE_KEY])
                {
                    retailer.retailerAppType = [dictRetailer objectForKey:JSON_RETAILAPPTYPE_KEY];
                }
    //added new fields
                if([dictRetailer objectForKey:@"enableRewards"])
                {
                    retailer.enableRewards = [dictRetailer objectForKey:@"enableRewards"];
                }
                if([dictRetailer objectForKey:@"enableRating"])
                {
                    retailer.enableRating = [dictRetailer objectForKey:@"enableRating"];
                }
    
                if([dictRetailer objectForKey:@"instagramUrl"])
                {
                    retailer.instagramUrl = [dictRetailer objectForKey:@"instagramUrl"];
                }
                if([dictRetailer objectForKey:@"instagramDisplay"])
                {
                    retailer.instagramDisplay = [NSString stringWithFormat:@"%@",[dictRetailer objectForKey:@"instagramDisplay"]];
                }
                if([dictRetailer objectForKey:@"fbIconDisplay"])
                {
                    retailer.fbIconDisplay = [NSString stringWithFormat:@"%@",[dictRetailer objectForKey:@"fbIconDisplay"]];
                }
                if([dictRetailer objectForKey:@"fbUrl"])
                {
                    retailer.fbUrl = [dictRetailer objectForKey:@"fbUrl"];
                }

                if([dictRetailer objectForKey:@"defaultCurrency"])
                {
                    retailer.defaultCurrency = [dictRetailer objectForKey:@"defaultCurrency"];
                    NSString *selectedCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECTED_CURRENCY];
                    if (selectedCurrency == nil || [selectedCurrency length] == 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:retailer.defaultCurrency forKey:KEY_SELECTED_CURRENCY];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if([dictRetailer objectForKey:@"allowedCurrencies"])
                {
                    retailer.allowedCurrencies = [dictRetailer objectForKey:@"allowedCurrencies"];
                }
                if([dictRetailer objectForKey:@"enableCreditCode"])
                {
                    NSString *enableShoppingCart =[dictRetailer objectForKey:@"enableCreditCode"];
                    if ([enableShoppingCart isEqualToString:@"1"]) {
                        [AAAppGlobals sharedInstance].enableCreditCode = TRUE;
                    }else{
                        [AAAppGlobals sharedInstance].enableCreditCode = FALSE;
                    }
                }
                if([dictRetailer objectForKey:@"enablePay"])
                {
                    retailer.enablePay = [dictRetailer objectForKey:@"enablePay"];
                }
                if([dictRetailer objectForKey:@"enableVerit"])
                {
                    retailer.enableVerit = [dictRetailer objectForKey:@"enableVerit"];
                }
                if([dictRetailer objectForKey:@"enableCOD"])
                {
                    retailer.enableCOD = [dictRetailer objectForKey:@"enableCOD"];
                }
                if([dictRetailer objectForKey:@"appIconColor"])
                {
                    retailer.appIconColor = [dictRetailer objectForKey:@"appIconColor"];
                }
                if([dictRetailer objectForKey:@"enableFeatured"])
                {
                    retailer.enableFeatured = [dictRetailer objectForKey:@"enableFeatured"];
                }
                if([dictRetailer objectForKey:@"enableRating"])
                {
                    [AAAppGlobals sharedInstance].enableRating = [dictRetailer objectForKey:@"enableRating"];
                }
                if([dictRetailer objectForKey:@"enableShoppingCart"])
                {
                    [AAAppGlobals sharedInstance].enableShoppingCart = [dictRetailer objectForKey:@"enableShoppingCart"];
                }
    
                if([dictRetailer objectForKey:@"enableDelivery"])
                {
                    [AAAppGlobals sharedInstance].enableDelivery = [dictRetailer objectForKey:@"enableDelivery"];
                }
                if([dictRetailer objectForKey:@"deliveryDays"])
                {
                    retailer.deliveryDays = [dictRetailer objectForKey:@"deliveryDays"];
                }
                if([dictRetailer objectForKey:@"deliveryHours"])
                {
                    retailer.deliveryHours = [dictRetailer objectForKey:@"deliveryHours"];
                }
                if([dictRetailer objectForKey:@"deliveryTimeSlots"])
                {
                    [AAAppGlobals sharedInstance].deliveryTimeSlots = [dictRetailer objectForKey:@"deliveryTimeSlots"];
                    NSString *deliveryTimeSlots =[AAAppGlobals sharedInstance].deliveryTimeSlots;
                    if (deliveryTimeSlots != nil && ![deliveryTimeSlots isKindOfClass:[NSNull class]]) {
                    
                        [AAAppGlobals sharedInstance].deliverySlotsArray = [[AAAppGlobals sharedInstance].deliveryTimeSlots componentsSeparatedByString:@","];
                        if ([[AAAppGlobals sharedInstance].deliverySlotsArray count]) {
                            [AAAppGlobals sharedInstance].selectedTime = [[AAAppGlobals sharedInstance].deliverySlotsArray objectAtIndex:0];
                        }
                    }
                }
                if([dictRetailer objectForKey:@"enableGiftWrap"])
                {
                    retailer.enableGiftWrap = [dictRetailer objectForKey:@"enableGiftWrap"];
                }
                if([dictRetailer objectForKey:@"gift_price"])
                {
                    retailer.gift_price = [dictRetailer objectForKey:@"gift_price"];
                }
    //Strore cllection details start
                if([dictRetailer objectForKey:@"enableCollection"])
                {
                    retailer.enableCollection = [dictRetailer objectForKey:@"enableCollection"];
                }
                if([dictRetailer objectForKey:@"collectionDays"])
                {
                    retailer.collectionDays = [dictRetailer objectForKey:@"collectionDays"];
                }
                if([dictRetailer objectForKey:@"deliveryType"])
                {
                    retailer.deliveryType = [dictRetailer objectForKey:@"deliveryType"];
                }
                if([dictRetailer objectForKey:@"collectionType"])
                {
                    retailer.collectionType = [dictRetailer objectForKey:@"collectionType"];
                }
                if([dictRetailer objectForKey:@"collectionHours"])
                {
                    retailer.collectionHours = [dictRetailer objectForKey:@"collectionHours"];
                }
                if([dictRetailer objectForKey:@"collectionTimeSlots"])
                {
                    retailer.collectionTimeSlots = [dictRetailer objectForKey:@"collectionTimeSlots"];
                    NSString *collectionTimeSlots =retailer.collectionTimeSlots;
                    if (collectionTimeSlots != nil && ![collectionTimeSlots isKindOfClass:[NSNull class]]) {
                        
                        [AAAppGlobals sharedInstance].collectionSlotsArray = [[AAAppGlobals sharedInstance].retailer.collectionTimeSlots componentsSeparatedByString:@","];
                        if ([[AAAppGlobals sharedInstance].collectionSlotsArray count]) {
                            [AAAppGlobals sharedInstance].selectedTime = [[AAAppGlobals sharedInstance].collectionSlotsArray objectAtIndex:0];
                        }
                    }
                }
                if([dictRetailer objectForKey:@"collectionAddress"])
                {
                    retailer.collectionAddress = [dictRetailer objectForKey:@"collectionAddress"];
                    NSString *collectionAddress =retailer.collectionAddress;
                    if (collectionAddress != nil && ![collectionAddress isKindOfClass:[NSNull class]]) {
                        
                        [AAAppGlobals sharedInstance].collectionAddressArray = [[AAAppGlobals sharedInstance].retailer.collectionAddress componentsSeparatedByString:@","];
                        if ([[AAAppGlobals sharedInstance].collectionAddressArray count]) {
                            [AAAppGlobals sharedInstance].selectedCollectionAddress = [[AAAppGlobals sharedInstance].collectionAddressArray objectAtIndex:0];
                        }
                    }
                }
     //Strore cllection details end

    
    
    //added new fields
                if([dictRetailer objectForKey:JSON_RETAILER_SPLASH_SCREEN_KEY])
                {
                    retailer.splashScreenURLString = [dictRetailer objectForKey:JSON_RETAILER_SPLASH_SCREEN_KEY];
                }
                if([dictRetailer objectForKey:JSON_RETAILER_FILE_KEY])
                {
                     retailer.retailerFile = [dictRetailer objectForKey:JSON_RETAILER_FILE_KEY];
                }
                if([dictRetailer objectForKey:JSON_RETAILER_FILE_TYPE_KEY])
                {
                     retailer.retailerFileType = [dictRetailer objectForKey:JSON_RETAILER_FILE_TYPE_KEY];
                }
    
                if ([dictRetailer objectForKey:@"enableDiscovery"]) {
                    retailer.enableDiscovery = [dictRetailer objectForKey:@"enableDiscovery"];
                }
                if([dictRetailer objectForKey:JSON_RETAILER_STORES_KEY])
                {
                    NSArray* arrRetailerStores = [dictRetailer objectForKey:JSON_RETAILER_STORES_KEY];
                    for(NSDictionary* store in arrRetailerStores)
                    {
                        AARetailerStores* retailerStore = [[AARetailerStores alloc] init];
                        if([store objectForKey:JSON_RETAILER_STORE_ADDRESS_KEY])
                        {
                            retailerStore.storeAddress = [store objectForKey:JSON_RETAILER_STORE_ADDRESS_KEY];
                        }
                        if([store objectForKey:JSON_RETAILER_STORE_CONTACT_KEY])
                        {
                            retailerStore.storeContact = [store objectForKey:JSON_RETAILER_STORE_CONTACT_KEY];
                        }
                        if([store objectForKey:JSON_RETAILER_STORE_LATITUDE_KEY] && [store objectForKey:JSON_RETAILER_STORE_LONGITUDE_KEY])
                        {
                            CGFloat latitude = [[store objectForKey:JSON_RETAILER_STORE_LATITUDE_KEY] floatValue];
                            CGFloat longitude = [[store objectForKey:JSON_RETAILER_STORE_LONGITUDE_KEY] floatValue];
                            
                            retailerStore.location = CLLocationCoordinate2DMake(latitude, longitude);
                        }
                        [retailer addRetailerStore:retailerStore];

                        
                    }
                }
                if([dictRetailer objectForKey:JSON_RETAILER_HOME_IMAGES_KEY])
                {
                    NSArray* arrRetailerStores = [dictRetailer objectForKey:JSON_RETAILER_HOME_IMAGES_KEY];
                    [retailer.home_imgArray removeAllObjects];
                    for(NSDictionary* store in arrRetailerStores)
                    {
                        AAMediaItem *mediaItem = [[AAMediaItem alloc] init];
                        if([store objectForKey:JSON_RETAILER_HOME_IMAGES_FILEPATH_KEY])
                        {
                            mediaItem.mediaUrl = [store objectForKey:JSON_RETAILER_HOME_IMAGES_FILEPATH_KEY];
                        }
                        if([store objectForKey:JSON_RETAILER_HOME_IMAGES_FILETYPE_KEY])
                        {
                            mediaItem.mediaType = [store objectForKey:JSON_RETAILER_HOME_IMAGES_FILETYPE_KEY];
                        }
                        [retailer.home_imgArray addObject:mediaItem];
                        
                    }
                }
                if ([dictRetailer objectForKey:@"featuredStores"]) {
                    NSArray *productOptions = [dictRetailer objectForKey:@"featuredStores"];
                    retailer.featuredStores = [[NSMutableArray alloc] init];
                    for (NSDictionary *option in productOptions) {
                        AAFeaturedStoreObject *item = [[AAFeaturedStoreObject alloc] init];
                        item.storeUrl = [option objectForKey:@"storeUrl"];
                        item.storeName = [option objectForKey:@"storeName"];
                        [retailer.featuredStores addObject:item];
                    }
                }
                if([dictRetailer objectForKey:JSON_RETAILER_PRODUCTS_KEY])
                {
                    NSArray* productList = [dictRetailer objectForKey:JSON_RETAILER_PRODUCTS_KEY];
                    [retailer.products removeAllObjects];
                        for(NSDictionary* product in productList)
                        {
                            AAEShopProduct* eShopProduct = [[AAEShopProduct alloc] init];
                            if ([product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY]) {
                                eShopProduct.productDescription = [product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY];
                            }
                            if ([product objectForKey:JSON_PRODUCT_WORKING_INFORMATION_KEY]) {
                                eShopProduct.productWorkingInformation = [product objectForKey:JSON_PRODUCT_WORKING_INFORMATION_KEY];
                            }
                            if ([product objectForKey:JSON_PRODUCT_ID_KEY]) {
                                eShopProduct.productId = [[product objectForKey:JSON_PRODUCT_ID_KEY] integerValue];
                            }
                            if ([product objectForKey:JSON_PRODUCT_NAME_KEY]) {
                                eShopProduct.productName = [product objectForKey:JSON_PRODUCT_NAME_KEY];
                            }
                            if ([product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY]) {
                                eShopProduct.productDescription = [product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY];
                            }
                            if ([product objectForKey:JSON_PRODUCT_NEW_PRICE_KEY]) {
                                eShopProduct.currentProductPrice = [product objectForKey:JSON_PRODUCT_NEW_PRICE_KEY];
                                //                                if (!isPriceChecked) {
                                //                                    isPriceChecked = true;
                                //                                    NSString * price = [NSString stringWithFormat:@"%@",eShopProduct.currentProductPrice];
                                //                                    NSRange range;
                                //                                    range = [price rangeOfString:@"."];
                                //                                    NSLog(@"Price = %@",price);
                                //                                    if (range.location == NSNotFound){
                                //                                        //[AAAppGlobals sharedInstance].isDecimalAllowed = false;
                                //                                        NSLog(@"decemal not Price = %@",price);
                                //                                    }else{
                                //                                        [AAAppGlobals sharedInstance].isDecimalAllowed = true;
                                //                                         NSLog(@"decemal yes Price = %@",price);
                                //                                    }
                                //
                                //                                }
                            }
                            if ([product objectForKey:JSON_PRODUCT_OLD_PRICE_KEY]) {
                                eShopProduct.previousProductPrice = [product objectForKey:JSON_PRODUCT_OLD_PRICE_KEY];
                                if ([eShopProduct.previousProductPrice floatValue]==0) {
                                    eShopProduct.previousProductPrice = nil;
                                }
                            }
                            if ([product objectForKey:JSON_PRODUCT_IMAGE_KEY]) {
                                eShopProduct.productImageURLString = [product objectForKey:JSON_PRODUCT_IMAGE_KEY];
                            }
                            if ([product objectForKey:JSON_PRODUCT_SHORT_DESCRIPTION_KEY]) {
                                eShopProduct.productShortDescription = [product objectForKey:JSON_PRODUCT_SHORT_DESCRIPTION_KEY];
                            }
                            if ([product objectForKey:@"availQty"]) {
                                eShopProduct.availQty = [product objectForKey:@"availQty"];
                            }
                            if ([product objectForKey:@"onSale"]) {
                                eShopProduct.onSale = [product objectForKey:@"onSale"];
                            }
                            if ([product objectForKey:@"productRating"]) {
                                eShopProduct.productRating = [product objectForKey:@"productRating"];
                            }
                            if ([product objectForKey:@"testimonials"]) {
                                eShopProduct.testimonials = [product objectForKey:@"testimonials"];
                            }
                            if ([product objectForKey:@"reward_points"]) {
                                eShopProduct.reward_points = [product objectForKey:@"reward_points"];
                            }
                            if ([product objectForKey:@"product_options"]) {
                                NSArray *productOptions = [product objectForKey:@"product_options"];
                                eShopProduct.product_options = [[NSMutableArray alloc] init];
                                for (NSDictionary *option in productOptions) {
                                    AAEShopProductOptions *item = [[AAEShopProductOptions alloc] init];
                                    item.optionLabel = [option objectForKey:@"optionLabel"];
                                    item.optionValue = [option objectForKey:@"optionValue"];
                                    [eShopProduct.product_options addObject:item];
                                }
                            }
                            if ([product objectForKey:@"product_img"]) {
                                eShopProduct.product_img = [product objectForKey:@"product_img"];
                            }
                            if ([product objectForKey:@"product_imgArray"]) {
                                NSArray *productOptions = [product objectForKey:@"product_imgArray"];
                                eShopProduct.product_imgs = [[NSMutableArray alloc] init];
                                for (NSDictionary *option in productOptions) {
                                    AAMediaItem *item = [[AAMediaItem alloc] init];
                                    item.mediaUrl = [option objectForKey:@"filePath"];
                                    item.mediaType = [option objectForKey:@"fileType"];
                                    [eShopProduct.product_imgs addObject:item];
                                }
                            }
                            
                            
                            
                            
                            
                            [retailer.products addObject:eShopProduct];
                            
                            
                            

                        
                    }
                }
    
                [AAAppGlobals sharedInstance].retailer = retailer;
                NSData *dataRetailer = [NSKeyedArchiver archivedDataWithRootObject:retailer];
    
                [[NSUserDefaults standardUserDefaults] setObject:dataRetailer forKey:USER_DEFAULTS_RETAILER_KEY];
               
                [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
}

@end

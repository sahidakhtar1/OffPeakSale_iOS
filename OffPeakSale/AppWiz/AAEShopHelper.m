//
//  AAEShopHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopHelper.h"

#import "AAEShopProductOptions.h"
#import "AAMediaItem.h"

@implementation AAEShopHelper
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
static NSString* const JSON_DATA_KEY = @"data";
static NSString* const JSON_CATEGORY_NAME_KEY = @"category";
static NSString* const JSON_PRODUCTS_KEY = @"products";
static NSString* const JSON_PRODUCT_DESCRIPTION_KEY = @"desc";
static NSString* const JSON_PRODUCT_WORKING_INFORMATION_KEY = @"how_it_works";
static NSString* const JSON_PRODUCT_ID_KEY = @"id";
static NSString* const JSON_PRODUCT_NAME_KEY = @"name";
static NSString* const JSON_PRODUCT_OLD_PRICE_KEY = @"old_price";
static NSString* const JSON_PRODUCT_NEW_PRICE_KEY = @"new_price";
static NSString* const JSON_PRODUCT_IMAGE_KEY = @"product_img";
static NSString* const JSON_PRODUCT_SHORT_DESCRIPTION_KEY = @"short_desc";

+(void)refreshEshopInformationForCategory:(NSString*)cid
                               searchText:(NSString*)keyword
                                   sortBy:(NSString*)sortBy
                     WithCompletionBlock : (void(^)(void))success
{

    @try {
        if (keyword == nil && sortBy != nil && [sortBy isEqualToString:@"rate"]) {
            if([[NSUserDefaults standardUserDefaults] objectForKey:cid])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:cid];
                [AAAppGlobals sharedInstance].products = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                success();
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error in getting data from local");
    }
    @finally {
         NSLog(@"error in getting data from local");
    }
    
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    if (cid != nil) {
       [dict setValue:cid forKey:@"cid"];
    }
    if (keyword != nil) {
       [dict setValue:keyword forKey:@"keyword"];
    }
    if (sortBy != nil && keyword == nil) {
        [dict setValue:sortBy forKey:@"sortBy"];
    }
//    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,
//                            [AAAppGlobals sharedInstance].customerEmailID,@"email", nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getAllProducts.php" withParams:dict withSuccessBlock:^(NSDictionary *response) {
        [AAEShopHelper populateCategories:response];
        success();
        if (keyword == nil && sortBy != nil && [sortBy isEqualToString:@"rate"]) {
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].products];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data forKey:cid];
            [defaults synchronize];
            
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog( @"Network failure" );
    }];
}
+(void)getEshopProductDetail:(NSString*)productId
        WithCompletionBlock : (void(^)(AAEShopProduct*))success{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [dict setValue:productId forKey:@"product_id"];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"getProductInfo.php" withParams:dict withSuccessBlock:^(NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([response valueForKey:@"data"]) {
            AAEShopProduct *product = [AAEShopHelper populateProduct:[response valueForKey:@"data"]];
            success(product);
        }
        
        
    } withFailureBlock:^(NSError *error) {
        //NSLog( @"Network failure" );
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

+(void)populateCategories : (NSDictionary*)response
{
    [AAAppGlobals sharedInstance].isDecimalAllowed = false;
    BOOL isPriceChecked = false;
    if([response objectForKey:JSON_ERROR_CODE_KEY])
    {
        if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
        {
            if ([response objectForKey:@"credit_terms"]) {
                [AAAppGlobals sharedInstance].credit_terms = [response objectForKey:@"credit_terms"];
            }
            
            if ([response objectForKey:@"currency_code"]) {
                NSString *currency_code =[response objectForKey:@"currency_code"];
                if ([currency_code isKindOfClass:[NSNull class]] ) {
                    currency_code = @"SGD";
                }
                [AAAppGlobals sharedInstance].currency_code = currency_code;
                
               // [AAAppGlobals sharedInstance].currency_symbol = [AAAppGlobals sharedInstance].currency_code;
                [[AAAppGlobals sharedInstance] getCurrencySymbol];
            }
            
            if ([response objectForKey:@"enableShoppingCart"]) {
                NSString *enableShoppingCart =[response objectForKey:@"enableShoppingCart"];
                if ([enableShoppingCart isEqualToString:@"1"]) {
                    [AAAppGlobals sharedInstance].enableShoppingCart = TRUE;
                }else{
                   [AAAppGlobals sharedInstance].enableShoppingCart = FALSE;
                }
                
                
                
            }
            if ([response objectForKey:@"enableCreditCode"]) {
                NSString *enableShoppingCart =[response objectForKey:@"enableCreditCode"];
                if ([enableShoppingCart isEqualToString:@"1"]) {
                    [AAAppGlobals sharedInstance].enableCreditCode = TRUE;
                }else{
                    [AAAppGlobals sharedInstance].enableCreditCode = FALSE;
                }
                
                
                
            }
            if ([response objectForKey:@"enableRating"]) {
                NSString *enableRating =[response objectForKey:@"enableRating"];
                
                if ([enableRating isEqualToString:@"1"]) {
                    [AAAppGlobals sharedInstance].enableRating = TRUE;
                }else{
                    [AAAppGlobals sharedInstance].enableRating = FALSE;
                }
                
            }
            if ([response objectForKey:@"disablePayment"]) {
                NSString *disablePayment =[response objectForKey:@"disablePayment"];
                
                if ([disablePayment isEqualToString:@"1"]) {
                    [AAAppGlobals sharedInstance].disablePayment = TRUE;
                }else{
                    [AAAppGlobals sharedInstance].disablePayment = FALSE;
                }
                
            }
            if([response objectForKey:@"enablePay"])
            {
                [AAAppGlobals sharedInstance].retailer.enablePay = [response objectForKey:@"enablePay"];
            }
            if([response objectForKey:@"enableVerit"])
            {
                [AAAppGlobals sharedInstance].retailer.enableVerit = [response objectForKey:@"enableVerit"];
            }
            if([response objectForKey:@"enableCOD"])
            {
                [AAAppGlobals sharedInstance].retailer.enableCOD = [response objectForKey:@"enableCOD"];
            }
            if([response objectForKey:@"deliveryDays"])
            {
                [AAAppGlobals sharedInstance].retailer.deliveryDays = [response objectForKey:@"deliveryDays"];
            }
            if([response objectForKey:@"deliveryTimeSlots"])
            {
                [AAAppGlobals sharedInstance].deliveryTimeSlots = [response objectForKey:@"deliveryTimeSlots"];
                NSString *deliveryTimeSlots =[AAAppGlobals sharedInstance].deliveryTimeSlots;
                if (deliveryTimeSlots != nil && ![deliveryTimeSlots isKindOfClass:[NSNull class]]) {
                    
                    [AAAppGlobals sharedInstance].deliverySlotsArray = [[AAAppGlobals sharedInstance].deliveryTimeSlots componentsSeparatedByString:@","];
                    if ([[AAAppGlobals sharedInstance].deliverySlotsArray count]) {
                        [AAAppGlobals sharedInstance].selectedTime = [[AAAppGlobals sharedInstance].deliverySlotsArray objectAtIndex:0];
                    }
                }
            }
           // [AAAppGlobals sharedInstance].enableShoppingCart = TRUE;
            
                if([response objectForKey:JSON_DATA_KEY] )
            {
               
                NSArray* arrCategoryList = [response objectForKey:JSON_DATA_KEY];
                [AAAppGlobals sharedInstance].products =  [self populateProducts:arrCategoryList];
//                for(NSDictionary* category in arrCategoryList)
//                {
//                    AAEshopCategory* eShopCategory = [[AAEshopCategory alloc] init];
//                    if([category objectForKey:JSON_CATEGORY_NAME_KEY])
//                    {
//                        eShopCategory.categoryName = [category objectForKey:JSON_CATEGORY_NAME_KEY];
//                    }
//                    if([category objectForKey:JSON_PRODUCTS_KEY])
//                    {
//                        NSArray* productList = [category objectForKey:JSON_PRODUCTS_KEY];
//                        
//                        for(NSDictionary* product in productList)
//                        {
//                            AAEShopProduct* eShopProduct = [[AAEShopProduct alloc] init];
//                            if ([product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY]) {
//                                eShopProduct.productDescription = [product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_WORKING_INFORMATION_KEY]) {
//                                eShopProduct.productWorkingInformation = [product objectForKey:JSON_PRODUCT_WORKING_INFORMATION_KEY];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_ID_KEY]) {
//                                eShopProduct.productId = [[product objectForKey:JSON_PRODUCT_ID_KEY] integerValue];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_NAME_KEY]) {
//                                eShopProduct.productName = [product objectForKey:JSON_PRODUCT_NAME_KEY];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY]) {
//                                eShopProduct.productDescription = [product objectForKey:JSON_PRODUCT_DESCRIPTION_KEY];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_NEW_PRICE_KEY]) {
//                                eShopProduct.currentProductPrice = [product objectForKey:JSON_PRODUCT_NEW_PRICE_KEY];
////                                if (!isPriceChecked) {
////                                    isPriceChecked = true;
////                                    NSString * price = [NSString stringWithFormat:@"%@",eShopProduct.currentProductPrice];
////                                    NSRange range;
////                                    range = [price rangeOfString:@"."];
////                                    NSLog(@"Price = %@",price);
////                                    if (range.location == NSNotFound){
////                                        //[AAAppGlobals sharedInstance].isDecimalAllowed = false;
////                                        NSLog(@"decemal not Price = %@",price);
////                                    }else{
////                                        [AAAppGlobals sharedInstance].isDecimalAllowed = true;
////                                         NSLog(@"decemal yes Price = %@",price);
////                                    }
////                                    
////                                }
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_OLD_PRICE_KEY]) {
//                                eShopProduct.previousProductPrice = [product objectForKey:JSON_PRODUCT_OLD_PRICE_KEY];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_IMAGE_KEY]) {
//                                eShopProduct.productImageURLString = [product objectForKey:JSON_PRODUCT_IMAGE_KEY];
//                            }
//                            if ([product objectForKey:JSON_PRODUCT_SHORT_DESCRIPTION_KEY]) {
//                                eShopProduct.productShortDescription = [product objectForKey:JSON_PRODUCT_SHORT_DESCRIPTION_KEY];
//                            }
//                            if ([product objectForKey:@"productRating"]) {
//                                eShopProduct.productRating = [product objectForKey:@"productRating"];
//                            }
//                            if ([product objectForKey:@"testimonials"]) {
//                                eShopProduct.testimonials = [product objectForKey:@"testimonials"];
//                            }
////                            if ([product objectForKey:@"product_options"]) {
////                                NSArray *productOptions = [product objectForKey:@"product_options"];
////                                eShopProduct.product_options = [[NSMutableArray alloc] init];
////                                for (NSDictionary *option in productOptions) {
////                                    AAEShopProductOptions *item = [[AAEShopProductOptions alloc] init];
////                                    item.optionLabel = [option objectForKey:@"optionLabel"];
////                                    item.optionValue = [option objectForKey:@"optionValue"];
////                                    [eShopProduct.product_options addObject:item];
////                                }
////                            }
////                            if ([product objectForKey:@"product_img"]) {
////                                eShopProduct.product_img = [product objectForKey:@"product_img"];
////                            }
////                            if ([product objectForKey:@"product_imgArray"]) {
////                                NSArray *productOptions = [product objectForKey:@"product_imgArray"];
////                                eShopProduct.product_imgs = [[NSMutableArray alloc] init];
////                                for (NSDictionary *option in productOptions) {
////                                    AAMediaItem *item = [[AAMediaItem alloc] init];
////                                    item.mediaUrl = [option objectForKey:@"filePath"];
////                                    item.mediaType = [option objectForKey:@"fileType"];
////                                    [eShopProduct.product_imgs addObject:item];
////                                }
////                            }
//
//                            
//                            
//                            [eShopCategory addProduct:eShopProduct];
//                            
//                    
//                            
//                        }
//                        
//                    }
//                    if([category objectForKey:JSON_CATEGORY_NAME_KEY])
//                    {
//                        [categoryList addEshopProductCategory:eShopCategory];
//                       
//                    }
//                    
//                }
                
//                [AAAppGlobals sharedInstance].categoryList = categoryList;
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].categoryList];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:data forKey:USER_DEFAULTS_ESHOP_KEY];
//                [defaults synchronize];
                
                
            }
            
            
        }
    }
    
}
+(NSMutableArray*)populateProducts:(NSArray*)productList{
//        NSArray* productList = [dictRetailer objectForKey:JSON_RETAILER_PRODUCTS_KEY];
    NSMutableArray *products = [[NSMutableArray alloc] init];
        for(NSDictionary* product in productList)
        {
            AAEShopProduct* eShopProduct = [self populateProduct:product];
            
            [products addObject:eShopProduct];
        }
    return products;
}
+(AAEShopProduct*)populateProduct:(NSDictionary*)product{
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
        eShopProduct.currentProductPrice = [NSString stringWithFormat:@"%@", [product objectForKey:JSON_PRODUCT_NEW_PRICE_KEY]];
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
        eShopProduct.previousProductPrice =[NSString stringWithFormat:@"%@", [product objectForKey:JSON_PRODUCT_OLD_PRICE_KEY]];
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
    if ([product objectForKey:@"productRating"]) {
        eShopProduct.productRating = [product objectForKey:@"productRating"];
    }
    if ([product objectForKey:@"testimonials"]) {
        eShopProduct.testimonials = [product objectForKey:@"testimonials"];
    }
    if ([product objectForKey:@"reward_points"]) {
        eShopProduct.reward_points = [product objectForKey:@"reward_points"];
    }
    if ([product objectForKey:@"availQty"]) {
        eShopProduct.availQty = [product objectForKey:@"availQty"];
    }
    if ([product objectForKey:@"onSale"]) {
        eShopProduct.onSale = [product objectForKey:@"onSale"];
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
    return eShopProduct;
}
@end

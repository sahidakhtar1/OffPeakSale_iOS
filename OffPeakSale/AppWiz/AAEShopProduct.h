//
//  AAEShopProduct.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAEShopProduct : NSObject
@property (nonatomic) NSInteger productId;
@property (nonatomic,copy) NSString* productName;
@property (nonatomic,copy) NSString* productDescription;
@property (nonatomic,copy) NSString* productShortDescription;
@property (nonatomic,copy) NSString* productWorkingInformation;
@property (nonatomic, copy) NSString* testimonials;
@property (nonatomic, copy) NSString* productRating;
@property (nonatomic, copy) NSString* product_img;
@property (nonatomic, strong) NSMutableArray *product_options;
@property (nonatomic, strong) NSMutableArray *product_imgs;
@property (nonatomic, strong) NSString *reward_points;
@property (nonatomic, strong) NSString *selectedOptionOne;
@property (nonatomic, strong) NSString *selectedOptionTwo;
@property (nonatomic, strong) NSString *qty;
@property (nonatomic, strong) NSString *availQty;
@property (nonatomic, strong) NSString *onSale;
@property (nonatomic, strong) NSString *giftMsg;
@property (nonatomic, strong) NSString *giftFor;
@property (nonatomic) Boolean giftWrapOpted;

@property (nonatomic,copy) NSString* previousProductPrice;
@property (nonatomic,copy)
    NSString* currentProductPrice;
@property (nonatomic,copy)
NSString* productImageURLString;
-(AAEShopProduct*)createCopy;


@end

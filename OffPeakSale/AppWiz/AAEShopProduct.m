//
//  AAEShopProduct.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopProduct.h"

@implementation AAEShopProduct
- (id)init
{
    self = [super init];
    if (self) {
        self.productId = -1;
        self.productName = @"";
        self.productDescription = @"";
        self.productShortDescription = @"";
        self.productWorkingInformation = @"";
        self.previousProductPrice = @"";
        self.currentProductPrice = @"";
        self.productImageURLString = @"";
        self.productRating = @"";
        self.testimonials = @"";
        self.reward_points = @"";
        self.selectedOptionOne = nil;
        self.selectedOptionTwo = nil;
        self.availQty = nil;
        self.product_options = [[NSMutableArray alloc] init];
        self.product_imgs = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:[NSNumber numberWithInteger:self.productId] forKey:@"productId"];
     [encoder encodeObject:self.productName forKey:@"productName"];
     [encoder encodeObject:self.productDescription forKey:@"productDescription"];
     [encoder encodeObject:self.productShortDescription forKey:@"productShortDescription"];
     [encoder encodeObject:self.productWorkingInformation forKey:@"productWorkingInformation"];
     [encoder encodeObject:self.testimonials forKey:@"testimonials"];
     [encoder encodeObject:self.previousProductPrice forKey:@"productPreviousPrice"];
     [encoder encodeObject:self.currentProductPrice forKey:@"productCurrentPrice"];
     [encoder encodeObject:self.productImageURLString forKey:@"productImageURLString"];
     [encoder encodeObject:self.productRating forKey:@"productRating"];
     [encoder encodeObject:self.product_options forKey:@"product_options"];
     [encoder encodeObject:self.product_imgs forKey:@"product_imgs"];
     [encoder encodeObject:self.product_img forKey:@"product_img"];
     [encoder encodeObject:self.reward_points forKey:@"reward_points"];
     [encoder encodeObject:self.availQty forKey:@"availQty"];
     [encoder encodeObject:self.onSale forKey:@"onSale"];
    [encoder encodeObject:self.outletName forKey:@"outletName"];
    [encoder encodeObject:self.outletAddr forKey:@"outletAddr"];
    [encoder encodeObject:self.outletContact forKey:@"outletContact"];
    [encoder encodeObject:self.outletLat forKey:@"outletLat"];
    [encoder encodeObject:self.outletLong forKey:@"outletLong"];
    [encoder encodeObject:self.offpeak_discount forKey:@"offpeak_discount"];
    
     }

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.productId = [[decoder decodeObjectForKey:@"productId"] integerValue];
        self.productName = [decoder decodeObjectForKey:@"productName"];
        self.productDescription = [decoder decodeObjectForKey:@"productDescription"];
        self.productShortDescription = [decoder decodeObjectForKey:@"productShortDescription"];
        self.productWorkingInformation = [decoder decodeObjectForKey:@"productWorkingInformation"];
        self.testimonials = [decoder decodeObjectForKey:@"testimonials"];
        self.previousProductPrice = [decoder decodeObjectForKey:@"productPreviousPrice"];
        self.currentProductPrice = [decoder decodeObjectForKey:@"productCurrentPrice"];
        self.productImageURLString = [decoder decodeObjectForKey:@"productImageURLString"];
        self.productRating = [decoder decodeObjectForKey:@"productRating"];
        self.product_options = [decoder decodeObjectForKey:@"product_options"];
        self.product_imgs = [decoder decodeObjectForKey:@"product_imgs"];
        self.product_img = [decoder decodeObjectForKey:@"product_img"];
        self.reward_points = [decoder decodeObjectForKey:@"reward_points"];
        self.availQty = [decoder decodeObjectForKey:@"availQty"];
        self.onSale = [decoder decodeObjectForKey:@"onSale"];
        self.outletName = [decoder decodeObjectForKey:@"outletName"];
        self.outletAddr = [decoder decodeObjectForKey:@"outletAddr"];
        self.outletContact = [decoder decodeObjectForKey:@"outletContact"];
        self.outletLat = [decoder decodeObjectForKey:@"outletLat"];
        self.outletLong = [decoder decodeObjectForKey:@"outletLong"];
        self.offpeak_discount = [decoder decodeObjectForKey:@"offpeak_discount"];
        
    }
    return self;
}

-(AAEShopProduct*)createCopy{
    AAEShopProduct *copy = [[AAEShopProduct alloc] init];
    copy.productId = self.productId;
    copy.productName = self.productName;
    copy.productDescription = self.productDescription;
    copy.productShortDescription = self.productShortDescription;
    copy.productWorkingInformation = self.productWorkingInformation;
    copy.testimonials = self.testimonials;
    copy.previousProductPrice = self.previousProductPrice;
    copy.currentProductPrice = self.currentProductPrice;
    copy.productImageURLString = self.productImageURLString;
    copy.productRating = self.productRating;
    copy.product_options = self.product_options;
    copy.product_imgs = self.product_imgs;
    copy.product_img = self.product_img;
    copy.reward_points = self.reward_points;
    copy.availQty = self.availQty;
    copy.onSale = self.onSale;
    return copy;
}
@end

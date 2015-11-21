//
//  ItemDetail.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 26/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemDetail : NSManagedObject

@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSString * productShortDescription;
@property (nonatomic, retain) NSString * previousProductPrice;
@property (nonatomic, retain) NSString * currentProductPrice;
@property (nonatomic, retain) NSString * productImageURLString;
@property (nonatomic, retain) NSString * qty;
@property (nonatomic, retain) NSString * productWorkingInformation;
@property (nonatomic, strong) UIImage *productImage;

@end

//
//  AAEshopCategories.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAEShopProduct.h"
@interface AAEshopCategory : NSObject
{
    NSMutableArray* productList_;
}
@property (nonatomic,copy) NSString* categoryName;

-(id)initWithName: (NSString*)categoryName;
-(void)addProduct : (AAEShopProduct*)product;
-(NSMutableArray*)getProductList;
@end

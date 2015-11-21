//
//  AAEshopCategories.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEshopCategory.h"

@implementation AAEshopCategory
- (id)init
{
    self = [super init];
    if (self) {
        productList_ = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id)initWithName: (NSString*)categoryName
{
    self = [self init];
    if (self) {
        self.categoryName = categoryName;
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.categoryName forKey:@"categoryName"];
 
    [encoder encodeObject:productList_ forKey:@"productsList"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.categoryName = [decoder decodeObjectForKey:@"categoryName"];
        productList_ = [decoder decodeObjectForKey:@"productsList"];
       
    }
    return self;
}
-(void)addProduct : (AAEShopProduct*)product
{
    [productList_ addObject:product];
}

-(NSMutableArray*)getProductList
{
    return productList_;
}
@end

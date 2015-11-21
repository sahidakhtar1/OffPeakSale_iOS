//
//  AAEshopCategoryList.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 26/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEshopCategoryList.h"

@implementation AAEshopCategoryList

- (id)init
{
    self = [super init];
    if (self) {
        categories_ = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)addEshopProductCategory : (AAEshopCategory*)category
{
    [categories_ addObject:category];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:categories_ forKey:@"categories"];
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
       
        categories_ = [decoder decodeObjectForKey:@"categories"];
        
    }
    return self;
}

-(NSMutableArray*)getCategoryNames
{
   return [[categories_ valueForKey:@"categoryName"] mutableCopy];
}

-(BOOL)doesCategoryNameExist : (NSString*)categoryName
{
    for(AAEshopCategory* category in categories_)
    {
        if([category.categoryName isEqualToString:categoryName])
        {
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray*)getProductListWithCategoryName: (NSString*)categoryName
{
    for(AAEshopCategory* category in categories_)
    {
        if([category.categoryName isEqualToString:categoryName])
        {
            return [category getProductList];
        }
    }
    return nil;
}

-(AAEshopCategory*)getCategoryWithCategoryName: (NSString*)categoryName
{
    for(AAEshopCategory* category in categories_)
    {
        if([category.categoryName isEqualToString:categoryName])
        {
            return category;
        }
    }
    return nil;
}

-(void)removeAllCategories
{
    [categories_ removeAllObjects];
}
@end

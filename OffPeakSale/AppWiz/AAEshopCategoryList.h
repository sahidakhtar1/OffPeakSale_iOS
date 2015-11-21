//
//  AAEshopCategoryList.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 26/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAEshopCategory.h"
@interface AAEshopCategoryList : NSObject
{
    NSMutableArray* categories_;
}
-(void)addEshopProductCategory : (AAEshopCategory*)category;
-(NSMutableArray*)getCategoryNames;
-(BOOL)doesCategoryNameExist : (NSString*)categoryName;
-(NSMutableArray*)getProductListWithCategoryName: (NSString*)categoryName;
-(AAEshopCategory*)getCategoryWithCategoryName: (NSString*)categoryName;
-(void)removeAllCategories;
@end

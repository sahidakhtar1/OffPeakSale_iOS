//
//  AAEShopCategoriesScrollView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAEShopCategoryScrollViewDelegate.h"
#import "AATabButton.h"
@interface AAEShopCategoriesScrollView : UIScrollView
{
    NSMutableArray* arrButtonViews_;
}
@property (nonatomic,strong) NSMutableArray* categories;
@property (nonatomic,strong) id<AAEShopCategoryScrollViewDelegate> eShopCategoryDelegate;
@property (nonatomic) NSString* selectedCategory;
@property (nonatomic,strong) UIFont* fontCategoryName;
@property (nonatomic, strong) UIView *selectedIndicator;
-(void)refreshScrollView;
@end

//
//  AAEShopProductCell.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAEShopProduct.h"
#import "AAEShopCardLabel.h"
#import "UIImageView+WebCache.h"
#import "RatingView.h"
#import "ItemDetail.h"

@protocol ShoppingCartItemDelegate <NSObject>

-(void)deleteItemAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface AAEShopWithDeleteCell : UITableViewCell
@property (nonatomic,strong) AAEShopProduct* eshopProduct;
@property (nonatomic,strong) UIView* viewMainContent;

@property (nonatomic, strong) RatingView *ratingView;
@property (nonatomic,strong) UILabel* lblProductName;
@property (nonatomic,strong) UILabel* lblProductShortDescription;
@property (nonatomic,strong) UILabel* lblProductCurrentPrice;
@property (nonatomic,strong) UILabel* lblProductPreviousPrice;
@property (nonatomic,strong) UIImageView* imgViewProductImage;
@property (nonatomic, strong) AAEShopProduct *cartItem;

@property (nonatomic,strong) UIView* overlayView;
@property (nonatomic) BOOL overlayLayer;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, unsafe_unretained) id<ShoppingCartItemDelegate> delegate;

-(void) setProductForCart:(AAEShopProduct*)item;
-(void)populateViews;
@end

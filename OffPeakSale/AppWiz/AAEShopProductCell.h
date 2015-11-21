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
@interface AAEShopProductCell : UITableViewCell
@property (nonatomic,strong) AAEShopProduct* eshopProduct;
@property (nonatomic,strong) UIView* viewMainContent;
@property (nonatomic) CGFloat contentHeight;

@property (nonatomic, strong) RatingView *ratingView;
@property (nonatomic,strong) UILabel* lblProductName;
@property (nonatomic,strong) UILabel* lblProductShortDescription;
@property (nonatomic,strong) UILabel* lblProductCurrentPrice;
@property (nonatomic,strong) UILabel* lblProductPreviousPrice;
@property (nonatomic,strong) UIImageView* imgViewProductImage;
@property (nonatomic, strong) ItemDetail *cartItem;
@property (nonatomic, strong) UIView *vwQtyIndicator;
@property (nonatomic, strong) UILabel *lblQtyIndicator;
@property (nonatomic, strong) UIView *vwSaleIndicator;
@property (nonatomic, strong) UILabel *lblSaleIndicator;


@property (nonatomic,strong) UIView* overlayView;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic) BOOL overlayLayer;

-(void) setProductForCart:(ItemDetail*)item;
@end

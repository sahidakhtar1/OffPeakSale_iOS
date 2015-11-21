//
//  AAProductInformationScrollView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 18/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAEShopProduct.h"
#import "UIImageView+WebCache.h"
#import "AAThemeHeadingView.h"
#import "RatingView.h"
#import  "AAProfileUpdatePopupView.h"
#import "AAVariantView.h"
#import "AAFilterDropDownScrollView.h"
@class AABannerView;
@protocol ProductRatingDelegate <NSObject>

-(void)rateProductWithProductId:(NSString*)productId withRating:(NSString*)rating;
-(void)presentImageZoomWithImage:(UIImage*)image;

@end

@interface AAProductInformationScrollView : UIScrollView{
    UIImage *prodImage;
}
@property (nonatomic, unsafe_unretained) id <ProductRatingDelegate> delegate;
@property (nonatomic,strong) AAEShopProduct* product;
@property (nonatomic,strong) UIFont* fontHeading;
@property (nonatomic,strong) UIFont* fontBody;
@property (nonatomic,strong) UIFont* fontProductShortDescription;
@property (nonatomic, strong) RatingView *ratingView;
@property (nonatomic,strong) AAProfileUpdatePopupView* updatePopupView;
@property (nonatomic,strong) AABannerView *banner;
@property (nonatomic, strong) AAVariantView *option1;
@property (nonatomic, strong) AAVariantView *option2;
@property (nonatomic,strong) AAFilterDropDownScrollView* optionDropDown;
@property (nonatomic, strong) NSString *selectedOption1;
@property (nonatomic, strong) NSString *selectedOption2;


-(void)refreshScrollView;
@end

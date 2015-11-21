//
//  AAConfirmPurchasePopupView.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AABasePopupView.h"
#import "AAEShopProduct.h"
#import "AAThemeGlossyButton.h"
#import "UIImageView+WebCache.h"
@interface AAConfirmPurchasePopupView : AABasePopupView

@property (nonatomic,strong) AAEShopProduct* eShopProduct;
@property (nonatomic,strong) NSDictionary* orderInformation;

//Creates and returns the confirm purchase popup view given a background frame, product and orderInformation.
+(AAConfirmPurchasePopupView*)createDatePickerViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect withProduct:(AAEShopProduct*)product andOrderInfo :(NSDictionary*)orderInfo;
@end

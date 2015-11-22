//
//  AAColor.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface AAColor : NSObject 


extern NSString* const NOTIFICATION_THEME_CHANGED;

@property (nonatomic,strong) UIColor* eShopCardBackgroundColor;
@property (nonatomic,strong) UIColor* eShopCardTextColor;
@property (nonatomic,strong) UIColor* eShopCategoryTextColor;
@property (nonatomic,strong) UIColor* retailerThemeTextColor;
@property (nonatomic,strong) UIColor* retailerThemeBackgroundColor;
@property (nonatomic,strong) UIColor* eShopVerticalSeparatorColor;
@property (nonatomic,strong) UIColor* retailerThemeLightColor;
@property (nonatomic,strong) UIColor* retailerThemeDarkColor;
@property (nonatomic,strong) UIColor* profileTextFieldTextColor;
@property (nonatomic,strong) UIColor* rbSelectedColor;

+ (AAColor *)sharedInstance;
@end

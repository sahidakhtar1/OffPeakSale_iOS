//
//  AAColor.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAColor.h"

@implementation AAColor
//@synthesize retailerThemeBackgroundColor = _retailerThemeBackgroundColor;
static AAColor* singleInstance;

NSString* const NOTIFICATION_THEME_CHANGED = @"ThemeChanged";
+ (AAColor *)sharedInstance
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        singleInstance = [[AAColor alloc] init];
        [singleInstance setDefaultColors];
        
    });
    
    return singleInstance;
}




-(void)setDefaultColors
{
   
    self.eShopCardBackgroundColor = UIColorFromRGB(0x000000);
    self.profileTextFieldTextColor = UIColorFromRGB(0x000000);
    self.eShopCardTextColor = UIColorFromRGB(0xFFFFFF);
    self.eShopCategoryTextColor = UIColorFromRGB(0x000000);
    self.eShopVerticalSeparatorColor = UIColorFromRGB(0xA3A3A3);
    self.rbSelectedColor = UIColorFromRGB(0x757575);
    self.product_title_color = UIColorFromRGB(0x343434);
    self.old_price_color = UIColorFromRGB(0x4d4d4d);
    self.textFieldDefaultBorader= UIColorFromRGB(0x757575);
    self.deviderColor = UIColorFromRGB(0x757575);

}

-(void)setRetailerThemeBackgroundColor:(UIColor *)retailerThemeBackgroundColor{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_THEME_CHANGED object:nil];
    [self willChangeValueForKey:@"_retailerThemeBackgroundColor"];
    _retailerThemeBackgroundColor = retailerThemeBackgroundColor;
    [self didChangeValueForKey:@"_retailerThemeBackgroundColor"];
    self.retailerThemeLightColor = [retailerThemeBackgroundColor colorWithAlphaComponent:0.2];
    self.retailerThemeDarkColor = [ self darkerColor: retailerThemeBackgroundColor];
}

- (UIColor *)darkerColor:(UIColor*)color
{
    return color;
    CGFloat h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"_retailerThemeBackgroundColor"]) {
        return NO;
    }
    else
    {
        return [super automaticallyNotifiesObserversForKey:key];
    }
}
@end

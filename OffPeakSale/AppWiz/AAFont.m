//
//  AAFont.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFont.h"

@implementation AAFont
NSString* const FONT_NAME = @"ArialMT";
NSString* const FONT_BOLD_NAME = @"Arial-BoldMT";
+(UIFont*)eShopCategoryTextFont
{
    return [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:11.0];
}

+(UIFont*)titleTextFont
{
    return [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:18.0];
}

+(UIFont*)defaultFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:size];
}

+(UIFont*)defaultBoldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:size];
}
@end

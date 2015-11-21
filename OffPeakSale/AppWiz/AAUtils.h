//
//  AAUtils.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAUtils : NSObject
+(CGSize)getTextSizeWithFont : (UIFont*)font andText:(NSString*)text andMaxWidth:(CGFloat)width;
CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
+(NSInteger)calculateAgeFromDate:(NSDate*)dateOfBirth;
+(unsigned int)getHexFromHexString : (NSString*)hexString;
@end

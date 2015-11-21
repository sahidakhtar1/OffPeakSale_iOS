//
//  AAStyleHelper.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAStyleHelper : NSObject
+(void)addGradientOverlayToView : (UIView*)view withFrame : (CGRect)frame withColor : (UIColor*)color;
+(void)addLightShadowToView:(UIView*)view;
@end

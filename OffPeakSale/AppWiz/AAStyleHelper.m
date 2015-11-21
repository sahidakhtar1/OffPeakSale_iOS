//
//  AAStyleHelper.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAStyleHelper.h"

@implementation AAStyleHelper
+(void)addGradientOverlayToView : (UIView*)view withFrame : (CGRect)frame withColor : (UIColor*)color
{
    
   
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = view.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[backdropcolo1 CGColor], (id)[backdropcolo2 CGColor], nil];
//    [self.vwBackDropContainerView.layer insertSublayer:gradient atIndex:0];
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       //(id)[color CGColor],
                       (id)[[color colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[color colorWithAlphaComponent:0.0f] CGColor],
                       /*(id)[[color colorWithAlphaComponent:0.3f] CGColor],
                        (id)[[color colorWithAlphaComponent:0.3f] CGColor],*/
                      
                       nil];
    
    
        colors = [[colors reverseObjectEnumerator] allObjects];
    
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [view.layer insertSublayer:gradient atIndex:0];
}

+(void)addLightShadowToView:(UIView*)view
{
//    view.layer.masksToBounds = NO;
//    view.layer.shadowOpacity = 0.5;
//    view.layer.shadowOffset = CGSizeMake(0, 0);
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowRadius = 4.0;
    view.layer.borderColor = BOARDER_COLOR.CGColor;
    view.layer.borderWidth = 1.0f;
}
@end

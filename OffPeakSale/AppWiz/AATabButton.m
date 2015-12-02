//
//  AATabButton.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 18/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AATabButton.h"

@implementation AATabButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self setUpView];
          
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
     [self addBackgroundImages];
     [self addShadow];
}

-(void)addBackgroundImages
{
//    [self setBackgroundColor:[UIColor clearColor]];
    UIImage* defaultBackgroundImage = [UIImage imageNamed:@"btn_tab_default"];
    
    [self setBackgroundImage:[defaultBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0,ceil(defaultBackgroundImage.size.width/2),0,ceil(defaultBackgroundImage.size.width/2) -1)] forState:UIControlStateNormal];
    
//    UIImage* selectedBackgroundImage = [UIImage imageNamed:@"btn_tab_selected"];
//    
//    [self setBackgroundImage:[selectedBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)] forState:UIControlStateSelected];

    
}

-(void)addShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 3.0;
    self.layer.masksToBounds = NO;
    //[self.layer setShadowPath:[self addRightShadow]];
}
-(void)removeShadow{
   // self.layer.
    self.layer.shadowOpacity = 0.0;
}
- (CGPathRef)addRightShadow
{
   
    UIBezierPath* path = [UIBezierPath bezierPath];
    
   
    
    // Start at the Top Left Corner
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame), 0.0)];
    
    
    
    // Move to the Bottom Right Corner
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [path closePath];
    
    return path.CGPath;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

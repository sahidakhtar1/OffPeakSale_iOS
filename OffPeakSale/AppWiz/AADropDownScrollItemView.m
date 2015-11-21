//
//  AADropDownScrollItemView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AADropDownScrollItemView.h"

@implementation AADropDownScrollItemView
NSInteger const LABEL_MARGIN = 10;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initValues];
        self.bottomBorderColor =[UIColor colorWithWhite:0.8f
                                                  alpha:1.0f];
        self.topBorderColor =[UIColor colorWithWhite:0.8f
                                                  alpha:1.0f];
    }
    return self;
}


-(void)initValues
{
    
   
    
    self.lblItemName = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN, 0, self.frame.size.width - 2*LABEL_MARGIN, self.frame.size.height)];
    [self.lblItemName setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.lblItemName];
   
}



-(void)addTopBorder
{
   self.topBorder = [CALayer layer];
    
     self.topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.0f);
    
     self.topBorder.backgroundColor = self.topBorderColor.CGColor;
    
    [self.layer addSublayer: self.topBorder];
    [self updateLabelFrame];
}

-(void)addBottomBorder
{
    self.bottomBorder = [CALayer layer];
    
     self.bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height-1, self.frame.size.width, 0.5f);
    
     self.bottomBorder.backgroundColor = self.bottomBorderColor.CGColor;
    
    [self.layer addSublayer: self.bottomBorder];
    [self updateLabelFrame];
}

-(void)updateLabelFrame
{
    CGRect lblFrame = self.lblItemName.frame;
    if(self.bottomBorder)
    {
        lblFrame.size.height -= self.bottomBorder.frame.size.height;
        lblFrame.origin.y -= self.bottomBorder.frame.size.height;

    }
    
    if(self.topBorder)
    {
         lblFrame.size.height -= self.topBorder.frame.size.height;
         lblFrame.origin.y += self.topBorder.frame.size.height;
    }
    
        self.lblItemName.frame = lblFrame;
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

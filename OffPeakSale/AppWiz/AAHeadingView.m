//
//  AAProductInformationHeadingView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 18/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAHeadingView.h"

@implementation AAHeadingView
static NSInteger const LABEL_PADDING_SIDES = 0;
static NSInteger const LABEL_PADDING_TOP = 5;
@synthesize viewStylingColor = viewStylingColor_;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        self.viewStylingColor = [UIColor blackColor];
        [self addHeadingLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.viewStylingColor.CGColor);
    
   //horizontal line
    CGContextSetLineWidth(context, 4.0);
    
    CGContextMoveToPoint(context, 0,self.bounds.origin.y + self.bounds.size.height); //start at this point
    
    CGContextAddLineToPoint(context, self.bounds.size.width,self.bounds.origin.y + self.bounds.size.height); //draw to this point
    
    
    
    //horizontal line
    CGContextStrokePath(context);
    
//    CGRect rectangle = CGRectMake(0, 0, 8, self.bounds.size.height);
//   
//    CGContextSetFillColorWithColor(context, self.viewStylingColor.CGColor); //this is the transparent color
//   
//    CGContextFillRect(context, rectangle);
   
}

-(void)addHeadingLabel
{
    self.lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_PADDING_SIDES, 0, self.frame.size.width - LABEL_PADDING_SIDES*2, self.frame.size.height - LABEL_PADDING_TOP)];
    self.lblHeading.adjustsFontSizeToFitWidth = YES;
    self.lblHeading.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.lblHeading setNumberOfLines:1];
    [self.lblHeading setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.lblHeading];
}

-(void)setViewStylingColor:(UIColor *)viewStylingColor{
    viewStylingColor_ = viewStylingColor;
    [self setNeedsDisplay];
}

@end

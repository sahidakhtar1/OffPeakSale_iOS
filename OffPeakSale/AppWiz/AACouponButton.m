//
//  AACouponButton.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACouponButton.h"

@implementation AACouponButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self initImages];
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initImages];
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
-(void)initImages
{
    [self setBackgroundImage:[UIImage imageNamed: @"coupon_default"] forState:UIControlStateNormal];
     [self setBackgroundImage:[UIImage imageNamed: @"coupon_selected"] forState:UIControlStateSelected];
}
@end

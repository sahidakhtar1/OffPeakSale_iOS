//
//  AAPaymentSelectorView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 18/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPaymentSelectorView.h"

@implementation AAPaymentSelectorView
NSInteger const LEFT_PADDING = 5;
NSInteger const CARD_NUMBER_WIDTH = 125;
NSInteger const PAYMENT_TYPE_IMAGE_HEIGHT = 30;
NSInteger const PAYMENT_TYPE_IMAGE_WIDTH = 80;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setUpViews];
    }
    return self;
}

-(void)setUpViews
{
    [self addHeaderView];
    [self addContentView];
}

-(void)addContentView
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeader.frame.size.height, self.frame.size.width, self.frame.size.height - self.viewHeader.frame.size.height)];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    CGSize lblCardNumberSize = [AAUtils getTextSizeWithFont:[UIFont systemFontOfSize:13.0] andText:@"Card Number" andMaxWidth:CGFLOAT_MAX];
    UILabel* lblCardNumber = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING, 20, lblCardNumberSize.width, PAYMENT_TYPE_IMAGE_HEIGHT)];
    [lblCardNumber setText:@"Card Number"];
    [lblCardNumber setFont:[UIFont systemFontOfSize:13.0]];
    
    [self.contentView addSubview:lblCardNumber];
    
    self.tfCardNumber = [[UITextField alloc] initWithFrame:CGRectMake( lblCardNumber.frame.origin.x + lblCardNumber.frame.size.width + 10, 20, CARD_NUMBER_WIDTH, 30)];
    self.tfCardNumber.font = [UIFont systemFontOfSize:12.0];
   
    self.tfCardNumber.borderStyle = UITextBorderStyleRoundedRect;
  
   
    self.tfCardNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:self.tfCardNumber];
    
    UIImageView* imgViewPaymentLogo = [[UIImageView alloc] initWithFrame:CGRectMake( self.tfCardNumber.frame.origin.x + self.tfCardNumber.frame.size.width + 10, 20, PAYMENT_TYPE_IMAGE_WIDTH, PAYMENT_TYPE_IMAGE_HEIGHT)];
    
    [imgViewPaymentLogo setImage:[UIImage imageNamed:@"paypal_logo"]];
    
    [imgViewPaymentLogo setContentMode:UIViewContentModeLeft];
    [self.contentView addSubview:imgViewPaymentLogo];
    [self addSubview:self.contentView];
    
}




-(void)addHeaderView;
{
    self.viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, PAYMENT_TYPE_IMAGE_HEIGHT + 2*5)];
    [self.viewHeader setBackgroundColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
    [self addSubview:self.viewHeader];
}

@end

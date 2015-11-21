//
//  AALoginDailogView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 24/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAOrderSucessView.h"
#import "AALoginHelper.h"
#import "AAAppGlobals.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";


static NSString* const CREDIT_TITLE_MSG = @"Purchase Order Submitted";
static NSString* const PAYMENT_TITLE_MSG = @"Payment Sucessful";

static NSString* const GRAND_TOTAL = @"Grand Total: ";

static NSString* const CREDIT_ORDER_NO = @"Commercial Order No: ";
static NSString* const PAYMENT_ORDER_NO = @"Order No: ";

static NSString* const CREDIT_MSG = @"Dear Customer,\nYour purchase order has been submitted.\nYou will receive E-Mail confirmation shortly.";
static NSString* const PAYMENT_MSG = @"Dear Customer,\nYour purchase is sucessful.\nYou will receive E-Mail confirmation shortly.";

@implementation AAOrderSucessView
- (id)initWithFrame:(CGRect)frame withOderNumber:(NSString*)odernumber grandTotal:(NSString*)total andIsByCredit:(BOOL)isByCredit
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.mOrderNumber = odernumber;
        self.mGrandTotal = total;
        self.mIsByCredit = isByCredit;
        self.backgroundColor= [UIColor clearColor];
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
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AAOrderSucessView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)refreshView{
   // self.vwHeaderView.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    CGRect rect = [UIScreen mainScreen].bounds;
    self.frame = rect;
    CALayer *layer = self.vwContainerView.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor clearColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.08f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    self.lblHeaderText.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17];
    self.lblGrandTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17];
    self.lblOrderNo.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:12];
    self.lblOderMsg.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:12];
    self.lblThabkYou.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:14];
    self.btnDismiss.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
   // self.lblThabkYou.text = @"dvvsd";

    CGSize productTextSize = [AAUtils getTextSizeWithFont:self.lblOderMsg.font andText:self.mGrandTotal andMaxWidth:self.lblOderMsg.frame.size.width];
    self.lblOderMsg.text = self.mGrandTotal;
    CGRect frame = self.lblOderMsg.frame;
    frame.size.height = productTextSize.height;
    self.lblOderMsg.frame = frame;
    
    CGRect contentViewFrame = self.vwContainerView.frame;
    contentViewFrame.size.height = frame.size.height + 20;
    contentViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - (contentViewFrame.size.height + 30);
    self.vwContainerView.frame =contentViewFrame;
    
//    self.vwContainerView.center = CGPointMake(self.center.x, rect.size.height/2);
    self.btnDismiss.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(removeView) userInfo:nil repeats:NO];
}


- (IBAction)btnCloseTapped:(id)sender {
    [self removeFromSuperview];
   // [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"REgistration required." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}
-(void)removeView{
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self removeView];
}
@end

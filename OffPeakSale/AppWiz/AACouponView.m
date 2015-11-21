//
//  AACouponView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 19/07/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AACouponView.h"
#import "AAAppGlobals.h"
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
@implementation AACouponView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
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
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"CouponView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)refreshView{
    // self.vwHeaderView.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    CGRect rect = [UIScreen mainScreen].bounds;
    self.frame = rect;
    CALayer *layer = self.vwContainerView.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    
    self.vwContainerView.center = CGPointMake(self.center.x, rect.size.height/2);
    self.tfCouon.text = @"";
    
    self.lblDiscount.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17];
    self.btnApplyCoupon.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.btnClose.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
}
- (IBAction)btnApplyCouponTapped:(id)sender {
    if ([self.tfCouon.text length]>0) {
        [self validateouponCode];
    }
}

- (IBAction)btnCloseTapped:(id)sender {
    [self removeFromSuperview];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect rect = [UIScreen mainScreen].bounds;
        [UIView animateWithDuration:.5 animations:^(void){
            CGRect frame = self.vwContainerView.frame;
            
            float endPoint = frame.origin.y + frame.size.height;
            if ((rect.size.height - 230)<endPoint) {
                frame.origin.y -= endPoint - (rect.size.height -230);
            }
            self.vwContainerView.frame = frame;
        }
                         completion:nil];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    CGRect rect = [UIScreen mainScreen].bounds;
        self.vwContainerView.center = CGPointMake(self.vwContainerView.center.x, rect.size.height/2);
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tfCouon resignFirstResponder];
    CGRect rect = [UIScreen mainScreen].bounds;
    self.vwContainerView.center = CGPointMake(self.vwContainerView.center.x, rect.size.height/2);
}
-(void)validateouponCode{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
     NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,self.tfCouon.text,@"creditCode",[[AAAppGlobals sharedInstance] allProductsID],@"productId", nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"validateToken.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            self.imgResult.hidden = false;
            self.lblDiscount.hidden = false;
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
                NSString *discount = @"0";
                if([response objectForKey:@"discount"])
                {
                    discount = [response objectForKey:@"discount"];
                }
                if([response objectForKey:@"discountType"])
                {
                    [AAAppGlobals sharedInstance].discountType = [response objectForKey:@"discountType"];
                }
                [AAAppGlobals sharedInstance].discountPercent = discount;
                [[AAAppGlobals sharedInstance] calculateCartTotal];
                if ([AAAppGlobals sharedInstance].cartTotal <= 0) {
                    self.lblDiscount.text = [NSString stringWithFormat:@"Invalid Voucher"];
                    self.imgResult.image = [UIImage imageNamed:@"fail"];
                    [AAAppGlobals sharedInstance].discountPercent = 0;
                    [AAAppGlobals sharedInstance].discountCode = nil;
                    [[AAAppGlobals sharedInstance] calculateCartTotal];
                }else{
                    [AAAppGlobals sharedInstance].discountCode = self.tfCouon.text;
                    if ([[AAAppGlobals sharedInstance].discountType isEqualToString:DESFAULT_DISCOUNT_TYPE]) {
                        self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@ discount awarded",discount,@"%"];
                    }else{
                        self.lblDiscount.text = [NSString stringWithFormat:@"%@ %@ discount awarded",[AAAppGlobals sharedInstance].currency_code,discount];
                    }
                    
                    self.imgResult.image = [UIImage imageNamed:@"success"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"couponApplied" object:nil];
                    if([AAAppGlobals sharedInstance].enableShoppingCart){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCartWithOutClick" object:nil];
                    }
                }
                
                
            }
            else
            {
               self.lblDiscount.text = [NSString stringWithFormat:@"Invalid Voucher"];
                self.imgResult.image = [UIImage imageNamed:@"fail"];
            }
        }
        else
        {
           
        }
        
        
    } withFailureBlock:^(NSError *error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}
@end

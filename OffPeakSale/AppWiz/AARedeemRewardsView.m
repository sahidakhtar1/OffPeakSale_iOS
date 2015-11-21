//
//  AARedeemRewardsView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/9/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARedeemRewardsView.h"
#import "AARedeemRewardsHelper.h"
@implementation AARedeemRewardsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        [self setFont];
        CGRect rect = [UIScreen mainScreen].bounds;
        self.frame = rect;
        CALayer *layer = self.vwContainerView.layer;
        layer.shadowOffset = CGSizeMake(1, 1);
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowRadius = 4.0f;
        layer.shadowOpacity = 0.80f;
        layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        self.vwContainerView.center = CGPointMake(self.center.x, rect.size.height/2);
    }
    return self;
}

- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AARedeemRewardsView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    self.lblTotalPts.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17];
    self.lblCashCredit.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17];
    
    self.lblTotalPointsValue.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17];
    self.lblCashCreditValu.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17];
    self.lblResult.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:14];
    self.lblTotalPointsValue.text = [NSString stringWithFormat:@"%@ Points",[AAAppGlobals sharedInstance].reward_points];
    self.lblCashCreditValu.text = [NSString stringWithFormat:@"%@ Points",[AAAppGlobals sharedInstance].reward_points];
}
- (IBAction)btnCloseTapped:(id)sender {
    [self.tfCredit resignFirstResponder];
    [self removeFromSuperview];
}

- (IBAction)btnReedemTapped:(id)sender {
    [self.tfCredit resignFirstResponder];
    if ([self.tfCredit.text integerValue]<=0) {
        return;
    }
    if ([self.tfCredit.text integerValue]> [AAAppGlobals sharedInstance].cartTotal) {
        self.lblResult.text = @"Entered Credit point is higher than earned Cart Total";
        self.lblResult.textColor =  [UIColor redColor];
        self.lblResult.hidden = false;
    }else if ([self.tfCredit.text integerValue] > 0 && [self.tfCredit.text integerValue]< [[AAAppGlobals sharedInstance].reward_points integerValue]) {
        self.lblResult.hidden = true;
        [AARedeemRewardsHelper redeemReward:[NSString stringWithFormat:@"%ld",(long)[self.tfCredit.text integerValue] ]
                        withCompletionBlock:^(NSString *sucessMsg){
            self.lblResult.text = sucessMsg;
            self.lblResult.textColor =  [UIColor blackColor];
            self.lblResult.hidden = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RewardsRedeemed" object:nil];
        }
                                 andFailure:^(NSString *errorMSG){
                                     self.lblResult.text = errorMSG;
                                     self.lblResult.textColor =  [UIColor redColor];
                                     self.lblResult.hidden = false;
                                 }];
    }else{
        self.lblResult.text = @"Entered Credit point is higher than earned reward points";
        self.lblResult.textColor =  [UIColor redColor];
        self.lblResult.hidden = false;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end

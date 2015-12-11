//
//  AAOrderDetailView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/15/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAOrderDetailView.h"

@implementation AAOrderDetailView

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
//        self.frame = frame;
        CGRect bottomViewFrame = self.frame;
        bottomViewFrame.size.height = frame.size.height;
        bottomViewFrame.size.width = frame.size.width;
        self.frame = bottomViewFrame;
       
//        [self.lblAddressValue setContentHuggingPriority:UILayoutPriorityRequired forAxis:(UILayoutConstraintAxisHorizontal)];
//        [self.lblAddressValue setContentHuggingPriority:UILayoutPriorityRequired forAxis:(UILayoutConstraintAxisVertical)];
        
        self.lblOrderId.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_ID_FONTSIZE];
         self.lblName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
         self.lblAddress.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
         self.lblTelephone.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
         self.lblDistance.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
         self.lblStatus.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];
         self.lblExpiry.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:ORDER_HISTORY_FONTSIZE];


    }
    return self;
}
-(void)awakeFromNib{
    
}
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AAOrderDetailView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    
}
- (IBAction)btnNameTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nameTappaed)]) {
        [self.delegate nameTappaed];
    }
}
@end

//
//  AAEShopFilterView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 12/05/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopFilterView.h"

@implementation AAEShopFilterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.frame = frame;
        self.backgroundColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        [self setFont];
        //        [self setRightIconstoTestFields];
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
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AAEShopFilterView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    self.lblFilterTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
    self.btnFilterNone.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
    self.btnFilterPopularity.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
    self.btnFilterLatest.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
    self.btnFilterLowestPrice.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
    self.btnFilterHighestPrice.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:17.0];
    self.btnDone.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17.0];
}
- (IBAction)btnFilteSelected:(id)sender {
    UIButton *button = (UIButton*)sender;
    self.selectedFilterIndex = [button tag];
    CGPoint center = self.imgFilterIndicator.center;
    center.y = button.center.y;
    self.imgFilterIndicator.center = center;
}

- (IBAction)btnDoneTapped:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(filterAppliedWith:)]) {
        [self.delegate filterAppliedWith:self.selectedFilterIndex];
    }
    [self removeFromSuperview];
}

- (IBAction)btnCloseTapped:(id)sender {
    [self removeFromSuperview];
}
@end

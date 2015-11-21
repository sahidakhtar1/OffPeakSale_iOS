//
//  AAVariantView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 21/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAVariantView.h"
#import "AAAppGlobals.h"
@implementation AAVariantView

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        
        self.backgroundColor= [UIColor clearColor];
    }
    return self;
}
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"VariantView" owner:self options:nil] objectAtIndex:0];
    self.vwHorizontalLine.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.vwVerticalLine.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.lblOptionlbl.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_HEADING_FONTSIZE];
    self.btnOptions.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_HEADING_FONTSIZE];
    return childView;
}
- (IBAction)btnOptionTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(showOptionDropDown:)]) {
        [self.delegate showOptionDropDown:tag];
    }
}
@end

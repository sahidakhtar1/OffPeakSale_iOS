//
//  AAHowItWorksView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/6/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAHowItWorksView.h"

@implementation AAHowItWorksView

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
        [self setFont];
        self.frame = frame;
        
    }
    return self;
}

- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AAHowItWorksView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    self.lblHowItWorksHeading.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_HEADING_FONTSIZE];
    self.lblHowItWorksDetail.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_BODY_FONTSIZE];
}
-(void)setHowItWorks:(NSString*)text{
    self.lblHowItWorksDetail.text = text;
    CGSize productTextSize = [AAUtils getTextSizeWithFont:self.lblHowItWorksDetail.font andText:self.lblHowItWorksDetail.text andMaxWidth:self.lblHowItWorksDetail.frame.size.width];
    
    CGRect frame = self.lblHowItWorksDetail.frame;
    frame.size.height = productTextSize.height;
    self.lblHowItWorksDetail.frame = frame;
    
    CGSize contentSize = self.mScrollView.contentSize;
    contentSize.height = self.lblHowItWorksDetail.frame.origin.y + self.lblHowItWorksDetail.frame.size.height+10;
    self.mScrollView.contentSize  = contentSize;
    
    CGRect underlineFrame = self.vwUnderLine.frame;
    underlineFrame.size.width = self.lblHowItWorksDetail.frame.size.width;
    self.vwUnderLine.frame = underlineFrame;
}
@end

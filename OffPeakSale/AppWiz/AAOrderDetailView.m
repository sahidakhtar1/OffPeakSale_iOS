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
@end

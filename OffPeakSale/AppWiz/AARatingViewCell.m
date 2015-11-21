//
//  AARatingViewCell.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 18/05/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AARatingViewCell.h"

@implementation AARatingViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[NSBundle mainBundle] loadNibNamed:@"AARatingViewCell" owner:self options:nil];
    CGRect frame = self.ratingCell.frame;
    frame.size.width = rect.size.width;
    self.ratingCell.frame = frame;
    [self addSubview:self.ratingCell];
    [self setBackgroundColor:[UIColor clearColor]];
    self.btnSubmit.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:14];
    self.btnSubmit.backgroundColor = [UIColor clearColor];
    self.btnSubmit.layer.borderColor = [AAColor sharedInstance].retailerThemeDarkColor.CGColor;
    self.btnSubmit.layer.borderWidth = 1.0f;
    self.btnSubmit.layer.cornerRadius = 4.0f;
    [self.btnSubmit setTitleColor:[AAColor sharedInstance].retailerThemeDarkColor forState:UIControlStateNormal];
}


- (IBAction)btSubmitRating:(id)sender {
    if (self.ratingView.rateCount != -1) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ratingDoneWithCount:)]) {
            [self.delegate ratingDoneWithCount:[NSString stringWithFormat:@"%d",self.ratingView.rateCount]];
        }
    }
}
@end

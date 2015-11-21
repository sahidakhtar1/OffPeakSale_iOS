//
//  RatingView.m
//  ParagoniOS
//
//  Created by Nichepro on 10/11/13.
//  Copyright (c) 2013 Nichepro. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView
@synthesize rateCount;
- (id)initWithFrame:(CGRect)frame isRatingOff:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isRatingOff;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[NSBundle mainBundle] loadNibNamed:@"RatingView" owner:self options:nil];
    [self addSubview:self.vwRatingView];
    [self setBackgroundColor:[UIColor clearColor]];
    self.rateCount = -1;
    if (self.isRatingOff) {
        [self setUserRatingOff];
    }
}

-(void)setUserRatingOff{
    [self addSubview:self.vwRatingImgView];
    [self.vwBtnCointainer removeFromSuperview];
}

- (IBAction)btnRatingTapped:(id)sender {
    int tag = [(UIButton*)sender tag];
    self.rateCount= tag+1;
    for (int i =0; i<=tag; i++) {
        UIButton *ratingStar = (UIButton*)[self.vwBtnCointainer viewWithTag:i];
        [ratingStar setSelected:YES];
    }
    
    for (int i = tag+1; i<5; i++) {
        UIButton *ratingStar = (UIButton*)[self.vwBtnCointainer viewWithTag:i];
        [ratingStar setSelected:NO];
    }
}

-(void)setProductRating:(float)rating{
    NSNumber *myNumber = [NSNumber numberWithDouble:(rating)];
    NSInteger ratingInt = [myNumber intValue];
    NSLog(@"ratingInt = %d rating=%f",ratingInt,rating );
    for (int i =0; i<ratingInt; i++) {
        UIImageView *ratingStar = (UIImageView*)[self.vwRatingImgView viewWithTag:i];
        ratingStar.image = [UIImage imageNamed:@"star_full"];
    }
    float decemalValuev = rating - ratingInt;
    if (decemalValuev>0.0) {
        UIImageView *ratingStar = (UIImageView*)[self.vwRatingImgView viewWithTag:ratingInt];
        ratingStar.image = [UIImage imageNamed:@"star_half"];
        ratingInt++;
    }
    for (int i = ratingInt; i<5; i++) {
        UIImageView *ratingStar = (UIImageView*)[self.vwRatingImgView viewWithTag:i];
        ratingStar.image = [UIImage imageNamed:@"star_empty"];
    }
    
}
@end

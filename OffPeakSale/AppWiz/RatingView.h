//
//  RatingView.h
//  ParagoniOS
//
//  Created by Nichepro on 10/11/13.
//  Copyright (c) 2013 Nichepro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView
- (IBAction)btnRatingTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *vwRatingView;
@property NSInteger rateCount;
@property (strong, nonatomic) IBOutlet UIView *vwRatingImgView;
@property (strong, nonatomic) IBOutlet UIView *vwBtnCointainer;
@property BOOL isRatingOff;
-(void)setUserRatingOff;
-(void)setProductRating:(float)rating;
- (id)initWithFrame:(CGRect)frame isRatingOff:(BOOL)flag;
@end

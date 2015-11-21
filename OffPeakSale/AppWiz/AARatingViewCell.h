//
//  AARatingViewCell.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 18/05/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "AAThemeGlossyButton.h"
@protocol RatingViewDelegate <NSObject>

-(void)ratingDoneWithCount:(NSString*)rating;

@end

@interface AARatingViewCell : UIView
@property (strong, nonatomic) IBOutlet UIView *ratingCell;
@property (strong, nonatomic) IBOutlet RatingView *ratingView;
@property (nonatomic, unsafe_unretained) id<RatingViewDelegate> delegate;
- (IBAction)btSubmitRating:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

@end

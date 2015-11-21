//
//  AAProductReview.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/5/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeValidationTextView.h"
#import "AAThemeValidationTextField.h"
@interface AAProductReview : UIView<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblAddReviewHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblReadReviewHeading;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextView *tvComment;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfName;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfEmailId;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblReviews;
@property (nonatomic, strong) NSString *productReviews;
@property (nonatomic, strong) NSString *productId;
-(void)showProductReview;
- (IBAction)btnSubmitTapped:(id)sender;

@end

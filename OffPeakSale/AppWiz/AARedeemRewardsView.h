//
//  AARedeemRewardsView.h
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/9/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeValidationTextField.h"
@interface AARedeemRewardsView : UIView<UITextFieldDelegate>
- (IBAction)btnCloseTapped:(id)sender;
- (IBAction)btnReedemTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPts;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPointsValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCashCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblCashCreditValu;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (strong, nonatomic) IBOutlet UIView *vwContainerView;

@end

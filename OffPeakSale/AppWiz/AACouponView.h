//
//  AACouponView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 19/07/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeValidationTextField.h"
#import "AAThemeGlossyButton.h"
@interface AACouponView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwContainerView;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCouon;
- (IBAction)btnApplyCouponTapped:(id)sender;
- (IBAction)btnCloseTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;
@property (strong, nonatomic) IBOutlet UIImageView *imgResult;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnApplyCoupon;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnClose;
@property (strong, nonatomic) NSString *productId;
-(void)refreshView;
@end

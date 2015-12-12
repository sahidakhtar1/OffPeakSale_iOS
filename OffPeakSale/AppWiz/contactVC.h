//
//  contactVC.h
//  OffPeakSeller
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeValidationTextView.h"
#import "AAThemeValidationTextField.h"

@interface contactVC : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwFormContainer;
@property (nonatomic,retain) IBOutlet AAThemeValidationTextField *nameTextFiled;
@property (nonatomic,retain) IBOutlet AAThemeValidationTextField *emailTextField;
@property (nonatomic,retain) IBOutlet AAThemeValidationTextField *subjectTextfield;
@property (nonatomic,retain) IBOutlet AAThemeValidationTextView *messageTextView;

@property (nonatomic,retain) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
- (IBAction)submitButton:(id)sender;
- (IBAction)btnPhoneTapped:(id)sender;

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIView *menuView;

@property (nonatomic, strong) NSString *pageTitle;

@end

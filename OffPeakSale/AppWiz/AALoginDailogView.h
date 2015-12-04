//
//  AALoginDailogView.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 24/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAThemeGlossyButton.h"
#import "AAThemeValidationTextField.h"
@protocol AALoginDailogDelegate <NSObject>

-(void)loginButtonTappedwithemailId:(NSString*)email andPassword:(NSString*)password;
-(void)logionSucessful;
-(void)showregistrationPage;
-(void)fBLoginTapped;

@end
typedef enum FormType{
   FormTypeLogin,
    FormTypeForgotPassword,
}FormType;

@interface AALoginDailogView : UIView <UITextFieldDelegate>
@property (nonatomic) FormType formType;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfemailaddress;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnNewUser;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIView *vwHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *lblHeaderText;
@property (strong, nonatomic) IBOutlet UIView *vwContainerView;
@property (strong, nonatomic) IBOutlet UILabel *lblFormTitle;
@property (nonatomic, unsafe_unretained) id<AALoginDailogDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

@property (strong, nonatomic) IBOutlet UIView *veForgotPasswordView;
@property (strong, nonatomic) IBOutlet UILabel *lblForgotPasswordTitle;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfFPEmailId;
@property (strong, nonatomic) IBOutlet UIView *vwForgotPassordTitleBG;
@property (weak, nonatomic) IBOutlet UIView *vwBtncontainer;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
- (IBAction)btnGetPawwordTapped:(id)sender;
- (IBAction)btnFbTapped:(id)sender;


- (IBAction)btnNewuserTapped:(id)sender;
- (IBAction)btnLogintapped:(id)sender;
- (IBAction)btnForgotPasswordTapped:(id)sender;
- (IBAction)btnCloseTapped:(id)sender;
-(void)refreshView;

@end

//
//  AALoginDailogView.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 24/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALoginDailogView.h"
#import "AALoginHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
@implementation AALoginDailogView

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        self.backgroundColor= [UIColor clearColor];
        self.frame = frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AALoginDailogView" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)refreshView{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.vwHeaderView.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.vwForgotPassordTitleBG.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.tfemailaddress.text = @"";
    self.tfPassword.text = @"";
//    CALayer *layer = self.vwContainerView.layer;
//    layer.shadowOffset = CGSizeMake(1, 1);
//    layer.shadowColor = [[UIColor blackColor] CGColor];
//    layer.shadowRadius = 4.0f;
//    layer.shadowOpacity = 0.80f;
//    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
//    
//    CALayer *layer1 = self.veForgotPasswordView.layer;
//    layer1.shadowOffset = CGSizeMake(1, 1);
//    layer1.shadowColor = [[UIColor blackColor] CGColor];
//    layer1.shadowRadius = 4.0f;
//    layer1.shadowOpacity = 0.80f;
//    layer1.shadowPath = [[UIBezierPath bezierPathWithRect:layer1.bounds] CGPath];
//    CGPoint centerPoint = self.veForgotPasswordView.center;
//    centerPoint.y = rect.size.height/2;
//    self.veForgotPasswordView.center = CGPointMake(160, rect.size.height/2);
//    self.vwContainerView.center = CGPointMake(self.vwContainerView.center.x, rect.size.height/2);
}
- (IBAction)btnGetPawwordTapped:(id)sender {
    NSString *message = nil;
    if (![self validateEmailId:self.tfemailaddress.text]) {
        message = @"Please Enter Valid Email Address.";
    }
    if (message != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else{
        //[self userLoginSucessfully];
        NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,self.tfemailaddress.text,@"email", nil];
        [AALoginHelper processForgotPaswordWithCompletionBlock:^(NSString *sucessMsg){
            [[[UIAlertView alloc] initWithTitle:nil message:sucessMsg delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
            self.formType = FormTypeLogin;
        }andFailure:^(NSString *error){
            [[[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        }withParams:params];
    }
}

- (IBAction)btnFbTapped:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions:@[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@", result);
                      }
                  }];
             }
         }
     }];
}

- (IBAction)btnNewuserTapped:(id)sender {
    [self removeFromSuperview];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(showregistrationPage)]) {
        [self.delegate showregistrationPage];
    }
}

- (IBAction)btnLogintapped:(id)sender {
    if(self.formType == FormTypeForgotPassword){
        [self btnGetPawwordTapped:nil];
    }else{

            [self.tfPassword resignFirstResponder];
            [self.tfemailaddress resignFirstResponder];
            NSString *message = nil;
            if (![self validateEmailId:self.tfemailaddress.text]) {
                message = @"Please Enter Valid Email Address.";
            }else if ([self.tfPassword.text isEqualToString:@""]){
                message = @"Please Enter Password.";
            }
            if (message != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }else{
                NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY,self.tfemailaddress.text,@"email",self.tfPassword.text,@"password", nil];
                [AALoginHelper processLoginWithCompletionBlock: ^{

                    [self userLoginSucessfully];
                }andFailure:^(NSString *error){
                    [[[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
                }withParams:params];
                
            }
    }
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
    [self clearfileds];
    if (self.formType == FormTypeLogin) {
        self.formType = FormTypeForgotPassword;
    }else{
        self.formType = FormTypeLogin;
    }
    
    
}

- (IBAction)btnCloseTapped:(id)sender {
    [self removeFromSuperview];
    [[[UIAlertView alloc] initWithTitle:@"Login error" message:@"Registration required." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}
-(void)showLoginPopup{
    [self clearfileds];
    [UIView animateWithDuration:1
                     animations:^{
                         [self.veForgotPasswordView removeFromSuperview];
                         [self addSubview:self.vwContainerView];
                     }
                     completion:nil];
}
-(void)clearfileds{
    self.tfFPEmailId.text = @"";
    self.tfPassword.text = @"";
    self.tfemailaddress.text = @"";
}
-(BOOL)validateEmailId:(NSString*)emailid{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];

    return myStringMatchesRegEx;
    if (myStringMatchesRegEx) {
     
        return NO;
    }else{
        return YES;
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    CGRect rect = [UIScreen mainScreen].bounds;
//    if (textField == self.tfemailaddress || textField == self.tfPassword) {
//        [UIView animateWithDuration:.5 animations:^(void){
//            CGRect frame = self.vwContainerView.frame;
//            
//            float endPoint = frame.origin.y + frame.size.height;
//            if ((rect.size.height - 216)<endPoint) {
//                frame.origin.y -= endPoint - (rect.size.height -216);
//            }
//            self.vwContainerView.frame = frame;
//        }
//                         completion:nil];
//       
//    }else if(textField == self.tfFPEmailId){
//        [UIView animateWithDuration:.5 animations:^(void){
//            CGRect frame = self.veForgotPasswordView.frame;
//            
//            float endPoint = frame.origin.y + frame.size.height;
//            if ((rect.size.height - 216)<endPoint) {
//                frame.origin.y -= endPoint - (rect.size.height -216);
//            }
//            self.veForgotPasswordView.frame = frame;
//        }
//                         completion:nil];
//    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    CGRect rect = [UIScreen mainScreen].bounds;
//    if (textField == self.tfemailaddress || textField == self.tfPassword) {
//        self.vwContainerView.center = CGPointMake(self.vwContainerView.center.x, rect.size.height/2);
//    }else if (textField == self.tfFPEmailId){
//        self.veForgotPasswordView.center = CGPointMake(self.vwContainerView.center.x, rect.size.height/2);
//    }
    return YES;
}
-(void)userLoginSucessfully{
//    [AAAppGlobals sharedInstance].customerEmailID = self.tfemailaddress.text;
//    [AAAppGlobals sharedInstance].customerPassword = self.tfPassword.text;
    [self removeFromSuperview];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(logionSucessful)]) {
        [self.delegate logionSucessful];
    }
}
-(void)setFormType:(FormType)formType{
    _formType = formType;
    [UIView animateWithDuration:1
                     animations:^{
                            switch (_formType) {
                                case FormTypeLogin:
                                {
                                    self.lblFormTitle.text = @"Login";
                                    [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
                                    self.tfPassword.hidden = false;
                                    [self.btnForgotPassword setTitle:@"Forgot Password" forState:UIControlStateNormal];
                                }
                                    break;
                                case FormTypeForgotPassword:
                                {
                                    self.lblFormTitle.text = @"Forgot Password";
                                    [self.btnLogin setTitle:@"Send Email" forState:UIControlStateNormal];
                                    
                                    self.tfPassword.hidden = true;
                                    [self.btnForgotPassword setTitle:@"Back to login" forState:UIControlStateNormal];;
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                     }
                     completion:nil];
    [self adjustViewFrame:formType];
}
-(void)adjustViewFrame:(FormType)formType{
    [UIView animateWithDuration:.3
                     animations:^{
                         
                     
                            float yCod = self.tfemailaddress.frame.origin.y+self.tfemailaddress.frame.size.height+8;
                            CGRect frame ;
                            if (formType == FormTypeLogin) {
                               yCod = self.tfPassword.frame.origin.y+self.tfemailaddress.frame.size.height+8;
                            }
                            frame = self.btnLogin.frame;
                            frame.origin.y = yCod;
                            self.btnLogin.frame = frame;
                            yCod += (frame.size.height+15);
                            
//                            frame = self.btnForgotPassword.frame;
//                            frame.origin.y = yCod;
//                            self.btnForgotPassword.frame = frame;
//                            yCod += (frame.size.height+15);
//                            
//                            frame = self.btnNewUser.frame;
//                            frame.origin.y = yCod;
//                            self.btnNewUser.frame = frame;
                     }
                     completion:nil];
    
}
@end

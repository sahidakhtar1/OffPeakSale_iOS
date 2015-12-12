//
//  contactVC.m
//  OffPeakSeller
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "contactVC.h"
#import "AAConfig.h"
#import "AAHeaderView.h"
#import "AAConfig.h"
#import "AAContactHelper.h"
@interface contactVC ()

@end

@implementation contactVC
@synthesize nameTextFiled,emailTextField,subjectTextfield,messageTextView,addressLabel,titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden=YES;
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.menuView.frame];
    [self.menuView addSubview:headerView];
    [headerView setTitle:self.pageTitle];
    headerView.showCart = false;
    headerView.showBack = false;
    [headerView setMenuIcons];
    self.messageTextView.placeHolderText = @"Message";
    self.messageTextView.textColor = [UIColor blackColor];
    [self clearFields];
    
    
    self.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:CONATCT_FIELD_TEXT_SIZE];
    self.addressLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CONATCT_FIELD_TEXT_SIZE];
    
    self.btnPhone.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CONATCT_FIELD_TEXT_SIZE];
    
    self.nameTextFiled.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CONATCT_FIELD_TEXT_SIZE];
    
    self.emailTextField.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CONATCT_FIELD_TEXT_SIZE];
    
     self.subjectTextfield.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CONATCT_FIELD_TEXT_SIZE];
    
     self.messageTextView.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CONATCT_FIELD_TEXT_SIZE];
    
    self.addressLabel.text = [AAAppGlobals sharedInstance].retailer.contactAddr;
    [self.btnPhone setTitle:[NSString stringWithFormat:@"Phone  %@",[AAAppGlobals sharedInstance].retailer.contactPhone] forState:UIControlStateNormal];
    
    CGSize lblRetailerPoweredBySize = [AAUtils
                                       getTextSizeWithFont:self.addressLabel.font
                                       andText:self.addressLabel.text
                                       andMaxWidth:addressLabel.frame.size.width];
    
    CGRect frame = self.addressLabel.frame;
    frame.size.height = lblRetailerPoweredBySize.height;
    self.addressLabel.frame = frame;
    
    CGRect phoneFrame = self.btnPhone.frame;
    phoneFrame.origin.y = frame.origin.y + frame.size.height + 20;
    self.btnPhone.frame = phoneFrame;
    
    CGRect containerViewFrame = self.vwFormContainer.frame;
    containerViewFrame.origin.y = phoneFrame.origin.y + phoneFrame.size.height+ 15;
    self.vwFormContainer.frame = containerViewFrame;
    
    self.nameTextFiled.leftView=[self getLeftPadding];
    self.emailTextField.leftView=[self getLeftPadding];
    self.subjectTextfield.leftView=[self getLeftPadding];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textView

-(void)textViewDidBeginEditing:(UITextView *)textView
{
}

#pragma mark - textField

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];

    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    return YES;
}


- (IBAction)submitButton:(id)sender {
    
    [nameTextFiled resignFirstResponder];
    [emailTextField resignFirstResponder];
    [subjectTextfield resignFirstResponder];
    
    [messageTextView resignFirstResponder];
    
    NSString *name = self.nameTextFiled.text;
    NSString *email = self.emailTextField.text;
    NSString *subject = self.subjectTextfield.text;
    NSString *message = self.messageTextView.text;
    NSString *errorMSG = nil;
    if (name == nil || [name length]==0) {
       errorMSG = @"Please enter name";
    }else if(email == nil || [email length] == 0 || ![self validateEmailId:email]){
        errorMSG = @"Please enter valid email id";
    }else if(subject == nil || [subject length]==0){
        errorMSG = @"Please enter subject";
    }else if(message ==  nil || [message length] == 0){
        errorMSG = @"Please enter message";
    }
    
    if (errorMSG == nil) {
        [AAContactHelper sendContactMailWithName:name emailId:email subject:subject andMessage:message withCompletionBlock:^(NSString *msg) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            [self clearFields];
        } andFailure:^(NSString *msg) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
        }];
    }else{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Fields" message:errorMSG delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
    
    
}

- (IBAction)btnPhoneTapped:(id)sender {
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",[AAAppGlobals sharedInstance].retailer.contactPhone]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView* calert = [[UIAlertView alloc]initWithTitle:@"Unable to call" message:@"Cannot call on this device." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
-(void)clearFields{
    self.nameTextFiled.text = nil;
    self.emailTextField.text = nil;
    self.subjectTextfield.text = nil;
    self.messageTextView.text = nil;
}
-(BOOL)validateEmailId:(NSString*)emailid{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    return myStringMatchesRegEx;
    
}
-(UIView*)getLeftPadding{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    return leftView;
}
@end

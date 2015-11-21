//
//  AAGiftWrapViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 11/15/15.
//  Copyright © 2015 Shaikh Shahid Akhtar. All rights reserved.
//

#import "AAGiftWrapViewController.h"
#import "AAThemeValidationTextView.h"
@interface AAGiftWrapViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnHim;
@property (weak, nonatomic) IBOutlet UIButton *btnHer;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnGiftWrap;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextView *tvGiftMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnForHimText;
@property (weak, nonatomic) IBOutlet UIButton *btnForHerText;
- (IBAction)btnHerTapped:(id)sender;
- (IBAction)btnHimTapped:(id)sender;
- (IBAction)btnCloseTapped:(id)sender;
- (IBAction)btnGiftWrapTappped:(id)sender;

@end

@implementation AAGiftWrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFont];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setFont{
    self.lblMessage.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:17];
    
    self.btnForHimText.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:18];
    self.btnForHerText.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:18];
    
    self.btnGiftWrap.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    
    [self.btnGiftWrap setTitle:[NSString stringWithFormat:@"Gift Wrap %@%@",[AAAppGlobals sharedInstance].currency_code,[AAAppGlobals sharedInstance].retailer.gift_price] forState:UIControlStateNormal];
    
    self.tvGiftMsg.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:14];
    
    self.tvGiftMsg.placeHolderText = @"Your message here";
    self.tvGiftMsg.validationDelegate  = self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnHerTapped:(id)sender {
        self.btnHer.selected = true;
        self.btnHim.selected = false;
}

- (IBAction)btnHimTapped:(id)sender {
    self.btnHer.selected = false;
    self.btnHim.selected = true;
}

- (IBAction)btnCloseTapped:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)btnGiftWrapTappped:(id)sender {
    [self.view removeFromSuperview];
    self.product.giftWrapOpted = true;
    self.product.giftMsg = self.tvGiftMsg.text;
    if (self.btnHim.isSelected) {
        self.product.giftFor = @"Male";
    }else{
        self.product.giftFor = @"Female";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length==0) {
        return true;
    }
    if (textView.text.length<=100) {
        return true;
    }
    return false;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end

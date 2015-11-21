//
//  AAMerchantAuthenticationPopupView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 2/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMerchantAuthenticationPopupView.h"
#import "AAScannerViewController.h"
@implementation AAMerchantAuthenticationPopupView
static NSInteger const PADDING = 10;
static NSInteger const CONTENT_OUTER_MARGIN = 10;
static NSInteger const BUTTON_HEIGHT = 40;

#define SCANBUTTONWIDTH 40

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(AAMerchantAuthenticationPopupView*)createMerchantAuthenticationPopupViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect withPadding:(float)padding
{
    AAMerchantAuthenticationPopupView* merchantAuthenticationPopupView = [[AAMerchantAuthenticationPopupView alloc] initWithBackgroundFrame:backgroundFrameRect andContentFrame:CGRectMake(0, 0, backgroundFrameRect.size.width-padding, backgroundFrameRect.size.height)];
    
    [merchantAuthenticationPopupView.contentView setBackgroundColor:[UIColor whiteColor]];
    [merchantAuthenticationPopupView.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [merchantAuthenticationPopupView.backgroundView setAlpha:0.8];
    [merchantAuthenticationPopupView setHeaderTitle:@"Password"];
    
    [merchantAuthenticationPopupView addHeaderView];
    
    CGFloat currentY = merchantAuthenticationPopupView.headerHeight + CONTENT_OUTER_MARGIN;
    
  
    currentY = [merchantAuthenticationPopupView addPasswordField:currentY];
    
    currentY = [merchantAuthenticationPopupView addButtons:currentY];
    
    CGRect contentViewframe = merchantAuthenticationPopupView.contentView.frame;
    contentViewframe.size.height = currentY;
   merchantAuthenticationPopupView.contentView.frame = contentViewframe;
   [merchantAuthenticationPopupView centreContentViewInSuperview];
    
    contentViewframe = merchantAuthenticationPopupView.contentView.frame;
    contentViewframe.origin.y = 50;

    merchantAuthenticationPopupView.contentView.frame = contentViewframe;
    
    return merchantAuthenticationPopupView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(CGFloat)addPasswordField:(CGFloat)currentY
{

    self.tfPassword = [[AAThemeValidationTextField alloc] initWithFrame:CGRectMake(CONTENT_OUTER_MARGIN, currentY, self.contentView.frame.size.width - 2*CONTENT_OUTER_MARGIN-SCANBUTTONWIDTH-8, SCANBUTTONWIDTH)];
    [self.tfPassword setSecureTextEntry:YES];
    [self.tfPassword setBorderStyle:UITextBorderStyleRoundedRect];
    [self.tfPassword setPlaceholder:@"Password"];
    [self.contentView addSubview:self.tfPassword];
    [self.tfPassword becomeFirstResponder];
    
    UIButton *btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnScan setFrame:CGRectMake(self.tfPassword.frame.origin.x+self.tfPassword.frame.size.width+8, currentY, SCANBUTTONWIDTH, SCANBUTTONWIDTH)];
    [btnScan setBackgroundImage:[UIImage imageNamed:@"ic_barcode"] forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(btnScanTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnScan];
    
    currentY = currentY + SCANBUTTONWIDTH + PADDING;
    return currentY;
}

-(CGFloat)addButtons:(CGFloat)currentY
{
    CGFloat buttonWidth = (self.contentView.frame.size.width - (2*CONTENT_OUTER_MARGIN) - PADDING)/2;
    AAThemeGlossyButton* btnAuthenticateMerchange = [[AAThemeGlossyButton alloc] initWithFrame:CGRectMake(CONTENT_OUTER_MARGIN-5, currentY, buttonWidth, BUTTON_HEIGHT)];
    
    [btnAuthenticateMerchange setTitle:@"Enter" forState:UIControlStateNormal];
    [btnAuthenticateMerchange.titleLabel setFont:[AAFont defaultBoldFontWithSize:14.0]];
    
    [btnAuthenticateMerchange addTarget:self action:@selector(btnAuthenticateMerchant:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnAuthenticateMerchange];
    AAThemeGlossyButton* btnConfirmCouponUpdate = [[AAThemeGlossyButton alloc] initWithFrame:CGRectMake(CONTENT_OUTER_MARGIN + buttonWidth +PADDING+5, currentY, buttonWidth, BUTTON_HEIGHT)];
    
    [btnConfirmCouponUpdate setTitle:@"Exit" forState:UIControlStateNormal];
    [btnConfirmCouponUpdate.titleLabel setFont:[AAFont defaultBoldFontWithSize:14.0]];
    
    [btnConfirmCouponUpdate addTarget:self action:@selector(btnConfirmUpdate:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnConfirmCouponUpdate];
    currentY = currentY + BUTTON_HEIGHT + CONTENT_OUTER_MARGIN;
    return currentY;
}

#pragma mark - Button Events
-(void)btnAuthenticateMerchant:(id)sender
{
    NSDictionary* dictMerchant = [[NSDictionary alloc] initWithObjectsAndKeys:self.tfPassword.text,JSON_MERCHANT_PASSWORD_KEY, nil];
    [AALoyaltyHelper authenticateMerchantFromServerWithParams:dictMerchant withCompletionBlock:^{
        [self.merchantAuthenticatDelegate enableMerchantMode:YES];
    } andFailure:^{
        UIAlertView* alertViewAuthenticationFailed = [[UIAlertView alloc] initWithTitle:@"Authentication Failure" message:@"Incorrect password entered. Please try again." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertViewAuthenticationFailed show ];
    }];
}
-(void)btnConfirmUpdate:(id)sender
{
    [self.tfPassword setText:@""];
    [self.merchantAuthenticatDelegate enableMerchantMode:NO];
    [self removeFromSuperview];
}

-(void)btnScanTapped{
    AAScannerViewController *scannerVC= [[AAScannerViewController alloc] initWithNibName:@"ScannerView" bundle:nil];
    scannerVC.delegate = self;    
    [self.merchantAuthenticatDelegate presentScanner:scannerVC];
}

-(void)scanningResult:(NSString*)result{
    self.tfPassword.text = result;
    [self btnAuthenticateMerchant:nil];
}

@end

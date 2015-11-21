//
//  AAProfileViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAProfileViewController.h"

#import "AAOrderSucessView.h"
#import "AAWebViewController.h"
#import "AAColor.h"
#import "AAShippingChargeHelper.h"
#import "ActivityIndicator.h"
#import "AAHeaderView.h"
#import "AAUserProfileHelper.h"
#import "AALoginDailogView.h"

static NSString* const PAYPAL_CHECKOUT = @"place_order.php";
static NSString* const COD_CHECKOUT = @"enquiryMail.php";
#define FOOTER_OPTIONS_FONTSIZE 14.0
@interface AAProfileViewController ()
@property (nonatomic,strong) AAValidationTextField *tf;
@property (nonatomic, strong) AALoginDailogView *loginView;
@end

@implementation AAProfileViewController
NSString* const PRODUCT_ID_KEY = @"prod_id";
NSString* const PRODUCT_QUANTITY_KEY = @"quantity";
NSString* const PRODUCT_SHORT_DESCRIPTION_KEY = @"short_desc";
NSString* const PRODUCT_AMOUNT_KEY = @"amount";
static NSString* const DATE_FORMAT = @"dd MMM yyyy";
static NSString* const COUNTRY_CODE_KEY = @"countryCode";
static NSString* const COUNTRY_NAME_KEY = @"countryName";
static NSString* const INDUSTRY_NAME_KEY =@"industry_name";
static NSString* const INDUSTRY_ID_KEY =@"id";
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
static NSString* const JSON_ERROR_CODE_KEY = @"errorCode";
@synthesize arrValidationCommercialFields,productInformationString;
@synthesize orderSucessAlert;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.heading = @"PROFILE";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCart" object:nil];
    [self.scGender setTintColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
    [self.btnBuyProduct setHidden:!self.showBuyButton];
    self.btnBuyProduct.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.btnSaveConsumerProfile.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.lblEnablePn.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE];
    self.lblRedeemRewards.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE];
    self.tvNoReward.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE];
    [self.btnRedeem setTitle:[AAAppGlobals sharedInstance].reward_points forState:UIControlStateNormal];
    self.veDevider.backgroundColor = [AAColor sharedInstance].retailerThemeTextColor;
    self.lblCreatePwd.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE];
    if(!self.showBuyButton)
    {
//        [self centerSaveButtonProfile];
        self.imgTriangle.hidden = true;
    }else{
        
    }
    [self setProfileButtons];
    if (self.isCOD) {
        [self.btnBuyProduct setTitle:@"Send Order" forState:UIControlStateNormal];
        self.tvNoReward.hidden = false;
    }else{
        [self.btnBuyProduct setTitle:@"Buy" forState:UIControlStateNormal];
        self.tvNoReward.hidden = true;
    }
    //set properties for text fields
    [self.tfMobileNumber setAllowOnlyNumbers:YES];
    [self.tfCommercilMobileNo setAllowOnlyNumbers:YES];
    [self.tfCommercialFaxNo setAllowOnlyNumbers:YES];
    [self.tfCommercialPostalCode setAllowOnlyNumbers:YES];
   // [self.tfCardNumber setAllowOnlyNumbers:YES];
   // [self.tfCardNumber setMaxNumberOfCharacters:16];
    
   // [self.tfCVV setAllowOnlyNumbers:YES];
   // [self.tfCVV setMaxNumberOfCharacters:3];
    
    [self.tfPostalCode setAllowOnlyNumbers:YES];
    
    //self.tfExpiryMonth.validationDelegate = self;
    
    NSString * appType = [AAAppGlobals sharedInstance].retailer.retailerAppType ;
   
    [self registerForKeyboardNotifications];
   // [self populateIndustries];
    [self populateCountries];
    
    [self.tpgrBackgrounvView setCancelsTouchesInView:NO];
    [self.tpgrBackgrounvView setDelegate:self];
    
    if ([appType isEqualToString:@"Commercial"]) {
        [self.scrollViewFieldsContainter setContentSize:CGSizeMake(self.view.frame.size.width, self.tfCommercialCNFPWD.frame.size.height+self.tfCommercialCNFPWD.frame.origin.y) ];
        self.viewFieldsContainer.hidden = TRUE;
        self.vwCommercialProfileForm.hidden = FALSE;
        for(AAThemeValidationTextField* tfValidation in self.arrValidationCommercialFields)
        {
            if (tfValidation == self.tfCommercialCustomerId) {
                
            }else{
                tfValidation.validationDelegate = self;
            }
            
        }
        
    }else{
        [self.scrollViewFieldsContainter setContentSize:CGSizeMake(self.view.frame.size.width, self.viewFieldsContainer.frame.size.height) ];
        self.viewFieldsContainer.hidden = FALSE;
        self.vwCommercialProfileForm.hidden = TRUE;
        for(AAThemeValidationTextField* tfValidation in self.arrValidationFields)
        {
            tfValidation.validationDelegate = self;
        }
       
    }
//    [[NSUserDefaults standardUserDefaults] setBool:false forKey:KEY_IS_LOGGED_IN];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if(isLoggedIn){
//        [self populateFields];
        [self.btnSaveConsumerProfile setTitle:@"Save" forState:UIControlStateNormal];
        [self logionSucessful];
    }else{
        [self.btnSaveConsumerProfile setTitle:@"Register" forState:UIControlStateNormal];
        [self showLoginView];
    }
    
    [self setFonts];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
//    self.lblTermsOfUse.attributedText = [[NSAttributedString alloc] initWithString:@"Terms of Use"
//                                                             attributes:underlineAttribute];
    self.vwTermsOfUse.layer.borderColor = (__bridge CGColorRef)([AAColor sharedInstance].retailerThemeLightColor);
    self.vwTermsOfUse.layer.borderWidth = 2.0f;
    self.vwTermsOfUse.layer.cornerRadius = 6.0f;
    [self.pnSwitch setOn:![[NSUserDefaults standardUserDefaults] boolForKey:PNKEY]];
    [self.pnSwitch setOnTintColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
    //[self.pnSwitch setOnTintColor:<#(UIColor *)#>]
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:@"Profile"];
    headerView.delegate = self;
    if(!self.showBuyButton
       && self.profileDelegate == nil)
    {
        
        headerView.showBack = false;
        headerView.showCart = false;
    }else{
        headerView.showBack = true;
        headerView.showCart = false;
    }
    [headerView setMenuIcons];
    
}
-(void)showLoginView{
    if (self.loginView == nil) {
        self.loginView = [[AALoginDailogView alloc] initWithFrame:self.scrollViewFieldsContainter.bounds];
        self.loginView.delegate = self;
    }
    
    [self.scrollViewFieldsContainter addSubview:self.loginView];
    [self.viewFieldsContainer setHidden:true];
    [self.viewBottomBar setHidden:true];
    self.loginView.formType = FormTypeLogin;
}
-(void)getEarnedRewards{
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"] || true) {
        [AAUserProfileHelper getUserProfilewithCompletionBlock:^{
            
            [self.btnRedeem setTitle:[AAAppGlobals sharedInstance].reward_points forState:UIControlStateNormal];
        }
                                                    andFailure:^(NSString *errorMSG){
                                                        
                                                        
                                                    }];
    }
}
-(void)setProfileButtons{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float buttonWidth ;
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if (self.showBuyButton && isLoggedIn) {
        
        buttonWidth = screenWidth/2;
        [self.btnBuyProduct setHidden:false];
        [self.btnSaveConsumerProfile setHidden:false];
        [self.veDevider setHidden:false];
        CGRect frame = self.btnSaveConsumerProfile.frame;
        frame.size.width = buttonWidth;
        self.btnSaveConsumerProfile.frame = frame;
        
        frame = self.veDevider.frame;
        frame.origin.x = buttonWidth;
        self.veDevider.frame =frame;
        
        frame = self.btnBuyProduct.frame;
        frame.origin.x = buttonWidth;
        frame.size.width = buttonWidth;
        self.btnBuyProduct.frame = frame;
        
    }else{
        buttonWidth = screenWidth;
        [self.btnSaveConsumerProfile setHidden:false];
        [self.btnBuyProduct setHidden:true];
        [self.veDevider setHidden:true];
        CGRect frame = self.btnSaveConsumerProfile.frame;
        frame.size.width = buttonWidth;
        self.btnSaveConsumerProfile.frame = frame;
    }
}
-(void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AAAppGlobals sharedInstance].paymentHandler initiateConnection];
    if(self.navigationController)
    {
    id<AAChildNavigationControllerDelegate> nvcEShop = (id<AAChildNavigationControllerDelegate>)   self.navigationController;
    
//    [nvcEShop showBackButtonView];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(rewardsRedeemed)
//                                                 name:@"RewardsRedeemed"
//                                               object:nil];
   
        
    //[self makePayment];
    [self getEarnedRewards];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RewardsRedeemed" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewBackgroundTapped:(id)sender {
    [self.view endEditing:YES];
    [self hideDropDownMenus];
}

- (IBAction)btnBuyProductTapped:(id)sender {
    if([self validateFields])
    {
        [self makePayment];
    }

}

- (IBAction)btnSaveConsumerProfileTapped:(id)sender {
    if([self validateFields])
    {
        NSString * appType = [AAAppGlobals sharedInstance].retailer.retailerAppType ;
        if ([appType isEqualToString:@"Commercial"]) {
            [self saveCommercialProfile];
        }else{
            [self saveConsumerProfile];
        }
    
    }
   [self.view endEditing:YES];
}

#pragma mark - Helpers
-(void)centerSaveButtonProfile
{
    CGRect saveProfileButtonFrame = self.btnSaveConsumerProfile.frame;
    saveProfileButtonFrame.origin.x = 0;
    saveProfileButtonFrame.size.width = self.view.frame.size.width;
    self.btnSaveConsumerProfile.frame = saveProfileButtonFrame;
    self.vwTermsOfUse.hidden  = true;
    self.veDevider.hidden = true;
    
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - 40.0, 0.0);
    self.scrollViewFieldsContainter.contentInset = contentInsets;
    self.scrollViewFieldsContainter.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height = aRect.size.height - kbSize.height + 44 - self.viewBottomBar.frame.size.height;
    if (!CGRectContainsRect(aRect, self.activeField.frame) ) {
        [self.scrollViewFieldsContainter scrollRectToVisible:self.activeField.frame animated:YES];
    }
//    CGRect bottomBarFrame = [self.viewBottomBar frame];
//    bottomBarFrame.origin.y = bottomBarFrame.origin.y - kbSize.height + 44.0;
//    
//    [self.viewBottomBar setFrame:bottomBarFrame];
   
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewFieldsContainter.contentInset = contentInsets;
    self.scrollViewFieldsContainter.scrollIndicatorInsets = contentInsets;
//    CGRect bottomBarFrame = [self.viewBottomBar frame];
//    bottomBarFrame.origin.y = self.view.frame.size.height - self.viewBottomBar.frame.size.height;
//    
//    [self.viewBottomBar setFrame:bottomBarFrame];
}

-(void)makePayment
{
    NSString *emailId;
    NSMutableDictionary* dictPayment = [[NSMutableDictionary alloc] init];
    NSString * appType = [AAAppGlobals sharedInstance].retailer.retailerAppType ;
    if ([appType isEqualToString:@"Commercial"]) {
        
        [self populatCommercialAndPaymentInformaion];
        emailId = [AAAppGlobals sharedInstance].customerEmailID;
    }else{
        
         [self populateConsumerAndPaymentInformation];
        emailId =self.consumer.email;
    }
   
    /*AAConsumer* consumer = [[AAConsumer alloc]init];
    
    [consumer setFirstName:@"Vignesh"];
    [consumer setLastName:@"Badrinath"];
    [consumer setMobileNumber:98528304];
    [consumer setEmail:@"vig.bk@gmail.com"];
    [consumer setAge:20];
    [consumer setDateOfBirth:@"10 Oct 1992"];
    [consumer setGender:@"M"];
    [consumer setAddress:@"Raffless "];
    [consumer setCity:@"Singapore"];
    [consumer setState:@"Singapore"];
    [consumer setCountry:@"SG"];
    [consumer setZip:623354];*/
    
    
    [dictPayment addEntriesFromDictionary:[self.consumer JSONDictionaryRepresentation]];
    
  /*  AAConsumerPayment* consumerPayment = [[AAConsumerPayment alloc] init];
    
    [consumerPayment setCardNumber:4111111111111111];
    [consumerPayment setExpiryMonth:@"02"];
    [consumerPayment setExpiryYear:@"2015"];
    [consumerPayment setCvv:435];
    [dictPayment addEntriesFromDictionary:[consumerPayment JSONDictionaryRepresentation] ];
    */
    NSMutableDictionary* paymentDictionary;
    if (1==2&&![AAAppGlobals sharedInstance].enableShoppingCart) {
        paymentDictionary = [[NSMutableDictionary alloc]init];
        [paymentDictionary setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
        if (self.isCOD) {
        }else{
            [paymentDictionary setObject:[self.productInformation objectForKey:PRODUCT_QUANTITY_KEY] forKey:PAYMENT_QUANTITY_KEY];
        }
        
        [paymentDictionary setObject:emailId forKey:PAYMENT_EMAIL_KEY];
        [paymentDictionary setObject:[self.productInformation objectForKey:PRODUCT_ID_KEY] forKey:PAYMENT_PRODUCT_ID_KEY];

        
    }else{
        paymentDictionary = [self createProductInfoDict];
        [paymentDictionary setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
        [paymentDictionary setObject:emailId forKey:PAYMENT_EMAIL_KEY];
        

    }
    if ([AAAppGlobals sharedInstance].enableCreditCode && [AAAppGlobals sharedInstance].discountPercent > 0) {
        [paymentDictionary setValue:[AAAppGlobals sharedInstance].discountPercent forKey:@"discount"];
        [paymentDictionary setValue:[AAAppGlobals sharedInstance].discountType forKey:@"discountType"];
        [paymentDictionary setValue:[AAAppGlobals sharedInstance].discountCode forKey:@"discountCode"];
    }
    if ([AAAppGlobals sharedInstance].shippingCharge > 0 && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
        if ([AAAppGlobals sharedInstance].freeAmount == 0 || [AAAppGlobals sharedInstance].freeAmount > [[AAAppGlobals sharedInstance] cartTotal]) {
            [paymentDictionary setObject:[NSString stringWithFormat:@"%.2f",[[AAAppGlobals sharedInstance].shippingCharge floatValue]] forKey:@"shippingAmt"];
        }
        
    }
//    if (!self.isCOD) {
        [paymentDictionary setObject:[AAAppGlobals sharedInstance].rewardPointsRedeemed forKey:@"redeemPoints"];
//    }
    if ([[AAAppGlobals sharedInstance].enableDelivery isEqualToString:@"1"] && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM YYYY"];
        NSString *dateStr = [formatter stringFromDate:[AAAppGlobals sharedInstance].scheduledDate];
        
        [paymentDictionary setObject:[NSString stringWithFormat:@"%@,%@",dateStr,
                                      [AAAppGlobals sharedInstance].selectedTime]
                              forKey:@"deliveryDate"];
    }else if ([[AAAppGlobals sharedInstance].retailer.enableCollection isEqualToString:@"1"] && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM YYYY"];
        NSString *dateStr = [formatter stringFromDate:[AAAppGlobals sharedInstance].scheduledDate];
        
        [paymentDictionary setObject:[NSString stringWithFormat:@"%@,%@ at %@",dateStr,
                                      [AAAppGlobals sharedInstance].selectedTime,[AAAppGlobals sharedInstance].selectedCollectionAddress]
                              forKey:@"collectDate"];
    }
    [AAAppGlobals sharedInstance].cod = self.isCOD;
    if ([appType isEqualToString:@"Commercial"]) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [AAConsumerProfileHelper saveCommercialProfileWithDictionary:self.consumer.JSONDictionaryCommercialProfileRepresentation.mutableCopy isNewUser:self.isNewUser withCompletionBlock:^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            //[self saveProfileToUserDefaults];
            if ([AAAppGlobals sharedInstance].isPayByCredits) {
                [self paybyCredit:paymentDictionary];
            }else{
                
                [AAAppGlobals sharedInstance].paymentHandler.paymentHandlerDelegate = self;
                [[AAAppGlobals sharedInstance].paymentHandler makePaymentWithDetails:paymentDictionary];
            }
            
            
        } andFailure:^(NSString *errorMessage) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            //[self saveProfileToUserDefaults];
            UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Cannot complete payment. Try again later." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertViewFailed show];
        }];
    }else{
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [[ActivityIndicator sharedActivityIndicator] show];
        [AAConsumerProfileHelper saveConsumerProfileWithDictionary:self.consumer.JSONDictionaryProfileRepresentation.mutableCopy withCompletionBlock:^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [[ActivityIndicator sharedActivityIndicator] hide];
            [self saveProfileToUserDefaults];
            [AAAppGlobals sharedInstance].paymentHandler.paymentHandlerDelegate = self;
            [[AAAppGlobals sharedInstance].paymentHandler makePaymentWithDetails:paymentDictionary];
            
        } andFailure:^(NSString *errorMessage) {
            [[ActivityIndicator sharedActivityIndicator] hide];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self saveProfileToUserDefaults];
            UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Cannot complete payment. Try again later." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertViewFailed show];
        }];
    }
    

    
    
    
    
    /*[AAPaymentInfoHelper makePaymentWithDictionary:dictPayment withCompletionBlock:^(NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Transaction Completed" message:@"Payment Succeeded" delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewSuccess show];
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self saveProfileToUserDefaults];
        [self.profileDelegate onPaymentSucceeded:response];
        
    } andFailure:^(NSString *errorMessage) {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
          UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:errorMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewFailed show];
        
    }];*/
    
    
   
    
}
-(void)saveCommercialProfile{
    NSMutableDictionary* dictConsumerProfile = [[NSMutableDictionary alloc] init];
    [self populatCommercialAndPaymentInformaion];
    [dictConsumerProfile addEntriesFromDictionary:[self.consumer JSONDictionaryCommercialProfileRepresentation]];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [AAConsumerProfileHelper saveCommercialProfileWithDictionary:dictConsumerProfile isNewUser:self.isNewUser withCompletionBlock:^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if([self.profileDelegate respondsToSelector:@selector(closeProfileViewController:)])
        {
            [AAAppGlobals sharedInstance].consumer = self.consumer;
            //[self saveProfileToUserDefaults];
            [self.profileDelegate closeProfileViewController:self];
        }
        else
        {
            
            
            UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Profile Saved" message:@"Profile has been successfully saved" delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            //[self saveProfileToUserDefaults];
            [AAAppGlobals sharedInstance].consumer = self.consumer;
            [alertViewSuccess show];
            [self updateFrameAfterLogin];
        }
    } andFailure:^(NSString *errorMessage) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if([self.profileDelegate respondsToSelector:@selector(closeProfileViewController:)])
        {
           // [self saveProfileToUserDefaults];
            [AAAppGlobals sharedInstance].consumer = self.consumer;
            [self.profileDelegate closeProfileViewController:self];
            
        }
        else
        {
            
            UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertViewSuccess show];
            [AAAppGlobals sharedInstance].consumer = self.consumer;
            //[self saveProfileToUserDefaults];
        }
    }];
}
-(void)paybyCredit:(NSDictionary*)params{
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"credit_terms_pay.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        if([response objectForKey:JSON_ERROR_CODE_KEY])
        {
            if([[response objectForKey:JSON_ERROR_CODE_KEY] integerValue]==1)
            {
               // success([response objectForKey:@"errorMessage"] );
                NSLog(@"Sucess = %@",[response objectForKey:@"errorMessage"]);
                NSString *totalAmt,*orderNum;
                if([response objectForKey:@"totalAmt"] )
                {
                    totalAmt = [response objectForKey:@"totalAmt"];
                }
                if([response objectForKey:@"orderNum"] )
                {
                    orderNum = [response objectForKey:@"orderNum"];
                }
                [self showOrderSucessAlerwithrderNo:orderNum andGrandTtotal:totalAmt andIsByCreditL:YES];
            }
            else
            {
               // failure([response objectForKey:@"errorMessage"]);
                 NSLog(@"fail = %@",[response objectForKey:@"errorMessage"]);
                UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Cannot complete payment. Try again later." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alertViewFailed show];
            }
        }
        else
        {
            //failure(@"Invalid input");
            NSLog(@"fail = %@",[response objectForKey:@"errorMessage"]);
            UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Cannot complete payment. Try again later." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertViewFailed show];
        }
        
        
    } withFailureBlock:^(NSError *error) {
        //failure(error.description);
        NSLog(@"fail = %@",error.description);
        UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Cannot complete payment. Try again later." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewFailed show];
    }];

}
-(void)showOrderSucessAlerwithrderNo:(NSString*)orderNo andGrandTtotal:(NSString*)grandTotal andIsByCreditL:(BOOL)isByCredit{
    NSMutableString * orderCNFMSG = [[NSMutableString alloc] initWithString:@"Order success. Email confirmation sent.\n\n"];
    [orderCNFMSG appendFormat:@"Grand Total: %@%@",[AAAppGlobals sharedInstance].currency_symbol,grandTotal];
    if (self.isCOD) {
        
        
    }else{
        [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
        [orderCNFMSG appendFormat:@"\n\Credit Points Earned: %@",[AAAppGlobals sharedInstance].rewardsPointEarned];
        if ([[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"]) {
            [orderCNFMSG appendFormat:@"\n\nVeritrans Id:: %@",orderNo];
        }else{
            [orderCNFMSG appendFormat:@"\n\nPaypal Id: %@",orderNo];
        }
        
    }
    self.orderSucessAlert = [[AAOrderSucessView alloc] initWithFrame:self.view.frame withOderNumber:orderNo grandTotal:orderCNFMSG andIsByCredit:isByCredit];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.orderSucessAlert];
    [self.orderSucessAlert refreshView];
    [[AAAppGlobals sharedInstance] deleteAllProducts];
    [AAAppGlobals sharedInstance].rewardsPointEarned = @"0";
    [AAAppGlobals sharedInstance].rewardPointsRedeemed = @"0";
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)saveConsumerProfile
{
    NSMutableDictionary* dictConsumerProfile = [[NSMutableDictionary alloc] init];
    [self populateConsumerAndPaymentInformation];
    /*AAConsumer* consumer = [[AAConsumer alloc]init];
     
     [consumer setFirstName:@"Vignesh"];
     [consumer setLastName:@"Badrinath"];
     [consumer setMobileNumber:98528304];
     [consumer setEmail:@"vig.bk@gmail.com"];
     [consumer setAge:20];
     [consumer setDateOfBirth:@"10 Oct 1992"];
     [consumer setGender:@"M"];
     [consumer setAddress:@"Raffless "];
     [consumer setCity:@"Singapore"];
     [consumer setState:@"Singapore"];
     [consumer setCountry:@"SG"];
     [consumer setZip:623354];*/
    
    
    [dictConsumerProfile addEntriesFromDictionary:[self.consumer JSONDictionaryProfileRepresentation]];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];;
    if (!isLoggedIn) {
        [dictConsumerProfile setValue:self.tfPwd.text forKey:@"password"];
    }
    
    /*  AAConsumerPayment* consumerPayment = [[AAConsumerPayment alloc] init];
     
     [consumerPayment setCardNumber:4111111111111111];
     [consumerPayment setExpiryMonth:@"02"];
     [consumerPayment setExpiryYear:@"2015"];
     [consumerPayment setCvv:435];
     [dictPayment addEntriesFromDictionary:[consumerPayment JSONDictionaryRepresentation] ];
     */
     [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [AAConsumerProfileHelper saveConsumerProfileWithDictionary:dictConsumerProfile withCompletionBlock:^{
         [self logionSucessful];
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if([self.profileDelegate respondsToSelector:@selector(closeProfileViewController:)])
        {
           
            [self saveProfileToUserDefaults];
            [self.profileDelegate closeProfileViewController:self];
        }
        else
        {
        
        
         UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Profile Saved" message:@"Profile has been successfully saved" delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [self saveProfileToUserDefaults];
        [alertViewSuccess show];
            [self updateFrameAfterLogin];
            [self getEarnedRewards];
        }
    } andFailure:^(NSString *errorMessage) {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if([self.profileDelegate respondsToSelector:@selector(closeProfileViewController:)])
        {
            [self saveProfileToUserDefaults];
            [self.profileDelegate closeProfileViewController:self];
        }
        else
        {

        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Profile" message:errorMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewSuccess show];
          [self saveProfileToUserDefaults];
        }
    }];
    
    
    
    
}
-(BOOL)validateEmailId:(NSString*)emailid{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    return myStringMatchesRegEx;
    
}
-(BOOL)validateFields
{
    BOOL isValid = YES;
    NSString* errMessage = @"";
    self.tf= nil;
    NSString * appType = [AAAppGlobals sharedInstance].retailer.retailerAppType ;
    if ([appType isEqualToString:@"Commercial"]) {
        for(UIView* view in [self.vwCommercialProfileForm subviews])
        {
            if([view isKindOfClass:[AAValidationTextField class]])
            {
                AAValidationTextField* tfValidation = (AAValidationTextField*)view;
                if (tfValidation == self.tfCommercialCustomerId) {
                    
                }else{
                    isValid =   [[[tfValidation isValid] objectForKey:IS_VALID_KEY] boolValue];
                    if(!isValid)
                    {
                        errMessage = [[tfValidation isValid] objectForKey:ERROR_MESSAGE_KEY];
                        self.tf = tfValidation;
                        break;
                    }
                }
            }
        }
        if (errMessage == nil) {
            if (![self validateEmailId:self.tfCommercialEmailId.text]) {
                errMessage = @"Please Enter Valid Email Address.";
                self.tf = self.tfCommercialEmailId;
            }else if (![self.tfCommercialPWD.text isEqualToString:self.tfCommercialCNFPWD.text]){
                errMessage= @"Password mismatched.";
                self.tf = self.tfCommercialPWD;
            }
        }
    }else{
        if (![self validateEmailId:self.tfEmail.text]) {
            errMessage = @"Please enter valid email id.";
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:errMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView setTag:1001];
            [alertView show];
            self.tf = self.tfEmail;
            return false;
        }
        for(UIView* view in [self.viewFieldsContainer subviews])
        {
            if([view isKindOfClass:[AAValidationTextField class]])
            {
                AAValidationTextField* tfValidation = (AAValidationTextField*)view;
                isValid =   [[[tfValidation isValid] objectForKey:IS_VALID_KEY] boolValue];
                if(!isValid)
                {
                    errMessage = [[tfValidation isValid] objectForKey:ERROR_MESSAGE_KEY];
                    self.tf = tfValidation;
                    break;
                }
            }
        }
    }
    
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];;
    if (!isLoggedIn) {
        NSString *password = self.tfPwd.text;
        if (password == nil || [password length] == 0) {
            isValid = false;
            self.tf = self.tfPwd;
        }else if(![password isEqualToString:self.tfCnfPwd.text]){
            isValid = false;
            self.tf = self.tfPwd;
        }
    }
    if(!isValid)
    {
    
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Fields" message:errMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView setTag:1001];
        [alertView show];
        
        
    }
    return isValid;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (self.tf != nil) {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                           selector:@selector(showFocusErrorField)
                                           userInfo:nil repeats:NO];
           
        }
    }
}
-(void)showFocusErrorField{
    [self.tf becomeFirstResponder];
}
-(void)populatCommercialAndPaymentInformaion{
    [self.consumer setCommercialCompany:self.tfCommercialComapany.text];
    NSString *industryCode = [self getIndustryCodeWithCountryName:self.tfCommercialIndustry.text];
    [self.consumer setCommercialIndustry:industryCode];
    if (self.tfCommercialCustomerId.text != nil) {
        [self.consumer setCommercialCustomerID:self.tfCommercialCustomerId.text];
    }
    
    [self.consumer setCommercialFirstName:self.tfCommercialFirstName.text];
    [self.consumer setCommercialLastName:self.tfCommercialLastName.text];
    [self.consumer setCommercialDesigniation:self.tfCommercialDesignation.text];
    [self.consumer setCommercialAddress:self.tfCommercialAddress.text];
    [self.consumer setCommercialCity:self.tfCommercialCity.text];
    [self.consumer setCommercialCountry:[self getCountryCodeWithCountryName:self.tfCommercialCountry.text]];
    [self.consumer setCommercialEmailID:self.tfCommercialEmailId.text];
    [self.consumer setCommercialPassword:self.tfCommercialPWD.text];
    [self.consumer setCommercialMobileNo:self.tfCommercilMobileNo.text];
    [self.consumer setCommercialFaxNo:self.tfCommercialFaxNo.text];
    [self.consumer setCommercialPostalCode:self.tfCommercialPostalCode.text];
    
    [self.consumer setCountry:[self getCountryCodeWithCountryName:self.tfCountry.text]];
    [self.consumer setZip:[[self.tfPostalCode text] integerValue]];
    
    AAConsumerPayment* consumerPayment = [[AAConsumerPayment alloc] init];
    [self.consumer removeAllConsumerPaymentInformation];
    [self.consumer addConsmerPaymentInformation:consumerPayment atIndex:0];
}

-(void)populateConsumerAndPaymentInformation
{
    
    
    [self.consumer setFirstName:self.tfFirstName.text];
    [self.consumer setLastName:self.tfLastName.text];
    [self.consumer setMobileNumber:self.tfMobileNumber.text.integerValue];
    [self.consumer setEmail:self.tfEmail.text];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:DATE_FORMAT];
    NSDate* dateOfBirth = [format dateFromString:self.tfDateOfBirth.text];
    [self.consumer setAge:[AAUtils calculateAgeFromDate:dateOfBirth]];
    [self.consumer setDateOfBirth:[self.tfDateOfBirth text]];
    [self.consumer setGender:[self.scGender titleForSegmentAtIndex:self.scGender.selectedSegmentIndex]];
    [self.consumer setAddress:self.tfAddress.text];
    [self.consumer setCity:self.tfCity.text];
  
    
    [self.consumer setCountry:[self getCountryCodeWithCountryName:self.tfCountry.text]];
    [self.consumer setZip:[[self.tfPostalCode text] integerValue]];
    
   
    AAConsumerPayment* consumerPayment = [[AAConsumerPayment alloc] init];
    
    //[consumerPayment setCardNumber:[[self.tfCardNumber text] longLongValue] ];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
  //  NSInteger monthIndex = [[df monthSymbols] indexOfObject:self.tfExpiryMonth.text] + 1;
   // NSString* monthIndexString = [NSString stringWithFormat:@"%02d",monthIndex];
    //[consumerPayment setExpiryMonth:monthIndexString];
    //[consumerPayment setExpiryYear:[self.tfExpiryYear text]];
  //  [consumerPayment setPaymentType:self.tfPaymentType.text];
    //[consumerPayment setCvv:self.tfCVV.text.integerValue];
    [self.consumer removeAllConsumerPaymentInformation];
    [self.consumer addConsmerPaymentInformation:consumerPayment atIndex:0];
}
-(void)setFonts{
    self.tfFirstName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfLastName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfMobileNumber.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfEmail.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfDateOfBirth.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    
    self.tfAddress.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfCity.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
   
    self.tfCountry.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    
    self.tfPostalCode.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    
}
-(void)populateFields
{
    if([AAAppGlobals sharedInstance].consumer)
    {
        self.consumer = [AAAppGlobals sharedInstance].consumer;
        
        self.tfFirstName.text = self.consumer.firstName;
        self.tfLastName.text = self.consumer.lastName;
        self.tfMobileNumber.text = [NSString stringWithFormat:@"%ld", (long)self.consumer.mobileNumber ];
        self.tfEmail.text = self.consumer.email;
        self.tfDateOfBirth.text = self.consumer.dateOfBirth;
        if([self.consumer.gender isEqualToString:@"M"])
        {
            [self.scGender setSelectedSegmentIndex:0];
        }
        else
        {
            [self.scGender setSelectedSegmentIndex:1];
        }
        self.tfAddress.text = self.consumer.address;
        self.tfCity.text = self.consumer.city;
        if(self.arrCountries && self.arrCountries.count > 0)
        {
            self.tfCountry.text = [self getCountryNameWithCountryCode: self.consumer.country] ;
        }
       
        self.tfPostalCode.text = [NSString stringWithFormat:@"%ld", (long)self.consumer.zip ];
        
        //AAConsumerPayment* consumerPayment = [self.consumer.arrConsmerPaymentInformation objectAtIndex:0];
        
       // self.tfCardNumber.text = [NSString stringWithFormat:@"%lld", (long long)consumerPayment.cardNumber ];
       // self.tfCVV.text = [NSString stringWithFormat:@"%d",consumerPayment.cvv];
       // self.tfExpiryYear.text = consumerPayment.expiryYear;
       // self.tfPaymentType.text = consumerPayment.paymentType;
       // NSDateFormatter *df = [[NSDateFormatter alloc] init];
       // NSString* strExpiryMonth = [[df monthSymbols] objectAtIndex:(consumerPayment.expiryMonth.integerValue -1) ];
        
        //self.tfExpiryMonth.text = strExpiryMonth;
        
        self.tfCommercialComapany.text = self.consumer.commercialCompany;
        if(self.arrIndustries && self.arrIndustries.count > 0)
        {
            self.tfCommercialIndustry.text = [self getIndustryNameWithCountryCode: self.consumer.commercialIndustry] ;
        }
       // self.tfCommercialIndustry.text = self.consumer.commercialIndustry;
        self.tfCommercialCustomerId.text = self.consumer.commercialCustomerID;
        self.tfCommercialFirstName.text = self.consumer.commercialFirstName;
        self.tfCommercialLastName.text  = self.consumer.commercialLastName;
        self.tfCommercialDesignation.text = self.consumer.commercialDesigniation;
        self.tfCommercialCity.text = self.consumer.commercialCity;
        self.tfCommercialCountry.text = self.consumer.commercialCountry;
        self.tfCommercialEmailId.text = self.consumer.commercialEmailID;
        self.tfCommercialPWD.text = self.consumer.commercialPassword;
        self.tfCommercialCNFPWD.text = self.consumer.commercialPassword;
        self.tfCommercialAddress.text = self.consumer.commercialAddress;
        self.tfCommercilMobileNo.text =  self.consumer.commercialMobileNo;
        self.tfCommercialFaxNo.text = self.consumer.commercialFaxNo;
        self.tfCommercialPostalCode.text = self.consumer.commercialPostalCode;
        self.isNewUser = FALSE;
    }
    else
    {
        self.consumer = [[AAConsumer alloc]init];
        self.isNewUser = TRUE;
        [self.consumer setDeviceToken:[AAAppGlobals sharedInstance].deviceToken];
       self.consumer.longitude = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude;
         
         self.consumer.latitude = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude;

    }
}


-(void)showMonthsDropDownMenu
{
    
    /*self.dropDownScrollViewMonths = [[AADropDownScrollView alloc] initWithFrame:CGRectMake(self.tfExpiryMonth.frame.origin.x, self.tfExpiryMonth.frame.origin.y + self.tfExpiryMonth.frame.size.height + 2,self.tfExpiryMonth.frame.size.width,90)];
    [self.dropDownScrollViewMonths setItemHeight:30];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    self.dropDownScrollViewMonths.dropDownDelegate = self;
    [self.dropDownScrollViewMonths setItems:[dateFormatter monthSymbols].mutableCopy];
     [self.dropDownScrollViewMonths refreshScrollView];
    [self.viewFieldsContainer addSubview:self.dropDownScrollViewMonths];
    [self.scrollViewFieldsContainter scrollRectToVisible:self.dropDownScrollViewMonths.frame animated:YES];*/
   
    
}
-(void)showYearDropDownMenu
{
    
   /* self.dropDownScrollViewYear = [[AADropDownScrollView alloc] initWithFrame:CGRectMake(self.tfExpiryYear.frame.origin.x, self.tfExpiryYear.frame.origin.y + self.tfExpiryYear.frame.size.height + 2,self.tfExpiryYear.frame.size.width,90)];
    [self.dropDownScrollViewYear setItemHeight:30];
    self.dropDownScrollViewYear.dropDownDelegate = self;
    
    [self.dropDownScrollViewYear setItems:[self getYearsArray]];
    [self.dropDownScrollViewYear refreshScrollView];
    [self.viewFieldsContainer addSubview:self.dropDownScrollViewYear];
      [self.scrollViewFieldsContainter scrollRectToVisible:self.dropDownScrollViewYear.frame animated:YES];
    */
}

-(void)showCountriesDropDownMenu
{
    if ([self.arrCountries count]==0) {
        return;
    }
    CGRect frame;
//    if ([self.vwCommercialProfileForm isHidden]) {
//        
//    }else{
//         frame = self.tfCommercialCountry.frame;
//    }
    frame = self.tfCountry.frame;
    
    self.dropDownScrollViewCountries = [[AAFilterDropDownScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 2,frame.size.width,90)];
    [self.dropDownScrollViewCountries setItemHeight:30];
    self.dropDownScrollViewCountries.dropDownDelegate = self;
     self.activeField = self.dropDownScrollViewCountries;
    [self.dropDownScrollViewCountries setItems:[self.arrCountries valueForKey:COUNTRY_NAME_KEY]];
    [self.dropDownScrollViewCountries refreshScrollView];
//    if ([self.vwCommercialProfileForm isHidden]) {
//        
//    }else{
//        [self.vwCommercialProfileForm addSubview:self.dropDownScrollViewCountries];
//    }
    [self.viewFieldsContainer addSubview:self.dropDownScrollViewCountries];
      [self.scrollViewFieldsContainter scrollRectToVisible:self.dropDownScrollViewCountries.frame animated:YES];
    [self.dropDownScrollViewCountries.hiddenTexfield becomeFirstResponder];
}
-(void)showIndustriesDropDownMenu
{
    if ([self.arrIndustries count] == 0) {
        return;
    }
    CGRect frame;
    if ([self.vwCommercialProfileForm isHidden]) {
    }else{
        frame = self.tfCommercialIndustry.frame;
    }
    
    self.dropDownScrollViewIndustries = [[AAFilterDropDownScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 2,frame.size.width,90)];
    [self.dropDownScrollViewIndustries setItemHeight:30];
    self.dropDownScrollViewIndustries.dropDownDelegate = self;
    self.activeField = self.dropDownScrollViewIndustries;
    [self.dropDownScrollViewIndustries setItems:[self.arrIndustries valueForKey:INDUSTRY_NAME_KEY]];
    [self.dropDownScrollViewIndustries refreshScrollView];
    if ([self.vwCommercialProfileForm isHidden]) {
    }else{
        [self.vwCommercialProfileForm addSubview:self.dropDownScrollViewIndustries];
    }
    
    [self.scrollViewFieldsContainter scrollRectToVisible:self.dropDownScrollViewIndustries.frame animated:YES];
    [self.dropDownScrollViewIndustries.hiddenTexfield becomeFirstResponder];
}

-(void)showPaymentTypeDropDownMenu
{
    
   /* self.dropDownScrollViewPaymentType = [[AADropDownScrollView alloc] initWithFrame:CGRectMake(self.tfPaymentType.frame.origin.x, self.tfPaymentType.frame.origin.y + self.tfPaymentType.frame.size.height + 2,self.tfPaymentType.frame.size.width,90)];
    [self.dropDownScrollViewPaymentType setItemHeight:30];
    self.dropDownScrollViewPaymentType.dropDownDelegate = self;
    
    [self.dropDownScrollViewPaymentType setItems:[AAAppGlobals sharedInstance].paymentTypes.mutableCopy];
    [self.dropDownScrollViewPaymentType refreshScrollView];
    [self.viewFieldsContainer addSubview:self.dropDownScrollViewPaymentType];
    [self.scrollViewFieldsContainter scrollRectToVisible:self.dropDownScrollViewPaymentType.frame animated:YES];*/
    
}

-(void)showDOBDatePickerView
{
        self.datePickerView = [AADatePickerView createDatePickerViewWithBackgroundFrameRect:CGRectMake(0, 0, self.view.superview.frame.size.width, self.view.superview.frame.size.height)];
   ;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-120];
    
    NSDate* minimumDate =  [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];

    [self.datePickerView.datePicker setMaximumDate:[NSDate date]];
    [self.datePickerView.datePicker setMinimumDate:minimumDate];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:DATE_FORMAT];
    NSDate *date = [dateFormat dateFromString:self.tfDateOfBirth.text];
    if(date)
    {
    [self.datePickerView setDatepickerDate:date];
    }
    self.datePickerView.datePickerDelegate = self;
    [self.view.superview addSubview:self.datePickerView];
   
    
}
-(void)hideDropDownMenus
{   if(self.dropDownScrollViewMonths)
        [self.dropDownScrollViewMonths removeFromSuperview];
    if(self.dropDownScrollViewYear)
        [self.dropDownScrollViewYear removeFromSuperview];
    if([[self.viewFieldsContainer subviews] containsObject:self.dropDownScrollViewCountries])
    {
        //[self.view endEditing:YES];
        [self.dropDownScrollViewCountries removeFromSuperview];
    }
    if(self.dropDownScrollViewPaymentType)
        [self.dropDownScrollViewPaymentType removeFromSuperview];
}

-(NSMutableArray*)getYearsArray
{
    NSMutableArray* yearsArray = [[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    for (int i=0; i<20; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
    }
    return yearsArray;
}

-(NSString*)getCountryCodeWithCountryName:(NSString*)countryName
{
    for(NSDictionary* dictCountry in self.arrCountries)
    {
        if ([[dictCountry objectForKey:COUNTRY_NAME_KEY] isEqualToString:countryName]) {
            NSString* countryCode = [dictCountry objectForKey:COUNTRY_CODE_KEY];
            return countryCode;
        }
    }
    
    return nil;
}
-(NSString*)getCountryNameWithCountryCode:(NSString*)countryCode
{
    for(NSDictionary* dictCountry in self.arrCountries)
    {
        if ([[dictCountry objectForKey:COUNTRY_CODE_KEY] isEqualToString:countryCode]) {
            NSString* countryName = [dictCountry objectForKey:COUNTRY_NAME_KEY];
            return countryName;
        }
    }
    
    return nil;
}
-(NSString*)getIndustryCodeWithCountryName:(NSString*)countryName
{
    for(NSDictionary* dictCountry in self.arrIndustries)
    {
        if ([[dictCountry objectForKey:INDUSTRY_NAME_KEY] isEqualToString:countryName]) {
            NSString* industryCode = [dictCountry objectForKey:INDUSTRY_ID_KEY];
            return industryCode;
        }
    }
    
    return nil;
}
-(NSString*)getIndustryNameWithCountryCode:(NSString*)industryCode
{
    for(NSDictionary* dictCountry in self.arrIndustries)
    {
        if ([[dictCountry objectForKey:INDUSTRY_ID_KEY] isEqualToString:industryCode]) {
            NSString* industryName = [dictCountry objectForKey:INDUSTRY_NAME_KEY];
            return industryName;
        }
    }
    
    return nil;
}
-(void)populateCountries
{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"countries"])
    {
        self.arrCountries = [[NSUserDefaults standardUserDefaults] objectForKey:@"countries"];
    }
    else
    {
        [AACountriesHelper getCountriesFromServerWithCompletionBlock:^(NSMutableArray * countries) {
            self.arrCountries = countries;
            [[NSUserDefaults standardUserDefaults] setObject:self.arrCountries forKey:@"countries"];
        } andFailure:^(NSString * errorMessage) {
           
        }];
    }
    
}

-(void)populateIndustries
{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"industries"])
    {
        self.arrIndustries = [[NSUserDefaults standardUserDefaults] objectForKey:@"industries"];
    }
    else
    {
        [AACountriesHelper getIndustriesFromServerWithCompletionBlock:^(NSMutableArray * countries) {
            self.arrIndustries = countries;
            [[NSUserDefaults standardUserDefaults] setObject:self.arrIndustries forKey:@"industries"];
        } andFailure:^(NSString * errorMessage) {
            
        }];
    }
    
}

-(void)saveProfileToUserDefaults
{
    if (![self.tfCommercialPWD.text isEqualToString:[AAAppGlobals sharedInstance].customerPassword]) {
        [AAAppGlobals sharedInstance].isPasswordChanged = YES;
    }
    [AAAppGlobals sharedInstance].consumer = self.consumer;
    [AAAppGlobals sharedInstance].customerEmailID = self.tfCommercialEmailId.text;
    NSData *dataConsumer = [NSKeyedArchiver archivedDataWithRootObject:self.consumer];
    
    [[NSUserDefaults standardUserDefaults] setObject:dataConsumer forKey:USER_DEFAULTS_CONSUMER_KEY];
    
    [[NSUserDefaults standardUserDefaults] setBool:!self.pnSwitch.isOn forKey:PNKEY];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:KEY_IS_LOGGED_IN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - validation text field delegates


-(BOOL)validationTextFieldShouldBeginEditing:(UITextField *)validatoinTextField
{
   
   
   /* if(validatoinTextField==self.tfExpiryMonth)
    {
        CGRect aRect = self.view.frame;
         //aRect.size.height -= kbSize.height;
         if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
         [self.scrollViewFieldsContainter scrollRectToVisible:self.activeField.frame animated:YES];
         }
         
         if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
         [self.scrollViewFieldsContainter scrollRectToVisible:self.activeField.frame animated:YES];
         }
        
        //[validatoinTextField resignFirstResponder];
         [self.view endEditing:YES];
        [self showMonthsDropDownMenu];
        return NO;
        
        //[self.view endEditing:YES];
    }
    else if(validatoinTextField==self.tfExpiryYear)
    {
        //[validatoinTextField resignFirstResponder];
         [self.view endEditing:YES];
        [self showYearDropDownMenu];
        return NO;
        //[self.view endEditing:YES];
    }*/
    if (validatoinTextField==self.tfCountry || validatoinTextField == self.tfCommercialCountry)
    {
        //[validatoinTextField resignFirstResponder];
         //[self.view endEditing:YES];
        
        [self showCountriesDropDownMenu];
       
        return NO;
        //[self.view endEditing:YES];
    }else if (validatoinTextField==self.tfCommercialIndustry)
    {
        //[validatoinTextField resignFirstResponder];
        //[self.view endEditing:YES];
        
        [self showIndustriesDropDownMenu];
        
        return NO;
        //[self.view endEditing:YES];
    }
   /* else if (validatoinTextField==self.tfPaymentType)
    {
        //[validatoinTextField resignFirstResponder];
         [self.view endEditing:YES];
        [self showPaymentTypeDropDownMenu];
        return NO;
        //[self.view endEditing:YES];
    }*/
    else if (validatoinTextField==self.tfDateOfBirth)
    {
        //[validatoinTextField resignFirstResponder];
        [self.view endEditing:YES];
        [self showDOBDatePickerView];
        return NO;
        //[self.view endEditing:YES];
    }
    else
    {
        //BOOL flag = self.dropDownScrollViewCountries.isFirstResponder;
       // //NSLog(flag ? @"Yes" : @"No");
          self.activeField = validatoinTextField;
        return YES;
    }
    
   
    
}
-(void)validationTextFieldDidBeginEditing:(UITextField *)validatoinTextField
{
    [self hideDropDownMenus];
}
-(void)getString{
      NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *tdict = [[NSMutableDictionary alloc] init];
    [tdict setObject:@"68" forKey:@"product"];
    [tdict setObject:@"6" forKey:@"qty"];
    
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tdict options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"myString = %@",myString);
    NSMutableString *str = [NSMutableString stringWithString:@"["];
    [str appendString:myString];
    [str appendString:@","];
    [str appendString:myString];
    [str appendString:@"]"];
    NSLog(@"str = %@",str);
    
    
}
-(NSMutableDictionary*)createProductInfoDict{
   
    NSArray *allCartItems = [[AAAppGlobals sharedInstance] getAllProducts];
    NSMutableArray *arr = [[NSMutableArray array] init];
    for (int i= 0; i< [allCartItems count];i++){
        AAEShopProduct *item = [allCartItems objectAtIndex:i];
        NSMutableDictionary *tdict = [[NSMutableDictionary alloc] init];
        [tdict setObject:[NSString stringWithFormat:@"%d",item.productId] forKey:PAYMENT_PRODUCT_ID_KEY];
        if (self.isCOD) {
            [tdict setObject:item.qty forKey:PAYMENT_QUANTITY_KEY];
        }else{
            [tdict setObject:item.qty forKey:PAYMENT_QUANTITY_KEY];
        }
        
        if (item.selectedOptionOne != nil) {
            NSMutableString *prodOption = [NSMutableString stringWithString:item.selectedOptionOne];
            if (item.selectedOptionTwo != nil) {
               [prodOption appendString:@","];
                [prodOption appendString:item.selectedOptionOne];
            }
            [tdict setObject:prodOption forKey:@"prodOptions"];
            
        }
        if (item.giftMsg) {
            NSMutableDictionary *giftDict = [[NSMutableDictionary alloc] init];
            [giftDict setValue:item.giftFor forKey:@"gift_to"];
            [giftDict setValue:item.giftMsg forKey:@"msg"];
            [giftDict setValue:[AAAppGlobals sharedInstance].retailer.gift_price forKey:@"price"];
            [tdict setObject:giftDict forKey:@"giftwrap"];
        }
        
        [arr addObject:tdict];
    }
    NSMutableDictionary *paymentDictionary  = [NSMutableDictionary dictionaryWithObject:arr forKey:@"products"];
    
    return paymentDictionary;
}

#pragma mark - Scroll view delegate callbacks
-(void)onDropDownMenuItemSelected:(id)dropDownScrollView withItemName:(NSString *)itemName
{
    
    
    if(dropDownScrollView==self.dropDownScrollViewCountries)
    {
//        if ([self.vwCommercialProfileForm isHidden]) {
//           
//        }else{
//            self.tfCommercialCountry.text = itemName;
//        }
        NSString *countryCode = [self getCountryCodeWithCountryName:itemName];
        [AAShippingChargeHelper getShippingChargeForCountry:countryCode
                                        withCompletionBlock:^{
                                            
                                        }
                                        andFailure:^(NSString *errorMSG){
                                                     
                                            
                                        }];
         self.tfCountry.text = itemName;
        
    }else if(dropDownScrollView==self.dropDownScrollViewIndustries)
    {
        if ([self.vwCommercialProfileForm isHidden]) {
        }else{
            self.tfCommercialIndustry.text = itemName;
        }
        [self.dropDownScrollViewIndustries removeFromSuperview];
        
    }
   /* else if (dropDownScrollView==self.dropDownScrollViewMonths)
    {
        self.tfExpiryMonth.text = itemName;
    }
    else if (dropDownScrollView==self.dropDownScrollViewYear)
    {
         self.tfExpiryYear.text = itemName;
    }
    else if (dropDownScrollView==self.dropDownScrollViewPaymentType)
    {
        self.tfPaymentType.text = itemName;
    }*/
    [dropDownScrollView removeFromSuperview];
    
}

#pragma mark - gesture recognizer callbacks
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass: [AAGlossyButton class]])
    {
        //change it to your condition
        return NO;
    }
    
    return YES;
}

#pragma mark - Date Picker Callbacks
-(void)onDateCancelled
{
    
}

-(void)onDateSelected:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    
    NSString* dateString = [dateFormatter stringFromDate:date];
    self.tfDateOfBirth.text = dateString;
}

#pragma mark - Payment handler callbacks
-(void)onPaymentSuccess : (NSDictionary*)response
{
    [AAAppGlobals sharedInstance].cod = false;
    [self saveProfileToUserDefaults];
//    if (self.isCOD) {
//        [[AAAppGlobals sharedInstance] deleteAllProducts];
//        [AAAppGlobals sharedInstance].discountPercent = @"0";
//        [AAAppGlobals sharedInstance].rewardPointsRedeemed = @"0";
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Order sent sucesfully." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
//        return;
//    }
    NSString *cartTotal;
//    if ([AAAppGlobals sharedInstance].isDecimalAllowed) {
//        cartTotal = [NSString stringWithFormat:@"%.2f",[AAAppGlobals sharedInstance].cartTotal];
//    }else{
//        cartTotal = [NSString stringWithFormat:@"%.0f",[AAAppGlobals sharedInstance].cartTotal];
//    }
    NSMutableDictionary* paymentDictionary;
    if (![AAAppGlobals sharedInstance].enableShoppingCart) {
        CGFloat qty = [[self.productInformation objectForKey:PRODUCT_QUANTITY_KEY] floatValue];
        CGFloat unitiPrice = [[self.productInformation objectForKey:PRODUCT_AMOUNT_KEY] floatValue];
        CGFloat total = qty*unitiPrice;
        if ([AAAppGlobals sharedInstance].enableCreditCode) {
           
            float percent =  [[AAAppGlobals sharedInstance].discountPercent floatValue];
            float totalDiscount = ((float)total * percent) / 100.0;
            total =total- totalDiscount;
           
        }
        if (total>=[AAAppGlobals sharedInstance].freeAmount ) {
            
        }else{
            if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
                total = total + [[AAAppGlobals sharedInstance].shippingCharge floatValue];
            }
            
        }
        total = total - [[AAAppGlobals sharedInstance].rewardPointsRedeemed integerValue];
        if ([AAAppGlobals sharedInstance].isDecimalAllowed) {
            cartTotal = [NSString stringWithFormat:@"%.2f",total];
        }else{
            cartTotal = [NSString stringWithFormat:@"%.0f",total];
        }
        paymentDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[self.productInformation objectForKey:PRODUCT_ID_KEY] , JSON_PAYMENT_PRODUCT_ID_KEY,[self.productInformation objectForKey:PRODUCT_QUANTITY_KEY],JSON_PAYMENT_QUANTITY_KEY,[self.productInformation objectForKey:PRODUCT_AMOUNT_KEY],JSON_PAYMENT_ORDER_AMOUT_KEY,[response objectForKey:@"paymen_status"],JSON_PAYMENT_STATUS_KEY, nil];
    }else{
        float tempTotal = [AAAppGlobals sharedInstance].cartTotal;
        if (tempTotal>=[AAAppGlobals sharedInstance].freeAmount) {
            
        }else{
            if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
                tempTotal = tempTotal + [[AAAppGlobals sharedInstance].shippingCharge floatValue];
            }
            
        }
        tempTotal = tempTotal - [[AAAppGlobals sharedInstance].rewardPointsRedeemed integerValue];
        if ([AAAppGlobals sharedInstance].isDecimalAllowed) {
            cartTotal = [NSString stringWithFormat:@"%.2f",tempTotal];
        }else{
            cartTotal = [NSString stringWithFormat:@"%.0f",tempTotal];
        }
        paymentDictionary = [self createProductInfoDict];
        [paymentDictionary setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
        //[paymentDictionary setObject:emailId forKey:PAYMENT_EMAIL_KEY];
        
        [paymentDictionary setObject:cartTotal forKey:JSON_PAYMENT_ORDER_AMOUT_KEY];
        [paymentDictionary setValue:[response objectForKey:@"paymen_status"] forKey:JSON_PAYMENT_STATUS_KEY];
        
    }
//    NSDictionary* dictPaymentInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[self.productInformation objectForKey:PRODUCT_ID_KEY] , JSON_PAYMENT_PRODUCT_ID_KEY,[self.productInformation objectForKey:PRODUCT_QUANTITY_KEY],JSON_PAYMENT_QUANTITY_KEY,[self.productInformation objectForKey:PRODUCT_AMOUNT_KEY],JSON_PAYMENT_ORDER_AMOUT_KEY,[response objectForKey:@"payment_state"],JSON_PAYMENT_STATUS_KEY, nil];
    NSString *placeOrderUrl = [response objectForKey:@"place_order_url"];
    
    [[ActivityIndicator sharedActivityIndicator] show];
    [AAPaymentInfoHelper sendPaymentInfoWithDictionary:paymentDictionary
                                              endPoint:placeOrderUrl
                                   withCompletionBlock:^(NSDictionary *dictionary) {
           [[ActivityIndicator sharedActivityIndicator] hide];
           NSString *orderNo = [dictionary objectForKey:@"transactionId"];
           if (orderNo == nil) {
               orderNo = [response objectForKey:@"invoiceId"];
           }
           if (self.isCOD) {
               
               
           }else{
               [self showOrderSucessAlerwithrderNo:orderNo andGrandTtotal:cartTotal andIsByCreditL:NO];
           }
    } andFailure:^(NSString *response) {
        [[ActivityIndicator sharedActivityIndicator] hide];
    }];
    //[self.profileDelegate onPaymentSucceeded:response];
    if (self.isCOD) {
        [self showOrderSucessAlerwithrderNo:@"" andGrandTtotal:cartTotal andIsByCreditL:NO];
        
    }
    [AAAppGlobals sharedInstance].discountPercent = @"0";
    
}
-(void)onPaymentFailure:(NSString *)errMessage
{
    UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:errMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertViewFailed show];
}
- (IBAction)btnReddemTapped:(id)sender {
    if([self.imgTriangle isHidden]){
        return;
    }
    self.redeemRewardView = [[AARedeemRewardsView alloc] init];
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self.redeemRewardView];
    
}

- (IBAction)btnTermsOfUseTapped:(id)sender {
    
//    UIAlertView *tncAlert = [[UIAlertView alloc] initWithTitle:@"Terms of Use" message:@" snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sdsnhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sdsnhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sdsnhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd snhs sn sdc sd c sd c sdc sd csd c sd sm v s s dc ssd bc sb c sbn sd sd"/*[AAAppGlobals sharedInstance].termsConditions */delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//    [tncAlert show];
    AAWebViewController* vcWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAWebViewController"];
    
    [self presentViewController:vcWebViewController animated:YES completion:^{
        
    }];
}

- (IBAction)pnSwitchToggled:(id)sender {
    
//    [[NSUserDefaults standardUserDefaults] setBool:self.pnSwitch.isOn forKey:PNKEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)hideKeyBoard{
    [self.activeField resignFirstResponder];
}
-(void)showregistrationPage{
    [self.loginView removeFromSuperview];
    [self.viewBottomBar setHidden:false];
    [self.viewFieldsContainer setHidden:false];
    [self.btnShowLoginForm setHidden:false];
    CGRect frame = self.viewFieldsContainer.frame;
    frame.origin.y = self.btnShowLoginForm.frame.size.height+8;
    self.viewFieldsContainer.frame = frame;
    self.vwRewards.hidden = true;
    frame = self.vwTermsOfUse.frame;
    frame.origin.y = self.vwRewards.frame.origin.y;
    self.vwTermsOfUse.frame = frame;
    
    
    self.vwCreatePassword.hidden = false;
    frame = self.vwCreatePassword.frame;
    frame.origin.y = self.tfMobileNumber.frame.origin.y + self.tfMobileNumber.frame.size.height;
    self.vwCreatePassword.frame = frame;
    
    frame = self.vwProfileinfo.frame;
    frame.origin.y = self.vwCreatePassword.frame.origin.y + self.vwCreatePassword.frame.size.height+8;
    self.vwProfileinfo.frame = frame;
    
    float vwHeight = frame.size.height + frame.origin.y;
    frame = self.viewFieldsContainer.frame;
    frame.size.height = vwHeight;
    self.viewFieldsContainer.frame = frame;
    CGSize contentSize = self.scrollViewFieldsContainter.contentSize;
    contentSize.height = vwHeight;
    self.scrollViewFieldsContainter.contentSize = contentSize;
    
}
-(void)logionSucessful{
//    self.consumer = [AAAppGlobals sharedInstance].consumer;
    [self populateFields];
    [self saveProfileToUserDefaults];
    
    [self updateFrameAfterLogin];
    [self.btnSaveConsumerProfile setTitle:@"Save" forState:UIControlStateNormal];
    [self setProfileButtons];
    
    

}
-(void)updateFrameAfterLogin{
    [self.loginView removeFromSuperview];
    [self.viewFieldsContainer setHidden:false];
    [self.viewBottomBar setHidden:false];
    [self.btnShowLoginForm setHidden:true];
    CGRect frame = self.viewFieldsContainer.frame;
    frame.origin.y = 0;
    self.viewFieldsContainer.frame = frame;
    
    self.vwRewards.hidden = false;
    frame = self.vwTermsOfUse.frame;
    frame.origin.y = self.vwRewards.frame.origin.y + self.vwRewards.frame.size.height+8;
    self.vwTermsOfUse.frame = frame;
    
    
    self.vwCreatePassword.hidden = true;
    //    frame = self.vwCreatePassword.frame;
    //    frame.origin.y = self.tfMobileNumber.frame.origin.y + self.tfMobileNumber.frame.size.height;
    //    self.vwCreatePassword.frame = frame;
    
    frame = self.vwProfileinfo.frame;
    frame.origin.y = self.tfMobileNumber.frame.origin.y + self.tfMobileNumber.frame.size.height+8;
    self.vwProfileinfo.frame = frame;
    
    float vwHeight = frame.size.height + frame.origin.y;
    frame = self.viewFieldsContainer.frame;
    frame.size.height = vwHeight;
    self.viewFieldsContainer.frame = frame;
    
    CGSize contentSize = self.scrollViewFieldsContainter.contentSize;
    contentSize.height = vwHeight;
    self.scrollViewFieldsContainter.contentSize = contentSize;
}

- (IBAction)btnShowLoginFormTapped:(id)sender {
    [self showLoginView];
}

@end

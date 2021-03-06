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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString* const PAYPAL_CHECKOUT = @"place_order.php";
static NSString* const COD_CHECKOUT = @"enquiryMail.php";
#define FOOTER_OPTIONS_FONTSIZE 14.0
@interface AAProfileViewController ()
@property (nonatomic,strong) AAValidationTextField *tf;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfConfirmEmail;
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
@synthesize productInformationString;
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
//        self.heading = @"PROFILE";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.heading = self.titleText;
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCart" object:nil];
    
    self.btnSaveConsumerProfile.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.lblEnablePn.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FOOTER_OPTIONS_FONTSIZE];
    
    
    //set properties for text fields
    [self.tfMobileNumber setAllowOnlyNumbers:YES];

    NSString * appType = [AAAppGlobals sharedInstance].retailer.retailerAppType ;
   
    [self registerForKeyboardNotifications];
   // [self populateIndustries];
    [self populateCountries];
    
    [self.tpgrBackgrounvView setCancelsTouchesInView:NO];
    [self.tpgrBackgrounvView setDelegate:self];
        [self.scrollViewFieldsContainter setContentSize:CGSizeMake(self.view.frame.size.width, self.viewFieldsContainer.frame.size.height) ];
        self.viewFieldsContainer.hidden = FALSE;
        for(AAThemeValidationTextField* tfValidation in self.arrValidationFields)
        {
            tfValidation.validationDelegate = self;
        }

    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if(isLoggedIn){
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
    [self.pnSwitch setOn:![[NSUserDefaults standardUserDefaults] boolForKey:PNKEY]];
    [self.pnSwitch setOnTintColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    if (self.titleText == nil) {
        [headerView setTitle:@"Profile"];
    }else{
       [headerView setTitle:self.titleText];
    }
    
    
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
    [self setTfIcons];
    [self.btnSaveConsumerProfile setBackgroundColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
    
}
-(void)setTfIcons{
    self.tfFirstName.leftView = [self getLeftImageViewWithImage:@"name_white"];
    self.tfFirstName.leftViewMode = UITextFieldViewModeAlways;
    self.tfEmail.leftView = [self getLeftImageViewWithImage:@"email_white"];
    self.tfEmail.leftViewMode = UITextFieldViewModeAlways;
    self.tfConfirmEmail.leftView = [self getLeftImageViewWithImage:@"email_white"];
    self.tfConfirmEmail.leftViewMode = UITextFieldViewModeAlways;
    self.tfMobileNumber.leftView = [self getLeftImageViewWithImage:@"phone_white"];
    self.tfMobileNumber.leftViewMode = UITextFieldViewModeAlways;
    self.tfCountry.leftView = [self getLeftImageViewWithImage:@"country_white"];
    self.tfCountry.leftViewMode = UITextFieldViewModeAlways;
    self.tfPwd.leftView = [self getLeftImageViewWithImage:@"password_white"];
    self.tfPwd.leftViewMode = UITextFieldViewModeAlways;
    self.tfCnfPwd.leftView = [self getLeftImageViewWithImage:@"password_white"];
    self.tfCnfPwd.leftViewMode = UITextFieldViewModeAlways;
}
-(UIView*)getLeftImageViewWithImage:(NSString*)imageName{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 20, 20)];
    [imgView setImage:[UIImage imageNamed:imageName]];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    [leftView addSubview:imgView];
    return leftView;
}
-(void)showLoginView{
    if (self.loginView == nil) {
        self.loginView = [[AALoginDailogView alloc] initWithFrame:self.scrollViewFieldsContainter.bounds];
        self.loginView.delegate = self;
    }
    
    [self.scrollViewFieldsContainter addSubview:self.loginView];
    [self.viewFieldsContainer setHidden:true];
    self.loginView.formType = FormTypeLogin;
}

-(void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
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
        [self saveConsumerProfile];
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
    aRect.size.height = aRect.size.height - kbSize.height + 44 - self.view.frame.size.height;
    if (!CGRectContainsRect(aRect, self.activeField.frame) ) {
        [self.scrollViewFieldsContainter scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewFieldsContainter.contentInset = contentInsets;
    self.scrollViewFieldsContainter.scrollIndicatorInsets = contentInsets;
}

-(void)makePayment
{
    NSString *emailId;
    NSMutableDictionary* dictPayment = [[NSMutableDictionary alloc] init];
    
    [self populateConsumerAndPaymentInformation];
    emailId =self.consumer.email;
    [dictPayment addEntriesFromDictionary:[self.consumer JSONDictionaryRepresentation]];
    
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
    
    [dictConsumerProfile addEntriesFromDictionary:[self.consumer JSONDictionaryProfileRepresentation]];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];;
    if (!isLoggedIn) {
        [dictConsumerProfile setValue:self.tfPwd.text forKey:@"password"];
    }
    
     [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [AAConsumerProfileHelper saveConsumerProfileWithDictionary:dictConsumerProfile withCompletionBlock:^{
         [self saveProfileToUserDefaults];
         [self logionSucessful];
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if([self.profileDelegate respondsToSelector:@selector(closeProfileViewController:)])
        {
           
            [self saveProfileToUserDefaults];
//            [self.profileDelegate closeProfileViewController:self];
        }
        else
        {
        
        
         UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Profile Saved" message:@"Profile has been successfully saved" delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [self saveProfileToUserDefaults];
        [alertViewSuccess show];
            [self updateFrameAfterLogin];
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
    
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];;
    if (!isLoggedIn) {
        NSString *password = self.tfPwd.text;
        NSString *confEmail = self.tfConfirmEmail.text;
        if (confEmail == nil || [confEmail length] == 0) {
            isValid = false;
            self.tf = self.tfConfirmEmail;
            
        }else if(![confEmail isEqualToString:self.tfEmail.text]){
            isValid = false;
            self.tf = self.tfConfirmEmail;
        }else if (password == nil || [password length] == 0) {
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

-(void)populateConsumerAndPaymentInformation
{
    if (self.consumer == nil) {
        self.consumer = [[AAConsumer alloc] init];
    }
    
    [self.consumer setFirstName:self.tfFirstName.text];
    [self.consumer setMobileNumber:self.tfMobileNumber.text.integerValue];
    [self.consumer setEmail:self.tfEmail.text];
    
    [self.consumer setCountry:[self getCountryCodeWithCountryName:self.tfCountry.text]];
    
   
    AAConsumerPayment* consumerPayment = [[AAConsumerPayment alloc] init];
    [self.consumer removeAllConsumerPaymentInformation];
    [self.consumer addConsmerPaymentInformation:consumerPayment atIndex:0];
}
-(void)setFonts{
    self.tfFirstName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfMobileNumber.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfEmail.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];

   
    self.tfCountry.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
}
-(void)populateFields
{
    if([AAAppGlobals sharedInstance].consumer)
    {
        self.consumer = [AAAppGlobals sharedInstance].consumer;
        
        self.tfFirstName.text = self.consumer.firstName;
        self.tfMobileNumber.text = [NSString stringWithFormat:@"%ld", (long)self.consumer.mobileNumber ];
        self.tfEmail.text = self.consumer.email;
        
        if(self.arrCountries && self.arrCountries.count > 0)
        {
            self.tfCountry.text = [self getCountryNameWithCountryCode: self.consumer.country] ;
        }
        
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
}
-(void)showYearDropDownMenu
{
}

-(void)showCountriesDropDownMenu
{
    if ([self.arrCountries count]==0) {
        return;
    }
    CGRect frame;
    frame = self.tfCountry.frame;
    
    self.dropDownScrollViewCountries = [[AAFilterDropDownScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height + 2,frame.size.width,90)];
    [self.dropDownScrollViewCountries setItemHeight:30];
    self.dropDownScrollViewCountries.dropDownDelegate = self;
     self.activeField = self.dropDownScrollViewCountries;
    [self.dropDownScrollViewCountries setItems:[self.arrCountries valueForKey:COUNTRY_NAME_KEY]];
    [self.dropDownScrollViewCountries refreshScrollView];
    [self.viewFieldsContainer addSubview:self.dropDownScrollViewCountries];
      [self.scrollViewFieldsContainter scrollRectToVisible:self.dropDownScrollViewCountries.frame animated:YES];
    [self.dropDownScrollViewCountries.hiddenTexfield becomeFirstResponder];
}

-(void)showPaymentTypeDropDownMenu
{
    
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
    [AAAppGlobals sharedInstance].consumer = self.consumer;
    NSData *dataConsumer = [NSKeyedArchiver archivedDataWithRootObject:self.consumer];
    
    [[NSUserDefaults standardUserDefaults] setObject:dataConsumer forKey:USER_DEFAULTS_CONSUMER_KEY];
    
    [[NSUserDefaults standardUserDefaults] setBool:!self.pnSwitch.isOn forKey:PNKEY];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:KEY_IS_LOGGED_IN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - validation text field delegates


-(BOOL)validationTextFieldShouldBeginEditing:(UITextField *)validatoinTextField
{
    if (validatoinTextField==self.tfCountry)
    {
        //[validatoinTextField resignFirstResponder];
        //[self.view endEditing:YES];
        
        [self showCountriesDropDownMenu];
        
        return NO;
        //[self.view endEditing:YES];
    }
    [self.dropDownScrollViewCountries removeFromSuperview];
    self.activeField = validatoinTextField;
    return YES;
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
        [self.dropDownScrollViewIndustries removeFromSuperview];
        
    }
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


- (IBAction)pnSwitchToggled:(id)sender {
    
//    [[NSUserDefaults standardUserDefaults] setBool:self.pnSwitch.isOn forKey:PNKEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)hideKeyBoard{
    [self.activeField resignFirstResponder];
}
-(void)showregistrationPage{
    [self.loginView removeFromSuperview];
    [self.viewFieldsContainer setHidden:false];
    [self.btnShowLoginForm setHidden:false];
    CGRect frame = self.viewFieldsContainer.frame;
    frame.origin.y = self.btnShowLoginForm.frame.size.height+8;
    self.viewFieldsContainer.frame = frame;
    self.tfConfirmEmail.hidden = false;
    CGRect tfFrame = self.tfConfirmEmail.frame;
    tfFrame.origin.y = self.tfEmail.frame.origin.y + self.tfEmail.frame.size.height+8;
    self.tfConfirmEmail.frame = tfFrame;
    
    tfFrame = self.tfMobileNumber.frame;
    tfFrame.origin.y = self.tfConfirmEmail.frame.origin.y + self.tfConfirmEmail.frame.size.height+8;
    self.tfMobileNumber.frame = tfFrame;
    
    tfFrame = self.tfCountry.frame;
    tfFrame.origin.y = self.tfMobileNumber.frame.origin.y + self.tfMobileNumber.frame.size.height+8;
    self.tfCountry.frame = tfFrame;
    
    self.vwCreatePassword.hidden = false;
    frame = self.vwCreatePassword.frame;
    frame.origin.y = self.tfCountry.frame.origin.y + self.tfCountry.frame.size.height;
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
    [self populateFields];
    [self saveProfileToUserDefaults];
    
    [self updateFrameAfterLogin];
    [self.btnSaveConsumerProfile setTitle:@"Save" forState:UIControlStateNormal];
    if([self.profileDelegate respondsToSelector:@selector(closeProfileViewController:)])
    {
        [self.profileDelegate closeProfileViewController:self];
    }
}
-(void)updateFrameAfterLogin{
    [self.loginView removeFromSuperview];
    [self.viewFieldsContainer setHidden:false];
    [self.btnShowLoginForm setHidden:true];
    CGRect frame = self.viewFieldsContainer.frame;
    frame.origin.y = 0;
    self.viewFieldsContainer.frame = frame;
    
    
    self.vwCreatePassword.hidden = true;
    self.tfConfirmEmail.hidden = true;
    
    CGRect tfframe = self.tfMobileNumber.frame;
    tfframe.origin.y = self.tfEmail.frame.origin.y + self.tfEmail.frame.size.height +8;
    self.tfMobileNumber.frame = tfframe;
    
    tfframe = self.tfCountry.frame ;
    tfframe.origin.y = self.tfMobileNumber.frame.origin.y + self.tfMobileNumber.frame.size.height +8;
    self.tfCountry.frame = tfframe;
    
    frame = self.vwProfileinfo.frame;
    frame.origin.y = self.tfCountry.frame.origin.y + self.tfCountry.frame.size.height+8;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.dropDownScrollViewCountries removeFromSuperview];
}
-(void)fBLoginTapped{
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
                          if ([result valueForKey:@"email"]) {
                              self.tfEmail.text = [result valueForKey:@"email"];
                          }
                          if ([result valueForKey:@"name"]) {
                              self.tfFirstName.text = [result valueForKey:@"name"];
                          }
                          [self saveConsumerProfile];
                      }
                  }];
             }
         }
     }];

}
@end

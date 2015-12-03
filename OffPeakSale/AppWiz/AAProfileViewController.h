//
//  AAProfileViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AAConsumer.h"
#import "AAConsumerPayment.h"
#import "AAPaymentInfoHelper.h"
#import "AAThemeValidationTextField.h"
#import "AAFilterDropDownScrollView.h"
#import "AACountriesHelper.h"
#import "AAConsumerProfileHelper.h"
#import "AAChildNavigationControllerDelegate.h"
#import "AADatePickerView.h"

#import "AAProfileViewControllerDelegate.h"
#import "AAThemeGlossyButton.h"
#import "AAThemeView.h"
#import "AAOrderSucessView.h"
#import "AARedeemRewardsView.h"
@interface AAProfileViewController : AAChildBaseViewController <AAValidationTextFieldDelegate,AADropDownScrollViewDelegate,UIGestureRecognizerDelegate,AADatePickerViewDelegate,AAPaymentHandlerDelegate>
extern NSString* const PRODUCT_ID_KEY;
extern NSString* const PRODUCT_QUANTITY_KEY;
extern NSString* const PRODUCT_SHORT_DESCRIPTION_KEY;
extern NSString* const PRODUCT_AMOUNT_KEY;

@property (nonatomic, strong) AAOrderSucessView *orderSucessAlert;
@property (nonatomic) BOOL showBuyButton;
@property (nonatomic, getter=isCOD) BOOL COD;
@property (nonatomic) BOOL isNewUser;
@property (nonatomic,strong) AAConsumer* consumer;
@property (nonatomic,strong) NSMutableArray* arrCountries;
@property (nonatomic,strong) NSMutableArray* arrIndustries;
@property (nonatomic,strong) NSDictionary* productInformation;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfMobileNumber;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfFirstName;

@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCountry;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfEmail;

@property (nonatomic,strong) UIView* activeField;
@property (nonatomic,strong) AADropDownScrollView* dropDownScrollViewMonths;
@property (nonatomic,strong) AADropDownScrollView* dropDownScrollViewYear;
@property (nonatomic,strong) AAFilterDropDownScrollView* dropDownScrollViewCountries;
@property (nonatomic,strong) AAFilterDropDownScrollView* dropDownScrollViewIndustries;
@property (nonatomic,strong) AADropDownScrollView* dropDownScrollViewPaymentType;
@property (nonatomic, strong) NSString *productInformationString;
@property (nonatomic, strong) NSString *titleText;


@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewFieldsContainter;


@property (strong, nonatomic) IBOutletCollection(AAThemeValidationTextField) NSArray *arrValidationFields;

@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnSaveConsumerProfile;

@property (weak, nonatomic) IBOutlet UIView *viewFieldsContainer;

@property (nonatomic,strong) AADatePickerView* datePickerView;
@property (nonatomic,weak) id<AAProfileViewControllerDelegate> profileDelegate;

- (IBAction)viewBackgroundTapped:(id)sender;
- (IBAction)btnSaveConsumerProfileTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tpgrBackgrounvView;
//for Comercial user
@property (weak, nonatomic) IBOutlet UILabel *lblEnablePn;
@property (weak, nonatomic) IBOutlet UISwitch *pnSwitch;

@property (weak, nonatomic) IBOutlet UIView *vwCreatePassword;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfPwd;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCnfPwd;
@property (weak, nonatomic) IBOutlet UIView *vwProfileinfo;
- (IBAction)pnSwitchToggled:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnShowLoginForm;
- (IBAction)btnShowLoginFormTapped:(id)sender;

@end

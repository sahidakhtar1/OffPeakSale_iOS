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
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfLastName;

@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfDateOfBirth;

@property (weak, nonatomic) IBOutlet UISegmentedControl *scGender;
/*@property (weak, nonatomic) IBOutlet AAProfileValidationTextField *tfPaymentType;
@property (weak, nonatomic) IBOutlet AAProfileValidationTextField *tfCardNumber;*/
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfAddress;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCity;

@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCountry;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfPostalCode;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfEmail;
/*@property (weak, nonatomic) IBOutlet AAProfileValidationTextField *tfCVV;
@property (weak, nonatomic) IBOutlet AAProfileValidationTextField *tfExpiryMonth;
@property (weak, nonatomic) IBOutlet UITextField *tfExpiryYear;*/
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

@property (weak, nonatomic) IBOutlet UIView *viewBottomBar;

@property (strong, nonatomic) IBOutletCollection(AAThemeValidationTextField) NSArray *arrValidationFields;
@property (strong, nonatomic) IBOutletCollection(AAThemeValidationTextField) NSArray *arrValidationCommercialFields;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnSaveConsumerProfile;

@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnBuyProduct;
@property (weak, nonatomic) IBOutlet UIView *viewFieldsContainer;

@property (nonatomic,strong) AADatePickerView* datePickerView;
@property (nonatomic,weak) id<AAProfileViewControllerDelegate> profileDelegate;
@property (weak, nonatomic) IBOutlet AAThemeView *viewHorizontalLineSeparator1;
@property (weak, nonatomic) IBOutlet AAThemeView *viewHorizontalLineSeparator2;

- (IBAction)viewBackgroundTapped:(id)sender;
- (IBAction)btnBuyProductTapped:(id)sender;
- (IBAction)btnSaveConsumerProfileTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tpgrBackgrounvView;
//for Comercial user
@property (strong, nonatomic) IBOutlet UIView *vwCommercialProfileForm;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialCity;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialComapany;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialIndustry;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialCustomerId;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialFirstName;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialLastName;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialDesignation;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialAddress;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialCountry;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialPWD;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialCNFPWD;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialEmailId;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialPostalCode;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercilMobileNo;
@property (weak, nonatomic) IBOutlet AAThemeView *veDevider;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfCommercialFaxNo;
@property (strong, nonatomic) IBOutlet UIView *vwTermsOfUse;
@property (strong, nonatomic) IBOutlet UIButton *btnTermsofUse;
@property (weak, nonatomic) IBOutlet UILabel *lblEnablePn;
@property (weak, nonatomic) IBOutlet UILabel *lblRedeemRewards;
@property (weak, nonatomic) IBOutlet UISwitch *pnSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnRedeem;
@property (weak, nonatomic) IBOutlet UIImageView *imgTriangle;
@property (strong, nonatomic) IBOutlet UILabel *lblTermsOfUse;
@property (strong, nonatomic) AARedeemRewardsView *redeemRewardView;
@property (weak, nonatomic) IBOutlet UIView *vwRewards;
@property (weak, nonatomic) IBOutlet UIView *vwCreatePassword;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatePwd;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfPwd;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfCnfPwd;
@property (weak, nonatomic) IBOutlet UIView *vwProfileinfo;
@property (weak, nonatomic) IBOutlet UILabel *tvNoReward;
- (IBAction)btnReddemTapped:(id)sender;
- (IBAction)btnTermsOfUseTapped:(id)sender;
- (IBAction)pnSwitchToggled:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnShowLoginForm;
- (IBAction)btnShowLoginFormTapped:(id)sender;

@end

//
//  AAProductInformationViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AAEShopProduct.h"
#import "AAProductInformationScrollView.h"
#import "AAChildNavigationControllerDelegate.h"
#import "AAProfileViewController.h"
#import "AAConfirmPurchasePopupView.h"
#import "AAThemeGlossyButton.h"
#import "AAThemeView.h"
#import "AAThemeLabel.h"
#import "AAThemeButton.h"
#import "AACurrentPriceThemeLabel.h"
#import "AAShareButtonProtocol.h"
#import "AAEShopCategoriesScrollView.h"
#import "AAShareActivityItemProvider.h"
#import "AAProfileUpdatePopupView.h"
#import "AAProductReview.h"
#import "AAHowItWorksView.h"
#import "AARetailerStoreMapViewController.h"
@interface AAProductInformationViewController : AAChildBaseViewController <AAProfileViewControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwEnquiry;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnEnquiry;

@property (strong, nonatomic) IBOutlet UIView *vwBuy;
@property (weak, nonatomic) IBOutlet UIView *viewVerticalSeparator;
@property (strong, nonatomic) IBOutlet UIView *viewVerticalSeparator2;
@property (weak, nonatomic) IBOutlet AAThemeView *viewHorizontalLineSeprator1;
@property (strong, nonatomic) IBOutlet AACurrentPriceThemeLabel *lblQty;
@property (weak, nonatomic) IBOutlet AAThemeView *viewHorizontalLineSeparator2;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviousProductPrice;
@property (weak, nonatomic) IBOutlet AACurrentPriceThemeLabel *lblCurrentProductPrice;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnBuyProduct;

@property (weak, nonatomic) IBOutlet AAProductInformationScrollView *scrollViewProductInformation;
@property (nonatomic,strong) AAEShopProduct* product;
@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfQty;
@property (nonatomic,strong) AAProfileUpdatePopupView* updatePopupView;
@property (weak, nonatomic) IBOutlet AAThemeButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *vwCard;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet AAThemeButton *btnScan;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblCartTotal;
- (IBAction)btnBuyProductTapped:(id)sender;
@property (weak, nonatomic) IBOutlet AAEShopCategoriesScrollView *productTabs;
- (IBAction)btnScanTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnShareTapped:(id)sender;
- (IBAction)btnCartTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *ProductScroolView;
@property (nonatomic, strong) AAProductReview *productReview;
@property (nonatomic, strong) AAHowItWorksView *howItWorks;
- (IBAction)btnSearchTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (nonatomic,strong) AARetailerStoreMapViewController *mapView;

@end

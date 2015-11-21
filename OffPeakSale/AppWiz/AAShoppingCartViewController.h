//
//  AAShoppingCartViewController.h
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 26/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAChildBaseViewController.h"
#import "AAChildNavigationControllerDelegate.h"
#import "TableViewKeyBoardHandling.h"
#import "AAThemeGlossyButton.h"
#import "AAThemeLabel.h"
#import "AAEShopNavigationViewController.h"
#import "AAThemeButton.h"
#import "AAShoppingCartBottomView.h"
#import "AACouponView.h"
@interface AAShoppingCartViewController : AAChildBaseViewController <UITableViewDataSource,UITableViewDelegate>{
    NSString *countryCode;
}
@property (strong, nonatomic) IBOutlet UIView *vwCheckout;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnEnquiry;

@property (strong, nonatomic) IBOutlet UIView *vwGTContainer;
@property (nonatomic,strong) AAConsumer* consumer;
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblGT;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnPaypal;
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblCreditTemsTime;
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblCreditTermsValue;
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblTNC;
@property (strong, nonatomic) IBOutlet AAThemeLabel *lblCredit;
@property (strong, nonatomic) IBOutlet TableViewKeyBoardHandling *tbCartItemTable;
@property (strong, nonatomic) IBOutlet UIView *vwCreditTermsView;
@property (strong, nonatomic) IBOutlet UILabel *lblGrandTotal;
@property (nonatomic, strong) NSMutableArray *allCartItems;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) AAEShopNavigationViewController *parentVc;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnBackToShop;
@property (strong, nonatomic) IBOutlet UILabel *lblCheckout;
@property (weak, nonatomic) IBOutlet UIView *vwShippingCharge;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblShippingChargeValue;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblShippingCharge;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblShippingPlaceHolder;
@property (weak, nonatomic) IBOutlet AAThemeButton *btnBack;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblCartTotal;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *vwCart;
@property (weak, nonatomic) IBOutlet UIButton *btnEnterCode;

@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalValue;

@property (nonatomic, strong) AAShoppingCartBottomView *cartBottomView;
@property (nonatomic, strong) AACouponView *couponView;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckOut;
@property (weak, nonatomic) IBOutlet UIButton *btnCOD;
@property (weak, nonatomic) IBOutlet UIView *vwDevider;
- (IBAction)btnContinueShoppingTapped:(id)sender;
- (IBAction)btnPayByCreditTapped:(id)sender;
- (IBAction)btnPayByPaypalTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnEnterCodeTapped:(id)sender;
- (IBAction)btnCODTapped:(id)sender;
- (IBAction)btnCheckOut:(id)sender;
@end

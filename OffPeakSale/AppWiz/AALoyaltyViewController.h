//
//  AALoyaltyViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "UIImageView+WebCache.h"
#import "AALoyaltyHelper.h"
#import "AACouponButton.h"
#import "AAMerchantAuthenticationPopupView.h"
#import "FacebookLikeView.h"
#import "Facebook.h"
@interface AALoyaltyViewController : AAChildBaseViewController <AAMerchantAuthenticationPopupViewDelegate,FacebookLikeViewDelegate,FBSessionDelegate>
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) AAMerchantAuthenticationPopupView* merchantAuthenticationPopupView;
@property (weak, nonatomic) IBOutlet UITextView *tvTermsConditions;
@property (weak, nonatomic) IBOutlet UIImageView *ivLoyalty;
@property (strong, nonatomic) IBOutletCollection(AACouponButton) NSArray *arrCouponButtons;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnResetCoupons;
@property (weak, nonatomic) IBOutlet UIView *viewTermsConditionsContainer;
@property (strong, nonatomic) IBOutlet UIView *vwFBLikeView;
@property (weak, nonatomic) IBOutlet FacebookLikeView *fbLikeView;
@property (strong,nonatomic) Facebook* facebook;
@property (nonatomic) BOOL isMerchant;
@property BOOL isActive;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic) NSInteger couponCount;
@property (weak, nonatomic) IBOutlet UIView *vwInstagram;
- (IBAction)btnCouponTap:(id)sender;
- (IBAction)btnMerchantTap:(id)sender;
- (IBAction)btnResetCouponsTap:(id)sender;
- (IBAction)btnInstagramTapped:(id)sender;

@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnMerchantAdmin;

@property (strong, nonatomic) IBOutlet UILabel *lblTNCTitle;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;

@end

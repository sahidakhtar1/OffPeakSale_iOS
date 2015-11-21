//
//  AAMainViewContainerController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAHomeNavigationViewController.h"
#import "AAEShopNavigationViewController.h"
#import "AALoyaltyViewController.h"
#import "AAFeedbackNavigationViewController.h"
#import "AAVouchersViewController.h"
#import "AAProfileViewController.h"
#import "AAThemeView.h"
#import "AAThemeLabel.h"
#import "AAThemeButton.h"
#import "AAPushNotificationPopupView.h"
#import "AAShareActivityItemProvider.h"
#import "AAMenuDropDownScrollView.h"
#import "AAShareButtonProtocol.h"
#import "AACouponView.h"
@interface AAMainViewContainerController : UIViewController <AAChildNavigationControllerDelegate,AARootChildViewControllerDelegate,AADropDownScrollViewDelegate,AAShareButtonProtocol,AABasePopupViewDelegate>
{
    NSMutableArray* viewControllers_;
    AACouponView *couponView;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *vwHome;
@property (weak, nonatomic) IBOutlet UIView *vwVoucher;
@property (weak, nonatomic) IBOutlet UIView *vwFeedback;
@property (weak, nonatomic) IBOutlet UIView *vwLoyality;
@property (weak, nonatomic) IBOutlet UIView *vwEshop;

- (IBAction)btnEnterCodeTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnEnterCode;
@property (nonatomic, strong) UIView *selectedIndicator;
@property (strong,nonatomic) UIViewController<AAChildBaseViewControllerProtocol>* selectedViewController;
@property (weak, nonatomic) IBOutlet AAThemeLabel *lblContainerTitle;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnTabs;
@property (nonatomic) NSUInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIView *viewBottomBar;
@property (weak, nonatomic) IBOutlet AAThemeView *viewTopBar;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet AAThemeButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (nonatomic) BOOL isMenuShown;
@property (nonatomic,strong) AAMenuDropDownScrollView* dropDownMenu;
@property (strong,nonatomic) AAPushNotificationPopupView* pushNotificationPopupView;
@property (strong, nonatomic) IBOutlet UIView *vwCartView;
@property (strong, nonatomic) IBOutlet UILabel *lblCartAmount;
@property BOOL isNavigatedFromCart;
@property BOOL isInCart;
- (IBAction)btnTabBarButtonTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
-(void)showPushPopup : (AAVoucher*)imageUrl;
- (IBAction)btnShareTap:(id)sender;
- (IBAction)btnProfileTap:(id)sender;
- (IBAction)btnCartTapped:(id)sender;

@end

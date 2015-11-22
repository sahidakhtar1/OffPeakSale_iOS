//
//  AAAppDelegate.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AARetailerInfoHelper.h"
#import "AASplashPageHelper.h"
#import "AASplashScreenViewController.h"
#import "AAMainViewContainerController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UIImageView+WebCache.h"
#import "AAPushNotificationHandler.h"
#import "SWRevealViewController.h"
#import "AAPushNotificationPopupView.h"
@interface AAAppDelegate : UIResponder <UIApplicationDelegate,AASplashScreenViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSDictionary* pushDictionary;
//@property (nonatomic, strong) NSMutableArray *cartItems;

@property (nonatomic, strong)SWRevealViewController *revealController;
@property (strong,nonatomic) AAPushNotificationPopupView* pushNotificationPopupView;
@property (nonatomic) NSInteger voucherIndex;


-(void)openSideMenu;
-(void)searchItemWithText:(NSString*)searchText;
-(void)showVoucher;
-(void)loadEshopDetailWithProduct:(AAEShopProduct*)product;
@end

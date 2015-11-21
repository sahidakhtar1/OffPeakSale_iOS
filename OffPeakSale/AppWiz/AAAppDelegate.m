//
//  AAAppDelegate.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAAppDelegate.h"
#import "AAConfig.h"
#import "WXApi.h"
#import "AASideMenuViewController.h"
#import "SWRevealViewController.h"
#import "AAEShopViewController.h"
#import "AAEShopViewController.h"
@implementation AAAppDelegate
//@synthesize cartItems;
-(void)getString{
//    NSMutableString *string = [[NSMutableString alloc] initWithString:@"[{"];
//    [string appendString:@"\"productid\":\"2\""];
//    [string appendString:@","];
//    [string appendString:@"\"qunatity\":\"2\""];
//    [string appendString:@"}]"];
//    NSLog(@"String = %@", string);
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"MerchantA1",@"retailerId",json,@"products",@"aa@aa.in",@"email", nil];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableDictionary *tdict = [[NSMutableDictionary alloc] init];
    [tdict setObject:@"68" forKey:@"product"];
    [tdict setObject:@"6" forKey:@"qty"];
    
     BOOL flag= [NSJSONSerialization isValidJSONObject:tdict];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:tdict options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"myString = %@",myString);
    NSMutableString *str = [NSMutableString stringWithString:@"["];
    [str appendString:myString];
    [str appendString:@","];
    [str appendString:myString];
    [str appendString:@"]"];
    NSLog(@"str = %@",str);
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:tdict,tdict, nil];
     NSData * jsonDataarr = [NSJSONSerialization dataWithJSONObject:arr options:0 error:nil];
    NSString * myString1 = [[NSString alloc] initWithData:jsonDataarr encoding:NSUTF8StringEncoding];
    NSMutableDictionary *mdict = [[NSMutableDictionary alloc] init];
    [mdict setObject:myString1 forKey:@"products"];
    [mdict setObject:@"MerchantA1" forKey:@"retailerId"];
    [mdict setObject:@"aa@aa.in" forKey:@"email"];
    NSLog(@"dict = %@", mdict);
    
    
    
}
-(void)printFontNames{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_ESHOP_KEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self printFontNames];
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    NSDictionary *userInfo =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        
        
        self.pushDictionary = userInfo;
        
    }

    
    [GMSServices provideAPIKey:GOOGLE_MAPS_API_KEY];
    // Override point for customization after application launch.
    [[AAAppGlobals sharedInstance] loadDataFromUserDefaults];
    [AARetailerInfoHelper processRetailerInformationWithCompletionBlock:^{
        [self initWindow];
       // [AASplashPageHelper getSplashScreenImageWithCompletionBlock:^{
           
        [self showSplashScreen];
    
    } andFailure:^(NSString *error) {
        if([AAAppGlobals sharedInstance].retailer)
        {
            [self initWindow];
            // [AASplashPageHelper getSplashScreenImageWithCompletionBlock:^{
            
            [self showSplashScreen];
        }
        else
        {
            
        }
    }];
    [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"demo 2.0"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    dispatch_async([AAAppGlobals sharedInstance].backgroundQueue, ^{
        [[AAAppGlobals sharedInstance].retryQueue processFailedRequests];
    });
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initWindow
{
     self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
}

-(void)showMainScreen
{
    [AAAppGlobals sharedInstance].locationHandler = [[AALocationHandler alloc] init];
       UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AAHomeViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"AAHomeViewController"];
    AACategoryDataModel *item = [[AACategoryDataModel alloc] init];
    item.categoryName = @"OffPeakSale";
    item.categoryId = @"279";
    AAEShopViewController *eshopVC = [storyboard instantiateViewControllerWithIdentifier:@"AAEShopViewController"];
    eshopVC.category = item;

    AASideMenuViewController *sideMenuVC = [storyboard instantiateViewControllerWithIdentifier:@"AASideMenuVC"];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:eshopVC];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideMenuVC];
    
    self.revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    self.revealController.delegate = self;
    
    [frontNavigationController setNavigationBarHidden:YES];
    [rearNavigationController setNavigationBarHidden:YES];
    self.window.rootViewController = self.revealController ;
    [self.window makeKeyAndVisible];
    if(self.pushDictionary)
    {
      AAVoucher* voucher =  [AAPushNotificationHandler processUserInfoDictionary:self.pushDictionary];
        BOOL isPNOff = [[NSUserDefaults standardUserDefaults] boolForKey:PNKEY];
        if(voucher && voucher.voucherFileType != nil && !isPNOff)
        {
            [self showPushPopup:voucher];
        }
    }
//    [self showDummyVoucher];
//    CGRect frame = [UIScreen mainScreen].bounds;
//    float scale = [UIScreen mainScreen].scale;
//    NSString *resolution = [NSString stringWithFormat:@"resolution %.0f x %.0f",frame.size.width*scale,frame.size.height*scale];
//    [[[UIAlertView alloc] initWithTitle:@"Device info" message:[NSString stringWithFormat:@"Model = %@",resolution] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];

}
-(void)showSplashScreen
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AASplashScreenViewController* vcSplashScreen = [storyboard instantiateViewControllerWithIdentifier:@"AASplashScreenViewController"];
    vcSplashScreen.splashScreenInterval = 3.0;
    vcSplashScreen.splashScreenDelegate = self;
  
    [vcSplashScreen setSplashScreenImageURL:[AAAppGlobals sharedInstance].retailer.splashScreenURLString ];
    self.window.rootViewController = vcSplashScreen;
    [self.window makeKeyAndVisible];
}
-(void)onSplashScreenDisplayCompleted
{
    
        [self showMainScreen];
    
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSMutableString* binaryString = [NSMutableString stringWithCapacity:devToken.length];
    unsigned char* bytes = (unsigned char*) [devToken bytes];
    for (int i = 0 ; i < devToken.length ; i++)
        [binaryString appendFormat:@"%02x", bytes[i]];
     if([AAAppGlobals sharedInstance].consumer)
     {
         
         [AAAppGlobals sharedInstance].consumer.deviceToken = binaryString;
     }
    NSLog(@"Token %@",binaryString);
    //[[[UIAlertView alloc] initWithTitle:@"Info" message:binaryString delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    
         [AAAppGlobals sharedInstance].deviceToken = binaryString;
     
    
         dispatch_async([AAAppGlobals sharedInstance].backgroundQueue, ^{
             [[AAAppGlobals sharedInstance].locationHelper sendLocationInformationWithCompletionBlock:^(NSDictionary *response) {
                 
             } andFailure:^(NSString *errorMessage) {
                 
             }];
         });
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //NSLog(@"Error in registration. Error: %@", err);
}



-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([userInfo objectForKey:@"pnType"]) {
        AAVoucher* voucher =  [AAPushNotificationHandler processUserInfoDictionary:userInfo];
        BOOL isPNOff = [[NSUserDefaults standardUserDefaults] boolForKey:PNKEY];
        if(voucher && voucher.voucherFileType != nil && !isPNOff)
        {
//            AAMainViewContainerController* mainViewController = (AAMainViewContainerController*)self.window.rootViewController;
//            [mainViewController showPushPopup:voucher];
            [self showPushPopup:voucher];
        }
    }
    
}

-(void)showDummyVoucher{
    AAVoucher* voucher = [[AAVoucher alloc] init];
    [voucher setVoucherFileType:VOUCHER_FILE_TYPE_IMAGE];
    voucher.pid = @"745";
    //    [voucher setVoucherFileUrl:[NSString stringWithFormat:
    //                                @"http://223.25.237.175/appwizlive/uploads/retailer/1/pnimages/Swensational_Christmas.mp4"]];
    [voucher setVoucherFileUrl:[NSString stringWithFormat:
                                @"http:\/\/smartcommerce.asia\/uploads\/retailer\/1\/pnimages\/deviceimg\/1496_pn_14349960321_1434972810_8._Push_Notification_Voucher_xdhpi.jpg"]];
    //http://appwizlive.com/uploads/retailer/11/pnimages/deviceimg/pn_14053468485.Eshop1.jpg
    AAMainViewContainerController* mainViewController = (AAMainViewContainerController*)self.window.rootViewController;
    //[mainViewController showPushPopup:voucher];
    BOOL isPNOff = [[NSUserDefaults standardUserDefaults] boolForKey:PNKEY];
    if(voucher && !isPNOff)
    {
        [self showPushPopup:voucher];
    }
}
-(void)openSideMenu{
   
    UINavigationController *rearNavigationController = (id)self.revealController.rearViewController;
    
//    if ( ![rearNavigationController.topViewController isKindOfClass:[AASideMenuViewController class]] )
//    {
//        AASideMenuViewController *rearViewController = [[AASideMenuViewController alloc] init];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
//        [self.revealController pushFrontViewController:navigationController animated:YES];
////        self.revealController.rearViewController = navigationController;
////        [self.revealController revealToggle:self];
//    }
//    else
//    {
        [self.revealController revealToggle:self];
//    }
}
-(void)searchItemWithText:(NSString*)searchText{
    UINavigationController *rearNavigationController = (id)self.revealController.rearViewController;
    UIViewController *sideVC = rearNavigationController.topViewController;
    AAEShopViewController *eshopVC = [sideVC.storyboard instantiateViewControllerWithIdentifier:@"AAEShopViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eshopVC];
    eshopVC.searchText = searchText;
    navigationController.navigationBarHidden=YES;
    [self.revealController pushFrontViewController:navigationController animated:YES];
}

#pragma mark -
#pragma mark Handle PN
-(void)showPushPopup : (AAVoucher*)voucher
{
    if(self.pushNotificationPopupView)
    {
        [self.pushNotificationPopupView removeFromSuperview];
    }
    
    self.pushNotificationPopupView = [AAPushNotificationPopupView createPushNotificationPopupViewWithBackgroundFrameRect:self.window.frame withVoucher:voucher];
    self.pushNotificationPopupView.delegate = self;
    [self.window addSubview:self.pushNotificationPopupView];
}
-(void)showVoucher{
    if ([[self.pushNotificationPopupView superview] isKindOfClass:[UIWindow class]]) {
        return;
    }else{
//        [self showDummyVoucher];
    }
    NSArray *vouchers = [[AAAppGlobals sharedInstance].voucherList getVouchers];;
    if (self.voucherIndex < [vouchers count]) {
        AAVoucher *voucher = [vouchers objectAtIndex:self.voucherIndex];
        [self showPushPopup:voucher];
        self.voucherIndex ++;
        if (self.voucherIndex > 2) {
            self.voucherIndex = 0;
        }
    }
}
-(void)loadEshopDetailWithProduct:(AAEShopProduct*)product{
    UINavigationController *rearNavigationController = (id)self.revealController.frontViewController;
    UIViewController *sideVC = rearNavigationController.topViewController;
    AAProductInformationViewController *eshopVC = [sideVC.storyboard instantiateViewControllerWithIdentifier:@"AAProductInformationViewController"];
    eshopVC.product = product;
    [rearNavigationController pushViewController:eshopVC animated:YES];
}

@end

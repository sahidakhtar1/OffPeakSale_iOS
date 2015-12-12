//
//  AASideMenuViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 4/23/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AASideMenuViewController.h"
#import "AASideMenuCell.h"
#import "SWRevealViewController.h"
#import "AAMainViewContainerController.h"
#import "AAFeedbackViewController.h"
#import "AAMenuWebViewController.h"
#import "AAVouchersViewController.h"
#import "AAProfileViewController.h"
#import "AASecondaryMenuViewController.h"
#import "AAAppGlobals.h"
#import "AAMenuItem.h"
#import "AALookBookViewController.h"
#import "AAOrderHistoryViewController.h"
#import "AACategoryDataModel.h"
#import "AAEShopViewController.h"
#import "contactVC.h"
@interface AASideMenuViewController ()

@end

@implementation AASideMenuViewController
@synthesize arrMenuItems;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrMenuItems = [[NSMutableArray alloc] init];
    
    [self becomeFirstResponder];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self populateMenuItems];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark TableView Delegate & Data Sources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrMenuItems count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AASideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideMenuCellInditifier"];
    AAMenuItem *menuIem = [self.arrMenuItems objectAtIndex:indexPath.row];
    cell.lblItemName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:MENU_ITEM_FONTSIZE];
    cell.lblItemName.text = menuIem.itemName;
    cell.imgArraow.hidden = !menuIem.showArrow;
    cell.imgIcon.image = [UIImage imageNamed:menuIem.iconName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AAMenuItem *menuItem = [self.arrMenuItems objectAtIndex:indexPath.row];
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontVC = (id)revealController.frontViewController;
    switch (menuItem.itemType) {
        case HOME:
            {
                if ( ![frontVC.topViewController isKindOfClass:[AAHomeViewController class]] )
                    {
                        AAHomeViewController *activity = [self.storyboard instantiateViewControllerWithIdentifier:@"AAHomeViewController"];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:activity];
                        navigationController.navigationBarHidden=YES;
                        [self.revealViewController pushFrontViewController:navigationController     animated:YES];
                    }else{
                        [revealController revealToggle:self];
                    }
            }
            break;
        case LOCATEUS:
            {
                if ( ![frontVC.topViewController isKindOfClass:[AARetailerStoreMapViewController class]] )
                {
                    AARetailerStoreMapViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AARetailerStoreMapViewController"];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                    navigationController.navigationBarHidden=YES;
                    [self.revealViewController pushFrontViewController:navigationController     animated:YES];
                }else{
                    [revealController revealToggle:self];
                }
            }
            break;
        case ESHOP:
                {
//                    AASecondaryMenuViewController *secondaryOption = [self.storyboard instantiateViewControllerWithIdentifier:@"AASecondaryMenuViewController"];
//                    secondaryOption.itemType = ESHOP;
//                    [self.navigationController pushViewController:secondaryOption animated:YES];
                    
                    AACategoryDataModel *item = [[AACategoryDataModel alloc] init];
                    item.categoryName = [AAAppGlobals sharedInstance].retailer.retailerName;
                    item.categoryId = @"279";
                    AAEShopViewController *eshopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAEShopViewController"];
                    eshopVC.category = item;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eshopVC];
                    navigationController.navigationBarHidden=YES;
                    [self.revealViewController pushFrontViewController:navigationController animated:YES];
                }
            break;
        case FEATUREDSTORE:
            {
                AASecondaryMenuViewController *secondaryOption = [self.storyboard instantiateViewControllerWithIdentifier:@"AASecondaryMenuViewController"];
                secondaryOption.itemType = FEATUREDSTORE;
                [self.navigationController pushViewController:secondaryOption animated:YES];
            }
            break;
        case LOYAITY:
            {
                if ( ![frontVC.topViewController isKindOfClass:[AALoyaltyViewController class]] )
                {
                    AALoyaltyViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AALoyaltyViewController"];
                    vcRetailerStore.title = menuItem.itemName;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                    navigationController.navigationBarHidden=YES;
                    [self.revealViewController pushFrontViewController:navigationController     animated:YES];
                }else{
                    [revealController revealToggle:self];
                }
            }
            break;
        case FEEDBACK:
        {
            if ( ![frontVC.topViewController isKindOfClass:[AAFeedbackViewController class]] )
            {
                AAFeedbackViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAFeedbackViewController"];
                vcRetailerStore.title = menuItem.itemName;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                navigationController.navigationBarHidden=YES;
                [self.revealViewController pushFrontViewController:navigationController     animated:YES];
            }else{
                [revealController revealToggle:self];
            }
        }
            break;
        case VOUCHER:
            if ( ![frontVC.topViewController isKindOfClass:[AAVouchersViewController class]] )
            {
                AAVouchersViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAVouchersViewController"];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                navigationController.navigationBarHidden=YES;
                [self.revealViewController pushFrontViewController:navigationController     animated:YES];
            }else{
                [revealController revealToggle:self];
            }
            break;
        case PROFILE:
            if ( ![frontVC.topViewController isKindOfClass:[AAProfileViewController class]] )
            {
                AAProfileViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                navigationController.navigationBarHidden=YES;
                vcRetailerStore.titleText =  menuItem.itemName;
                [self.revealViewController pushFrontViewController:navigationController     animated:YES];
            }else{
                [revealController revealToggle:self];
            }
            break;
        case ABOUTUS:
            {
                
                contactVC* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"contactVC"];
                vcRetailerStore.pageTitle= menuItem.itemName;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                navigationController.navigationBarHidden=YES;
                [self.revealViewController pushFrontViewController:navigationController     animated:YES];
            }
            break;
        case TERMSOFUSE:
            {
                    AAMenuWebViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAMenuWebViewController"];
                    [vcRetailerStore setWebPageUrl:[AAAppGlobals sharedInstance].retailer.termsUrl];
                    [vcRetailerStore setWebPageTitle:menuItem.itemName];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
                    navigationController.navigationBarHidden=YES;
                [self.revealViewController pushFrontViewController:navigationController     animated:YES];
            }
           
                break;
        case CURRENCY:
            {
                AASecondaryMenuViewController *secondaryOption = [self.storyboard instantiateViewControllerWithIdentifier:@"AASecondaryMenuViewController"];
                secondaryOption.itemType = CURRENCY;
                [self.navigationController pushViewController:secondaryOption animated:YES];
            }
            break;
        case CALENDAR:
        {
            AAMenuWebViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAMenuWebViewController"];
            [vcRetailerStore setWebPageUrl:[AAAppGlobals sharedInstance].retailer.calendarUrl];
            [vcRetailerStore setWebPageTitle:[NSString stringWithFormat:menuItem.itemName,[AAAppGlobals sharedInstance].retailer.retailerName ]];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
            navigationController.navigationBarHidden=YES;
            [self.revealViewController pushFrontViewController:navigationController     animated:YES];
        }
            break;
        case LOOKBOOK:
        {
            AALookBookViewController *lookBookVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AALookBookViewController"];
            lookBookVC.title = menuItem.itemName;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lookBookVC];
            navigationController.navigationBarHidden=YES;
            [self.revealViewController pushFrontViewController:navigationController     animated:YES];
        }
            break;
        case MYORDER:
        {
            AAOrderHistoryViewController *orderHistoryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAOrderHistoryViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:orderHistoryVC];
            navigationController.navigationBarHidden=YES;
            orderHistoryVC.pageTitle = menuItem.itemName;
            [self.revealViewController pushFrontViewController:navigationController animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)populateMenuItems{
    
    [arrMenuItems removeAllObjects];
    NSArray *menuList = [AAAppGlobals sharedInstance].retailer.menuList;
    for (NSDictionary *menu in menuList) {
        NSString *itemOrgName = [menu valueForKey:@"origName"];
        NSString *itemDisplayName = [menu valueForKey:@"displayName"];
        if ([itemOrgName compare:@"eshop" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *eshop = [[AAMenuItem alloc] init];
            eshop.itemName = itemDisplayName;
            eshop.itemType = ESHOP;
            eshop.showArrow = NO;
            eshop.iconName = @"home-1";
            [arrMenuItems addObject:eshop];

        }
        if ([itemOrgName compare:@"voucher" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *voucher = [[AAMenuItem alloc] init];
            voucher.itemName = itemDisplayName;
            voucher.itemType = VOUCHER;
            voucher.showArrow = NO;
            voucher.iconName = @"voucher-1";
            [arrMenuItems addObject:voucher];
        }
        if ([itemOrgName compare:@"myorders" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *myOrder = [[AAMenuItem alloc] init];
            myOrder.itemName = itemDisplayName;
            myOrder.itemType = MYORDER;
            myOrder.showArrow = YES;
            myOrder.iconName = @"icon_cart_black.png";
            [arrMenuItems addObject:myOrder];
        }
        if ([itemOrgName compare:@"myprofile" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *profile = [[AAMenuItem alloc] init];
            profile.itemName = itemDisplayName;
            profile.itemType = PROFILE;
            profile.showArrow = NO;
            profile.iconName = @"my_profile";
            [arrMenuItems addObject:profile];
        }
        if ([itemOrgName compare:@"terms" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *termsOfUse = [[AAMenuItem alloc] init];
            termsOfUse.itemName = itemDisplayName;
            termsOfUse.itemType = TERMSOFUSE;
            termsOfUse.showArrow = NO;
            termsOfUse.iconName = @"termsofuse";
            [arrMenuItems addObject:termsOfUse];
            
        }
        if ([itemOrgName compare:@"contact" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *aboutus = [[AAMenuItem alloc] init];
            aboutus.itemName = itemDisplayName;
            aboutus.itemType = ABOUTUS;
            aboutus.showArrow = NO;
            aboutus.iconName = @"about_us";
            [arrMenuItems addObject:aboutus];

        }
    }
    
//    AAMenuItem *eshop = [[AAMenuItem alloc] init];
//    eshop.itemName = @"Resturants Nearby";
//    eshop.itemType = ESHOP;
//    eshop.showArrow = NO;
//    eshop.iconName = @"eshop-1";
//    [arrMenuItems addObject:eshop];
    
//    AAMenuItem *voucher = [[AAMenuItem alloc] init];
//    voucher.itemName = @"Notification";
//    voucher.itemType = VOUCHER;
//    voucher.showArrow = NO;
//    voucher.iconName = @"voucher-1";
//    [arrMenuItems addObject:voucher];
    
    
//    AAMenuItem *myOrder = [[AAMenuItem alloc] init];
//    myOrder.itemName = @"Order History";
//    myOrder.itemType = MYORDER;
//    myOrder.showArrow = NO;
//    myOrder.iconName = @"icon_cart_black.png";
//    [arrMenuItems addObject:myOrder];
    
    
//    AAMenuItem *profile = [[AAMenuItem alloc] init];
//    profile.itemName = @"Profile";
//    profile.itemType = PROFILE;
//    profile.showArrow = YES;
//    profile.iconName = @"my_profile";
//    [arrMenuItems addObject:profile];
    
    
//    AAMenuItem *termsOfUse = [[AAMenuItem alloc] init];
//    termsOfUse.itemName = @"Terms & Consditions";
//    termsOfUse.itemType = TERMSOFUSE;
//    termsOfUse.showArrow = NO;
//    termsOfUse.iconName = @"termsofuse";
//    [arrMenuItems addObject:termsOfUse];
    
//    AAMenuItem *aboutus = [[AAMenuItem alloc] init];
//    aboutus.itemName = @"Online Help";
//    aboutus.itemType = ABOUTUS;
//    aboutus.showArrow = NO;
//    aboutus.iconName = @"about_us";
//    [arrMenuItems addObject:aboutus];
    
    
    
//    AAMenuItem *currency = [[AAMenuItem alloc] init];
//    currency.itemName = @"Currency";
//    currency.itemType = CURRENCY;
//    currency.showArrow = YES;
//    currency.iconName = @"ic_currency";
//    [arrMenuItems addObject:currency];

    [self.tbMenu reloadData];
    
    
    
}
//#pragma mark -
//#pragma mark Hamdle Shake Gesture
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if ( event.subtype == UIEventSubtypeMotionShake )
//    {
//        // Put in code here to handle shake
//    }
//    
//    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
//        [super motionEnded:motion withEvent:event];
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
@end

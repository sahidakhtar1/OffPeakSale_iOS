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
                    AASecondaryMenuViewController *secondaryOption = [self.storyboard instantiateViewControllerWithIdentifier:@"AASecondaryMenuViewController"];
                    secondaryOption.itemType = ESHOP;
                    [self.navigationController pushViewController:secondaryOption animated:YES];
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
                AASecondaryMenuViewController *secondaryOption = [self.storyboard instantiateViewControllerWithIdentifier:@"AASecondaryMenuViewController"];
                secondaryOption.itemType = PROFILE;
                [self.navigationController pushViewController:secondaryOption animated:YES];
            }else{
                [revealController revealToggle:self];
            }
            break;
        case ABOUTUS:
            {
                AASecondaryMenuViewController *secondaryOption = [self.storyboard instantiateViewControllerWithIdentifier:@"AASecondaryMenuViewController"];
                secondaryOption.itemType = ABOUTUS;
                [self.navigationController pushViewController:secondaryOption animated:YES];
            }
            break;
        case TERMSOFUSE:
            {
                    AAMenuWebViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAMenuWebViewController"];
                    [vcRetailerStore setWebPageUrl:[AAAppGlobals sharedInstance].retailer.termsUrl];
                    [vcRetailerStore setWebPageTitle:@"Terms of Use"];
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
        if ([itemOrgName compare:@"index" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *home = [[AAMenuItem alloc] init];
            home.itemName = itemDisplayName;
            home.itemType = HOME;
            home.showArrow = NO;
            home.iconName = @"home-1";
            [arrMenuItems addObject:home];
        }
        if ([itemOrgName compare:@"eshop" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *eshop = [[AAMenuItem alloc] init];
            eshop.itemName = itemDisplayName;
            eshop.itemType = ESHOP;
            eshop.showArrow = YES;
            eshop.iconName = @"eshop-1";
            [arrMenuItems addObject:eshop];
            
//            if ([[AAAppGlobals sharedInstance].retailer.featuredStores count]>0) {
//                AAMenuItem *featuredStore = [[AAMenuItem alloc] init];
//                featuredStore.itemName = @"Featured Store";
//                featuredStore.itemType = FEATUREDSTORE;
//                featuredStore.showArrow = YES;
//                featuredStore.iconName = @"featured_store";
//                [arrMenuItems addObject:featuredStore];
//            }

        }
        if ([itemOrgName compare:@"loyalty" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *layalty = [[AAMenuItem alloc] init];
            layalty.itemName = itemDisplayName;
            layalty.itemType = LOYAITY;
            layalty.showArrow = NO;
            layalty.iconName = @"loyalty-1";
            [arrMenuItems addObject:layalty];
        }
        if ([itemOrgName compare:@"feedback" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *feedback = [[AAMenuItem alloc] init];
            feedback.itemName = itemDisplayName;
            feedback.itemType = FEEDBACK;
            feedback.showArrow = NO;
            feedback.iconName = @"feedback-1";
            [arrMenuItems addObject:feedback];
        }
        if ([itemOrgName compare:@"lookbook" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *lookbook = [[AAMenuItem alloc] init];
            lookbook.itemName = itemDisplayName;
            lookbook.itemType = LOOKBOOK;
            lookbook.showArrow = NO;
            lookbook.iconName = @"lookbook";
            [arrMenuItems addObject:lookbook];
        }
        if ([itemOrgName compare:@"contact" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *locateus = [[AAMenuItem alloc] init];
            locateus.itemName = itemDisplayName;
            locateus.itemType = LOCATEUS;
            locateus.showArrow = NO;
            locateus.iconName = @"locate_us";
            [arrMenuItems addObject:locateus];
            
        }
        if ([itemOrgName compare:@"calendar" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            AAMenuItem *calendar = [[AAMenuItem alloc] init];
            calendar.itemName = itemDisplayName;
            calendar.itemType = CALENDAR;
            calendar.showArrow = NO;
            calendar.iconName = @"ic_calendar";
            [arrMenuItems addObject:calendar];
        }
    }
    
    AAMenuItem *voucher = [[AAMenuItem alloc] init];
    voucher.itemName = @"Voucher";
    voucher.itemType = VOUCHER;
    voucher.showArrow = NO;
    voucher.iconName = @"voucher-1";
    [arrMenuItems addObject:voucher];
    
    
    AAMenuItem *myOrder = [[AAMenuItem alloc] init];
    myOrder.itemName = @"My Orders";
    myOrder.itemType = MYORDER;
    myOrder.showArrow = NO;
    myOrder.iconName = @"icon_cart_black.png";
    [arrMenuItems addObject:myOrder];
    
    
    AAMenuItem *profile = [[AAMenuItem alloc] init];
    profile.itemName = @"Profile";
    profile.itemType = PROFILE;
    profile.showArrow = YES;
    profile.iconName = @"my_profile";
    [arrMenuItems addObject:profile];
    
    AAMenuItem *aboutus = [[AAMenuItem alloc] init];
    aboutus.itemName = [NSString stringWithFormat:@"About Us",[AAAppGlobals sharedInstance].retailer.retailerName ];
    aboutus.itemType = ABOUTUS;
    aboutus.showArrow = YES;
    aboutus.iconName = @"about_us";
    [arrMenuItems addObject:aboutus];
    
    AAMenuItem *termsOfUse = [[AAMenuItem alloc] init];
    termsOfUse.itemName = @"Terms of Use";
    termsOfUse.itemType = TERMSOFUSE;
    termsOfUse.showArrow = NO;
    termsOfUse.iconName = @"termsofuse";
//    [arrMenuItems addObject:termsOfUse];
    
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

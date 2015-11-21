//
//  AASecondaryMenuViewController.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/7/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AASecondaryMenuViewController.h"
#import "AASecondaryMenuCell.h"
#import "AAFeaturedStoreObject.h"
#import "AAMenuWebViewController.h"
#import "SWRevealViewController.h"
#import "AACategoryHelper.h"
#import "AACategoryDataModel.h"
#import "AAEShopViewController.h"
@interface AASecondaryMenuViewController ()
@property  (nonatomic, strong) NSArray *arrCurrencies;
@end

@implementation AASecondaryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrCurrencies = [[AAAppGlobals sharedInstance].retailer.allowedCurrencies componentsSeparatedByString:@","];
    if (self.itemType == ESHOP) {
        [AACategoryHelper refreshEshopCategoryWithCompletionBlock:^{
            [self.tbSecondaryMenu reloadData];
        }];
    }
    // Do any additional setup after loading the view.
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    switch (self.itemType) {
        case FEATUREDSTORE:
            rowCount = [[AAAppGlobals sharedInstance].retailer.featuredStores count]+1;
            break;
        case ESHOP:
            rowCount = [[AAAppGlobals sharedInstance].arrCategory count] + 1;
            break;
        case CURRENCY:
            
            break;
        case ABOUTUS:
            rowCount = 3;
            break;
        case PROFILE:{
            if (self.isCurrencyExpanded) {
                rowCount = [self.arrCurrencies count]+3;
            }else{
               rowCount = 3;
            }
        }
            break;
        default:
            rowCount = 1;
            break;
    }
    return rowCount;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AASecondaryMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AASecondaryMenuCell"];
    if (indexPath.row == 0) {
        cell.imgIcon.hidden = false;
        cell.lblItemName.text = @"Back";
        cell.imgRightIcon.hidden = true;
    }else if(self.itemType == FEATUREDSTORE){
        AAFeaturedStoreObject *menuIem = [[AAAppGlobals sharedInstance].retailer.featuredStores objectAtIndex:indexPath.row-1];
        cell.lblItemName.text = menuIem.storeName;
        cell.imgIcon.hidden = true;
        cell.imgRightIcon.hidden = true;
    }
    else if(self.itemType == ESHOP){
        AACategoryDataModel *menuIem = [[AAAppGlobals sharedInstance].arrCategory objectAtIndex:indexPath.row-1];
        cell.lblItemName.text = menuIem.categoryName;
        cell.imgIcon.hidden = true;
        cell.imgRightIcon.hidden = true;
    }
    else if(self.itemType == CURRENCY){
        cell.lblItemName.text = [self.arrCurrencies objectAtIndex:indexPath.row-1];
        cell.imgIcon.hidden = true;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECTED_CURRENCY] isEqualToString:cell.lblItemName.text]) {
            cell.imgRightIcon.hidden = false;
        }else{
            cell.imgRightIcon.hidden = true;
        }
    }else if (self.itemType == ABOUTUS){
        NSString *itemName;
        cell.imgIcon.hidden = false;
        if (indexPath.row == 1) {
            itemName = [NSString stringWithFormat:@"About Us",[AAAppGlobals sharedInstance].retailer.retailerName ];
            cell.imgIcon.image = [UIImage imageNamed:@"about_us"];
        }else if (indexPath.row == 2){
            itemName = @"Terms of Use";
            cell.imgIcon.image = [UIImage imageNamed:@"termsofuse"];
        }
        cell.lblItemName.text = itemName;
        
        cell.imgRightIcon.hidden = true;
    }else if(self.itemType == PROFILE){
        
            NSString *itemName;
            cell.imgIcon.hidden = false;
            if (indexPath.row == 1) {
                itemName = @"Profile";
                cell.imgIcon.image = [UIImage imageNamed:@"my_profile"];
                cell.lblItemName.text = itemName;
                
                cell.imgRightIcon.hidden = true;
            }else if (indexPath.row == 2){
                itemName = @"Currency";
                cell.imgIcon.image = [UIImage imageNamed:@"ic_currency"];
                cell.lblItemName.text = itemName;
                
                cell.imgRightIcon.hidden = true;
            }else{
                NSString *currencySymbol =[self.arrCurrencies objectAtIndex:indexPath.row-3];
                cell.lblItemName.text = [NSString stringWithFormat:@"     %@",currencySymbol];
                cell.imgIcon.hidden = true;
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECTED_CURRENCY] isEqualToString:currencySymbol]) {
                    cell.imgRightIcon.hidden = false;
                }else{
                    cell.imgRightIcon.hidden = true;
                }
            }
        
    }
    cell.lblItemName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:MENU_ITEM_FONTSIZE];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.itemType == FEATUREDSTORE){
        AAFeaturedStoreObject *item = [[AAAppGlobals sharedInstance].retailer.featuredStores objectAtIndex:indexPath.row -1];
        AAMenuWebViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAMenuWebViewController"];
        [vcRetailerStore setWebPageUrl:item.storeUrl];
        [vcRetailerStore setPageTitle:item.storeName];
        vcRetailerStore.webPageTitle = item.storeName;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
        navigationController.navigationBarHidden=YES;
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
        
    }else if (self.itemType ==  ESHOP){
        AACategoryDataModel *item = [[AAAppGlobals sharedInstance].arrCategory objectAtIndex:indexPath.row -1];
        AAEShopViewController *eshopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAEShopViewController"];
        eshopVC.category = item;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:eshopVC];
        navigationController.navigationBarHidden=YES;
        [self.revealViewController pushFrontViewController:navigationController animated:YES];
        
    }else if (self.itemType == PROFILE ){
        if (indexPath.row == 1) {
            AAProfileViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
            navigationController.navigationBarHidden=YES;
            [self.revealViewController pushFrontViewController:navigationController     animated:YES];

            
        }else if (indexPath.row == 2){
            self.isCurrencyExpanded= !self.isCurrencyExpanded;
            [tableView reloadData];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:[self.arrCurrencies objectAtIndex:indexPath.row-3] forKey:KEY_SELECTED_CURRENCY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [tableView reloadData];
        }
        
    }else if (self.itemType == ABOUTUS){
        AAMenuWebViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AAMenuWebViewController"];
        if (indexPath.row == 1) {
            [vcRetailerStore setWebPageUrl:[AAAppGlobals sharedInstance].retailer.aboutUrl];
            [vcRetailerStore setWebPageTitle:[NSString stringWithFormat:@"About Us",[AAAppGlobals sharedInstance].retailer.retailerName ]];
        }else if (indexPath.row == 2){
            [vcRetailerStore setWebPageUrl:[AAAppGlobals sharedInstance].retailer.termsUrl];
            [vcRetailerStore setWebPageTitle:@"Terms of Use"];
        }
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vcRetailerStore];
        navigationController.navigationBarHidden=YES;
        [self.revealViewController pushFrontViewController:navigationController     animated:YES];

    }
}
@end

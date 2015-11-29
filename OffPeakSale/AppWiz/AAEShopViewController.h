//
//  AAEShopViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AAEShopHelper.h"
#import "AAEShopProductCell.h"
#import "AAEShopCategoriesScrollView.h"
#import "AAProductInformationViewController.h"
#import "AALoginDailogView.h"
#import "AACategoryDataModel.h"
#import "AAEShopFilterView.h"
#import "AAHeaderView.h"
@interface AAEShopViewController : AAChildBaseViewController <UITableViewDataSource,UITableViewDelegate,AAEShopCategoryScrollViewDelegate,AALoginDailogDelegate, HeaderViewDelegate, EshopFilterDelegate>
{
    NSMutableArray* productList_;
    AAHeaderView *headerView1;
    int selectedCategoryIndex;
}
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AACategoryDataModel *category;
@property (weak, nonatomic) IBOutlet UITableView *tableViewEShopProductList;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (weak, nonatomic) IBOutlet AAEShopCategoriesScrollView *scrollViewCategoryList;
@property (strong,nonatomic) NSString* selectedCategoryName;
@property (strong,nonatomic) AAEShopProduct* selectedProduct;
@property (weak, nonatomic) IBOutlet UIView *vwFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblFilter;
- (IBAction)btnFilterTapped:(id)sender;
@property (strong, nonatomic)  AALoginDailogView *loginDailog;
@property (strong, nonatomic) AAEShopFilterView *filetrView;
@property (nonatomic) NSInteger selectedFilterIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblNoSearchFoundText;
@property (nonatomic, strong) NSString* searchText;
@property (nonatomic, strong) NSString* filterKey;
@property (weak, nonatomic) IBOutlet UIButton *nearByBtn;
@property (strong, nonatomic) IBOutlet UIView *locationAlertView;

@property (weak, nonatomic) IBOutlet UIScrollView *ProductScroolView;

@property (weak, nonatomic) IBOutlet AAEShopCategoriesScrollView *productTabs;

@end

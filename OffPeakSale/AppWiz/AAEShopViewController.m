//
//  AAEShopViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopViewController.h"
#import "AAHeaderView.h"
#import "UIViewController+AAShakeGestuew.h"
#import "AAShoppingCartViewController.h"
@interface AAEShopViewController ()

@end
#import "AALoginDailogView.h"
@implementation AAEShopViewController
@synthesize loginDailog;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.heading = @"E-SHOP";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filterKey = @"rate";
    self.selectedFilterIndex = 1;
    [AAAppGlobals sharedInstance].products  = nil;
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableViewEShopProductList registerClass:[AAEShopProductCell class] forCellReuseIdentifier:@"EShopProductCell"];
    self.tableViewEShopProductList.delegate = self;
    self.tableViewEShopProductList.dataSource = self;
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableViewEShopProductList.tableHeaderView = headerView;
    productList_ = [[NSMutableArray alloc] init];
    self.selectedCategoryName = nil;
    self.scrollViewCategoryList.eShopCategoryDelegate = self;
    self.scrollViewCategoryList.fontCategoryName = [AAFont eShopCategoryTextFont];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
    headerView1 = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView1];
    [headerView1 setTitle:self.category.categoryName];
    headerView1.showCart = true;
    headerView1.showBack = false;
    headerView1.delegate = self;
    [headerView1 setMenuIcons];
    if (self.searchText != nil) {
        self.vwFilter.hidden = true;
        CGRect frame = self.tableViewEShopProductList.frame;
        frame.origin.y = frame.origin.y - self.vwFilter.frame.size.height;
        frame.size.height = frame.size.height + self.vwFilter.frame.size.height;
        self.tableViewEShopProductList.frame = frame;
        [headerView1 setTitle:self.searchText];
    }
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //[self refreshView];
    [self cat_viewDidAppear:YES];
    [self.tableViewEShopProductList reloadData];
    [self populateView];
    [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
    headerView1.lblCartTotal.text = [NSString stringWithFormat:@"%d",[AAAppGlobals sharedInstance].cartTotalItemCount];
    
    
}
-(void)reloadTable{
    [self.tableViewEShopProductList reloadData];
}
-(void)refreshView
{
    NSInteger enablePassword = [[AAAppGlobals sharedInstance].retailer.enablePassword integerValue];
    if (enablePassword==1 && [AAAppGlobals sharedInstance].isPasswordChanged) {
        //call show alert and call
        loginDailog = [[AALoginDailogView alloc] init];
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview:loginDailog];
        [loginDailog refreshView];
        loginDailog.delegate = self;
//        [self populateView];
    }else{
        [self populateView];
    }
    
}
-(void)populateView{
    
//    [self populateCategories];
    [self.tableViewEShopProductList reloadData];
    [AAEShopHelper refreshEshopInformationForCategory:self.category.categoryId
                                           searchText:self.searchText
                                               sortBy:self.filterKey
                                  WithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self populateCategories];
            [self.tableViewEShopProductList reloadData];
            if (([AAAppGlobals sharedInstance].products == nil || [[AAAppGlobals sharedInstance].products count] == 0 )&& self.searchText != nil) {
                self.lblNoSearchFoundText.hidden = false;
                self.tableViewEShopProductList.hidden = true;
            }else{
                self.lblNoSearchFoundText.hidden = true;
                self.tableViewEShopProductList.hidden = false;

            }
        });
        
        
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Table View Management
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AAAppGlobals sharedInstance].products count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAEShopProductCell* productCell = [self.tableViewEShopProductList dequeueReusableCellWithIdentifier:@"EShopProductCell" forIndexPath:indexPath];
    productCell.selectionStyle = UITableViewCellSelectionStyleNone;
    productCell.eshopProduct = [[AAAppGlobals sharedInstance].products objectAtIndex:indexPath.row];
    return productCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedProduct = [[AAAppGlobals sharedInstance].products objectAtIndex:indexPath.row];
    
    AAProductInformationViewController*  vcProductInformation = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProductInformationViewController"];
    vcProductInformation.product = self.selectedProduct;
    [self.navigationController pushViewController:vcProductInformation animated:YES];
    //[self performSegueWithIdentifier:@"showProductInformation" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAEShopProduct *product= [[AAAppGlobals sharedInstance].products objectAtIndex:indexPath.row];
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    CGSize shortDescriptionLabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHORTDESC_FONTSIZE] andText:product.productShortDescription andMaxWidth:self.view.frame.size.width- 30 ];
    return [[AAAppGlobals sharedInstance] getImageHeight] +shortDescriptionLabelSize.height+  50;
}

#pragma mark - Helpers
-(void)populateCategories
{
    NSArray* arrCategoryNames = [[AAAppGlobals sharedInstance].categoryList getCategoryNames];
    if([arrCategoryNames count] >0)
    {
    if(self.selectedCategoryName==nil || ![[AAAppGlobals sharedInstance].categoryList doesCategoryNameExist:self.selectedCategoryName])
    {
        
       
        NSString* selectedCategoryName =[arrCategoryNames objectAtIndex:0];
        self.scrollViewCategoryList.selectedCategory = selectedCategoryName;
        self.selectedCategoryName = selectedCategoryName;
        productList_ = [[AAAppGlobals sharedInstance].categoryList getProductListWithCategoryName:selectedCategoryName];
    }
    else
    {
        
        productList_ = [[AAAppGlobals sharedInstance].categoryList getProductListWithCategoryName:self.selectedCategoryName];
    }
   
   
    self.scrollViewCategoryList.categories = arrCategoryNames.mutableCopy;
    
    
    [self.scrollViewCategoryList refreshScrollView];
    }
}

#pragma mark - Scroll view  categories callbacks
-(void)onCategeorySelected:(NSString *)categoryName
{
    AAEshopCategory* selectedCategory = [[AAAppGlobals sharedInstance].categoryList getCategoryWithCategoryName:categoryName];
     productList_ = [selectedCategory getProductList];
    self.selectedCategoryName = selectedCategory.categoryName;
    [self.tableViewEShopProductList reloadData];
}

#pragma mark - Transition View controller management
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
       
    AAProductInformationViewController*  vcProductInformation = segue.destinationViewController;
    
    vcProductInformation.product = self.selectedProduct;
}

#pragma mark -
#pragma mark Login dailog Delagate
-(void)logionSucessful{
    [AAAppGlobals sharedInstance].isPasswordChanged = NO;
    [self populateView];
}
-(void)showregistrationPage{
//    AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
//    
//    profileViewController.profileDelegate = self;
//    profileViewController.showBuyButton = NO;
//    [self.navigationController pushViewController:profileViewController animated:YES];
//    profileViewController.heading = @"PROFILE";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showProfilePage" object:nil];
}
- (IBAction)btnFilterTapped:(id)sender {
    if (self.filetrView == nil) {
        self.filetrView = [[AAEShopFilterView alloc] initWithFrame:self.view.frame];
        self.filetrView.delegate = self;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.filetrView];
}
-(void)filterAppliedWith:(NSInteger)filterIndex{
    if (self.selectedFilterIndex != filterIndex) {
        self.selectedFilterIndex = filterIndex;
        NSArray *filterKeyArray = [NSArray arrayWithObjects:@"none",@"rate",@"new",@"low",@"high", nil];
        self.filterKey = [filterKeyArray objectAtIndex:self.selectedFilterIndex];
        [AAEShopHelper refreshEshopInformationForCategory:self.category.categoryId
                                               searchText:nil
                                                   sortBy:self.filterKey
                                      WithCompletionBlock:^{
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //            [self populateCategories];
                                              [self.tableViewEShopProductList reloadData];
                                          });
                                          
                                          
                                          
                                      }];
    }
    
}

- (void)cartButtonTapped {
    if ([AAAppGlobals sharedInstance].cartTotalItemCount == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Your shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }else{
        AAShoppingCartViewController *shoppingCartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAShoppingCartView"];
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    }
}
-(void)hideKeyBoard{
    [self.tableViewEShopProductList reloadData];
}

@end

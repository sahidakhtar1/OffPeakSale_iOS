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

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface AAEShopViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;

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
    selectedCategoryIndex = 1;
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
    headerView1.backgroundColor = [UIColor redColor];
    headerView1.showCart = false;
    headerView1.showBack = false;
    headerView1.delegate = self;
    [headerView1 setMenuIcons];
    if (self.searchText != nil) {
//        self.vwFilter.hidden = true;
//        CGRect frame = self.tableViewEShopProductList.frame;
//        frame.origin.y = frame.origin.y - self.vwFilter.frame.size.height;
//        frame.size.height = frame.size.height + self.vwFilter.frame.size.height;
//        self.tableViewEShopProductList.frame = frame;
        [headerView1 setTitle:self.searchText];
    }
    
    self.productTabs.eShopCategoryDelegate = self;
    self.productTabs.backgroundColor=[UIColor whiteColor];
    self.productTabs.fontCategoryName = [AAFont eShopCategoryTextFont];
    [self populateCategories];
    if ([[AAAppGlobals sharedInstance].retailer.enableDiscovery isEqualToString:@"1"]) {
        self.nearByBtn.hidden = false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NOTIFICATION_LOCATION_UPDATED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDenied) name:NOTIFICATION_LOCATION_DENIED object:nil];
        [AAAppGlobals sharedInstance].currentLat = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude;
        [AAAppGlobals sharedInstance].currentLong = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude;
//        [AAAppGlobals sharedInstance].targetLat = [AAAppGlobals sharedInstance].currentLat;
//        [AAAppGlobals sharedInstance].targetLong = [AAAppGlobals sharedInstance].currentLong;
        [self.imgLocation setHidden:false];
        if ([AAAppGlobals sharedInstance].showLocationOffalert) {
            [self showAlert];
            [AAAppGlobals sharedInstance].showLocationOffalert = false;
        }
    }else{
        self.nearByBtn.hidden = true;
        CGRect categoryFrame =self.vwFilter.frame;
        categoryFrame.origin.y = self.nearByBtn.frame.origin.y;
        self.vwFilter.frame = categoryFrame;
        
        CGRect tableFrame = self.tableViewEShopProductList.frame;
        tableFrame.origin.y -= self.nearByBtn.frame.size.height;
        tableFrame.size.height += self.nearByBtn.frame.size.height;
        self.tableViewEShopProductList.frame = tableFrame;
        [self.imgLocation setHidden:YES];
        [self populateView];
    }
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        [self.imgLocation setImage:[UIImage imageNamed:@"ic_location_filter_white"]];
    }else{
        [self.imgLocation setImage:[UIImage imageNamed:@"ic_location_filter_black"]];
    }
    self.nearByBtn.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CATEGORY_FONTSIZE];
    [self.nearByBtn setBackgroundColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
}
-(void)locationViewPopUp
{
    self.locationAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.locationAlertView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.locationAlertView];
    
    UILabel *bgLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgLbl.backgroundColor = [UIColor blackColor];
    bgLbl.alpha = 0.3;
    [self.locationAlertView addSubview:bgLbl];

}
-(void)populateCategories
{
     AAEshopCategory *selectedCategory ;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *categoryNames = [[AAAppGlobals sharedInstance].categoryList getCategoryNames];
    for (int i = 0;i<[categoryNames count];i++) {
        AAEshopCategory *category = [[AAAppGlobals sharedInstance].categoryList getCategoryWithCategoryName:[categoryNames objectAtIndex:i]];
        [arr addObject:category.categoryName];
        if (i == selectedCategoryIndex) {
            selectedCategory = category;
        }
    }
    if ([arr count ]== 0) {
        return;
    }
    
   
    
    
    self.productTabs.selectedCategory = selectedCategory.categoryName;
    self.productTabs.categories = arr.mutableCopy;
    [self.productTabs refreshScrollView];
    [self onCategeorySelected:self.productTabs.selectedCategory];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //[self refreshView];
    [self cat_viewDidAppear:YES];
    [self.tableViewEShopProductList reloadData];
    if ([AAAppGlobals sharedInstance].targetLat == 0 && [AAAppGlobals sharedInstance].targetLong == 0) {
        
    }else{
       [self populateView];
    }
    
//    [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
//    headerView1.lblCartTotal.text = [NSString stringWithFormat:@"%d",[AAAppGlobals sharedInstance].cartTotalItemCount];
    
    
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
                                               sortBy:@""
                                               forLat:[NSString stringWithFormat:@"%f",[AAAppGlobals sharedInstance].targetLat]
                                              andLong:[NSString stringWithFormat:@"%f",[AAAppGlobals sharedInstance].targetLong]                                  WithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self populateCategories];
            
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
    return [productList_ count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAEShopProductCell* productCell = [self.tableViewEShopProductList dequeueReusableCellWithIdentifier:@"EShopProductCell" forIndexPath:indexPath];
    productCell.selectionStyle = UITableViewCellSelectionStyleNone;
    productCell.eshopProduct = [productList_ objectAtIndex:indexPath.row];
    return productCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedProduct = [productList_ objectAtIndex:indexPath.row];
    
    AAProductInformationViewController*  vcProductInformation = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProductInformationViewController"];
    vcProductInformation.product = self.selectedProduct;
    [self.navigationController pushViewController:vcProductInformation animated:YES];
    //[self performSegueWithIdentifier:@"showProductInformation" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAEShopProduct *product= [productList_ objectAtIndex:indexPath.row];
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    CGSize shortDescriptionLabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHORTDESC_FONTSIZE] andText:product.productShortDescription andMaxWidth:self.view.frame.size.width- 30 ];
    return [[AAAppGlobals sharedInstance] getImageHeight] +shortDescriptionLabelSize.height+  50;
}

#pragma mark - Helpers
//-(void)populateCategories
//{
//    NSArray* arrCategoryNames = [[AAAppGlobals sharedInstance].categoryList getCategoryNames];
//    if([arrCategoryNames count] >0)
//    {
//    if(self.selectedCategoryName==nil || ![[AAAppGlobals sharedInstance].categoryList doesCategoryNameExist:self.selectedCategoryName])
//    {
//        
//       
//        NSString* selectedCategoryName =[arrCategoryNames objectAtIndex:0];
//        self.scrollViewCategoryList.selectedCategory = selectedCategoryName;
//        self.selectedCategoryName = selectedCategoryName;
//        productList_ = [[AAAppGlobals sharedInstance].categoryList getProductListWithCategoryName:selectedCategoryName];
//    }
//    else
//    {
//        
//        productList_ = [[AAAppGlobals sharedInstance].categoryList getProductListWithCategoryName:self.selectedCategoryName];
//    }
//   
//   
//    self.scrollViewCategoryList.categories = arrCategoryNames.mutableCopy;
//    
//    
//    [self.scrollViewCategoryList refreshScrollView];
//    }
//}

#pragma mark - Scroll view  categories callbacks
-(void)onCategeorySelected:(NSString *)categoryName
{
    
    AAEshopCategory* selectedCategory = [[AAAppGlobals sharedInstance].categoryList getCategoryWithCategoryName:categoryName];
    productList_ = [selectedCategory getProductList];
    self.selectedCategoryName = selectedCategory.categoryName;
    [self.tableViewEShopProductList reloadData];
    if ([productList_ count] == 0) {
        self.lblNoSearchFoundText.hidden = false;
        self.tableViewEShopProductList.hidden = true;
    }else{
        self.lblNoSearchFoundText.hidden = true;
        self.tableViewEShopProductList.hidden = false;
        
    }
    [self.nearByBtn setTitle:[NSString stringWithFormat:@"Nearby %lu",(unsigned long)[productList_ count]] forState:UIControlStateNormal];
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
    self.searchText = nil;
    [headerView1 setTitle:[AAAppGlobals sharedInstance].retailer.retailerName];
    [self populateView];
    
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
-(void)locationUpdated:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AAAppGlobals sharedInstance].currentLat = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude;
        [AAAppGlobals sharedInstance].currentLong = [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude;
        [AAAppGlobals sharedInstance].targetLat = [AAAppGlobals sharedInstance].currentLat;
        [AAAppGlobals sharedInstance].targetLong = [AAAppGlobals sharedInstance].currentLong;
        [self populateView];
    });
}
-(void)locationDenied
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([AAAppGlobals sharedInstance].showLocationOffalert) {
            [self showAlert];
            [AAAppGlobals sharedInstance].showLocationOffalert = false;
        }
    });
}
-(void)showAlert{
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
    {
        UIAlertView* curr1=[[UIAlertView alloc] initWithTitle:@"This app does not have access to Location service" message:@"You can enable access in Settings->Privacy->Location->Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [curr1 show];
    }
    else
    {
        UIAlertView* curr2=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Enable location services" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enable", nil];
        curr2.tag=121;
        [curr2 show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 121 && buttonIndex == 1)
        {
            //code for opening settings app in iOS 8
            [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

@end

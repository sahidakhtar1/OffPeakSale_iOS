//
//  AAMainViewContainerController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAMainViewContainerController.h"
#import "AAAppGlobals.h"
#import "AAShoppingCartViewController.h"
#import "AACouponView.h"
#import "MGInstagram.h"
#import "DMActivityInstagram.h"
#include "AAWhatsAppActivity.h"
#include "AAWechatActivity.h"

#import "SWRevealViewController.h"
#import "AASideMenuViewController.h"
@interface AAMainViewContainerController ()

@end

@implementation AAMainViewContainerController
@synthesize selectedIndex = selectedIndex_;
@synthesize isInCart,selectedIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - UI View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    float tabWidth = [UIScreen mainScreen].bounds.size.width/5;
    self.selectedIndicator = [[UIView alloc] initWithFrame:CGRectMake(0,42, tabWidth, 2)];
    [self resizeTabsWithTabSize:tabWidth];
    self.selectedIndicator.backgroundColor = [[AAColor sharedInstance].retailerThemeBackgroundColor colorWithAlphaComponent:.8];
    [self.viewBottomBar addSubview:self.selectedIndicator];
    
    self.isMenuShown = NO;
    selectedIndex_ = 0;
    [[self.btnTabs objectAtIndex:selectedIndex_] setSelected:YES];
    [self populateViewControllers];
	// Do any additional setup after loading the view.
    [self displayInitialContentController];
    self.isNavigatedFromCart = FALSE;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showProfilePage)
                                                 name:@"showProfilePage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showProfilePageForPayment)
                                                 name:@"showProfilePageForPayment"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showEshop)
                                                 name:@"continueShopping"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCartAmount)
                                                 name:@"updateCart"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCartWithClick)
                                                 name:@"showCartWithClick"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCartWithOutClick)
                                                 name:@"showCartWithOutClick"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showEnterCode)
                                                 name:@"showEnterCode"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideEnterCode)
                                                 name:@"hideEnterCode"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideCart)
                                                 name:@"hideCart"
                                               object:nil];
    
    
    
   
}
-(void)resizeTabsWithTabSize:(float)tabWidth{
    float originX = 0;
    CGRect frame = self.vwHome.frame;
    frame.origin.x = originX;
    frame.size.width = tabWidth;
    self.vwHome.frame = frame;
    
    originX += tabWidth;
    frame = self.vwEshop.frame;
    frame.origin.x = originX;
    frame.size.width = tabWidth;
    self.vwEshop.frame = frame;
    
    originX += tabWidth;
    frame = self.vwLoyality.frame;
    frame.origin.x = originX;
    frame.size.width = tabWidth;
    self.vwLoyality.frame = frame;
    
    originX += tabWidth;
    frame = self.vwFeedback.frame;
    frame.origin.x = originX;
    frame.size.width = tabWidth;
    self.vwFeedback.frame = frame;
    
    originX += tabWidth;
    frame = self.vwVoucher.frame;
    frame.origin.x = originX;
    frame.size.width = tabWidth;
    self.vwVoucher.frame = frame;
    
}
-(void)hideCart{
    [self.vwCartView setHidden:YES];
}
-(void)setTitleFont{
    self.lblContainerTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE];
    self.lblCartAmount.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:CARTTOTAL_FONTSIZE];
    self.btnEnterCode.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:13];
    self.selectedIndicator.backgroundColor = [[AAColor sharedInstance].retailerThemeBackgroundColor colorWithAlphaComponent:.8];
}
-(void)showCartWithClick{
    isInCart = NO;
    if (![AAAppGlobals sharedInstance].enableShoppingCart) {
        [self.vwCartView setHidden:YES];
        [self.btnEnterCode setHidden:YES];
    }
    else{
        [self.vwCartView setHidden:NO];
        CGRect frame = self.btnShare.frame;
        frame.origin.x = 47;
        self.btnShare.frame = frame;
    }
    [self updateCartAmount];
}
-(void)showCartWithOutClick{
    isInCart = NO;
    if (![AAAppGlobals sharedInstance].enableShoppingCart) {
        [self.vwCartView setHidden:YES];
    }else{
        [self.vwCartView setHidden:NO];
//        CGRect frame = self.btnShare.frame;
//        frame.origin.x = 47;
//        self.btnShare.frame = frame;
    }
    [self.btnEnterCode setHidden:true];
    [self updateCartAmount];
}
-(void)showEnterCode{
    if ([AAAppGlobals sharedInstance].enableCreditCode){
        [self.btnEnterCode setHidden:false];
        [self.vwCartView setHidden:YES];
        CGRect frame = self.btnShare.frame;
        frame.origin.x = 47;
        self.btnShare.frame = frame;
    }else{
        [self.btnEnterCode setHidden:TRUE];
    }
    [self.vwCartView setHidden:true];
}
-(void)hideEnterCode{
    [self.btnEnterCode setHidden:TRUE];
}
-(void)showEshop{
    [self setSelectedIndex:1];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
    [self.lblContainerTitle setFont:[AAFont titleTextFont]];
    [self.btnBack setTitleColor:[AAColor sharedInstance].retailerThemeTextColor forState:UIControlStateNormal];
    [self.btnBack.titleLabel setFont:[AAFont titleTextFont]];
    
    /*AAVoucher* testVoucher = [[AAVoucher alloc]init];
    testVoucher.voucherFileType = @"Video";
    testVoucher.voucherFileUrl = @"http://223.25.237.175/appwizlive/uploads/retailer/1/pnimages/Promo_Video.mp4";
    [self showPushPopup:testVoucher];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCartAmount{
    [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
    self.lblCartAmount.text = [NSString stringWithFormat:@"(%d)",[AAAppGlobals sharedInstance].cartTotalItemCount];
}

#pragma mark - Helpers
- (void) displayInitialContentController
{
    AAChildBaseViewController* initController = [viewControllers_ objectAtIndex:0];
    
    [self addChildViewController:initController];                // 1
    initController.view.frame = CGRectMake(0, self.viewTopBar.frame.size.height, self.view.frame.size.width,self.viewBottomBar.frame.origin.y - self.viewTopBar.frame.size.height);
    [self.view addSubview:initController.view];
    [initController didMoveToParentViewController:self];          // 3
    self.selectedViewController = initController;
    [self updateViewController];
    
}
-(void)populateViewControllers
{
    viewControllers_ = [[NSMutableArray alloc] initWithCapacity:6];
    AAHomeNavigationViewController* nvcHome = [self.storyboard instantiateViewControllerWithIdentifier:@"AAHomeNavigationViewController"];
    nvcHome.childNavigationControllerDelegate = self;
    [nvcHome setRootViewControllerDelegate:self];
    [viewControllers_ addObject:nvcHome];
    
    AAEShopNavigationViewController* nvcEShop = [self.storyboard instantiateViewControllerWithIdentifier:@"AAEShopNavigationViewController"];
    nvcEShop.childNavigationControllerDelegate = self;
    [viewControllers_ addObject:nvcEShop];
    
    AALoyaltyViewController* vcLoyalty = [self.storyboard instantiateViewControllerWithIdentifier:@"AALoyaltyViewController"];
    [viewControllers_ addObject:vcLoyalty];
    
    AAFeedbackNavigationViewController* nvcFeedback = [self.storyboard instantiateViewControllerWithIdentifier:@"AAFeedbackNavigationViewController"];
    nvcFeedback.childNavigationControllerDelegate = self;
    [viewControllers_ addObject:nvcFeedback];
    
   /* AAProfileViewController* vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [viewControllers_ addObject:vcProfile];*/
    
      AAVouchersViewController* vcVouchers = [self.storyboard instantiateViewControllerWithIdentifier:@"AAVouchersViewController"];
    [viewControllers_ addObject:vcVouchers];
    
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
   
    if(selectedIndex_!=selectedIndex)
    {
        if(selectedIndex < [viewControllers_ count])
        {
         [self.btnBack setHidden:YES];
            [self.btnProfile setHidden:NO];
            if (selectedIndex != 1) {
                self.vwCartView.hidden = true;
            }
        [self cycleFromViewController:self.selectedViewController toViewController:[viewControllers_ objectAtIndex:selectedIndex]];
        }
    }
    else
    {
        [self.selectedViewController refreshView];
    }
    selectedIndex_ = selectedIndex;
    self.isNavigatedFromCart = FALSE;
    CGRect frame = self.selectedIndicator.frame;
    frame.origin.x = selectedIndex_ * frame.size.width;
    self.selectedIndicator.frame = frame;
    
}

-(void)updateViewController
{
    [self.lblContainerTitle setText:self.selectedViewController.heading];
}

-(void)showPushPopup : (AAVoucher*)voucher
{
    if(self.pushNotificationPopupView)
    {
        [self.pushNotificationPopupView removeFromSuperview];
    }
    
    self.pushNotificationPopupView = [AAPushNotificationPopupView createPushNotificationPopupViewWithBackgroundFrameRect:self.view.frame withVoucher:voucher];
    self.pushNotificationPopupView.delegate = self;
    [self.view addSubview:self.pushNotificationPopupView];
}

-(void)showMenuDropDown
{
    self.dropDownMenu = [[AAMenuDropDownScrollView alloc] initWithFrame:CGRectMake(0, self.viewTopBar.frame.size.height,100, 90)];
    [self.dropDownMenu setDropDownDelegate:self];
    [self.dropDownMenu refreshScrollView];
    [self.view addSubview:self.dropDownMenu];
}

-(void)hideDropDownMenu
{
    self.isMenuShown = NO;
    [self.dropDownMenu removeFromSuperview];
}

#pragma mark - UI Event Management
- (IBAction)btnTabBarButtonTapped:(id)sender {
    
    UIButton* tabBarButton = (UIButton*)sender;
    if(selectedIndex_ < [viewControllers_ count])
    {
    [[self.btnTabs objectAtIndex:self.selectedIndex] setSelected:NO];
    }
    [tabBarButton setSelected:YES];
    NSUInteger index = [self.btnTabs indexOfObject:tabBarButton];
    
    [self setSelectedIndex:index];
    
    
}

- (IBAction)btnBackTapped:(id)sender {
    [self.btnBack setHidden:YES];
    [self.btnProfile setHidden:NO];
    if (self.isNavigatedFromCart) {
        self.isInCart = false;
        [self btnCartTapped:nil];
    }else{
        UINavigationController* nvcSelected = (UINavigationController*)self.selectedViewController;
        [nvcSelected popViewControllerAnimated:YES];
    }
    
    
}
- (IBAction)btnShareTap:(id)sender {
   
    NSString* imageUrl = [self.selectedViewController.dictShareInformation objectForKey:@"share_product_img"];
    
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *shareImage = [imageCache imageFromDiskCacheForKey:imageUrl];
    
    AAShareActivityItemProvider* itemProviderShareString = [self.selectedViewController.dictShareInformation objectForKey:@"share_product_info"];
    NSString *shareString = itemProviderShareString.eshopProduct.productShortDescription;
    shareString = [NSString stringWithFormat:@"%@\nProduct Price : %@%@ \nDownload app here : %@", shareString,[AAAppGlobals sharedInstance].currency_symbol,itemProviderShareString.eshopProduct.currentProductPrice,ITUNES_URL];
    
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
    
    instagramActivity.presentFromButton = (UIBarButtonItem *)sender;
    AAWhatsAppActivity *wahtsAppActivity = [[AAWhatsAppActivity alloc] init];
    wahtsAppActivity.shareImage = shareImage;
    wahtsAppActivity.shareString = shareString;
    wahtsAppActivity.presentFromView = self.view;
    
    AAWechatActivity *weChatActivicty = [[AAWechatActivity alloc] init];
    weChatActivicty.shareImage = shareImage;
    weChatActivicty.shareString = shareString;
     NSArray *applicationActivities = @[instagramActivity,wahtsAppActivity,weChatActivicty];
    
   
    
    
    
//    if ([MGInstagram isAppInstalled])
//        [MGInstagram postImage:shareImage withCaption:shareString inView:self.view];
//    else{
//        NSArray *activityItems = [NSArray arrayWithObjects:itemProviderShareString, shareImage,  nil];
//        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//        [activityViewController setExcludedActivityTypes:[NSArray arrayWithObjects:UIActivityTypePostToFlickr,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeAirDrop, nil]];
//        //[activityViewController setValue:@"I think you should get this deal" forKey:@"subject"];
//        
//        [self presentViewController:activityViewController animated:YES completion:nil];
//    }
    

    
NSArray *activityItems = [NSArray arrayWithObjects:itemProviderShareString, shareImage,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
//    [activityViewController setExcludedActivityTypes:[NSArray arrayWithObjects:UIActivityTypePostToFlickr,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeAirDrop, nil]];
    //[activityViewController setValue:@"I think you should get this deal" forKey:@"subject"];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    

}
-(void)showCartView{
    
}

- (IBAction)btnProfileTap:(id)sender {
//    if(self.isMenuShown)
//    {
//        self.isMenuShown = NO;
//        [self hideDropDownMenu];
//    }
//    else
//    {
//    self.isMenuShown = YES;
//    [self showMenuDropDown];
//    }
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *rearNavigationController = (id)revealController.rearViewController;
    
    if ( ![rearNavigationController.topViewController isKindOfClass:[AASideMenuViewController class]] )
    {
        AASideMenuViewController *rearViewController = [[AASideMenuViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    else
    {
        [revealController revealToggle:self];
    }

}

- (IBAction)btnCartTapped:(id)sender {
    if (self.isInCart) {
        return;
    }
    if ([[[AAAppGlobals sharedInstance] getAllProducts] count]==0){
        [[[UIAlertView alloc] initWithTitle:nil message:@"Your shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return;
    }
    self.isInCart = YES;
    AAEShopNavigationViewController *nvc= [viewControllers_ objectAtIndex:1];
    if(selectedIndex_ < [viewControllers_ count]){
        [[self.btnTabs objectAtIndex:self.selectedIndex] setSelected:NO];
    }
    self.selectedIndex = [viewControllers_ count];
    AAShoppingCartViewController* vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"AAShoppingCartView"];
    vcProfile.parentVc = nvc;
    self.isMenuShown = NO;
    [self cycleFromViewController:self.selectedViewController toViewController:vcProfile];
    [self hideBackButtonView];
    self.isNavigatedFromCart = FALSE;
}



- (void) cycleFromViewController: (UIViewController<AAChildBaseViewControllerProtocol>*) oldC
                toViewController: (UIViewController<AAChildBaseViewControllerProtocol>*) newC
{
    [oldC willMoveToParentViewController:nil];
    [self addChildViewController:newC];
    
    
    
    [newC.view setFrame:oldC.view.frame];
    [self.viewBottomBar setUserInteractionEnabled:NO];
    
    [self transitionFromViewController: oldC toViewController: newC   // 3
                              duration: 0 options:UIViewAnimationOptionTransitionNone
                            animations:^{
                                
                                
                            }
                            completion:^(BOOL finished) {
                                
                                [oldC removeFromParentViewController];
                                
                                [newC didMoveToParentViewController:self];
                                self.selectedViewController = newC;
                                [self updateViewController];
                                [self.selectedViewController refreshView];
                                [self.viewBottomBar setUserInteractionEnabled:YES];
                            }];
};


#pragma mark - Child Navigation Controller callbacks
-(void)showBackButtonView
{
    [self.btnBack setHidden:NO];
    [self.btnProfile setHidden:YES];
      [self hideDropDownMenu];
}
-(void)hideBackButtonView
{
    [self.btnBack setHidden:YES];
     [self.btnProfile setHidden:NO];
  
}

#pragma mark - Share button protocol
-(void)showShareButtonView
{
    if (![AAAppGlobals sharedInstance].enableShoppingCart) {
       [self.btnShare setHidden:NO];
        if ([AAAppGlobals sharedInstance].enableCreditCode) {
            CGRect frame = self.btnShare.frame;
            frame.origin.x = 47;
            self.btnShare.frame = frame;
        }else{
            CGRect frame = self.btnShare.frame;
            frame.origin.x = [UIScreen mainScreen].bounds.size.width - 50;
            self.btnShare.frame = frame;
        }
        
        
    }else{
       [self.vwCartView setHidden:NO];
        [self.btnShare setHidden:NO];
        CGRect frame = self.btnShare.frame;
        frame.origin.x = 47;
        self.btnShare.frame = frame;
    }
    
   
}
-(void)hideShareButtonView
{
    [self.vwCartView setHidden:YES];
    [self.btnShare setHidden:YES];
    [self.btnEnterCode setHidden:YES];
    
    
}
#pragma mark - Root view controller callbacks
-(void)updateHeading
{
    [self.lblContainerTitle setText:self.selectedViewController.heading];
    [self setTitleFont];
}
#pragma mark- Drop down scroll view delegate
-(void)onDropDownMenuItemSelected:(id)dropDownScrollView withItemName:(NSString *)itemName
{
   if([itemName isEqualToString:MENU_PROFILE])
   {
       if(selectedIndex_ < [viewControllers_ count])
        [[self.btnTabs objectAtIndex:self.selectedIndex] setSelected:NO];
       self.selectedIndex = [viewControllers_ count];
       AAProfileViewController* vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
       [vcProfile setShowBuyButton:NO];
        [dropDownScrollView removeFromSuperview];
       self.isMenuShown = NO;
       [self cycleFromViewController:self.selectedViewController toViewController:vcProfile];
      
   }
}
-(void)showProfilePageForPayment{
    if(selectedIndex_ < [viewControllers_ count])
        [[self.btnTabs objectAtIndex:self.selectedIndex] setSelected:NO];
    self.selectedIndex = [viewControllers_ count];
    AAProfileViewController* vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [vcProfile setShowBuyButton:YES];
    [self showBackButtonView];
    self.isMenuShown = NO;
    [self cycleFromViewController:self.selectedViewController toViewController:vcProfile];
    self.isNavigatedFromCart = TRUE;
}
-(void)showProfilePage{
    if(selectedIndex_ < [viewControllers_ count])
    [[self.btnTabs objectAtIndex:self.selectedIndex] setSelected:NO];
    self.selectedIndex = [viewControllers_ count];
    AAProfileViewController* vcProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [vcProfile setShowBuyButton:NO];
    self.isMenuShown = NO;
    [self cycleFromViewController:self.selectedViewController toViewController:vcProfile];
}
#pragma mark - popup view callbacks
-(void)popupViewClosed:(id)popupView
{
    if (popupView==self.pushNotificationPopupView) {
        if([self.selectedViewController isKindOfClass:[AAVouchersViewController class]])
        {
        [self.selectedViewController refreshView];
        }
    }
}
-(void)updateCart{
    
}
- (IBAction)btnEnterCodeTapped:(id)sender {
    couponView = [[AACouponView alloc] init];
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:couponView];
    [couponView refreshView];
    
}
@end

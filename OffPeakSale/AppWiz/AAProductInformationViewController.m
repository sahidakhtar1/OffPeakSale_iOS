//
//  AAProductInformationViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 17/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAProductInformationViewController.h"
#import "AAAppDelegate.h"

#import "AAZoomViewController.h"
#import "AABannerView.h"
#import "AAShoppingCartViewController.h"
#import "AAEShopProductOptions.h"
#import "DMActivityInstagram.h"
#import "AAWhatsAppActivity.h"
#import "AAWechatActivity.h"
#import "AAScannerViewController.h"
#import "AAGiftWrapViewController.h"
#import "AAMapView.h"
#import "AAOrderSucessView.h"
#import "ActivityIndicator.h"
@interface AAProductInformationViewController ()
@property (nonatomic, strong) UIImageView *imageViewForAnimation;
@property (nonatomic, strong) AAGiftWrapViewController *giftWrapDialog;
@property (nonatomic,strong) AAOrderSucessView *orderSucessAlert;
@property (nonatomic, strong) AACouponView *couponView;
- (IBAction)btnCouponTapped:(id)sender;
@end

@implementation AAProductInformationViewController
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.tfQty.text = @"1";
	// Do any additional setup after loading the view.
    [self styleSeparators];
    
    [self populateProductPrices];
    [self refreshView];

    self.vwBuy.hidden = false;
    self.vwEnquiry.hidden = true;
    
   
    self.btnBuyProduct.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.tfQty.font  = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_QTY_FONTSIZE];
    self.lblQty.font  = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_QTY_FONTSIZE];
    self.lblCurrentProductPrice.font  = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_ITEMTOTAL_FONTSIZE];
    self.btnEnquiry.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.lblTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE];
    self.lblCartTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CARTTOTAL_FONTSIZE];
    self.lblTitle.text = @"Eshop";
    
    self.productTabs.eShopCategoryDelegate = self;
    self.productTabs.fontCategoryName = [AAFont eShopCategoryTextFont];
    [self populateCategories];
    [self popuateProductInfo];
    [self setMenuIcons];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [AAColor sharedInstance].retailerThemeTextColor,NSForegroundColorAttributeName,
                                                                                                  //[UIColor whiteColor],UITextAttributeTextShadowColor,
                                                                                                  //[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    self.mSearchBar.barTintColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    self.mSearchBar.tintColor = [AAColor sharedInstance].retailerThemeTextColor;
    
    CGRect frameCurrentProductPrice = self.lblCurrentProductPrice.frame;
    frameCurrentProductPrice.size.width = self.lblQty.frame.origin.x-frameCurrentProductPrice.origin.x-5;
    self.lblCurrentProductPrice.frame = frameCurrentProductPrice;
    [self.btnBuyProduct setTitle:@"Buy" forState:UIControlStateNormal];
    
}
-(void)setMenuIcons{
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        [self.btnCart setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
        [self.btnShare setImage:[UIImage imageNamed:@"share_button"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        [self.btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [self.btnScan setImage:[UIImage imageNamed:@"ic_barcode_white"] forState:UIControlStateNormal];
    }else{
        [self.btnCart setImage:[UIImage imageNamed:@"icon_cart_black.png"] forState:UIControlStateNormal];
        [self.btnShare setImage:[UIImage imageNamed:@"share_button_black"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"back_button_black"] forState:UIControlStateNormal];
        [self.btnSearch setImage:[UIImage imageNamed:@"search_black"] forState:UIControlStateNormal];
        [self.btnScan setImage:[UIImage imageNamed:@"ic_barcode"] forState:UIControlStateNormal];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(couponApplied)
                                                 name:@"couponApplied"
                                               object:nil];
    
    id<AAChildNavigationControllerDelegate> nvcEShop = (id<AAChildNavigationControllerDelegate>)   self.navigationController;
    
//    [nvcEShop showBackButtonView];
    
    id<AAShareButtonProtocol> vcContentContainer = (id<AAShareButtonProtocol>)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (vcContentContainer != nil && [vcContentContainer respondsToSelector:@selector(showShareButtonView)]) {
        [vcContentContainer showShareButtonView];
    }
    if ([AAAppGlobals sharedInstance].enableCreditCode) {
        if (![AAAppGlobals sharedInstance].enableShoppingCart) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showEnterCode" object:nil];
        }
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:START_TIMER object:nil];
    [self.scrollViewProductInformation.banner startTimer];
    [self updateCartTotal];
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] postNotificationName:STOP_TIMER object:nil];
    [self.scrollViewProductInformation.banner stopTime];
    
    
    
    id<AAShareButtonProtocol> vcContentContainer = (id<AAShareButtonProtocol>)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (vcContentContainer != nil && [vcContentContainer respondsToSelector:@selector(hideShareButtonView)]) {
        [vcContentContainer hideShareButtonView];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideEnterCode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"couponApplied" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"couponApplied" object:nil];
}
-(void)refreshView
{

     [self populateProductPrices];
   self.scrollViewProductInformation.product = self.product;
    [self.scrollViewProductInformation refreshScrollView];
    self.scrollViewProductInformation.delegate = self;
}
-(NSDictionary *)dictShareInformation
{
    AAShareActivityItemProvider* productInfoShareString = [[AAShareActivityItemProvider alloc] initWithPlaceholderItem:self.product];
    productInfoShareString.eshopProduct = self.product;
    NSDictionary* dictInformation = [NSDictionary dictionaryWithObjectsAndKeys:productInfoShareString,@"share_product_info",self.product.productImageURLString,@"share_product_img", nil];
                                     return dictInformation;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
-(void)styleSeparators
{
    [self.viewVerticalSeparator setBackgroundColor:[AAColor sharedInstance].eShopVerticalSeparatorColor];
    self.viewVerticalSeparator.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.viewVerticalSeparator.layer.shadowOpacity = .8;
    self.viewVerticalSeparator.layer.shadowRadius = 3.0;
    
    [self.viewVerticalSeparator2 setBackgroundColor:[AAColor sharedInstance].eShopVerticalSeparatorColor];
    self.viewVerticalSeparator2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.viewVerticalSeparator2.layer.shadowOpacity = .8;
    self.viewVerticalSeparator2.layer.shadowRadius = 3.0;
    
  
    
    
}
-(NSString*)removeCurrency:(NSString*)str{
    NSString *result;
    if ([str isKindOfClass:[NSString class]]) {
        result = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    }else{
        return str;
    }
   
    
    return result;
}
-(void)populateProductPrices
{
    NSString *selectedCurrencyKey = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECTED_CURRENCY];
    if (selectedCurrencyKey == nil) {
        selectedCurrencyKey = [AAAppGlobals sharedInstance].currency_code;
    }
    float currencyMultiplier = [[[[AAAppGlobals sharedInstance] currecyDict] valueForKey:selectedCurrencyKey] floatValue];
    if (currencyMultiplier ==0) {
        currencyMultiplier = 1.0f;
        selectedCurrencyKey =[AAAppGlobals sharedInstance].currency_code;
    }
//    BOOL isDecimalAllowed = [[AAAppGlobals sharedInstance] isHavingDecimal:self.product.currentProductPrice];

    NSString *price;
    float itemTotal  = [[self removeCurrency:self.product.currentProductPrice] floatValue]*[self.tfQty.text integerValue];

    if (![[AAAppGlobals sharedInstance].discountType isEqualToString:DESFAULT_DISCOUNT_TYPE]) {
        itemTotal =itemTotal- [[AAAppGlobals sharedInstance].discountPercent floatValue];
        if (itemTotal<0) {
            itemTotal = 0;
        }
        
    }else{
        float percent =  [[AAAppGlobals sharedInstance].discountPercent floatValue];
        float totalDiscount = ((float)itemTotal * percent) / 100.0;
        itemTotal =itemTotal- totalDiscount;
    }
    itemTotal = itemTotal *currencyMultiplier;

    price = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:itemTotal];
    
    NSString* currentProductPrice = [NSString stringWithFormat:@"%@%@",[[AAAppGlobals sharedInstance] getCurrencySymbolWithCode:selectedCurrencyKey],price];
    CGSize currentPricelabelSize = [AAUtils getTextSizeWithFont:self.lblCurrentProductPrice.font andText:currentProductPrice andMaxWidth:80];
    
    [self.lblCurrentProductPrice setText:currentProductPrice];
    
    
   
}

-(void)showConfirmPurchasePopupView: (NSDictionary*)orderInfo;
{
    NSMutableDictionary* orderInformation = [[NSMutableDictionary alloc] initWithDictionary:orderInfo copyItems:YES];
    
    [orderInformation setObject:[NSNumber numberWithInt:1] forKey:PRODUCT_QUANTITY_KEY];
    AAConfirmPurchasePopupView* confirmPurchasePopupView = [AAConfirmPurchasePopupView createDatePickerViewWithBackgroundFrameRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withProduct:self.product andOrderInfo:orderInformation];
    
    [self.view addSubview:confirmPurchasePopupView];
}
-(void)showLoginView{
    AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [profileViewController setShowBuyButton:YES];
    profileViewController.profileDelegate = self;
    profileViewController.showBuyButton = NO;
    [self.navigationController pushViewController:profileViewController animated:YES];
}
-(void)checkout{
    
}
#pragma mark - profile view controller callbacks
-(void)closeProfileViewController:(id)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
    [self makePayment];
}
#pragma mark - UI Event Management
- (IBAction)btnBuyProductTapped:(id)sender {
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_LOGGED_IN];
    if (!isLoggedIn) {
        [self showLoginView];
    }else{
        [self makePayment];
    }
    
//    if (1== 2 && ![AAAppGlobals sharedInstance].enableShoppingCart) {
//    
//   // NSString* currentProductPrice = [NSString stringWithFormat:@"%.2f",[[self removeCurrency:self.product.currentProductPrice] floatValue]*[self.tfQty.text integerValue]];
//        AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
//        [profileViewController setShowBuyButton:YES];
//        [profileViewController setProfileDelegate:self];
//        [profileViewController setProductInformation:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger: self.product.productId],PRODUCT_ID_KEY,[NSNumber numberWithInt:[self.tfQty.text intValue]],PRODUCT_QUANTITY_KEY,self.product.productShortDescription,PRODUCT_SHORT_DESCRIPTION_KEY,self.product.currentProductPrice,PRODUCT_AMOUNT_KEY, nil]];
//    
//        [self.navigationController pushViewController:profileViewController animated:YES];
//
//    }else{
//        if ([self.product.product_options count]>0) {
//            AAEShopProductOptions *option1 = [self.product.product_options objectAtIndex:0];
//            if (self.product.selectedOptionOne == nil) {
//                [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please selct %@",option1.optionLabel] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
//                return;
//            }
//        }
//        if ([self.product.product_options count]>1) {
//            AAEShopProductOptions *option1 = [self.product.product_options objectAtIndex:1];
//            if (self.product.selectedOptionOne == nil) {
//                [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Please selct %@",option1.optionLabel] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
//                return;
//            }
//        }
//        BOOL isAdded =  [[AAAppGlobals sharedInstance] addProductToCart:self.product witnQuantity:self.tfQty.text];
//        if (isAdded) {
//            [self makeCartAniation];
//            
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *path = [paths objectAtIndex:0];
//            path = [NSString stringWithFormat:@"%@/%d.png",path,self.product.productId];
//            NSFileManager* filemanager = [NSFileManager defaultManager];
//            if ([filemanager fileExistsAtPath:path]) {
//                
//            }else{
//                UIView *view = [self.scrollViewProductInformation viewWithTag:100];
//                UIImageView *imgView = [view viewWithTag:101];
//                if ([imgView isKindOfClass:[UIImageView class]]) {
//                    if (imgView.image != nil) {
//                        NSData *imageData = UIImagePNGRepresentation(imgView.image);
//                        [filemanager createFileAtPath:path contents:imageData attributes:nil];
//                    }
//                    
//                }
//                // NSData *imageData = UIImagePNGRepresentation();
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCart" object:nil];
//        }else{
//           // [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to add the product to cart." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
//        }
//        
//    }
    
}


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
    self.product.selectedOptionOne = nil;
    self.product.selectedOptionTwo = nil;
}

- (IBAction)btnShareTapped:(id)sender {
        NSString* imageUrl = [self.dictShareInformation objectForKey:@"share_product_img"];
        
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *shareImage = [imageCache imageFromDiskCacheForKey:imageUrl];
        
        AAShareActivityItemProvider* itemProviderShareString = [self.dictShareInformation objectForKey:@"share_product_info"];
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

- (IBAction)btnCartTapped:(id)sender {
    if ([AAAppGlobals sharedInstance].cartTotalItemCount == 0) {
         [[[UIAlertView alloc] initWithTitle:nil message:@"Your shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }else{
        AAShoppingCartViewController *shoppingCartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAShoppingCartView"];
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    }
}

-(void)updateCartTotal{
    [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
    self.lblCartTotal.text = [NSString stringWithFormat:@"%ld",(long)[AAAppGlobals sharedInstance].cartTotalItemCount];
}

#pragma mark - Profile view controller callbacks
-(void)onPaymentSucceeded:(NSDictionary *)response
{
    [self.navigationController popViewControllerAnimated:YES];
      [self showConfirmPurchasePopupView:response];
   }


#pragma mark -
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:1
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = 0;
                         self.view.frame = frame;
                     }
                     completion:nil];
    if ([self.tfQty.text integerValue]<1) {
        self.tfQty.text= @"1";
    }
     [self populateProductPrices];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:1
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = -216;
                         self.view.frame = frame;
                     }
                     completion:nil];
   
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL flag = true;
    if ([string length]== 0) {
        return true;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if ([str integerValue]>9) {
        return false;
    }else{
        return true;
    }
    return flag;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tfQty resignFirstResponder];
}


-(void)rateProductWithProductId:(NSString*)productId withRating:(NSString*)rating{
//    if ([AAAppGlobals sharedInstance].consumer) {
//        [self showProfileUpdatePopupView];
//        return;
//    }
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,@"retailerId",
                            /*[AAAppGlobals sharedInstance].customerEmailID,@"email",*/
                            productId,@"productId",
                            rating,@"rating" ,nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"send_product_rating.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        NSLog(@"response = %@",response);
        [[[UIAlertView alloc] initWithTitle:@"Product rating" message:[response valueForKey:@"errorMessage"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    } withFailureBlock:^(NSError *error) {
        //NSLog( @"Network failure" );
        NSLog(@"error = %@",error);
    }];
}
-(void)presentImageZoomWithImage:(UIImage*)image{
    AAZoomViewController *zoomView = [[AAZoomViewController alloc] initWithImage:image andDelegate:nil];
    [self presentViewController:zoomView animated:YES completion:^{
        
    }];

}
#pragma mark - profile update popup view callbacks
-(void)showProfileUpdateScreen
{
    
    AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    
    profileViewController.profileDelegate = self;
    profileViewController.showBuyButton = NO;
    [self.navigationController pushViewController:profileViewController animated:YES];
    
}

-(void)showProfileUpdatePopupView
{
    self.updatePopupView = [AAProfileUpdatePopupView createProfileUpdatePopupViewWithBackgroundFrameRect:self.view.bounds];
    self.updatePopupView.profilePopupViewDelegate = self;
    [self.view addSubview:self.updatePopupView];
    
}
-(void)populateCategories
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:@"Reviews"];
    [arr addObject:@"Details"];
    if (self.product.productWorkingInformation.length>0) {
      [arr addObject:@"How It Works"];
    }
    [arr addObject:@"Map"];
    self.productTabs.selectedCategory = @"Details";
    self.productTabs.categories = arr.mutableCopy;
    [self.productTabs refreshScrollView];
    [self onCategeorySelected:self.productTabs.selectedCategory];
    
    
}
-(void)popuateProductInfo{
    int width = [UIScreen mainScreen].bounds.size.width;
    self.productReview = [[AAProductReview alloc] initWithFrame:CGRectMake(0, 0, width, self.ProductScroolView.frame.size.height)];
    [self.ProductScroolView addSubview:self.productReview];
    self.productReview.productReviews = self.product.testimonials;
    [self.productReview showProductReview];
    
    self.howItWorks = [[AAHowItWorksView alloc] initWithFrame:CGRectMake(2*width, 0, width, self.ProductScroolView.frame.size.height)];
    [self.ProductScroolView addSubview:self.howItWorks];
    [self.howItWorks setHowItWorks:self.product.productWorkingInformation];
    
    UIView *mapContainer = [[UIView alloc] initWithFrame:CGRectMake(3*width+15, 15, width-30, self.ProductScroolView.frame.size.height-15)];
    [self.ProductScroolView addSubview:mapContainer];
    
    AAMapView *mvRetailerStores = [[AAMapView alloc] initWithFrame:CGRectMake(0,0, mapContainer.frame.size.width , mapContainer.frame.size.height )];
    [mapContainer addSubview:mvRetailerStores];
    [self putPinsOnMap:mvRetailerStores];
    [mvRetailerStores addMarkerWithTitle:self.product.productShortDescription address:self.product.outletAddr andConatct:self.product.outletContact atLat:self.product.outletLat lng:self.product.outletLong];

    
    CGRect frame = self.scrollViewProductInformation.frame;
    frame.origin.x = width;
    frame.size.width = width;
    self.scrollViewProductInformation.frame = frame;
    
    self.ProductScroolView.contentSize = CGSizeMake(4*width, self.ProductScroolView.contentSize.height);
    
    
}
-(void)putPinsOnMap:(AAMapView*)map{
    CLLocationCoordinate2D currentLocation =
    CLLocationCoordinate2DMake([AAAppGlobals sharedInstance].targetLat,
                               [AAAppGlobals sharedInstance].targetLong);
    [map addCurrentLocationMarkerWithCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate
                                      withTitle:@"Current Location"
                                        andIcon:[UIImage imageNamed:@"current_location_marker"]];
}

#pragma mark - Scroll view  categories callbacks
-(void)onCategeorySelected:(NSString *)categoryName
{
    CGPoint offset = self.ProductScroolView.contentOffset;
    if ([categoryName isEqualToString:@"Reviews"]) {
        offset.x = 0;
    }else if ([categoryName isEqualToString:@"Details"]){
        offset.x = self.ProductScroolView.frame.size.width;
    }else if ([categoryName isEqualToString:@"How It Works"]){
        offset.x = 2*self.ProductScroolView.frame.size.width;
    }else if ([categoryName isEqualToString:@"Map"]){
        offset.x = 3*self.ProductScroolView.frame.size.width;
    }
    [self.ProductScroolView setContentOffset:offset animated:YES];
}
-(void)makeCartAniation{
    [self.tfQty resignFirstResponder];
    UIImage *imageToAnimate = [UIImage imageNamed:@"bigcart"];
    self.imageViewForAnimation = [[UIImageView alloc] initWithImage:imageToAnimate];
    self.imageViewForAnimation.alpha = 1.0f;
    self.imageViewForAnimation.frame = CGRectMake(self.view.frame.size.width-self.btnBuyProduct.frame.size.width/2-15, self.view.frame.size.height-20, 70, 70);
    CGRect imageFrame = self.imageViewForAnimation.frame;
    //Your image frame.origin from where the animation need to get start
    CGPoint viewOrigin = self.imageViewForAnimation.frame.origin;
//    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
//    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
    
    self.imageViewForAnimation.frame = imageFrame;
    self.imageViewForAnimation.layer.position = viewOrigin;
    [self.view addSubview:self.imageViewForAnimation];
    
    // Set up fade out effect
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // Set up scaling
    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(10.0f, 10.0f)]];
    resizeAnimation.fillMode = kCAFillModeForwards;
    resizeAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    //Setting Endpoint of the animation
    CGPoint endPoint = CGPointMake(self.vwCard.frame.origin.x+self.vwCard.frame.size.width/2,self.vwCard.frame.origin.y+self.vwCard.frame.size.height/2);
    //to end animation in last tab use
    //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    float cureveYposition = [[AAAppGlobals sharedInstance] getImageHeight]+120;
    CGPathAddCurveToPoint(curvedPath, NULL, 60, cureveYposition, 60, cureveYposition, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    [group setAnimations:[NSArray arrayWithObjects:/*fadeOutAnimation,*/ pathAnimation, resizeAnimation, nil]];
    group.duration = 1.5f;
    group.delegate = self;
    [group setValue:self.imageViewForAnimation forKey:@"imageViewBeingAnimated"];
    
    [self.imageViewForAnimation.layer addAnimation:group forKey:@"savingAnimation"];
    
}
-(void)showGiftWrapDialog{
    
    if ([[AAAppGlobals sharedInstance].retailer.enableGiftWrap isEqualToString:@"1"]) {
        AAEShopProduct *cartItem = [[AAAppGlobals sharedInstance] cartItemWithId:self.product.productId];
        BOOL isGiftMsgAdded = true;
        if (!cartItem.giftWrapOpted) {
            self.giftWrapDialog = [self.storyboard instantiateViewControllerWithIdentifier:@"AAGiftWrapViewController"];
            self.giftWrapDialog.product = cartItem;
            [self.view addSubview:self.giftWrapDialog.view];
        }else{
            [[[UIAlertView alloc]initWithTitle:nil message:@"Product added to cart sucessfully." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        }
        
    }else{
        [[[UIAlertView alloc]initWithTitle:nil message:@"Product added to cart sucessfully." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
   
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"Animation done");
    [self updateCartTotal];
    [self.imageViewForAnimation removeFromSuperview];
    self.imageViewForAnimation = nil;
    [self showGiftWrapDialog];
}
- (IBAction)btnSearchTapped:(id)sender {
    [self.mSearchBar setHidden:false];
    [self.btnScan setHidden:false];
    [self.btnBack setHidden:true];
    [self.btnShare setHidden:true];
    [self.mSearchBar becomeFirstResponder];
}
-(void)locationTapped{
    self.productTabs.selectedCategory = @"Map";
    [self.productTabs refreshScrollView];
    [self onCategeorySelected:self.productTabs.selectedCategory];
}
#pragma mark -
#pragma mark Search bar delegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.mSearchBar resignFirstResponder];
    [self.mSearchBar setHidden:true];
    [self.btnScan setHidden:true];
    [self.btnBack setHidden:false];
    [self.btnShare setHidden:false];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.mSearchBar resignFirstResponder];
    [self.mSearchBar setHidden:true];
    [self.btnScan setHidden:true];
    [self.btnBack setHidden:false];
    [self.btnShare setHidden:false];
    NSString *trimmedString = [self.mSearchBar.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"trimmedString = %@",trimmedString);
    if ([trimmedString length]) {
        AAAppDelegate *appDelegate = (AAAppDelegate*) [[UIApplication sharedApplication] delegate];
        [appDelegate searchItemWithText:trimmedString];
    }
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.mSearchBar resignFirstResponder];
    [self.mSearchBar setHidden:true];
    [self.btnScan setHidden:true];
    [self.btnBack setHidden:false];
    [self.btnShare setHidden:false];
}
-(void)scanningResult:(NSString*)result{
    NSString *trimmedString = [result stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"trimmedString = %@",trimmedString);
    AAAppDelegate *appDelegate = (AAAppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate searchItemWithText:trimmedString];
    [self.mSearchBar resignFirstResponder];
    [self.mSearchBar setHidden:true];
    [self.btnScan setHidden:true];
    [self.btnBack setHidden:false];
    [self.btnShare setHidden:false];
    
}
- (IBAction)btnScanTapped:(id)sender {
    AAScannerViewController *scannerVC= [[AAScannerViewController alloc] initWithNibName:@"ScannerView" bundle:nil];
    scannerVC.delegate = self;
    AAAppDelegate *appDelegate = (AAAppDelegate*) [[UIApplication sharedApplication] delegate];
    [self presentViewController:scannerVC animated:YES completion:nil];
}
-(NSMutableDictionary*)createProductInfoDict{
    
    NSArray *allCartItems = [[AAAppGlobals sharedInstance] getAllProducts];
    NSMutableArray *arr = [[NSMutableArray array] init];
    AAEShopProduct *item = self.product;
    NSMutableDictionary *tdict = [[NSMutableDictionary alloc] init];
    [tdict setObject:[NSString stringWithFormat:@"%d",item.productId] forKey:PAYMENT_PRODUCT_ID_KEY];
    
    [tdict setObject:self.tfQty.text forKey:PAYMENT_QUANTITY_KEY];
    [arr addObject:tdict];
    
    NSMutableDictionary *paymentDictionary  = [NSMutableDictionary dictionaryWithObject:arr forKey:@"products"];
    
    return paymentDictionary;
}
#pragma mark - Payment handler callbacks
-(void)onPaymentSuccess : (NSDictionary*)response
{
    [AAAppGlobals sharedInstance].cod = false;
    
    NSString *cartTotal = self.lblCurrentProductPrice.text;
    
    NSMutableDictionary* paymentDictionary;
//    if (![AAAppGlobals sharedInstance].enableShoppingCart) {
//        CGFloat qty = [[self.productInformation objectForKey:PRODUCT_QUANTITY_KEY] floatValue];
//        CGFloat unitiPrice = [[self.productInformation objectForKey:PRODUCT_AMOUNT_KEY] floatValue];
//        CGFloat total = qty*unitiPrice;
//        if ([AAAppGlobals sharedInstance].enableCreditCode) {
//            
//            float percent =  [[AAAppGlobals sharedInstance].discountPercent floatValue];
//            float totalDiscount = ((float)total * percent) / 100.0;
//            total =total- totalDiscount;
//            
//        }
//        if (total>=[AAAppGlobals sharedInstance].freeAmount ) {
//            
//        }else{
//            if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
//                total = total + [[AAAppGlobals sharedInstance].shippingCharge floatValue];
//            }
//            
//        }
//        total = total - [[AAAppGlobals sharedInstance].rewardPointsRedeemed integerValue];
//        if ([AAAppGlobals sharedInstance].isDecimalAllowed) {
//            cartTotal = [NSString stringWithFormat:@"%.2f",total];
//        }else{
//            cartTotal = [NSString stringWithFormat:@"%.0f",total];
//        }
//        paymentDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[self.productInformation objectForKey:PRODUCT_ID_KEY] , JSON_PAYMENT_PRODUCT_ID_KEY,[self.productInformation objectForKey:PRODUCT_QUANTITY_KEY],JSON_PAYMENT_QUANTITY_KEY,[self.productInformation objectForKey:PRODUCT_AMOUNT_KEY],JSON_PAYMENT_ORDER_AMOUT_KEY,[response objectForKey:@"paymen_status"],JSON_PAYMENT_STATUS_KEY, nil];
//    }else{
////        if (tempTotal>=[AAAppGlobals sharedInstance].freeAmount) {
////            
////        }else{
////            if ([AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
////                tempTotal = tempTotal + [[AAAppGlobals sharedInstance].shippingCharge floatValue];
////            }
////            
////        }
////        tempTotal = tempTotal - [[AAAppGlobals sharedInstance].rewardPointsRedeemed integerValue];
////        if ([AAAppGlobals sharedInstance].isDecimalAllowed) {
////            cartTotal = [NSString stringWithFormat:@"%.2f",tempTotal];
////        }else{
////            cartTotal = [NSString stringWithFormat:@"%.0f",tempTotal];
////        }
    paymentDictionary = [self createProductInfoDict];
    [paymentDictionary setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    
    [paymentDictionary setObject:cartTotal forKey:JSON_PAYMENT_ORDER_AMOUT_KEY];
    [paymentDictionary setValue:[response objectForKey:@"paymen_status"] forKey:JSON_PAYMENT_STATUS_KEY];
        
//    }
    NSString *placeOrderUrl = [response objectForKey:@"place_order_url"];
    
    [[ActivityIndicator sharedActivityIndicator] show];
    [AAPaymentInfoHelper sendPaymentInfoWithDictionary:paymentDictionary
                                              endPoint:placeOrderUrl
                                   withCompletionBlock:^(NSDictionary *dictionary) {
                                       [[ActivityIndicator sharedActivityIndicator] hide];
                                       NSString *orderNo = [dictionary objectForKey:@"transactionId"];
                                       NSString *paypal_transactionId = [dictionary objectForKey:@"paypal_transactionId"];
                                       if (orderNo == nil) {
                                           orderNo = [response objectForKey:@"invoiceId"];
                                       }
                                       [self showOrderSucessAlerwithrderNo:orderNo gateWayTransactionId:paypal_transactionId
                                                            andGrandTtotal:cartTotal
                                                            andIsByCreditL:NO];
                                       
                                   } andFailure:^(NSString *response) {
                                       [[ActivityIndicator sharedActivityIndicator] hide];
                                   }];
    [AAAppGlobals sharedInstance].discountPercent = @"0";
    
}
-(void)onPaymentFailure:(NSString *)errMessage
{
    UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:errMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alertViewFailed show];
}

-(void)showOrderSucessAlerwithrderNo:(NSString*)orderNo
                gateWayTransactionId:(NSString*)gateWayTransactionId
                      andGrandTtotal:(NSString*)grandTotal
                      andIsByCreditL:(BOOL)isByCredit{
    NSMutableString * orderCNFMSG = [[NSMutableString alloc] initWithString:@"Order success. Email confirmation sent.\n\n"];
    [orderCNFMSG appendFormat:@"Grand Total: %@",grandTotal];

    [orderCNFMSG appendFormat:@"\n\nTransaction Id: %@",orderNo];
//    [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
    
    if ([[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"]) {
        [orderCNFMSG appendFormat:@"\nVeritrans Id:: %@",gateWayTransactionId];
    }else{
        [orderCNFMSG appendFormat:@"\nPaypal Id: %@",gateWayTransactionId];
    }
    
    self.orderSucessAlert = [[AAOrderSucessView alloc] initWithFrame:self.view.frame withOderNumber:orderNo grandTotal:orderCNFMSG andIsByCredit:NO];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.orderSucessAlert];
    [self.orderSucessAlert refreshView];
//    [[AAAppGlobals sharedInstance] deleteAllProducts];
    [AAAppGlobals sharedInstance].rewardsPointEarned = @"0";
    [AAAppGlobals sharedInstance].rewardPointsRedeemed = @"0";
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)makePayment
{
    NSString *emailId;
    NSMutableDictionary* dictPayment = [[NSMutableDictionary alloc] init];
    
    emailId =[AAAppGlobals sharedInstance].consumer.email;
    
    NSMutableDictionary* paymentDictionary;

    paymentDictionary = [self createProductInfoDict];
    [paymentDictionary setObject:RETAILER_ID forKey:JSON_RETAILER_ID_KEY];
    [paymentDictionary setObject:emailId forKey:PAYMENT_EMAIL_KEY];
        
        
    if ([AAAppGlobals sharedInstance].enableCreditCode && [AAAppGlobals sharedInstance].discountPercent > 0) {
        [paymentDictionary setValue:[AAAppGlobals sharedInstance].discountPercent forKey:@"discount"];
        [paymentDictionary setValue:[AAAppGlobals sharedInstance].discountType forKey:@"discountType"];
        [paymentDictionary setValue:[AAAppGlobals sharedInstance].discountCode forKey:@"discountCode"];
    }
//    if ([AAAppGlobals sharedInstance].shippingCharge > 0 && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
//        if ([AAAppGlobals sharedInstance].freeAmount == 0 || [AAAppGlobals sharedInstance].freeAmount > [[AAAppGlobals sharedInstance] cartTotal]) {
//            [paymentDictionary setObject:[NSString stringWithFormat:@"%.2f",[[AAAppGlobals sharedInstance].shippingCharge floatValue]] forKey:@"shippingAmt"];
//        }
//        
//    }
    //    if (!self.isCOD) {
//    [paymentDictionary setObject:[AAAppGlobals sharedInstance].rewardPointsRedeemed forKey:@"redeemPoints"];
//    //    }
//    if ([[AAAppGlobals sharedInstance].enableDelivery isEqualToString:@"1"] && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"dd MMM YYYY"];
//        NSString *dateStr = [formatter stringFromDate:[AAAppGlobals sharedInstance].scheduledDate];
//        
//        [paymentDictionary setObject:[NSString stringWithFormat:@"%@,%@",dateStr,
//                                      [AAAppGlobals sharedInstance].selectedTime]
//                              forKey:@"deliveryDate"];
//    }else if ([[AAAppGlobals sharedInstance].retailer.enableCollection isEqualToString:@"1"] && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 1) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"dd MMM YYYY"];
//        NSString *dateStr = [formatter stringFromDate:[AAAppGlobals sharedInstance].scheduledDate];
//        
//        [paymentDictionary setObject:[NSString stringWithFormat:@"%@,%@ at %@",dateStr,
//                                      [AAAppGlobals sharedInstance].selectedTime,[AAAppGlobals sharedInstance].selectedCollectionAddress]
//                              forKey:@"collectDate"];
//    }
    [AAAppGlobals sharedInstance].cod = false;
    
    [AAAppGlobals sharedInstance].paymentHandler.paymentHandlerDelegate = self;
    [[AAAppGlobals sharedInstance].paymentHandler makePaymentWithDetails:paymentDictionary];
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [[ActivityIndicator sharedActivityIndicator] show];
//    [AAConsumerProfileHelper saveConsumerProfileWithDictionary:self.consumer.JSONDictionaryProfileRepresentation.mutableCopy withCompletionBlock:^{
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        [[ActivityIndicator sharedActivityIndicator] hide];
//        [self saveProfileToUserDefaults];
//       
//        
//    } andFailure:^(NSString *errorMessage) {
//        [[ActivityIndicator sharedActivityIndicator] hide];
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        [self saveProfileToUserDefaults];
//        UIAlertView* alertViewFailed = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Cannot complete payment. Try again later." delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        [alertViewFailed show];
//    }];
    
}

- (IBAction)btnCouponTapped:(id)sender {
    self.couponView = [[AACouponView alloc] init];
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self.couponView];
    self.couponView.productId = [NSString stringWithFormat:@"%d",(int)self.product.productId];
    [self.couponView refreshView];
}
-(void)couponApplied{
    [self performSelectorOnMainThread:@selector(populateProductPrices) withObject:nil waitUntilDone:NO];
}
@end

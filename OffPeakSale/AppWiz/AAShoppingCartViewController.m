//
//  AAShoppingCartViewController.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 26/04/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAShoppingCartViewController.h"
#import "AACertVeiwCell.h"
#import "ItemDetail.h"
#import "ImageDownloader.h"
#import "AAConsumerProfileHelper.h"
#import "AAProfileViewController.h"
#import "AAEShopWithDeleteCell.h"
#import "AAShippingChargeHelper.h"
#import "AAUserProfileHelper.h"

@interface AAShoppingCartViewController ()

@end

@implementation AAShoppingCartViewController
@synthesize allCartItems;
@synthesize consumer,parentVc;
@synthesize imageDownloadsInProgress;
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
    
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
    self.cartBottomView = [[AAShoppingCartBottomView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 100)];
    self.cartBottomView.delegate = self;
    [self.tbCartItemTable setTableFooterView:self.cartBottomView];
    
//    [self updateGrandTotal];
    
    if ([AAAppGlobals sharedInstance].disablePayment) {
        [self.tbCartItemTable registerClass:[AAEShopWithDeleteCell class] forCellReuseIdentifier:@"CartCell"];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
    }else{
       
    }
//    self.vwShippingCharge.layer.borderColor = [UIColor colorWithRed:160.0/255.0 green:163.0/255.0 blue:164.0/255.0 alpha:1].CGColor;
//    self.vwShippingCharge.layer.borderWidth = 1;
    
   
    //[self updateCreditTerms];
    self.consumer = [AAAppGlobals sharedInstance].consumer;
	// Do any additional setup after loading the view.
    [self setMenuIcons];
    self.lblTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:TITLE_FONTSIZE];
    self.lblCartTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:CARTTOTAL_FONTSIZE];
    [self.btnEnterCode.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:13.0]];
//    [self.btnEnterCode.titleLabel setTextColor:[AAColor sharedInstance].retailerThemeTextColor];
    [self.btnEnterCode setTitleColor:[AAColor sharedInstance].retailerThemeTextColor forState:UIControlStateNormal];
    [self setCheckoutMehods];
    [[AAAppGlobals sharedInstance] getDateByAddingDays:[[AAAppGlobals sharedInstance].retailer.deliveryDays intValue]];
    
    [self.lblTotal setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FOOTER_OPTIONS_FONTSIZE]];
    [self.lblTotalValue setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FOOTER_OPTIONS_FONTSIZE]];
}
-(void)setMenuIcons{
    if ([[AAAppGlobals sharedInstance].retailer.appIconColor isEqualToString:@"White"]) {
        [self.btnCart setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    }else{
        [self.btnCart setImage:[UIImage imageNamed:@"icon_cart_black.png"] forState:UIControlStateNormal];
        [self.btnBack setImage:[UIImage imageNamed:@"back_button_black"] forState:UIControlStateNormal];
    }
}
-(void)reloadTable{
    [self.tbCartItemTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(couponApplied)
                                                 name:@"couponApplied"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rewardsRedeemed)
                                                 name:@"RewardsRedeemed"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deliveryScheduled)
                                                 name:@"DeliveryScheduled"
                                               object:nil];

//    if(self.navigationController)
//    {
//        id<AAChildNavigationControllerDelegate> nvcEShop = (id<AAChildNavigationControllerDelegate>)   self.navigationController;
//        
//        [nvcEShop hideBackButtonView];
//    }
    if ([AAAppGlobals sharedInstance].enableCreditCode || [[AAAppGlobals sharedInstance].retailer.enableCreditCode isEqualToString:@"1"]) {
        if ([AAAppGlobals sharedInstance].discountPercent == 0) {
            self.btnEnterCode.hidden = false;
            self.vwCart.hidden = true;
//           [[NSNotificationCenter defaultCenter] postNotificationName:@"showEnterCode" object:nil];
        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCartWithOutClick" object:nil];
            self.btnEnterCode.hidden = true;
            self.vwCart.hidden = false;
        }
        
        
    }else{
        self.btnEnterCode.hidden = true;
        self.vwCart.hidden = false;
    }
    self.cartBottomView.lblDiscountApplied.text = [NSString stringWithFormat:@"(%@ %@) ",[AAAppGlobals sharedInstance].currency_symbol,[AAAppGlobals sharedInstance].discountPercent];
    self.lblGrandTotal.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_TOTAL_FONTSIZE];
    self.lblGT.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_TOTAL_FONTSIZE];
    self.lblShippingCharge.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_TOTAL_FONTSIZE - 2];
    self.lblShippingChargeValue.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_TOTAL_FONTSIZE - 2];
    self.lblShippingPlaceHolder.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_TOTAL_FONTSIZE - 2];
    
    self.btnBackToShop.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_BACK2SHOP_FONTSIZE];
    self.lblCheckout.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_CHECKOUT_FONTSIZE];
    self.btnEnquiry.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHOPPINGCART_BACK2SHOP_FONTSIZE];
    
//    if ([[AAAppGlobals sharedInstance].retailer.enablePay isEqualToString:@"1"] ||
//        [[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"]) {
//        self.vwCheckout.hidden = TRUE;
//        self.btnEnquiry.hidden = FALSE;
//        self.vwGTContainer.hidden = TRUE;
//        CGRect frame = self.tbCartItemTable.frame;
//        frame.size.height += self.vwGTContainer.frame.size.height-5;
//        self.tbCartItemTable.frame = frame;
//    }else{
//        self.vwCheckout.hidden = FALSE;
//        self.btnEnquiry.hidden = TRUE;
//        self.vwGTContainer.hidden = FALSE;
//    }
    [self updateGrandTotal];
    countryCode =  [AAAppGlobals sharedInstance].consumer.country;
    if (countryCode != nil && countryCode.length>0) {
        self.lblShippingCharge.hidden = true;
        self.lblShippingChargeValue.hidden = true;
        [AAShippingChargeHelper getShippingChargeForCountry:countryCode
                                        withCompletionBlock:^{
                                            self.lblShippingCharge.hidden = false;
                                            self.lblShippingChargeValue.hidden = false;
                                            [self updateGrandTotal];
                                        }
                                                 andFailure:^(NSString *errorMSG){
                                                     
                                                     
                                                 }];
    }else{
        self.lblShippingCharge.hidden = true;
        self.lblShippingChargeValue.hidden = true;
        self.lblShippingPlaceHolder.hidden = false;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
        [AAUserProfileHelper getUserProfilewithCompletionBlock:^{
                                            self.cartBottomView.rewardsEarnedValue.text = [AAAppGlobals sharedInstance].reward_points;
                                                }
                                                 andFailure:^(NSString *errorMSG){
                                                     
                                                     
                                                 }];
    }
    self.allCartItems = [[AAAppGlobals sharedInstance] getAllProducts];
//    [self reloadTable];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideEnterCode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"couponApplied" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RewardsRedeemed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeliveryScheduled" object:nil];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark TableView Delegate and data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.allCartItems count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height=10;
    AAEShopProduct* item = [self.allCartItems objectAtIndex:indexPath.row];
    float maxWidthForLbl = [UIScreen mainScreen].bounds.size.width - (MARGIN+PRODUCT_IMAGE_WIDTH+MARGIN + MARGIN+RIGHTITEM_WIDTH+MARGIN);
    CGSize productTextSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_SHORTDESC_FONTSIZE] andText:item.productShortDescription andMaxWidth:maxWidthForLbl];
    height += productTextSize.height + ITEM_GAP;
    height += 20+ITEM_GAP;
    if ([item.product_options count] != 0) {
        NSMutableString *oprionStr = [NSMutableString stringWithFormat:@"Options:"];
        if (item.selectedOptionOne != nil) {
            [oprionStr appendString:item.selectedOptionOne];
        }
        if (item.selectedOptionTwo != nil) {
            [oprionStr appendString:@", "];
            [oprionStr appendString:item.selectedOptionTwo];
        }
        
        CGSize optionSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE] andText:oprionStr andMaxWidth:maxWidthForLbl ];
        height +=optionSize.height+ITEM_GAP;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
       height +=20+ITEM_GAP;
    }
    
    if (height < 71) {
        height = 71;
    }
    if (item.giftMsg) {
        float giftWrapMaxWidth = [UIScreen mainScreen].bounds.size.width-MARGIN-45;
        CGSize giftMsgSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE] andText:item.giftMsg andMaxWidth:giftWrapMaxWidth ];
        height +=giftMsgSize.height;
    }
    height += ITEM_GAP;

    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([AAAppGlobals sharedInstance].disablePayment) {
//        AAEShopWithDeleteCell* productCell = (AAEShopWithDeleteCell*)[self.tbCartItemTable dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
//        productCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        AAEShopProduct *item =[self.allCartItems objectAtIndex:indexPath.row];
//        [productCell setProductForCart:item];
//        productCell.indexPath = indexPath;
//        productCell.delegate = self;
//        [productCell populateViews];
//        return productCell;
//    }
   
    NSString *CellIdentifier = @"CartItemCell";
    AACertVeiwCell *cell = (AACertVeiwCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AACertVeiwCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[AACertVeiwCell class]]) {
                cell = (AACertVeiwCell *)currentObject;
                break;
            }
        }
    }
    AAEShopProduct* item = [self.allCartItems objectAtIndex:indexPath.row];
    cell.lblDescription.text =item.productShortDescription;
    
    cell.tfQty.text = item.qty;
    
    float maxWidthForLbl = [UIScreen mainScreen].bounds.size.width - (MARGIN+PRODUCT_IMAGE_WIDTH+MARGIN + MARGIN+RIGHTITEM_WIDTH+MARGIN);
    CGSize productTextSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_SHORTDESC_FONTSIZE] andText:item.productShortDescription andMaxWidth:maxWidthForLbl];
    CGRect frame = cell.lblDescription.frame ;
    frame.size.height = productTextSize.height;
    cell.lblDescription.frame  = frame;
    BOOL isDecimalAllowed = [[AAAppGlobals sharedInstance] isHavingDecimal:item.currentProductPrice];
    NSString *unitPrice;
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };

    float currentPriceX,currentPriceY;
    CGSize previousPricelabelSize;
    if (item.previousProductPrice != nil) {
        if (isDecimalAllowed) {
            unitPrice = [NSString stringWithFormat:@"%.2f",[item.previousProductPrice floatValue]];
        }else{
            unitPrice = [NSString stringWithFormat:@"%.0f",[item.previousProductPrice floatValue]];
        }
        unitPrice = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:[unitPrice floatValue]];
        NSString* prodPrevPrice = [NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_symbol,unitPrice];
        NSMutableAttributedString *attStringPreviousProductPrice = [[NSMutableAttributedString alloc] initWithString:prodPrevPrice attributes:attributes];
         previousPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHOPPINGCART_ITEMTOTAL_FONTSIZE] andText:prodPrevPrice andMaxWidth:maxWidthForLbl ];
        CGRect prevPriceFrame  = cell.lbUnitPrice.frame;
        prevPriceFrame.size.width = previousPricelabelSize.width;
        prevPriceFrame.origin.y = frame.origin.y + frame.size.height+ITEM_GAP;
        cell.lbUnitPrice.frame = prevPriceFrame;
        currentPriceX = prevPriceFrame.origin.x + prevPriceFrame.size.width + 5;
        currentPriceY = prevPriceFrame.origin.y;
        [cell.lbUnitPrice setAttributedText:attStringPreviousProductPrice];
        cell.lbUnitPrice.hidden = false;
    }else{
        currentPriceX = cell.lbUnitPrice.frame.origin.x;
        currentPriceY = frame.origin.y + frame.size.height+ITEM_GAP;
        cell.lbUnitPrice.hidden = true;

    }
    
    CGRect itemTotalFrame = cell.lblItemTotal.frame;
    itemTotalFrame.origin.y = currentPriceY;
    itemTotalFrame.origin.x = currentPriceX;
    itemTotalFrame.size.width = [UIScreen mainScreen].bounds.size.width - (MARGIN+RIGHTITEM_WIDTH+MARGIN) - itemTotalFrame.origin.x;
    cell.lblItemTotal.frame = itemTotalFrame;
    
    float cellHieght = itemTotalFrame.origin.y + itemTotalFrame.size.height+ITEM_GAP;
    if ([item.product_options count] == 0) {
        cell.lblProductOptions.hidden = true;
        
    }else{
        cell.lblProductOptions.hidden = false;
        
        NSMutableString *oprionStr = [NSMutableString stringWithFormat:@"Options:"];
        if (item.selectedOptionOne != nil) {
            [oprionStr appendString:item.selectedOptionOne];
        }
        if (item.selectedOptionTwo != nil) {
            [oprionStr appendString:@", "];
            [oprionStr appendString:item.selectedOptionTwo];
        }
        cell.lblProductOptions.text = oprionStr;
        [cell.lblProductOptions setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]];
        CGSize optionSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE] andText:oprionStr andMaxWidth:maxWidthForLbl ];
        CGRect productOptionFrame = cell.lblProductOptions.frame;
        productOptionFrame.origin.y = cellHieght;
        productOptionFrame.size.width = maxWidthForLbl;
        productOptionFrame.size.height = optionSize.height;
        cell.lblProductOptions.frame = productOptionFrame;
        cellHieght += optionSize.height+ITEM_GAP;
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
        cell.lblRewardPoints.hidden = false;
        CGRect productOptionFrame = cell.lblRewardPoints.frame;
        productOptionFrame.origin.y = cellHieght;
        cell.lblRewardPoints.frame = productOptionFrame;
        cellHieght += 20+ITEM_GAP;
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld Credit Points",[item.qty integerValue ] * [item.reward_points integerValue]]];
        int length = [[NSString stringWithFormat:@"%ld",[item.qty integerValue ] * [item.reward_points integerValue]] length];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
                      range:NSMakeRange(0,length)];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
                      range:NSMakeRange(length+1,[@"Credit Points" length])];
        [cell.lblRewardPoints setAttributedText:hogan];
    }else{
        cell.lblRewardPoints.hidden = true;
       
    }
    
    
    NSString *itemTotal;
    CGFloat newPrice = [item.currentProductPrice floatValue];
    if (item.giftMsg) {
        newPrice += [[AAAppGlobals sharedInstance].retailer.gift_price floatValue];
    }
    if (isDecimalAllowed) {
        itemTotal = [NSString stringWithFormat:@"%.2f",[item.qty integerValue ] * newPrice];
    }else{
        itemTotal = [NSString stringWithFormat:@"%.0f",[item.qty integerValue ] * newPrice];
    }
    itemTotal = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:[itemTotal floatValue]];
    cell.lblItemTotal.text = [NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_symbol, itemTotal];

    cell.delegate = self;
    cell.indexPath = indexPath;
    
    [cell.imgProductImage setImageWithURL:[NSURL URLWithString:item.product_img]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                        }];
//    cellHieght +=5;
    if (cellHieght < 71) {
        cellHieght = 71;
    }
    CGPoint rightViewCenter = cell.vwRightView.center;
    rightViewCenter.y = cellHieght/2;
    cell.vwRightView.center = rightViewCenter;
    
    if (item.giftMsg) {
        float giftWrapMaxWidth = [UIScreen mainScreen].bounds.size.width-MARGIN-45;
        CGSize giftMsgSize= [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE] andText:item.giftMsg andMaxWidth:giftWrapMaxWidth ];
        
        cell.lblGiftMsg.text = item.giftMsg;
        cell.lblGiftMsg.hidden = false;
        CGRect giftMsgFrame = cell.lblGiftMsg.frame;
        giftMsgFrame.origin.y = cellHieght;
        giftMsgFrame.size.height = giftMsgSize.height;
        cell.lblGiftMsg.frame = giftMsgFrame;
        cellHieght +=giftMsgSize.height;
        cell.lblGiftMsg.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE];
    }else{
       cell.lblGiftMsg.hidden = true;
    }
    cellHieght += ITEM_GAP;
    CGRect deviderFrame = cell.vwDevider.frame;
    deviderFrame.origin.y = cellHieght - deviderFrame.size.height;
    cell.vwDevider.frame = deviderFrame;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self.tbCartItemTable findFirstResponder:self.tbCartItemTable] resignFirstResponder];
}
#pragma mark -
#pragma mark Image Downloader Delegate Method

//initiate download of image for a row
- (void)startImageDownload:(NSString *)imageUrl forIndexPath:(NSIndexPath *)indexPath {
    ImageDownloader *imageLoader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageLoader == nil) {
        imageLoader = [[ImageDownloader alloc] init];
        imageLoader.indexPathCurrentRow = indexPath;
        imageLoader.delegate = self;
        [imageDownloadsInProgress setObject:imageLoader forKey:indexPath];
		[imageLoader startImageDownload:imageUrl];
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDownloadComplete:(UIImage*)prodImage forIndex:(NSIndexPath*)indexPath{
    if (indexPath.row>= self.allCartItems.count) {
        [imageDownloadsInProgress removeObjectForKey:indexPath];
        return;
    }
	ImageDownloader *imageLoader = [imageDownloadsInProgress objectForKey:indexPath];
	
	if (imageLoader != nil) {
		ItemDetail *p = [self.allCartItems objectAtIndex:indexPath.row];
		p.productImage = prodImage;
		AACertVeiwCell *cell = (AACertVeiwCell*)[self.tbCartItemTable cellForRowAtIndexPath:indexPath];
        if(cell != nil){
			if (p.productImage!=nil) {
				cell.imgProductImage.image = p.productImage;
			} else {
			}
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            path = [NSString stringWithFormat:@"%@/%@.png",path,p.productId];
            NSFileManager* filemanager = [NSFileManager defaultManager];
            if ([filemanager fileExistsAtPath:path]) {
                
            }else{
                    NSData *imageData = UIImagePNGRepresentation(prodImage);
                    [filemanager createFileAtPath:path contents:imageData attributes:nil];
                }
            }
    }
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}
- (void) cancelAllActiveDownload {
	NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
	for (int i=0; i < [allDownloads count]; i++) {
		ImageDownloader* imd = [allDownloads objectAtIndex:i];
		[imd performSelector:@selector(cancelImageDownload)];
		imd.delegate = nil;
	}
	
	
	[imageDownloadsInProgress removeAllObjects];
}
-(void)updateQTYAtIndexPath:(NSIndexPath*)indexPath withQTY:(NSString *)qty{
    
    AAEShopProduct *item = [self.allCartItems objectAtIndex:indexPath.row];
    if ([qty intValue]>0) {
       item.qty = qty;
    }else{
        
    }
    
    [self.tbCartItemTable reloadData];
    [self updateGrandTotal];
}
-(void)deleteProductAtIndexPath:(NSIndexPath*)indexPath{
    AAEShopProduct *item = [self.allCartItems objectAtIndex:indexPath.row];
    [[AAAppGlobals sharedInstance] deletePoduct:item];
    [self.allCartItems removeObject:item];
    [self.tbCartItemTable reloadData];
    [self updateGrandTotal];
    if ([AAAppGlobals sharedInstance].enableCreditCode) {
        self.btnEnterCode.hidden = false;
        self.vwCart.hidden = true;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showEnterCode" object:nil];
    }
    if ([self.allCartItems count]==0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"continueShopping" object:nil];
    }
}
- (IBAction)btnContinueShoppingTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"continueShopping" object:nil];

}

- (IBAction)btnPayByCreditTapped:(id)sender {
    if ([self.allCartItems count]==0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        return;
    }
    
   // NSString *productinformation = [self createProductJSON];
//    NSDictionary* paymentDictionary = [NSDictionary dictionaryWithObjectsAndKeys:RETAILER_ID,JSON_RETAILER_ID_KEY ,
//                                       emailId,PAYMENT_EMAIL_KEY,
//                                       productinformation,@"products", nil];
   
//       AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
//        [profileViewController setShowBuyButton:YES];
//        [profileViewController setProfileDelegate:self];
//    [profileViewController setProductInformationString:productinformation];
//    [self.parentVc.navigationController pushViewController:profileViewController animated:YES];
    
    [AAAppGlobals sharedInstance].isPayByCredits = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showProfilePageForPayment" object:nil];

}

- (IBAction)btnPayByPaypalTapped:(id)sender {
    if ([self.allCartItems count]==0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        return;
    }
   
    [AAAppGlobals sharedInstance].isPayByCredits = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"showProfilePageForPayment" object:nil];

}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEnterCodeTapped:(id)sender {
    self.couponView = [[AACouponView alloc] init];
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self.couponView];
    [self.couponView refreshView];
}

- (IBAction)btnCODTapped:(id)sender {
    AAProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [profileVC setShowBuyButton:YES];
    [profileVC setCOD:YES];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)btnCheckOut:(id)sender {
    AAProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [profileVC setShowBuyButton:YES];
    [profileVC setCOD:NO];
    [self.navigationController pushViewController:profileVC animated:YES];
}
-(void)setCheckoutMehods{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float buttonWidth ;
    if (([[AAAppGlobals sharedInstance].retailer.enablePay isEqualToString:@"1"] ||[[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"])&&
        [[AAAppGlobals sharedInstance].retailer.enableCOD isEqualToString:@"1"]) {
        
        buttonWidth = screenWidth/2;
        [self.btnCheckOut setHidden:false];
        [self.btnCOD setHidden:false];
        [self.vwDevider setHidden:false];
        CGRect frame = self.btnCheckOut.frame;
        frame.size.width = buttonWidth;
        self.btnCheckOut.frame = frame;
        
        frame = self.vwDevider.frame;
        frame.origin.x = buttonWidth;
        self.vwDevider.frame =frame;
        
        frame = self.btnCOD.frame;
        frame.origin.x = buttonWidth;
        frame.size.width = buttonWidth;
        self.btnCOD.frame = frame;
        
    }else if ([[AAAppGlobals sharedInstance].retailer.enablePay isEqualToString:@"1"] || [[AAAppGlobals sharedInstance].retailer.enableVerit isEqualToString:@"1"]){
        buttonWidth = screenWidth;
        [self.btnCheckOut setHidden:false];
        [self.btnCOD setHidden:true];
        [self.vwDevider setHidden:true];
        CGRect frame = self.btnCheckOut.frame;
        frame.size.width = buttonWidth;
        self.btnCheckOut.frame = frame;
        
    }else if ([[AAAppGlobals sharedInstance].retailer.enableCOD isEqualToString:@"1"]){
        buttonWidth = screenWidth;
        [self.btnCheckOut setHidden:true];
        [self.btnCOD setHidden:false];
        [self.vwDevider setHidden:true];
        
        CGRect frame = self.btnCOD.frame;
        frame.origin.x = 0;
        frame.size.width = buttonWidth;
        self.btnCOD.frame = frame;
        
    }else{
        buttonWidth = screenWidth;
        [self.btnCheckOut setHidden:false];
        [self.btnCOD setHidden:true];
        [self.vwDevider setHidden:true];
        CGRect frame = self.btnCheckOut.frame;
        frame.size.width = buttonWidth;
        self.btnCheckOut.frame = frame;
    }
    
    [self.btnCheckOut setTitleColor:[AAColor sharedInstance].retailerThemeTextColor forState:UIControlStateNormal];
    [self.btnCOD setTitleColor:[AAColor sharedInstance].retailerThemeTextColor forState:UIControlStateNormal];
    [self.vwDevider setBackgroundColor:[AAColor sharedInstance].retailerThemeTextColor];
    
    [self.btnCheckOut.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE]];
    [self.btnCOD.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE]];
    
}
-(void)rewardsRedeemed{
    [self.cartBottomView.btnRewardRedeemed setTitle:[NSString stringWithFormat:@"(%@)",[AAAppGlobals sharedInstance].rewardPointsRedeemed] forState:UIControlStateNormal];
    [self updateGrandTotal];
}
-(void)deliveryScheduled{
    [self.cartBottomView updateSchedule];
}
-(void)couponApplied{
    self.btnEnterCode.hidden = true;
    self.vwCart.hidden = false;
    self.cartBottomView.lblDiscountApplied.text = [NSString stringWithFormat:@"(%@ %@) ",[AAAppGlobals sharedInstance].currency_symbol,[AAAppGlobals sharedInstance].discountPercent];
    [self performSelectorOnMainThread:@selector(updateGrandTotal) withObject:nil waitUntilDone:NO];
}
-(void)updateGrandTotal{
    [[AAAppGlobals sharedInstance] calculateCartTotalItemCount];
    [[AAAppGlobals sharedInstance] calculateCartTotal];
    self.lblCartTotal.text = [NSString stringWithFormat:@"%d", [AAAppGlobals sharedInstance].cartTotalItemCount];
    NSString *shippingValue = @"Free";
    CGFloat cartTotal = [AAAppGlobals sharedInstance].cartTotal;
    if ([AAAppGlobals sharedInstance].shippingCharge > 0 && [AAAppGlobals sharedInstance].deliveryOptonSelectedIndex == 0) {
        if ([AAAppGlobals sharedInstance].freeAmount == 0 || [AAAppGlobals sharedInstance].freeAmount > [[AAAppGlobals sharedInstance] cartTotal]) {
            if ([[AAAppGlobals sharedInstance] isHavingDecimal:[AAAppGlobals sharedInstance].shippingCharge]) {
                shippingValue = [NSString stringWithFormat:@"%@ %@",[AAAppGlobals sharedInstance].currency_code,[NSString stringWithFormat:@"%.2f",[[AAAppGlobals sharedInstance].shippingCharge floatValue]] ];
            }else{
                shippingValue = [NSString stringWithFormat:@"%@ %@",[AAAppGlobals sharedInstance].currency_code,[NSString stringWithFormat:@"%.0f",[[AAAppGlobals sharedInstance].shippingCharge floatValue]] ];
            }
            cartTotal += [[AAAppGlobals sharedInstance].shippingCharge floatValue];
        }else{
            shippingValue = [NSString stringWithFormat:@"Free"];
        }
        
    }else{
        if (countryCode != nil && countryCode.length>0) {
            self.cartBottomView.lblShippingValue.text = [NSString stringWithFormat:@"Free"];
            self.lblShippingPlaceHolder.hidden = true;
        }else{
        }
    }
    int redeemedReward = [[AAAppGlobals sharedInstance].rewardPointsRedeemed intValue];
    cartTotal -= redeemedReward;
    NSString *total;
    if ([AAAppGlobals sharedInstance].isDecimalAllowed) {
        total = [NSString stringWithFormat:@"%.2f", cartTotal];
    }else{
        total = [NSString stringWithFormat:@"%.0f", cartTotal];
    }
    self.lblTotalValue.text = [NSString stringWithFormat:@"%@ %@",[AAAppGlobals sharedInstance].currency_code,total ];
    self.cartBottomView.lblShippingValue.text = shippingValue;
    [self.cartBottomView refreshView];
    [self.cartBottomView adjustFrames];
    
    
}
-(void)updateCreditTerms{
    NSString * appType = [AAAppGlobals sharedInstance].retailer.retailerAppType ;
    NSString *creditTerms = [AAAppGlobals sharedInstance].credit_terms;
    if ([appType isEqualToString:@"Commercial"] && creditTerms != nil) {
     
        if ([creditTerms isEqualToString:@"COD"]) {
            self.lblCreditTermsValue.hidden = TRUE;
            self.lblCreditTemsTime.hidden = TRUE;
            self.lblCredit.text = creditTerms;
            CGPoint center = self.lblCredit.center;
            center.x = self.vwCreditTermsView.frame.size.width/2;
            self.lblCredit.center = center;
            
            center = self.lblTNC.center;
            center.x = self.vwCreditTermsView.frame.size.width/2;
            self.lblTNC.center = center;
            
        }else{
            NSArray *componets = [creditTerms componentsSeparatedByString:@" "];
            if ([componets count]>0) {
                self.lblCreditTermsValue.text = [componets objectAtIndex:0];
            }
            if ([componets count]>1) {
                self.lblCreditTemsTime.text = [componets objectAtIndex:1];
            }
        }
        
    }else{
        self.vwCreditTermsView.hidden = true;
        CGPoint center = self.btnPaypal.center;
        center.x = 160;
        self.btnPaypal.center = center;
    }
   
}
-(NSMutableString*)createProductJSON{
    NSMutableString *productInformation = [NSMutableString stringWithFormat:@"["];
    if ([allCartItems count]>0) {
        ItemDetail *item = [self.allCartItems objectAtIndex:0];
        [productInformation appendString:@"{\""];
        [productInformation appendString:PAYMENT_PRODUCT_ID_KEY];
        [productInformation appendString:@"\":\""];
        [productInformation appendString:item.productId];
        [productInformation appendString:@"\",\""];
        [productInformation appendString:PAYMENT_QUANTITY_KEY];
        [productInformation appendString:@"\":\""];
        [productInformation appendString:item.qty];
        [productInformation appendString:@"\"}"];
        
    }
    for (int i= 1; i< [allCartItems count];i++){
        ItemDetail *item = [self.allCartItems objectAtIndex:i];
        
        [productInformation appendString:@",{\""];
        [productInformation appendString:PAYMENT_PRODUCT_ID_KEY];
        [productInformation appendString:@"\":\""];
        [productInformation appendString:item.productId];
        [productInformation appendString:@"\",\""];
        [productInformation appendString:PAYMENT_QUANTITY_KEY];
        [productInformation appendString:@"\":\""];
        [productInformation appendString:item.qty];
        [productInformation appendString:@"\"}"];
        
    }
    [productInformation appendString:@"]"];
    return productInformation;
}

-(void)deleteItemAtIndexPath:(NSIndexPath*)indexPath{
    AAEShopProduct *item = [self.allCartItems objectAtIndex:indexPath.row];
    [[AAAppGlobals sharedInstance] deletePoduct:item];
    [self.allCartItems removeObject:item];
    [self.tbCartItemTable reloadData];
    [self updateGrandTotal];
    
    if ([self.allCartItems count]==0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Shopping cart is empty." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
}
-(void)deliveryOptionchnaged{
    [self updateGrandTotal];
}
-(void)showLoginView{
    AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    [profileViewController setShowBuyButton:YES];
    profileViewController.profileDelegate = self;
    profileViewController.showBuyButton = NO;
    [self.navigationController pushViewController:profileViewController animated:YES];
}
#pragma mark - profile view controller callbacks
-(void)closeProfileViewController:(id)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

//
//  AAEShopProductCell.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopProductCell.h"

@implementation AAEShopProductCell

NSInteger const MAIN_VIEW_PADDING = 10.0;
NSInteger const IMAGE_VIEW_PADDING = 0.0;
NSInteger const LABEL_VIEW_LEFT_PADDING = 15.0;
NSInteger const OVERLAY_TOP_PADDING = 8.0;
NSInteger const PRICE_VIEW_HEIGHT = 40.0;
static NSInteger const QTY_INDICATOR_WIDTH = 100.0;
static NSInteger const QTY_INDICATOR_HEIGHT = 30.0;
static NSInteger const CIRCULAR_VIEW_WIDTH = 90.0;
static NSInteger const CIRCULAR_VIEW_HEIGHT = 50.0;
NSInteger const RATING_VIEW_WEIDTH = 105;
@synthesize eshopProduct = eShopProduct_;
@synthesize priceView;
@synthesize cartItem;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView.superview setClipsToBounds:NO];
        [self setUpCell];
    }
    return self;
}
-(void) setProductForCart:(ItemDetail*)item{
    self.cartItem = item;
    [self populateViews];
}
-(void)setUpCell
{
    
    self.viewMainContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - MAIN_VIEW_PADDING)];
    [self.viewMainContent setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.viewMainContent setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
    [self.contentView addSubview:self.viewMainContent];
    
    self.lblProductPreviousPrice = [[UILabel alloc] init];
    self.lblProductCurrentPrice = [[UILabel alloc] init];
    self.lblProductShortDescription = [[UILabel alloc] init];
    self.lblProductName = [[UILabel alloc] init];
    self.lblDistance = [[UILabel alloc] init];
    
    self.lblDistance.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:DISTANCE_FONTSIZE];
    self.lblDistance.textColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    
    self.imgViewProductImage = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_VIEW_PADDING, IMAGE_VIEW_PADDING, self.viewMainContent.frame.size.width - 2*IMAGE_VIEW_PADDING, [[AAAppGlobals sharedInstance] getImageHeight] - 2*IMAGE_VIEW_PADDING)];
     [self.imgViewProductImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth ];
    [self.viewMainContent addSubview:self.imgViewProductImage];
    self.overlayView = [[UIView alloc] init];
    
    self.discountView = [[AAThemeCircularView alloc]
                         initWithFrame:CGRectMake(self.imgViewProductImage.frame.size.width -
                                                  LABEL_VIEW_LEFT_PADDING -CIRCULAR_VIEW_WIDTH
                                                  ,self.imgViewProductImage.frame.size.height -
                                                  LABEL_VIEW_LEFT_PADDING -CIRCULAR_VIEW_HEIGHT ,
                                                  CIRCULAR_VIEW_WIDTH,
                                                  CIRCULAR_VIEW_HEIGHT)];
    self.discountView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.5f];
    [self.discountView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.viewMainContent addSubview:self.discountView];
    
    self.lblDiscountPercentage = [[UILabel alloc] initWithFrame:CGRectMake(7,
                                                                           CIRCULAR_VIEW_HEIGHT/2-15,
                                                                           CIRCULAR_VIEW_WIDTH/2+2,
                                                                           30)];
    [self.lblDiscountPercentage setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:QTY_DISCOUNT_VALUE_FONT]];
    [self.lblDiscountPercentage setTextAlignment:NSTextAlignmentRight];
    self.lblDiscountPercentage.textColor = [UIColor whiteColor];
    [self.discountView addSubview:self.lblDiscountPercentage];
    

    UILabel *lblOff = [[UILabel alloc] initWithFrame:CGRectMake(CIRCULAR_VIEW_WIDTH/2+10, CIRCULAR_VIEW_HEIGHT/2-4, CIRCULAR_VIEW_WIDTH/2, 15)];
    [lblOff setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:QTY_DISCOUNT_LBL_FONT]];
    [lblOff setTextAlignment:NSTextAlignmentLeft];
    lblOff.text = @"Off";
    lblOff.textColor = [UIColor whiteColor];
    [self.discountView addSubview:lblOff];
    
    UILabel *percent = [[UILabel alloc] initWithFrame:CGRectMake(CIRCULAR_VIEW_WIDTH/2+10, CIRCULAR_VIEW_HEIGHT/2-15, CIRCULAR_VIEW_WIDTH/2, 15)];
    [percent setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:QTY_DISCOUNT_LBL_FONT]];
    [percent setTextAlignment:NSTextAlignmentLeft];
    percent.text = @"%";
    percent.textColor = [UIColor whiteColor];
    [self.discountView addSubview:percent];
    
    
    self.overlayLayer = NO;
    float screenWidth = [UIScreen mainScreen].bounds.size.width - 25;
    self.lblAddress = [[UILabel alloc] init];
    self.imgPin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.imgPin setImage:[UIImage imageNamed:@"locate_us"]];
//                         WithFrame:CGRectMake(screenWidth-RATING_VIEW_WEIDTH,
//                                                                   10,
//                                                                   RATING_VIEW_WEIDTH,
//                                                                   20)];
    
    [self.viewMainContent addSubview:self.locationView];
    
    self.priceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 [[AAAppGlobals sharedInstance] getImageHeight],
                                                                 screenWidth+20,
                                                                 PRICE_VIEW_HEIGHT)];
    self.priceView.backgroundColor = [UIColor whiteColor];
    self.lblProductPreviousPrice.textColor = [AAColor sharedInstance].old_price_color;
    self.lblProductCurrentPrice.textColor = [AAColor sharedInstance].product_title_color;
    self.lblProductShortDescription.textColor = [AAColor sharedInstance].product_title_color;
    self.lblAddress.textColor = [AAColor sharedInstance].old_price_color;
//    [self.priceView addSubview:self.ratingView];
    [self.priceView addSubview:self.lblProductPreviousPrice];
    [self.priceView addSubview:self.lblProductCurrentPrice];
    [self.priceView addSubview:self.lblProductShortDescription];
    [self.priceView addSubview:self.lblDistance];
    [self.priceView addSubview:self.lblAddress];
    [self.priceView addSubview:self.imgPin];
    [self.viewMainContent addSubview:self.priceView];
    
    float width = [UIScreen mainScreen].bounds.size.width;
    self.vwQtyIndicator = [[UIView alloc]
                           initWithFrame:CGRectMake(width-QTY_INDICATOR_WIDTH,
                                                    
                                                    0,
                                                    QTY_INDICATOR_WIDTH,
                                                    QTY_INDICATOR_HEIGHT)];
//    self.vwQtyIndicator.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_tab_default"]];
    _vwQtyIndicator.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.5f];
//    _vwQtyIndicator.alpha = 0.5;
    [self.viewMainContent addSubview:self.vwQtyIndicator];
    
    self.lblQtyIndicator = [[UILabel alloc] initWithFrame:self.vwQtyIndicator.bounds];
    [self.lblQtyIndicator setTextAlignment:NSTextAlignmentCenter];
    self.lblQtyIndicator.textColor = [UIColor whiteColor];
    self.lblQtyIndicator.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont
                                                size:QTY_INDICATOR_FONT];
    [self.vwQtyIndicator addSubview:self.lblQtyIndicator];
    
    
    
    self.vwSaleIndicator = [[UIView alloc]
                           initWithFrame:CGRectMake(0,
                                                    
                                                    0,
                                                    QTY_INDICATOR_WIDTH,
                                                    QTY_INDICATOR_HEIGHT)];
    self.vwSaleIndicator.backgroundColor = [UIColor colorWithRed:221.0f/255.0f
                                                           green:45.0f/255.0f
                                                            blue:35.0f/255.0f
                                                           alpha:1];
    [self.viewMainContent addSubview:self.vwSaleIndicator];
    
    self.lblSaleIndicator = [[UILabel alloc] initWithFrame:self.vwSaleIndicator.bounds];
    [self.lblSaleIndicator setTextAlignment:NSTextAlignmentCenter];
    self.lblSaleIndicator.textColor = [UIColor whiteColor];
    self.lblSaleIndicator.text = @"Hot Deal";
    self.lblSaleIndicator.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont
                                                size:QTY_INDICATOR_FONT];
    self.lblAddress.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                           size:ADDRESS_FONTSIZE];
    [self.vwSaleIndicator addSubview:self.lblSaleIndicator];
    
    self.vwDevider = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewMainContent.frame.size.height-10, width, 10)];
    [self.vwDevider setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
    [self.viewMainContent addSubview:self.vwDevider];
    
    
   
}
-(void)setEshopProduct:(AAEShopProduct *)eshopProduct
{
    eShopProduct_ = eshopProduct;
   
    [self populateViews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)populateViews
{
    NSString *imageUrlString;
     NSString* previousProductPrice;
    NSString* currentProductPrice;
    NSString *prodDesc;
    NSString *prodrating;
    NSString *selectedCurrencyKey = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECTED_CURRENCY];
    if (selectedCurrencyKey == nil) {
        selectedCurrencyKey = [AAAppGlobals sharedInstance].currency_code;
    }
    selectedCurrencyKey = [AAAppGlobals sharedInstance].currency_symbol;
    float currencyMultiplier = [[[[AAAppGlobals sharedInstance] currecyDict] valueForKey:selectedCurrencyKey] floatValue];
    if (currencyMultiplier == 0) {
        currencyMultiplier = 1.0f;
        selectedCurrencyKey = [AAAppGlobals sharedInstance].currency_symbol;
    }
    
    
    if ([AAAppGlobals sharedInstance].disablePayment && self.cartItem != nil) {
        imageUrlString = self.cartItem.productImageURLString;
        float currentprice, prevprice;
//        currentprice =
        previousProductPrice = [NSString stringWithFormat:@"%@%@",/*[AAAppGlobals sharedInstance].currency_code*/selectedCurrencyKey,self.cartItem.previousProductPrice];
        currentProductPrice = [NSString stringWithFormat:@"%@%@",/*[AAAppGlobals sharedInstance].currency_code*/selectedCurrencyKey,self.cartItem.currentProductPrice];
        prodDesc = self.cartItem.productShortDescription;
        prodrating = self.cartItem.productDescription;
    }else{
        float currentprice,prevprice;
        if (self.eshopProduct.previousProductPrice != nil) {
            prevprice = [self.eshopProduct.previousProductPrice floatValue]* currencyMultiplier;
            NSString *prevpriceWithconverion = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:prevprice];
            previousProductPrice = [NSString stringWithFormat:@"%@%@",/*[AAAppGlobals sharedInstance].currency_code*/selectedCurrencyKey,prevpriceWithconverion];
        }else{
            prevprice = 0.0;
            previousProductPrice = @"";
        }
        currentprice = [self.eshopProduct.currentProductPrice floatValue]*currencyMultiplier;
        
        NSString *currenctPriceWithConversion = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:currentprice];
        imageUrlString = self.eshopProduct.productImageURLString;
        
        currentProductPrice = [NSString stringWithFormat:@"%@%@",/*[AAAppGlobals sharedInstance].currency_code*/selectedCurrencyKey,currenctPriceWithConversion];
        prodDesc = self.eshopProduct.productShortDescription;
        prodrating = self.eshopProduct.productRating;
    }
    CGSize disctanceSize;
    if ([[AAAppGlobals sharedInstance].retailer.enableDiscovery isEqualToString:@"1"]) {
        NSString *distance = [[AAAppGlobals sharedInstance] getDisctanceFrom:[AAAppGlobals
                                                                              sharedInstance].targetLat
                                                                     andLong:[AAAppGlobals
                                                                              sharedInstance].targetLong
                                                                       toLat:[self.eshopProduct.outletLat doubleValue]
                                                                     andLong:[self.eshopProduct.outletLong doubleValue]];
        self.lblDistance.text = [NSString stringWithFormat:@"%@ KM",distance];
        disctanceSize = [AAUtils getTextSizeWithFont:self.lblDistance.font andText:self.lblDistance.text andMaxWidth:MAXFLOAT];
        self.lblDistance.frame = CGRectMake(self.imgViewProductImage.frame.size.width - disctanceSize.width-15, 5, disctanceSize.width, disctanceSize.height);
            self.lblDistance.hidden = false;
        
    }else{
        disctanceSize.height = 0;
        disctanceSize.width = 0;
        self.lblDistance.hidden = true;
    }
    
    CGSize shortDescriptionLabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHORTDESC_FONTSIZE] andText:prodDesc andMaxWidth:self.imgViewProductImage.frame.size.width- (2*MAIN_VIEW_PADDING )- disctanceSize.width -10 ];
    
    //TODO - Multiple Images issue
    NSURL* imageUrl = [NSURL URLWithString: imageUrlString];
    [self.imgViewProductImage setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
//    [self.imgViewProductImage setContentMode:
//     UIViewContentModeScaleAspectFill];
    [self.imgViewProductImage setClipsToBounds:YES];
    
    self.lblDiscountPercentage.text = self.eshopProduct.offpeak_discount;
    
    
    NSInteger bottomY = 0;
    
   
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    float currentPriceOriginX;
    if (self.eshopProduct.previousProductPrice != nil) {
        NSMutableAttributedString *attStringPreviousProductPrice = [[NSMutableAttributedString alloc] initWithString:previousProductPrice attributes:attributes];
        
        CGSize previousPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE] andText:previousProductPrice andMaxWidth:175 ];
        float prevStartY = (shortDescriptionLabelSize.height+10 -previousPricelabelSize.height);
        [self.lblProductPreviousPrice setFrame:CGRectMake(LABEL_VIEW_LEFT_PADDING,
                                                          shortDescriptionLabelSize.height+18,
                                                          previousPricelabelSize.width,
                                                          previousPricelabelSize.height)];
        [self.lblProductPreviousPrice setAttributedText:attStringPreviousProductPrice];
        [self.lblProductPreviousPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE]];
        [self.lblProductPreviousPrice setBackgroundColor:[UIColor clearColor]];
//        [self.lblProductPreviousPrice setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        self.lblProductPreviousPrice.hidden = false;
        currentPriceOriginX = self.lblProductPreviousPrice.frame.origin.x + self.lblProductPreviousPrice.frame.size.width + 3;
    }else{
        self.lblProductPreviousPrice.hidden = true;
        currentPriceOriginX = LABEL_VIEW_LEFT_PADDING;
    }
    
//    CGPoint center = self.ratingView.center;
//    center.y = self.lblProductPreviousPrice.center.y;
//    self.ratingView.center = center;
//    
//    CGRect ratingFrame = self.ratingView.frame;
//    ratingFrame.origin.x = self.imgViewProductImage.frame.size.width - ratingFrame.size.width-15;;
//    self.ratingView.frame = ratingFrame;
    
    
    
    
    CGSize currentPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FONT_SIZE_NEW_PRICE] andText:currentProductPrice andMaxWidth:175];
   float newStartY = (PRICE_VIEW_HEIGHT-currentPricelabelSize.height)/2;
    [self.lblProductCurrentPrice setFrame:CGRectMake( currentPriceOriginX,
                                                    shortDescriptionLabelSize.height+15,
                                                     currentPricelabelSize.width,
                                                     currentPricelabelSize.height)];
    [self.lblProductCurrentPrice setText:currentProductPrice];
    [self.lblProductCurrentPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FONT_SIZE_NEW_PRICE]];
    [self.lblProductCurrentPrice setBackgroundColor:[UIColor clearColor]];
   // [self.lblProductCurrentPrice setTextColor:[[AAColor sharedInstance] eShopCardTextColor]];
    
     [self.lblProductCurrentPrice setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
   
    
    if ([AAAppGlobals sharedInstance].disablePayment && self.cartItem != nil) {
         bottomY = self.lblProductCurrentPrice.frame.origin.y;
    }else{
        bottomY = [[AAAppGlobals sharedInstance] getImageHeight];
    }
    self.lblAddress.text = self.eshopProduct.outletName;
    float maxwidth = SCREEN_WIDTH - self.lblProductCurrentPrice.frame.origin.x + currentPricelabelSize.width+10 - (2*LABEL_VIEW_LEFT_PADDING);
    CGSize addressSize = [AAUtils getTextSizeWithFont:self.lblAddress.font andText:self.lblAddress.text andMaxWidth:maxwidth];
    self.lblAddress.frame = CGRectMake(SCREEN_WIDTH-LABEL_VIEW_LEFT_PADDING-addressSize.width, shortDescriptionLabelSize.height+15, addressSize.width, 20);
    CGRect imgFrame = self.imgPin.frame;
    imgFrame.origin.x = self.lblAddress.frame.origin.x - imgFrame.size.width -5;
    imgFrame.origin.y = self.lblAddress.frame.origin.y;
    self.imgPin.frame = imgFrame;
    
    
    [self.lblProductShortDescription setFrame:CGRectMake( LABEL_VIEW_LEFT_PADDING, 10, shortDescriptionLabelSize.width, shortDescriptionLabelSize.height)];
    [self.lblProductShortDescription setText:prodDesc];
    [self.lblProductShortDescription setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHORTDESC_FONTSIZE]];
    [self.lblProductShortDescription setNumberOfLines:0];
    [self.lblProductShortDescription setBackgroundColor:[UIColor clearColor]];
    [self.lblProductShortDescription setTextColor:[UIColor blackColor]];
    [self.lblProductShortDescription setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    CGRect dividerFrame  = self.vwDevider.frame;
    dividerFrame.origin.y = self.priceView.frame.origin.y+self.priceView.frame.size.height + 30;
    self.vwDevider.frame = dividerFrame;

    
    CGFloat overlayViewHeight = self.imgViewProductImage.frame.size.height - self.lblProductShortDescription.frame.origin.y + OVERLAY_TOP_PADDING + IMAGE_VIEW_PADDING;
    if(![self overlayLayer])
    {
    [self.overlayView setFrame:CGRectMake(IMAGE_VIEW_PADDING, self.lblProductShortDescription.frame.origin.y -OVERLAY_TOP_PADDING, self.imgViewProductImage.frame.size.width, overlayViewHeight)];
        
    [AAStyleHelper addGradientOverlayToView:self.overlayView withFrame:self.overlayView.frame withColor:[UIColor blackColor]];
        self.overlayLayer = YES;
    }
    else
    {
        [self.overlayView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.overlayView setFrame:CGRectMake(IMAGE_VIEW_PADDING, self.lblProductShortDescription.frame.origin.y -OVERLAY_TOP_PADDING, self.imgViewProductImage.frame.size.width, overlayViewHeight)];
         [AAStyleHelper addGradientOverlayToView:self.overlayView withFrame:self.overlayView.frame withColor:[UIColor blackColor]];
    }
   
    [self.overlayView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    
    CGPoint center1 = self.lblProductPreviousPrice.center;
    center1.y = self.lblProductCurrentPrice.center.y;
    self.lblProductPreviousPrice.center = center1;
    
    if (self.eshopProduct.availQty != nil) {
        self.lblQtyIndicator.text = [NSString stringWithFormat:@"%@ Sold",self.eshopProduct.availQty];
        self.vwQtyIndicator.hidden = false;

    }else{
        self.vwQtyIndicator.hidden = true;
//        self.lblQtyIndicator.text = @"Sold";
    }
    
    if (self.eshopProduct.onSale != nil && [self.eshopProduct.onSale integerValue]==1) {
        self.vwSaleIndicator.hidden = false;
    }else{
        self.vwSaleIndicator.hidden = true;
    }
    CGPoint center = self.lblDistance.center;
    center.y = self.lblProductShortDescription.center.y;
    self.lblDistance.center = center;
    
   
}


-(CGSize)getLabelSizeWithFont : (UIFont*)font andText : (NSString*)text
{
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(self.viewMainContent.frame.size.width - 2*LABEL_VIEW_LEFT_PADDING, 80)];
    return labelSize;
}


@end

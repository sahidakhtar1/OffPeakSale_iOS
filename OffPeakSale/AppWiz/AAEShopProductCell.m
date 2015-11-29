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
NSInteger const QTY_INDICATOR_WIDTH = 80.0;
NSInteger const QTY_INDICATOR_HEIGHT = 30.0;


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
    _vwQtyIndicator.backgroundColor = [UIColor blackColor];
    _vwQtyIndicator.alpha = 0.5;
    [self.viewMainContent addSubview:self.vwQtyIndicator];
    
    self.lblQtyIndicator = [[UILabel alloc] initWithFrame:self.vwQtyIndicator.bounds];
    [self.lblQtyIndicator setTextAlignment:NSTextAlignmentCenter];
    self.lblQtyIndicator.textColor = [UIColor whiteColor];
    self.lblQtyIndicator.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                                size:QTY_INDICATOR_FONT];
    [self.vwQtyIndicator addSubview:self.lblQtyIndicator];
    
    
    
    self.vwSaleIndicator = [[UIView alloc]
                           initWithFrame:CGRectMake(0,
                                                    
                                                    0,
                                                    QTY_INDICATOR_WIDTH,
                                                    QTY_INDICATOR_HEIGHT)];
    self.vwSaleIndicator.backgroundColor = [UIColor colorWithRed:230.0f/255.0f
                                                           green:46.0f/255.0f
                                                            blue:37.0f/255.0f
                                                           alpha:1];
    //[self.viewMainContent addSubview:self.vwSaleIndicator];
    
    self.lblSaleIndicator = [[UILabel alloc] initWithFrame:self.vwSaleIndicator.bounds];
    [self.lblSaleIndicator setTextAlignment:NSTextAlignmentCenter];
    self.lblSaleIndicator.textColor = [UIColor whiteColor];
    self.lblSaleIndicator.text = @"Sale";
    self.lblSaleIndicator.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                                size:QTY_INDICATOR_FONT];
    self.lblAddress.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                           size:ADDRESS_FONTSIZE];
    //[self.vwSaleIndicator addSubview:self.lblSaleIndicator];
    
   
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
    float currencyMultiplier = [[[[AAAppGlobals sharedInstance] currecyDict] valueForKey:selectedCurrencyKey] floatValue];
    if (currencyMultiplier == 0) {
        currencyMultiplier = 1.0f;
        selectedCurrencyKey = [AAAppGlobals sharedInstance].currency_code;
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
    
    self.lblDistance.text = @"12KM";
    CGSize disctanceSize = [AAUtils getTextSizeWithFont:self.lblDistance.font andText:self.lblDistance.text andMaxWidth:MAXFLOAT];
    self.lblDistance.frame = CGRectMake(self.imgViewProductImage.frame.size.width - disctanceSize.width-15, 5, disctanceSize.width, disctanceSize.height);
    
    CGSize shortDescriptionLabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHORTDESC_FONTSIZE] andText:prodDesc andMaxWidth:self.imgViewProductImage.frame.size.width- (2*MAIN_VIEW_PADDING )- disctanceSize.width -10 ];
    
    //TODO - Multiple Images issue
    NSURL* imageUrl = [NSURL URLWithString: imageUrlString];
    [self.imgViewProductImage setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
//    [self.imgViewProductImage setContentMode:
//     UIViewContentModeScaleAspectFill];
    [self.imgViewProductImage setClipsToBounds:YES];
    
    NSInteger bottomY = 0;
    
   
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    float currentPriceOriginX;
    if (self.eshopProduct.previousProductPrice != nil) {
        NSMutableAttributedString *attStringPreviousProductPrice = [[NSMutableAttributedString alloc] initWithString:previousProductPrice attributes:attributes];
        
        CGSize previousPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE] andText:previousProductPrice andMaxWidth:175 ];
        float prevStartY = (shortDescriptionLabelSize.height+5 -previousPricelabelSize.height);
        [self.lblProductPreviousPrice setFrame:CGRectMake(LABEL_VIEW_LEFT_PADDING,
                                                          shortDescriptionLabelSize.height+10,
                                                          previousPricelabelSize.width,
                                                          previousPricelabelSize.height)];
        [self.lblProductPreviousPrice setAttributedText:attStringPreviousProductPrice];
        [self.lblProductPreviousPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE]];
        [self.lblProductPreviousPrice setBackgroundColor:[UIColor clearColor]];
        //[self.lblProductPreviousPrice setTextColor:[[AAColor sharedInstance] eShopCardTextColor]];
        [self.lblProductPreviousPrice setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
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
                                                    shortDescriptionLabelSize.height+10,
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
    self.lblAddress.text = @"safafsdsd";
    float maxwidth = SCREEN_WIDTH - self.lblProductCurrentPrice.frame.origin.x + currentPricelabelSize.width+10 - (2*LABEL_VIEW_LEFT_PADDING);
    CGSize addressSize = [AAUtils getTextSizeWithFont:self.lblAddress.font andText:self.lblAddress.text andMaxWidth:maxwidth];
    self.lblAddress.frame = CGRectMake(SCREEN_WIDTH-LABEL_VIEW_LEFT_PADDING-addressSize.width, shortDescriptionLabelSize.height+10, addressSize.width, 20);
    CGRect imgFrame = self.imgPin.frame;
    imgFrame.origin.x = self.lblAddress.frame.origin.x - imgFrame.size.width -5;
    imgFrame.origin.y = self.lblAddress.frame.origin.y;
    self.imgPin.frame = imgFrame;
    
    
    [self.lblProductShortDescription setFrame:CGRectMake( LABEL_VIEW_LEFT_PADDING, 5, shortDescriptionLabelSize.width, shortDescriptionLabelSize.height)];
    [self.lblProductShortDescription setText:prodDesc];
    [self.lblProductShortDescription setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:SHORTDESC_FONTSIZE]];
    [self.lblProductShortDescription setNumberOfLines:0];
    [self.lblProductShortDescription setBackgroundColor:[UIColor clearColor]];
    [self.lblProductShortDescription setTextColor:[UIColor blackColor]];
    [self.lblProductShortDescription setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

    
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
        self.lblQtyIndicator.text = [NSString stringWithFormat:@"%@ sold",self.eshopProduct.availQty];
        self.vwQtyIndicator.hidden = false;

    }
    
    if (self.eshopProduct.onSale != nil && [self.eshopProduct.onSale integerValue]==1) {
        self.vwSaleIndicator.hidden = false;
    }else{
        self.vwSaleIndicator.hidden = true;
    }
    
   
}


-(CGSize)getLabelSizeWithFont : (UIFont*)font andText : (NSString*)text
{
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(self.viewMainContent.frame.size.width - 2*LABEL_VIEW_LEFT_PADDING, 80)];
    return labelSize;
}


@end

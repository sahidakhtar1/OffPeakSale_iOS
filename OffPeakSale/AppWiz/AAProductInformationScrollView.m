//
//  AAProductInformationScrollView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 18/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAProductInformationScrollView.h"
#import "AARatingViewCell.h"
#import "AAProfileViewController.h"

#import "AAMediaItem.h"
#import "AABannerView.h"
#import "AAEShopProductOptions.h"
#import "AAThemeCircularView.h"
@implementation AAProductInformationScrollView

@synthesize banner;
@synthesize option1,option2;
static NSInteger const LABEL_VIEW_LEFT_PADDING = 15;
static NSInteger const IMAGE_VIEW_MARGIN = 0;
static NSInteger const IMAGE_VIEW_HEIGHT = 195;
static NSInteger const IMAGE_VIEW_WIDTH = 300;
static NSInteger const PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN = 15;
static NSInteger const PRODUCT__SHORT_DESCRIPTION_LABEL_TEXT_MARGIN = 5;
static NSInteger const PRODUCT_HEADING_MARGIN = 20;
static NSInteger const PRODOCT_BODY_MARGIN = 15;
static NSInteger const QTY_INDICATOR_WIDTH = 80.0;
static NSInteger const QTY_INDICATOR_HEIGHT = 30.0;
static NSInteger const CIRCULAR_VIEW_WIDTH = 90.0;
static NSInteger const CIRCULAR_VIEW_HEIGHT = 50.0;
//static NSInteger const INTERVIEW_SPACING = 20;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initValues];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initValues];
    }
    return self;
}

-(void)initValues
{
    self.fontHeading = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_HEADING_FONTSIZE];//[UIFont boldSystemFontOfSize:15.0];
    self.fontBody = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_BODY_FONTSIZE];// [UIFont systemFontOfSize:12.0];
    self.fontProductShortDescription = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_SHORTDESC_FONTSIZE];//[UIFont systemFontOfSize:17.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)refreshScrollView
{
    UITapGestureRecognizer* tpgrDropDownItemView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDown)];
    [self addGestureRecognizer:tpgrDropDownItemView];
    CGFloat currentY = 0;
//    if ([self.product.product_imgs count]>0) {
//        currentY = [self addProductImage];
//    }
    //TODO - Multiple Images issue
    if(![self.product.productImageURLString isEqualToString:@""])
    {
     currentY = [self addProductImage];
    }
    if(![self.product.productShortDescription
         isEqualToString:@""])
    {
        currentY = [self addProductShortDescriptionWithOrgY:currentY];
    }
    if ([[AAAppGlobals sharedInstance].retailer.enableRewards isEqualToString:@"1"]) {
        currentY = [self addRewardsAtY:currentY];
    }
//    if ([AAAppGlobals sharedInstance].enableRating || [[AAAppGlobals sharedInstance].retailer.enableRating isEqualToString:@"1"]) {
//        currentY  = [self addProductRatingWithOrgY:currentY];
//    }
//    if ([self.product.product_options count]>0) {
//        AAEShopProductOptions *option1 = [self.product.product_options objectAtIndex:0];
//        currentY = [self addVariantOption1At:currentY withOption:option1.optionLabel];
//        if ([self.product.product_options count]>1) {
//            AAEShopProductOptions *option2 = [self.product.product_options objectAtIndex:1];
//            currentY = [self addVariantOption2At:currentY withOption:option2.optionLabel];
//            
//        }
//    }
    
    
    currentY = [self addProductDetails:currentY];
     [self setContentSize:CGSizeMake(self.frame.size.width, currentY + 10)];
}




-(CGFloat)addProductImage
{
    
   //NSURL* imageURL = [NSURL URLWithString:self.product.productImageURLString];
    float imageWidth = [UIScreen mainScreen].bounds.size.width - 2*IMAGE_VIEW_MARGIN;
    NSInteger imgContainerPadding = (self.frame.size.width - imageWidth - 2*IMAGE_VIEW_MARGIN)/2;
    UIView* viewImgContainer = [[UIView alloc] initWithFrame:CGRectMake(IMAGE_VIEW_MARGIN, IMAGE_VIEW_MARGIN, imageWidth, [[AAAppGlobals sharedInstance] getImageHeight])];
    
    viewImgContainer.tag = 100;
    [viewImgContainer setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewImgContainer];
    
    //TODO - Multiple Images issue
    AAMediaItem *mediaItem = [[AAMediaItem alloc] init];
    mediaItem.mediaUrl = self.product.productImageURLString;
    mediaItem.mediaType = RETAILER_FILE_TYPE_IMAGE;
    
    AAMediaItem *mediaItem2 = [[AAMediaItem alloc] init];
    //mediaItem2.mediaUrl = self.product.productImageURLString;
    mediaItem2.mediaType = RETAILER_FILE_TYPE_YOUTUBE_VIDEO;
    
    self.banner = [[AABannerView alloc] initWithFrame:viewImgContainer.bounds];
    self.banner.delegate = self;
    self.banner.bannerItems = [NSArray arrayWithArray:self.product.product_imgs];
    [self.banner populateItems];
    [viewImgContainer addSubview:self.banner];
    CGFloat currentY = viewImgContainer.frame.origin.y + viewImgContainer.frame.size.height + 10;
    
    UIView *vwQtyIndicator;
    UILabel *lblQtyIndicator;
    UIView *vwSaleIndicator;
    UILabel *lblSaleIndicator;
    if (self.product.availQty != nil) {
    vwQtyIndicator = [[UIView alloc]
                           initWithFrame:CGRectMake(imageWidth-QTY_INDICATOR_WIDTH,
                                                    0,
                                                    QTY_INDICATOR_WIDTH,
                                                    QTY_INDICATOR_HEIGHT)];
    vwQtyIndicator.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.5f];
    
    lblQtyIndicator = [[UILabel alloc] initWithFrame:vwQtyIndicator.bounds];
    [lblQtyIndicator setTextAlignment:NSTextAlignmentCenter];
    lblQtyIndicator.textColor = [UIColor whiteColor];
    lblQtyIndicator.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                                size:QTY_INDICATOR_FONT];
    [vwQtyIndicator addSubview:lblQtyIndicator];

    [viewImgContainer addSubview:vwQtyIndicator];
    
    lblQtyIndicator.text = [NSString stringWithFormat:@"%@ sold",self.product.availQty];
    vwQtyIndicator.hidden = false;
        
    }else{
//        vwQtyIndicator.hidden = true;
    }
    
    if (self.product.onSale != nil && [self.product.onSale integerValue]==1) {
        vwSaleIndicator = [[UIView alloc]
                                initWithFrame:CGRectMake(0,
                                                         
                                                         0,
                                                         QTY_INDICATOR_WIDTH,
                                                         QTY_INDICATOR_HEIGHT)];
        vwSaleIndicator.backgroundColor = [UIColor colorWithRed:230.0f/255.0f
                                                               green:46.0f/255.0f
                                                                blue:37.0f/255.0f
                                                               alpha:1];
        
        lblSaleIndicator = [[UILabel alloc] initWithFrame:vwSaleIndicator.bounds];
        [lblSaleIndicator setTextAlignment:NSTextAlignmentCenter];
        lblSaleIndicator.textColor = [UIColor whiteColor];
        lblSaleIndicator.text = @"Sale";
        lblSaleIndicator.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                                     size:QTY_INDICATOR_FONT];
        [vwSaleIndicator addSubview:lblSaleIndicator];
        [viewImgContainer addSubview:vwSaleIndicator];
        
    vwSaleIndicator.hidden = false;
    }else{
        vwSaleIndicator.hidden = true;
    }
    
    
    AAThemeCircularView *discountView;
    UILabel *lblDiscountPercentage;
    discountView = [[AAThemeCircularView alloc]
                         initWithFrame:CGRectMake(viewImgContainer.frame.size.width -
                                                  LABEL_VIEW_LEFT_PADDING -CIRCULAR_VIEW_WIDTH
                                                  ,viewImgContainer.frame.size.height -
                                                  LABEL_VIEW_LEFT_PADDING -CIRCULAR_VIEW_HEIGHT ,
                                                  CIRCULAR_VIEW_WIDTH,
                                                  CIRCULAR_VIEW_HEIGHT)];
    [discountView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    discountView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:.5f];
    [viewImgContainer addSubview:discountView];
    
    lblDiscountPercentage = [[UILabel alloc] initWithFrame:CGRectMake(7,
                                                                      CIRCULAR_VIEW_HEIGHT/2-15,
                                                                      CIRCULAR_VIEW_WIDTH/2+2,
                                                                      30)];
    [lblDiscountPercentage setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:QTY_DISCOUNT_VALUE_FONT]];
    [lblDiscountPercentage setTextAlignment:NSTextAlignmentRight];
    lblDiscountPercentage.textColor = [UIColor whiteColor];
    [discountView addSubview:lblDiscountPercentage];
    lblDiscountPercentage.text = self.product.offpeak_discount;
    
    UILabel *lblOff = [[UILabel alloc] initWithFrame:CGRectMake(CIRCULAR_VIEW_WIDTH/2+10, CIRCULAR_VIEW_HEIGHT/2-4, CIRCULAR_VIEW_WIDTH/2, 15)];
    [lblOff setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:QTY_DISCOUNT_LBL_FONT]];
    [lblOff setTextAlignment:NSTextAlignmentLeft];
    lblOff.text = @"Off";
    lblOff.textColor = [UIColor whiteColor];
    [discountView addSubview:lblOff];
    
    UILabel *percent = [[UILabel alloc] initWithFrame:CGRectMake(CIRCULAR_VIEW_WIDTH/2+10, CIRCULAR_VIEW_HEIGHT/2-15, CIRCULAR_VIEW_WIDTH/2, 15)];
    [percent setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:QTY_DISCOUNT_LBL_FONT]];
    [percent setTextAlignment:NSTextAlignmentLeft];
    percent.text = @"%";
    percent.textColor = [UIColor whiteColor];
    [discountView addSubview:percent];
    
    return currentY;
    
}

-(void)imageTapped{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(presentImageZoomWithImage:)]) {
        [self.delegate presentImageZoomWithImage:prodImage];
    }
}
-(CGFloat)addProductShortDescriptionWithOrgY : (CGFloat)orgY
{
    UILabel *lblDistance = [[UILabel alloc] init];
    CGSize disctanceSize;
    if ([[AAAppGlobals sharedInstance].retailer.enableDiscovery isEqualToString:@"1"]) {
        lblDistance.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:DISTANCE_FONTSIZE];
        lblDistance.textColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
        NSString *distance = [[AAAppGlobals sharedInstance] getDisctanceFrom:[AAAppGlobals
                                                                              sharedInstance].targetLat
                                                                     andLong:[AAAppGlobals
                                                                              sharedInstance].targetLong
                                                                       toLat:[self.product.outletLat doubleValue]
                                                                     andLong:[self.product.outletLong doubleValue]];
        lblDistance.text = [NSString stringWithFormat:@"%@KM",distance];
        disctanceSize = [AAUtils getTextSizeWithFont:lblDistance.font andText:lblDistance.text andMaxWidth:MAXFLOAT];
        lblDistance.frame = CGRectMake(self.frame.size.width - disctanceSize.width-15, orgY, disctanceSize.width, disctanceSize.height);
        [self addSubview:lblDistance];
    }else{
        disctanceSize.width = 0;
        disctanceSize.height = 0;
    }
    
    CGSize productTextSize = [AAUtils getTextSizeWithFont:self.fontProductShortDescription andText:self.product.productShortDescription andMaxWidth:self.frame.size.width - 2*PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN - disctanceSize.width-10];
    
    UIView* viewProductDescriptionContainer = [[UIView alloc] initWithFrame:CGRectMake(PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, orgY, self.frame.size.width - 2*PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN- disctanceSize.width-10, productTextSize.height + PRODUCT__SHORT_DESCRIPTION_LABEL_TEXT_MARGIN*2)];
    [viewProductDescriptionContainer setBackgroundColor:[UIColor whiteColor]];

    UILabel* lblProductShortDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, PRODUCT__SHORT_DESCRIPTION_LABEL_TEXT_MARGIN, productTextSize.width, productTextSize.height )];
    [lblProductShortDescription setFont:self.fontProductShortDescription];
    [lblProductShortDescription setText:self.product.productShortDescription];
    [lblProductShortDescription setNumberOfLines:0];
    [viewProductDescriptionContainer addSubview:lblProductShortDescription];
    [self addSubview:viewProductDescriptionContainer];
    
    
    
    CGFloat currentY = viewProductDescriptionContainer.frame.origin.y + viewProductDescriptionContainer.frame.size.height + 5;
    
    return currentY;
}
-(CGFloat)addRewardsAtY:(CGFloat)orgY{
    UILabel *lblProductPreviousPrice = [[UILabel alloc] init];
    UILabel *lblProductCurrentPrice = [[UILabel alloc] init];
    UILabel *lblAddress = [[UILabel alloc] init];
    [self addSubview:lblProductPreviousPrice];
    [self addSubview:lblProductCurrentPrice];
    [self addSubview:lblAddress];

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
    NSString* previousProductPrice;
    NSString* currentProductPrice;
    float currentprice,prevprice;
    if (self.product.previousProductPrice != nil) {
        prevprice = [self.product.previousProductPrice floatValue]* currencyMultiplier;
        NSString *prevpriceWithconverion = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:prevprice];
        previousProductPrice = [NSString stringWithFormat:@"%@%@",/*[AAAppGlobals sharedInstance].currency_code*/selectedCurrencyKey,prevpriceWithconverion];
    }else{
        prevprice = 0.0;
        previousProductPrice = @"";
    }
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    currentprice = [self.product.currentProductPrice floatValue]*currencyMultiplier;
    
    NSString *currenctPriceWithConversion = [[AAAppGlobals sharedInstance] getPriceStrfromFromPrice:currentprice];
    
    currentProductPrice = [NSString stringWithFormat:@"%@%@",selectedCurrencyKey,currenctPriceWithConversion];
    float currentPriceOriginX;
    if (self.product.previousProductPrice != nil) {
        NSMutableAttributedString *attStringPreviousProductPrice = [[NSMutableAttributedString alloc] initWithString:previousProductPrice attributes:attributes];
        
        CGSize previousPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE] andText:previousProductPrice andMaxWidth:175 ];
        [lblProductPreviousPrice setFrame:CGRectMake(15,
                                                          orgY,
                                                          previousPricelabelSize.width,
                                                          previousPricelabelSize.height)];
        [lblProductPreviousPrice setAttributedText:attStringPreviousProductPrice];
        [lblProductPreviousPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE]];
        [lblProductPreviousPrice setBackgroundColor:[UIColor clearColor]];
        //[self.lblProductPreviousPrice setTextColor:[[AAColor sharedInstance] eShopCardTextColor]];
        [lblProductPreviousPrice setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        lblProductPreviousPrice.hidden = false;
        currentPriceOriginX = lblProductPreviousPrice.frame.origin.x + lblProductPreviousPrice.frame.size.width + 3;
    }else{
        lblProductPreviousPrice.hidden = true;
        currentPriceOriginX = LABEL_VIEW_LEFT_PADDING;
    }
    CGSize currentPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FONT_SIZE_NEW_PRICE] andText:currentProductPrice andMaxWidth:175];
    [lblProductCurrentPrice setFrame:CGRectMake( currentPriceOriginX,
                                                     orgY,
                                                     currentPricelabelSize.width,
                                                     currentPricelabelSize.height)];
    [lblProductCurrentPrice setText:currentProductPrice];
    [lblProductCurrentPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FONT_SIZE_NEW_PRICE]];
    [lblProductCurrentPrice setBackgroundColor:[UIColor clearColor]];
    lblAddress.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont
                                      size:ADDRESS_FONTSIZE];
    
    UIImageView *imgPin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [imgPin setImage:[UIImage imageNamed:@"locate_us"]];

    lblAddress.text = self.product.outletName;
    float maxwidth = SCREEN_WIDTH - lblProductCurrentPrice.frame.origin.x + currentPricelabelSize.width+10 - (2*LABEL_VIEW_LEFT_PADDING);
    CGSize addressSize = [AAUtils getTextSizeWithFont:lblAddress.font andText:lblAddress.text andMaxWidth:maxwidth];
    lblAddress.frame = CGRectMake(SCREEN_WIDTH-LABEL_VIEW_LEFT_PADDING-addressSize.width, orgY, addressSize.width, 20);
    CGRect imgFrame = imgPin.frame;
    imgFrame.origin.x = lblAddress.frame.origin.x - imgFrame.size.width -5;
    imgFrame.origin.y = lblAddress.frame.origin.y;
    imgPin.frame = imgFrame;
    [self addSubview:imgPin];
    
    CGPoint centerPrevPrice = lblProductPreviousPrice.center;
    CGPoint centerCurrectPrice = lblProductCurrentPrice.center;
    centerCurrectPrice.y = centerPrevPrice.y;
    lblProductCurrentPrice.center = centerCurrectPrice;
    CGPoint centerimgPin = imgPin.center;
    centerimgPin.y = centerPrevPrice.y;
    imgPin.center = centerimgPin;
    CGPoint centerAddress = lblAddress.center;
    centerAddress.y = centerPrevPrice.y;
    lblAddress.center = centerAddress;
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setFrame:CGRectMake(lblAddress.frame.origin.x -20,
                                     lblAddress.frame.origin.y-10,
                                     lblAddress.frame.size.width+20,
                                     lblAddress.frame.size.height+15)];
    [self addSubview:locationBtn];
    [locationBtn setBackgroundColor:[UIColor clearColor]];
    [locationBtn addTarget:self action:@selector(locationTapped) forControlEvents:UIControlEventTouchUpInside];
    
    return orgY+currentPricelabelSize.height+8;
}
-(void)locationTapped{
    if ([self.delegate respondsToSelector:@selector(locationTapped)]) {
        [self.delegate locationTapped];
    }
}
-(CGFloat)addProductRatingWithOrgY : (CGFloat)orgY
{
    
    AARatingViewCell *ratingCell = [[AARatingViewCell alloc] initWithFrame:CGRectMake(PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, orgY, self.frame.size.width-PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, 44)];
    [self addSubview:ratingCell];
    ratingCell.delegate = self;
    CGFloat currentY = orgY+44 + 5;
    
    return currentY;
}

-(CGFloat)addProductDetails : (CGFloat)orgY
{
    CGFloat currentY = orgY;
    
    if(![self.product.productDescription isEqualToString:@""])
    {
        currentY = [self addHeadingView:currentY withText:@"Product Details"];
        currentY = [self addBodyLabel:currentY withText:self.product.productDescription];
    }
//    if(![self.product.productWorkingInformation isEqualToString:@""])
//    {
//        currentY = [self addHeadingView:currentY withText:@"How It Works"];
//        currentY = [self addBodyLabel:currentY withText:self.product.productWorkingInformation];
//    }
//    if ([self.product.testimonials length] > 0) {
//        currentY = [self addHeadingView:currentY withText:@"Testimonial"];
//        currentY = [self addBodyLabel:currentY withText:self.product.testimonials];
//    }
   
    return currentY;
}

-(CGFloat)addHeadingView : (CGFloat) orgY withText: (NSString*)headingText;
{
    AAThemeHeadingView* viewHeading = [[AAThemeHeadingView alloc] initWithFrame:CGRectMake(PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, orgY, self.frame.size.width - 2*PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, 30)];
    [viewHeading.lblHeading setFont:self.fontHeading];
    [viewHeading.lblHeading setText:headingText];
    
    [self addSubview:viewHeading];
    CGFloat currentY = viewHeading.frame.origin.y + viewHeading.frame.size.height + 13;
   
    
    
    return currentY;
}

-(CGFloat)addBodyLabel: (CGFloat) orgY withText: (NSString*)headingText;
{
    CGSize bodyLabelSize = [AAUtils getTextSizeWithFont:self.fontBody andText:headingText andMaxWidth: self.frame.size.width - 2*PRODOCT_BODY_MARGIN];
    
    UILabel* lblBody = [[UILabel alloc] initWithFrame:CGRectMake(PRODOCT_BODY_MARGIN, orgY, bodyLabelSize.width, bodyLabelSize.height)];
    [lblBody setFont:self.fontBody];
    [lblBody setText:headingText];
    [lblBody setNumberOfLines:0];
    
    [self addSubview:lblBody];
    CGFloat currentY = lblBody.frame.origin.y + lblBody.frame.size.height + 20;
    
    
    return currentY;
}
-(void)ratingDoneWithCount:(NSString*)rating{
    NSLog(@"rating done = %@",rating);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rateProductWithProductId:withRating:)]) {
        [self.delegate rateProductWithProductId:[NSString stringWithFormat:@"%d",self.product.productId] withRating:rating];
    }
}

-(CGFloat)addVariantOption1At:(CGFloat)originY withOption:(NSString*)optionName{
    
   self.option1 = [[AAVariantView alloc] init];
    self.option1.frame = CGRectMake(0, originY, [UIScreen mainScreen].bounds.size.width, 45);
    [self.option1.btnOptions setTag:1];
    self.option1.lblOptionlbl.text = optionName;
    [self.option1.btnOptions setTitle:[NSString stringWithFormat:@"Select %@",optionName] forState:UIControlStateNormal];
    self.option1.delegate = self;
    [self addSubview:self.option1];
    originY += 45;
    return originY;
}
-(CGFloat)addVariantOption2At:(CGFloat)originY withOption:(NSString*)optionName{
    
    self.option2 = [[AAVariantView alloc] init];
    self.option2.frame = CGRectMake(0, originY, [UIScreen mainScreen].bounds.size.width, 45);
    [self.option2.btnOptions setTag:2];
    self.option2.lblOptionlbl.text = optionName;
    [self.option2.btnOptions setTitle:[NSString stringWithFormat:@"Select %@",optionName] forState:UIControlStateNormal];
    self.option2.delegate = self;
    [self addSubview:self.option2];
    originY += 55;
    return originY;
}

-(void)option1Tapped{
    if (self.optionDropDown != nil) {
        [self.optionDropDown removeFromSuperview];
        self.optionDropDown = nil;
    }
    AAEShopProductOptions *option = [self.product.product_options objectAtIndex:0];
    NSArray *arr = [option.optionValue componentsSeparatedByString:@","];
    float height = 40;
    if ([arr count]<3) {
        height = [arr count]*height;
    }else{
        height = height*3;
    }
    self.optionDropDown = [[AAFilterDropDownScrollView alloc]
                           initWithFrame:CGRectMake(self.option1.btnOptions.frame.origin.x,
                                                    self.option1.frame.origin.y + self.option1.frame.size.height - 10,
                                                    self.option1.btnOptions.frame.size.width,
                                                    height)];
    self.optionDropDown.tag = 0;
    [self.optionDropDown setItemHeight:40];
    self.optionDropDown.dropDownDelegate = self;
    
    [self.optionDropDown setItems:arr];
    [self.optionDropDown refreshScrollView:true];
    
    
    [self addSubview:self.optionDropDown];
    CGRect frame =self.optionDropDown.frame;
   // frame.origin.y += self.option2
    [self scrollRectToVisible:frame animated:YES];
    [self.option1.btnOptions setTitle:self.selectedOption1 forState:UIControlStateNormal];
    
}
-(void)option2Tapped{
    if (self.optionDropDown != nil) {
        [self.optionDropDown removeFromSuperview];
        self.optionDropDown = nil;
    }
    AAEShopProductOptions *option = [self.product.product_options objectAtIndex:1];
    NSArray *arr = [option.optionValue componentsSeparatedByString:@","];
    float height = 40;
    if ([arr count]<3) {
        height = [arr count]*height;
    }else{
        height = height*3;
    }
    self.optionDropDown = [[AAFilterDropDownScrollView alloc]
                           initWithFrame:CGRectMake(self.option2.btnOptions.frame.origin.x,
                                                    self.option2.frame.origin.y + self.option2.frame.size.height - 10,
                                                    self.option2.btnOptions.frame.size.width,
                                                    90)];
    self.optionDropDown.tag = 1;
    [self.optionDropDown setItemHeight:40];
    self.optionDropDown.dropDownDelegate = self;
    [self.optionDropDown setItems:arr];
    [self.optionDropDown refreshScrollView:YES];
    
    
    [self addSubview:self.optionDropDown];
    
    [self scrollRectToVisible:self.optionDropDown.frame animated:YES];
    [self.option2.btnOptions setTitle:self.selectedOption2 forState:UIControlStateNormal];
    
}
-(void)showOptionDropDown:(int)optionIndex{
    switch (optionIndex) {
        case 1:
            [self option1Tapped];
            break;
        case 2:
            [self option2Tapped];
            break;
            
        default:
            break;
    }
}
#pragma mark - Scroll view delegate callbacks
-(void)onDropDownMenuItemSelected:(id)dropDownScrollView withItemName:(NSString *)itemName
{
    AAFilterDropDownScrollView *dropDown = (AAFilterDropDownScrollView*)dropDownScrollView;
    
    if(dropDown.tag == 0)
    {
        self.selectedOption1 = itemName;
        self.product.selectedOptionOne = itemName;
        [self.option1.btnOptions setTitle:itemName forState:UIControlStateNormal];
        
    }else
    {
        self.selectedOption2 = itemName;
        self.product.selectedOptionTwo = itemName;
       [self.option2.btnOptions setTitle:itemName forState:UIControlStateNormal];
        
    }
    
    [self.optionDropDown removeFromSuperview];
    
}
-(void)hideDropDown{
    [self.optionDropDown removeFromSuperview];
}
-(void)presentZoomViewWithImage:(UIImage*)image{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(presentImageZoomWithImage:)]) {
        [self.delegate presentImageZoomWithImage:image];
    }

}
@end

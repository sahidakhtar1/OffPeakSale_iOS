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

@implementation AAProductInformationScrollView

@synthesize banner;
@synthesize option1,option2;

static NSInteger const IMAGE_VIEW_MARGIN = 0;
static NSInteger const IMAGE_VIEW_HEIGHT = 195;
static NSInteger const IMAGE_VIEW_WIDTH = 300;
static NSInteger const PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN = 15;
static NSInteger const PRODUCT__SHORT_DESCRIPTION_LABEL_TEXT_MARGIN = 5;
static NSInteger const PRODUCT_HEADING_MARGIN = 20;
static NSInteger const PRODOCT_BODY_MARGIN = 15;
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
    if ([AAAppGlobals sharedInstance].enableRating || [[AAAppGlobals sharedInstance].retailer.enableRating isEqualToString:@"1"]) {
        currentY  = [self addProductRatingWithOrgY:currentY];
    }
    if ([self.product.product_options count]>0) {
        AAEShopProductOptions *option1 = [self.product.product_options objectAtIndex:0];
        currentY = [self addVariantOption1At:currentY withOption:option1.optionLabel];
        if ([self.product.product_options count]>1) {
            AAEShopProductOptions *option2 = [self.product.product_options objectAtIndex:1];
            currentY = [self addVariantOption2At:currentY withOption:option2.optionLabel];
            
        }
    }
    
    
    currentY = [self addProductDetails:currentY];
     [self setContentSize:CGSizeMake(self.frame.size.width, currentY + 10)];
}




-(CGFloat)addProductImage
{
    
   //NSURL* imageURL = [NSURL URLWithString:self.product.productImageURLString];
    float imageWidth = [UIScreen mainScreen].bounds.size.width - 2*IMAGE_VIEW_MARGIN;
    NSInteger imgContainerPadding = (self.frame.size.width - imageWidth - 2*IMAGE_VIEW_MARGIN)/2;
    UIView* viewImgContainer = [[UIView alloc] initWithFrame:CGRectMake(IMAGE_VIEW_MARGIN, IMAGE_VIEW_MARGIN, imageWidth, [[AAAppGlobals sharedInstance] getImageHeight])];
    
//    viewImgContainer.layer.borderColor = BOARDER_COLOR.CGColor;
//    viewImgContainer.layer.borderWidth = 1.0f;
    
    viewImgContainer.tag = 100;
    //[viewImgContainer.layer setShadowRadius:3];
    [viewImgContainer setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewImgContainer];
    
    
//    UIImageView* imgViewProductImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, IMAGE_VIEW_HEIGHT)];
//    CGRect frame  = imgViewProductImage.frame;
//    [imgViewProductImage setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:frame];
//        [btn addTarget:self action:@selector(imageTapped) forControlEvents:UIControlEventTouchUpInside];
//        [viewImgContainer addSubview:btn];
//        prodImage = image;
//    }];
//    
////    [imgViewProductImage setContentMode:
////     UIViewContentModeScaleAspectFill];
//    [imgViewProductImage setClipsToBounds:YES];
//    imgViewProductImage.tag = 101;
    
    //TODO - Multiple Images issue
    AAMediaItem *mediaItem = [[AAMediaItem alloc] init];
    mediaItem.mediaUrl = self.product.productImageURLString;
    mediaItem.mediaType = RETAILER_FILE_TYPE_IMAGE;
    
    AAMediaItem *mediaItem2 = [[AAMediaItem alloc] init];
    //mediaItem2.mediaUrl = self.product.productImageURLString;
    mediaItem2.mediaType = RETAILER_FILE_TYPE_YOUTUBE_VIDEO;
    
    self.banner = [[AABannerView alloc] initWithFrame:viewImgContainer.bounds];
    self.banner.delegate = self;
    self.banner.bannerItems = [NSArray arrayWithArray:self.product.product_imgs];//self.product.product_imgs;
    [self.banner populateItems];
    [viewImgContainer addSubview:self.banner];
    CGFloat currentY = viewImgContainer.frame.origin.y + viewImgContainer.frame.size.height + 10;
    
    return currentY;
    
}

-(void)imageTapped{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(presentImageZoomWithImage:)]) {
        [self.delegate presentImageZoomWithImage:prodImage];
    }
}
-(CGFloat)addProductShortDescriptionWithOrgY : (CGFloat)orgY
{
    CGSize productTextSize = [AAUtils getTextSizeWithFont:self.fontProductShortDescription andText:self.product.productShortDescription andMaxWidth:self.frame.size.width - 2*PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN];
    
    UIView* viewProductDescriptionContainer = [[UIView alloc] initWithFrame:CGRectMake(PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, orgY, self.frame.size.width - 2*PRODUCT__SHORT_DESCRIPTION_CONTAINER_MARGIN, productTextSize.height + PRODUCT__SHORT_DESCRIPTION_LABEL_TEXT_MARGIN*2)];
    [viewProductDescriptionContainer setBackgroundColor:[UIColor whiteColor]];
//    viewProductDescriptionContainer.layer.shadowOpacity = 0.5;
//    viewProductDescriptionContainer.layer.shadowOffset = CGSizeMake(0, 0);
//    viewProductDescriptionContainer.layer.shadowColor = [UIColor blackColor].CGColor;
//    viewProductDescriptionContainer.layer.shadowRadius = 4.0;    //[viewProductDescriptionContainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//    viewProductDescriptionContainer.layer.borderColor = BOARDER_COLOR.CGColor;
//    viewProductDescriptionContainer.layer.borderWidth = 1.0f;

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
    UILabel* lblBody = [[UILabel alloc] initWithFrame:CGRectMake(PRODOCT_BODY_MARGIN, orgY, 290, 20)];
    [lblBody setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ Credit Points",self.product.reward_points]];
    int length = [[NSString stringWithFormat:@"%@",self.product.reward_points] length];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
                  range:NSMakeRange(0,length)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_REWARDS_FONTSIZE]
                  range:NSMakeRange(length+1,[@"Credit Points" length])];
    [lblBody setAttributedText:hogan];
//    [lblBody setText:[NSString stringWithFormat:@"%@ Reward Points",self.product.reward_points]];
    [lblBody setNumberOfLines:0];
    
    [self addSubview:lblBody];
    return orgY+20;
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
//-(void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated{
//    CGPoint currentOffset = self.contentOffset;
//    
//}
-(void)hideDropDown{
    [self.optionDropDown removeFromSuperview];
}
-(void)presentZoomViewWithImage:(UIImage*)image{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(presentImageZoomWithImage:)]) {
        [self.delegate presentImageZoomWithImage:image];
    }

}
@end

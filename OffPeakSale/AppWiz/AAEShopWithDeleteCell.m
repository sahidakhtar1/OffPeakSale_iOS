//
//  AAEShopProductCell.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAEShopWithDeleteCell.h"

@implementation AAEShopWithDeleteCell
NSInteger const CART_MAIN_VIEW_PADDING = 10.0;
NSInteger const CART_IMAGE_VIEW_PADDING = 0.0;
NSInteger const CART_LABEL_VIEW_LEFT_PADDING = 8.0;
NSInteger const CART_OVERLAY_TOP_PADDING = 5.0;

NSInteger const CART_RATING_VIEW_WEIDTH = 105;
@synthesize eshopProduct = eShopProduct_;
@synthesize ratingView;
@synthesize cartItem,indexPath,delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView.superview setClipsToBounds:NO];
        [self setUpCell];
    }
    [self.ratingView setUserRatingOff];
    return self;
}
-(void) setProductForCart:(AAEShopProduct*)item{
    self.cartItem = item;
    [self populateViews];
     [self.ratingView setUserRatingOff];
}
-(void)setUpCell
{
    
    self.viewMainContent = [[UIView alloc] initWithFrame:CGRectMake(CART_MAIN_VIEW_PADDING, 0, self.contentView.frame.size.width - CART_MAIN_VIEW_PADDING*2, self.contentView.frame.size.height - CART_MAIN_VIEW_PADDING)];
    [self.viewMainContent setBackgroundColor:[[AAColor sharedInstance] eShopCardBackgroundColor]];
//    [self.viewMainContent.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.viewMainContent.layer setShadowOffset:CGSizeMake(0, 5) ];
//    [self.viewMainContent.layer setShadowOpacity:0.8];
//    [self.viewMainContent.layer setShadowRadius:5];
//    [self.viewMainContent.layer setMasksToBounds:NO];
    
    self.viewMainContent.layer.borderColor = BOARDER_COLOR.CGColor;
    self.viewMainContent.layer.borderWidth = 1.0f;
    
    [self.viewMainContent setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
    [self.contentView addSubview:self.viewMainContent];
    
    
    
    self.lblProductPreviousPrice = [[UILabel alloc] init];
    self.lblProductCurrentPrice = [[UILabel alloc] init];
    self.lblProductShortDescription = [[UILabel alloc] init];
    self.lblProductName = [[UILabel alloc] init];
    
    self.imgViewProductImage = [[UIImageView alloc] initWithFrame:CGRectMake(CART_IMAGE_VIEW_PADDING, CART_IMAGE_VIEW_PADDING, self.viewMainContent.frame.size.width - 2*CART_IMAGE_VIEW_PADDING, self.viewMainContent.frame.size.height - 2*CART_IMAGE_VIEW_PADDING)];
     [self.imgViewProductImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
    [self.viewMainContent addSubview:self.imgViewProductImage];
    self.overlayView = [[UIView alloc] init];
    [self.viewMainContent addSubview:self.overlayView];
    [self.viewMainContent addSubview:self.lblProductPreviousPrice];
     [self.viewMainContent addSubview:self.lblProductCurrentPrice];
     [self.viewMainContent addSubview:self.lblProductShortDescription];
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(screenWidth - 40, 0, 20, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(btnDeleteTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.viewMainContent addSubview:deleteButton];
    self.overlayLayer = NO;
    float height = [[AAAppGlobals sharedInstance] getImageHeight];
    self.ratingView = [[RatingView alloc] initWithFrame:CGRectMake(screenWidth-CART_RATING_VIEW_WEIDTH - 25,
                                                                   height-CART_OVERLAY_TOP_PADDING-20,
                                                                   CART_RATING_VIEW_WEIDTH,
                                                                   20) isRatingOff:YES];
    
    [self.viewMainContent addSubview:self.ratingView];
    [self.ratingView setBackgroundColor:[UIColor clearColor]];
    [self.ratingView setUserRatingOff];
    
   
}
-(void)btnDeleteTapped{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(deleteItemAtIndexPath:)]) {
        [self.delegate deleteItemAtIndexPath:self.indexPath];
    }
}
-(void)setEshopProduct:(AAEShopProduct *)eshopProduct
{
    [self.ratingView setUserRatingOff];
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
    if ([AAAppGlobals sharedInstance].disablePayment && self.cartItem != nil) {
        imageUrlString = self.cartItem.productImageURLString;
        previousProductPrice = [NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_code,self.cartItem.previousProductPrice];
        currentProductPrice = [NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_code,self.cartItem.currentProductPrice];
        prodDesc = self.cartItem.productShortDescription;
        prodrating = self.cartItem.productDescription;
    }else{
        imageUrlString = self.eshopProduct.productImageURLString;
         previousProductPrice = [NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_code,self.eshopProduct.previousProductPrice];
        currentProductPrice = [NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_code,self.eshopProduct.currentProductPrice];
        prodDesc = self.eshopProduct.productShortDescription;
        prodrating = self.eshopProduct.productRating;
    }
    
    
    
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
    NSMutableAttributedString *attStringPreviousProductPrice = [[NSMutableAttributedString alloc] initWithString:previousProductPrice attributes:attributes];
   
        CGSize previousPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE] andText:previousProductPrice andMaxWidth:175 ];
        [self.lblProductPreviousPrice setFrame:CGRectMake(CART_LABEL_VIEW_LEFT_PADDING,
                                                          self.viewMainContent.frame.size.height-CART_OVERLAY_TOP_PADDING-previousPricelabelSize.height,
                                                          previousPricelabelSize.width,
                                                          previousPricelabelSize.height)];
        [self.lblProductPreviousPrice setAttributedText:attStringPreviousProductPrice];
        [self.lblProductPreviousPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_OLD_PRICE]];
        [self.lblProductPreviousPrice setBackgroundColor:[UIColor clearColor]];
        [self.lblProductPreviousPrice setTextColor:[[AAColor sharedInstance] eShopCardTextColor]];
    [self.lblProductPreviousPrice setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    
    
    
    CGSize currentPricelabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_NEW_PRICE] andText:currentProductPrice andMaxWidth:175];
   
    [self.lblProductCurrentPrice setFrame:CGRectMake( self.lblProductPreviousPrice.frame.origin.x + self.lblProductPreviousPrice.frame.size.width + 3,
                                                     self.viewMainContent.frame.size.height-CART_OVERLAY_TOP_PADDING-currentPricelabelSize.height,
                                                     currentPricelabelSize.width,
                                                     currentPricelabelSize.height)];
    [self.lblProductCurrentPrice setText:currentProductPrice];
    [self.lblProductCurrentPrice setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_NEW_PRICE]];
    [self.lblProductCurrentPrice setBackgroundColor:[UIColor clearColor]];
    [self.lblProductCurrentPrice setTextColor:[[AAColor sharedInstance] eShopCardTextColor]];
    
     [self.lblProductCurrentPrice setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
   
    
    
    
        bottomY = self.lblProductCurrentPrice.frame.origin.y;
  
    CGSize shortDescriptionLabelSize = [AAUtils getTextSizeWithFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_NEW_PRICE] andText:prodDesc andMaxWidth:self.imgViewProductImage.frame.size.width- (2*CART_MAIN_VIEW_PADDING ) ];
  
    
    [self.lblProductShortDescription setFrame:CGRectMake( CART_LABEL_VIEW_LEFT_PADDING,
                                                         bottomY-CART_OVERLAY_TOP_PADDING- shortDescriptionLabelSize.height,
                                                         shortDescriptionLabelSize.width,
                                                         shortDescriptionLabelSize.height)];
    [self.lblProductShortDescription setText:prodDesc];
    [self.lblProductShortDescription setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FONT_SIZE_NEW_PRICE]];
    [self.lblProductShortDescription setNumberOfLines:0];
    [self.lblProductShortDescription setBackgroundColor:[UIColor clearColor]];
    [self.lblProductShortDescription setTextColor:[[AAColor sharedInstance] eShopCardTextColor]];
    [self.lblProductShortDescription setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];

    
    CGFloat overlayViewHeight = self.imgViewProductImage.frame.size.height - self.lblProductShortDescription.frame.origin.y + CART_OVERLAY_TOP_PADDING + CART_IMAGE_VIEW_PADDING;
    if(![self overlayLayer])
    {
    [self.overlayView setFrame:CGRectMake(CART_IMAGE_VIEW_PADDING, self.lblProductShortDescription.frame.origin.y -CART_OVERLAY_TOP_PADDING, self.imgViewProductImage.frame.size.width, overlayViewHeight)];
        
    [AAStyleHelper addGradientOverlayToView:self.overlayView withFrame:self.overlayView.frame withColor:[UIColor blackColor]];
        self.overlayLayer = YES;
    }
    else
    {
        [self.overlayView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.overlayView setFrame:CGRectMake(CART_IMAGE_VIEW_PADDING, self.lblProductShortDescription.frame.origin.y -CART_OVERLAY_TOP_PADDING, self.imgViewProductImage.frame.size.width, overlayViewHeight)];
         [AAStyleHelper addGradientOverlayToView:self.overlayView withFrame:self.overlayView.frame withColor:[UIColor blackColor]];
    }
   
    [self.overlayView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    if ([AAAppGlobals sharedInstance].enableRating) {
        [self.ratingView setHidden:NO];
        [self.ratingView setUserRatingOff];
        [self.ratingView setProductRating:[prodrating floatValue]];
        [self.ratingView setProductRating:3.5];
        
    }else{
        [self.ratingView setHidden:YES];
    }
    
   
}


-(CGSize)getLabelSizeWithFont : (UIFont*)font andText : (NSString*)text
{
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(self.viewMainContent.frame.size.width - 2*CART_LABEL_VIEW_LEFT_PADDING, 80)];
    return labelSize;
}


@end

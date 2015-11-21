//
//  AAConfirmPurchasePopupView.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 20/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAConfirmPurchasePopupView.h"

@implementation AAConfirmPurchasePopupView
NSString* const ORDER_NUMBER_KEY = @"invoiceId";
NSString* const QUANTITY_KEY = @"quantity";
NSInteger const VIEW_MARGIN = 20;
NSInteger const PADDING = 10;
NSInteger const IMAGE_VIEW_HEIGHT = 75;
NSInteger const IMAGE_VIEW_WIDTH = 100;
NSInteger const BUTTON_HEIGHT = 40;
NSInteger const BUTTON_WIDTH = 100;
NSInteger const PRODOCT_LABEL_HEADING_WIDTH = 50;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
              [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
           }
    return self;
}


+(AAConfirmPurchasePopupView*)createDatePickerViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect withProduct:(AAEShopProduct*)product andOrderInfo :(NSDictionary*)orderInfo
{
    AAConfirmPurchasePopupView* confirmPurchasePopupView = [[AAConfirmPurchasePopupView alloc] initWithBackgroundFrame:backgroundFrameRect andContentFrame:CGRectMake(0, 0, backgroundFrameRect.size.width- 2*VIEW_MARGIN, backgroundFrameRect.size.height)];
    confirmPurchasePopupView.eShopProduct = product;
    confirmPurchasePopupView.orderInformation = orderInfo;
    confirmPurchasePopupView.headerTitle = @"Payment Success";
    confirmPurchasePopupView.headerTitleColor = [AAColor sharedInstance].retailerThemeTextColor;
    confirmPurchasePopupView.headerFont = [AAFont defaultBoldFontWithSize:20.0];
    confirmPurchasePopupView.headerColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
    confirmPurchasePopupView.headerHeight = 30;
    [confirmPurchasePopupView.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [confirmPurchasePopupView.backgroundView setAlpha:0.8];
    [confirmPurchasePopupView addHeaderView];
    
    CGFloat currentY = confirmPurchasePopupView.headerHeight + PADDING;
    
    
    [confirmPurchasePopupView addProductDetails:currentY];
    
    currentY = [confirmPurchasePopupView addProductImage:currentY];
    
  currentY =  [confirmPurchasePopupView addConfirmationMessage:currentY];
    
    
    currentY = [confirmPurchasePopupView addDismissButton:currentY];
    
    
    
    
    CGRect contentViewframe = confirmPurchasePopupView.contentView.frame;
    contentViewframe.size.height = currentY;
    confirmPurchasePopupView.contentView.frame = contentViewframe;
    [confirmPurchasePopupView centreContentViewInSuperview];
    return confirmPurchasePopupView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(CGFloat)addProductImage : (CGFloat)currentY
{
    UIImageView* ivProduct = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, currentY , IMAGE_VIEW_WIDTH, IMAGE_VIEW_HEIGHT)];
    NSURL* imageURL = [NSURL URLWithString:self.eShopProduct.productImageURLString];
    [ivProduct setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    [self.contentView addSubview:ivProduct];
    currentY = currentY + PADDING + IMAGE_VIEW_HEIGHT;
    return currentY;
}

-(CGFloat)addProductDetails:(CGFloat)currentY
{
    
    if(![self.eShopProduct.productShortDescription length]==0)
    {
      currentY =  [self addProductDetail:@"Product" andContent:self.eShopProduct.productShortDescription andCurrentY:currentY];
    }
    
    if([self.orderInformation objectForKey:ORDER_NUMBER_KEY])
    {
         currentY =  [self addProductDetail:@"Order No" andContent:[[self.orderInformation objectForKey:ORDER_NUMBER_KEY] stringValue] andCurrentY:currentY];
    }
    
    if([self.orderInformation objectForKey:QUANTITY_KEY])
    {
        currentY =  [self addProductDetail:@"Quantity" andContent:[[self.orderInformation objectForKey:QUANTITY_KEY] stringValue]  andCurrentY:currentY];
    }

    
    if(![self.eShopProduct.currentProductPrice length]==0)
    {
        currentY =  [self addProductDetail:@"Amount" andContent:[NSString stringWithFormat:@"%@%@",[AAAppGlobals sharedInstance].currency_symbol,self.eShopProduct.currentProductPrice] andCurrentY:currentY];
    }
    
    return currentY;
}


-(CGFloat)addProductDetail : (NSString*)headingText andContent : (NSString*)content andCurrentY:(CGFloat)currentY
{
    UIFont* font = [AAFont defaultBoldFontWithSize:9.0];
    NSInteger currentX = IMAGE_VIEW_WIDTH + 2*PADDING;
   
    CGSize lblHeadingSize = [AAUtils getTextSizeWithFont:font andText:headingText andMaxWidth:PRODOCT_LABEL_HEADING_WIDTH];
    UILabel* lblHeading = [[UILabel alloc] initWithFrame:CGRectMake(currentX, currentY, PRODOCT_LABEL_HEADING_WIDTH, lblHeadingSize.height)];
    [lblHeading setFont:font];
    [lblHeading setText:headingText];
    [lblHeading setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:lblHeading];
    
    currentX+=PRODOCT_LABEL_HEADING_WIDTH;
    UILabel* lblColon = [[UILabel alloc] initWithFrame:CGRectMake(currentX, currentY, 10, lblHeadingSize.height)];
    [lblColon setTextAlignment:NSTextAlignmentCenter];
    [lblColon setText:@":"];
    [lblColon setFont:font];
    [self.contentView addSubview:lblColon];
    
     CGFloat maxWidth = self.contentView.frame.size.width - IMAGE_VIEW_WIDTH - 3*PADDING - PRODOCT_LABEL_HEADING_WIDTH - 10;
    currentX+=10;
    CGSize lblContentSize = [AAUtils getTextSizeWithFont:font andText:content andMaxWidth:maxWidth];
    UILabel* lblContent = [[UILabel alloc] initWithFrame:CGRectMake(currentX, currentY, lblContentSize.width, lblContentSize.height)];
    [lblContent setNumberOfLines:0];
    [lblContent setFont:font];
    [lblContent setText:content];
    
    [self.contentView addSubview:lblContent];
    
    currentY = currentY + lblContentSize.height + 1;
    return currentY;
}
-(CGFloat)addConfirmationMessage : (CGFloat)currentY
{
    NSString* confirmationMessageText = @"Dear Customer, \nYour Purchase is Successful \nYou will receive E-Mail confirmation shortly";
    CGSize lblConfirmationMessageSize = [AAUtils getTextSizeWithFont:[AAFont defaultBoldFontWithSize:10 ] andText:confirmationMessageText andMaxWidth:self.contentView.frame.size.width];
    UILabel* lblConfirmationMessage = [[UILabel alloc] initWithFrame:CGRectMake(2*PADDING, currentY, self.contentView.frame.size.width - 2 * PADDING, lblConfirmationMessageSize.height)];
    [lblConfirmationMessage setFont:[AAFont defaultBoldFontWithSize:10]];
    [lblConfirmationMessage setText:confirmationMessageText];
    [lblConfirmationMessage setNumberOfLines:0];
    [self.contentView addSubview:lblConfirmationMessage];
    currentY = currentY + lblConfirmationMessageSize.height + PADDING;
    
    return currentY;
}

-(CGFloat)addDismissButton:(CGFloat)currentY
{
    
    CGFloat xCoord = ceilf(self.contentView.frame.size.width - BUTTON_WIDTH)/2;
    AAThemeGlossyButton* btnDismissPopup = [[AAThemeGlossyButton alloc] initWithFrame:CGRectMake(xCoord, currentY, BUTTON_WIDTH, BUTTON_HEIGHT)];
   
    [btnDismissPopup setTitle:@"Dismiss" forState:UIControlStateNormal];
    [btnDismissPopup.titleLabel setFont:[AAFont defaultBoldFontWithSize:14.0]];
    
    [btnDismissPopup addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnDismissPopup];
    
    currentY = currentY + BUTTON_HEIGHT + PADDING;
    return currentY;
}

-(void)changeTheme
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTheme];
    });
    
}
-(void)updateTheme
{
    self.lblTitle.textColor = [AAColor sharedInstance].retailerThemeTextColor;
    self.headerView.backgroundColor = [AAColor sharedInstance].retailerThemeBackgroundColor;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_THEME_CHANGED object:nil];
}

@end

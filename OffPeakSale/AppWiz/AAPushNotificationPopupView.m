//
//  AAPushNotificationPopupView.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 30/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAPushNotificationPopupView.h"
#import "AAAppDelegate.h"
#import "AAEShopHelper.h"
@implementation AAPushNotificationPopupView

static NSInteger const PADDING = 0;
static NSInteger const IMAGE_VIEW_HEIGHT = 200;
static NSInteger const IMAGE_VIEW_WIDTH = 300;
static NSInteger const BUTTON_HEIGHT = 40;
static NSInteger const BUTTON_WIDTH = 100;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:NOTIFICATION_THEME_CHANGED object:nil];
    }
    return self;
}


+(AAPushNotificationPopupView*)createPushNotificationPopupViewWithBackgroundFrameRect : (CGRect)backgroundFrameRect withVoucher:(AAVoucher*)voucher
{
    AAPushNotificationPopupView* pushNotificationPopupView = [[AAPushNotificationPopupView alloc] initWithBackgroundFrame:backgroundFrameRect andContentFrame:CGRectMake(0, 0, backgroundFrameRect.size.width- 2*MARGIN, backgroundFrameRect.size.height)];
    pushNotificationPopupView.voucher = voucher;
    [pushNotificationPopupView.contentView setBackgroundColor:[UIColor blackColor]];
    [pushNotificationPopupView.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[pushNotificationPopupView.backgroundView setAlpha:0.8];
    [pushNotificationPopupView addHeaderView];
    
    CGFloat currentY = 0;
    
    
    
    currentY = [pushNotificationPopupView addVoucherInformation:currentY];
    
   
    
    
    currentY = [pushNotificationPopupView addDismissButton:currentY];
    
    
    
    
    CGRect contentViewframe = pushNotificationPopupView.contentView.frame;
    contentViewframe.size.height = currentY;
    pushNotificationPopupView.contentView.frame = contentViewframe;
    [pushNotificationPopupView centreContentViewInSuperview];
    return pushNotificationPopupView;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(CGFloat)addVoucherInformation:(CGFloat)currentY
{
    if([self.voucher.voucherFileType isEqualToString:VOUCHER_FILE_TYPE_IMAGE])
    {
        if (self.voucher.pid != nil) {
            [self addButton:currentY];
        }
      return    [self addVoucherImage:currentY];
    }
    else if([self.voucher.voucherFileType isEqualToString:VOUCHER_FILE_TYPE_VIDEO])
    {
        return [self addVoucherVideoView:currentY];
    }
    return 0;
}
-(void)addButton:(CGFloat)currentY{
    float width = [UIScreen mainScreen].bounds.size.width - 2*MARGIN;
    float height = [[AAAppGlobals sharedInstance] getImageHeightWithPadding:MARGIN];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(PADDING, currentY, width, height)];
    [btn addTarget:self action:@selector(loadProductDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}
-(CGFloat)addVoucherImage : (CGFloat)currentY
{
    float width = [UIScreen mainScreen].bounds.size.width - 2*MARGIN;
    float height = [[AAAppGlobals sharedInstance] getImageHeightWithPadding:MARGIN];
    UIImageView* ivVoucher = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, currentY , width, height)];
    NSURL* imageURL = [NSURL URLWithString:self.voucher.voucherFileUrl];
    
    [ivVoucher setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    [self.contentView addSubview:ivVoucher];
    currentY = currentY + 5 + IMAGE_VIEW_HEIGHT;
    return currentY;
}

-(CGFloat)addVoucherVideoView : (CGFloat)currentY
{
    float width = [UIScreen mainScreen].bounds.size.width - 2*MARGIN;
    float height = [[AAAppGlobals sharedInstance] getImageHeightWithPadding:MARGIN];
//    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:[ NSURL URLWithString:self.voucher.voucherFileUrl]];
//    //[self.moviePlayerController setScalingMode:MPMovieScalingModeAspectFill];
//    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
//    self.moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
//    self.moviePlayerController.contentURL = [ NSURL URLWithString:self.voucher.voucherFileUrl];
//    [self.moviePlayerController.view setFrame:CGRectMake(PADDING, currentY , width, IMAGE_VIEW_HEIGHT)];
//    self.moviePlayerController.shouldAutoplay = YES;
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    self.moviePlayerController.view.backgroundColor = [UIColor whiteColor];
//   // self.moviePlayerController.fullscreen = YES;
//    [self.moviePlayerController prepareToPlay];
//    [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
//    [self.contentView addSubview:self.moviePlayerController.view];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideControl)
//                                                 name:MPMoviePlayerLoadStateDidChangeNotification
//                                               object:self.moviePlayerController];
//    
//    currentY = currentY + PADDING + IMAGE_VIEW_HEIGHT;
    
    self.videoPlayerView = [[AAVideoPlayerView alloc] initWithFrame:CGRectMake(PADDING, currentY , width, height)];
    [self.videoPlayerView setVideoUrl:self.voucher.voucherFileUrl];
    [self.contentView  addSubview:self.videoPlayerView];
    [self.videoPlayerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth ];
    self.videoPlayerView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    currentY = currentY + PADDING + IMAGE_VIEW_HEIGHT;
    return currentY;
    
}
-(void)hideControl
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self     name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:self.moviePlayerController];
    [self.moviePlayerController setControlStyle:MPMovieControlStyleEmbedded];
    
}


-(CGFloat)addDismissButton:(CGFloat)currentY
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY+8, self.contentView.frame.size.width, BUTTON_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:bgView];
    CGFloat xCoord = ceilf(self.contentView.frame.size.width - BUTTON_WIDTH)/2;
    AAThemeGlossyButton* btnDismissPopup = [[AAThemeGlossyButton alloc] initWithFrame:CGRectMake(xCoord, currentY, BUTTON_WIDTH, BUTTON_HEIGHT)];
   
    [btnDismissPopup setTitle:@"Dismiss" forState:UIControlStateNormal];
    [btnDismissPopup.titleLabel setFont:[AAFont defaultBoldFontWithSize:BUTTON_FONTSIZE]];
   
    [btnDismissPopup addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnDismissPopup];
    
    currentY = currentY + BUTTON_HEIGHT + PADDING;
    return currentY;
}

-(void)closePopup
{
    [self removeFromSuperview];
    if (self.moviePlayerController) {
        [self.moviePlayerController stop];
        [self.videoPlayerView.player pause];
    }
}
-(void)loadProductDetail{
    [self removeFromSuperview];
    
    [AAEShopHelper getEshopProductDetail:self.voucher.pid WithCompletionBlock:^(AAEShopProduct *p) {
        AAAppDelegate *appDelagate = (AAAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelagate loadEshopDetailWithProduct:p];
    }];
}

/*
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
}*/


-(void)dealloc
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_THEME_CHANGED object:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

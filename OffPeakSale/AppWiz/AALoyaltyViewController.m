//
//  AALoyaltyViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AALoyaltyViewController.h"
#import "AAWebViewController.h"
#import "AAHeaderView.h"
#import "UIViewController+AAShakeGestuew.h"
#import "AAScannerViewController.h"
@interface AALoyaltyViewController ()

@end

@implementation AALoyaltyViewController
@synthesize isActive;
@synthesize mTimer;
@synthesize title;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.heading = @"LOYALTY";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.facebook = [[Facebook alloc] initWithAppId:@"599710556749526" andDelegate:self];
    self.isMerchant = NO;
    self.couponCount = [AAAppGlobals sharedInstance].loyalty.couponCount;
    [self setUpCouponButtons];
    self.fbLikeView.layout = @"standard";
    self.fbLikeView.showFaces = NO;
     self.fbLikeView.action = @"like";
    self.fbLikeView.delegate = self;
    [self.btnResetCoupons setHidden:NO];
    
    NSLog(@"Logo size = %@",NSStringFromCGRect(self.ivLoyalty.frame));
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:self.title];
    headerView.showCart = false;
    headerView.showBack = false;
    headerView.delegate = self;
    [headerView setMenuIcons];
	// Do any additional setup after loading the view.
}
-(void) startTimer{
    if (self.isActive) {
        self.isActive = false;
    }else{
        [self enableMerchantMode:FALSE];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateViews];
    [self cat_viewDidAppear:YES];
    [self setScoialIcon];
    self.btnResetCoupons.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.btnMerchantAdmin.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    
    self.tvTermsConditions.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:LOTALITY_TNC_FONTSIZE];
    self.lblTNCTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:LOTALITY_TNCTITLE_FONTSIZE];
    //[self showMerchantAuthenticationPopup];
    [AAStyleHelper addLightShadowToView:self.viewTermsConditionsContainer];
    [AALoyaltyHelper getLoyaltyInformationFromServerWithCompletionBlock:^{
        [self updateViews];
    } andFailure:^{
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self enableMerchantMode:NO];
}
-(void)setScoialIcon{
    if  ([[AAAppGlobals sharedInstance].retailer.fbIconDisplay isEqualToString:@"1"]){
        self.vwFBLikeView.alpha = 1;
    }else{
        self.vwFBLikeView.alpha = 0;
    }
    if ([[AAAppGlobals sharedInstance].retailer.instagramDisplay isEqualToString:@"1"]) {
            self.vwInstagram.alpha = 1;
        }else{
            self.vwInstagram.alpha = 0;
        }
        
    
    [self adjustTNCContainerSize];
}
-(void)updateViews
{
    AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
    self.tvTermsConditions.text = loyalty.termsCondtitions;
    self.fbLikeView.href = [NSURL URLWithString:[AAAppGlobals sharedInstance].retailer.fbUrl];
    
    [self.fbLikeView load];

    [self.ivLoyalty setImageWithURL:[NSURL URLWithString:loyalty.loyaltyImageUrlString ] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    self.btnResetCoupons.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.btnMerchantAdmin.titleLabel.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    
    self.tvTermsConditions.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:LOTALITY_TNC_FONTSIZE];
    self.lblTNCTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:LOTALITY_TNCTITLE_FONTSIZE];
}
- (IBAction)arrCouponButtons:(id)sender {
}
- (IBAction)btnCouponTap:(id)sender {
    self.isActive = true;
    if(self.isMerchant)
    {
    
    AACouponButton* btnCoupon = (AACouponButton*)sender;
         if([btnCoupon isSelected])
         {
        if(btnCoupon.tag == self.couponCount)
        {
            [btnCoupon setSelected:!btnCoupon.selected];
               self.couponCount--;
             //[self.btnResetCoupons setHidden:YES];
        }
         }
        else
        {
            if(btnCoupon.tag == (self.couponCount + 1))
            {
                [btnCoupon setSelected:!btnCoupon.selected];
                self.couponCount++;
                            }
        }
      
         
    }
    
}

-(void)setCouponCount:(NSInteger)couponCount
{
    _couponCount = couponCount;
    if(self.couponCount==MAX_COUPON_COUNT)
    {
        if(self.isMerchant)
        {
        //[self.btnResetCoupons setHidden:NO];
        }
        
        
    }
    else
    {
        //[self.btnResetCoupons setHidden:YES];
    }
    
}

- (IBAction)btnMerchantTap:(id)sender {
    self.isActive = true;
    [self showMerchantAuthenticationPopup];
}

- (IBAction)btnResetCouponsTap:(id)sender {
    self.isActive = true;
    if(self.isMerchant)
    {
    self.couponCount = 0;
    for(AACouponButton* btnCoupon in self.arrCouponButtons)
    {
        
        btnCoupon.selected = NO;
        
    }
    }
    else
    {
        [self showMerchantAuthenticationPopup];
    }
}

- (IBAction)btnInstagramTapped:(id)sender {
//    AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
    
//    AAWebViewController* vcWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAWebViewController"];
//    
//    vcWebViewController.intagramURL =loyalty.instagramUrl;
//    [self presentViewController:vcWebViewController animated:YES completion:^{
//        
//    }];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AAAppGlobals sharedInstance].retailer.instagramUrl]];
}



-(void)showMerchantAuthenticationPopup
{
    if(self.merchantAuthenticationPopupView)
    {
        [self.view addSubview:self.merchantAuthenticationPopupView];
    }
    else
    {
        CGRect frame = self.view.bounds;
//        float rightpadding = frame.size.width - (self.btnMerchantAdmin.frame.origin.x+self.btnMerchantAdmin.frame.size.width);
//        float leftPadding = self.btnResetCoupons.frame.origin.x;
       // frame.size.width = frame.size.width - ;
        self.merchantAuthenticationPopupView = [AAMerchantAuthenticationPopupView createMerchantAuthenticationPopupViewWithBackgroundFrameRect:self.view.bounds withPadding:30];
        self.merchantAuthenticationPopupView.merchantAuthenticatDelegate = self;
        [self.view addSubview:self.merchantAuthenticationPopupView];
    }
}

-(void)setUpCouponButtons
{
  
    
    
    
    NSInteger index = self.couponCount;
    for(int i= 1; i<=index;i++)
    {
       AACouponButton* btnCoupon = (AACouponButton*)[self.view viewWithTag:i];
        btnCoupon.selected = YES;
        
    }
}

#pragma mark - Merchant authentication popup callbacks
-(void)enableMerchantMode:(BOOL)enable
{
    self.isMerchant = enable;
    if(!enable)
    {
         //[self.btnResetCoupons setHidden:YES];
        [AAAppGlobals sharedInstance].loyalty.couponCount = self.couponCount;
        NSData *dataLoyalty = [NSKeyedArchiver archivedDataWithRootObject:[AAAppGlobals sharedInstance].loyalty];
        
        [[NSUserDefaults standardUserDefaults] setObject:dataLoyalty    forKey:USER_DEFAULTS_LOYALTY_KEY];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.mTimer isValid]) {
            [self.mTimer invalidate];
            self.mTimer = nil;
            self.merchantAuthenticationPopupView = nil;
        }
        
    }
    else
    {
        if(self.couponCount==MAX_COUPON_COUNT)
        {
            //[self.btnResetCoupons setHidden:NO];
        }
            
        if ([self.mTimer isValid]) {
            [self.mTimer invalidate];
            self.mTimer = nil;
        }
        isActive = NO;
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        
    }
    [self.merchantAuthenticationPopupView closePopup];
}
-(void)presentScanner:(AAScannerViewController*)scannerVC{
    [self presentViewController:scannerVC animated:YES completion:nil];
}



#pragma mark FacebookLikeViewDelegate

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    [self.facebook authorize:[NSArray array]];
    self.isActive = true;
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
//    AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
    if  ([[AAAppGlobals sharedInstance].retailer.fbIconDisplay isEqualToString:@"1"]){
        self.vwFBLikeView.alpha = 1;
    }else{
        self.vwFBLikeView.alpha = 0;
    }
    [UIView commitAnimations];
    [self adjustTNCContainerSize];
    self.isActive = true;
}

#pragma mark FBSessionDelegate
-(void)fbDidNotLogin:(BOOL)cancelled
{
    if(cancelled)
    {
//        AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
        if  ([[AAAppGlobals sharedInstance].retailer.fbIconDisplay isEqualToString:@"1"]){
            self.vwFBLikeView.alpha = 1;
        }else{
            self.vwFBLikeView.alpha = 0;
        }
        [self.fbLikeView load];
        [self adjustTNCContainerSize];

    }
    self.isActive = true;
}

- (void)fbDidLogin {
//	AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
    if  ([[AAAppGlobals sharedInstance].retailer.fbIconDisplay isEqualToString:@"1"]){
        self.vwFBLikeView.alpha = 1;
    }else{
        self.vwFBLikeView.alpha = 0;
    }
    [self.fbLikeView load];
    [self adjustTNCContainerSize];
    self.isActive = true;
}

- (void)fbDidLogout {
//	AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
    if  ([[AAAppGlobals sharedInstance].retailer.fbIconDisplay isEqualToString:@"1"]){
        self.vwFBLikeView.alpha = 1;
    }else{
        self.vwFBLikeView.alpha = 0;
    }
    [self.fbLikeView load];
    [self adjustTNCContainerSize];
    self.isActive = true;
}
// Called when the user likes a URL via this view
- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView{
    NSLog(@"facebookLikeViewDidLike");
    self.isActive = true;
}

// Called when the user unlikes a URL via this view
- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView{
    NSLog(@"facebookLikeViewDidUnlike");
    self.isActive = true;
}

-(void)adjustTNCContainerSize{
    CGRect frame = self.viewTermsConditionsContainer.frame;
    AALoyalty* loyalty = [AAAppGlobals sharedInstance].loyalty;
    if (self.vwFBLikeView.alpha == 0 && self.vwInstagram.alpha == 0) {
        float availableSpace = (self.vwFBLikeView.frame.origin.y + self.vwFBLikeView.frame.size.height) -(self.lblTNCTitle.frame.origin.y + self.lblTNCTitle.frame.size.height + 10);
        frame.size.height = availableSpace;
    }else{
        float availableSpace = (self.vwFBLikeView.frame.origin.y) -(self.lblTNCTitle.frame.origin.y + self.lblTNCTitle.frame.size.height + 10);
        frame.size.height = availableSpace-10;
    }
    self.viewTermsConditionsContainer.frame = frame;
    [self adjustSocialMediaIcon];
}
-(void)adjustSocialMediaIcon{
    float width = [UIScreen mainScreen].bounds.size.width;
    CGPoint fbCenter = self.vwFBLikeView.center;
    CGPoint instagrameCenter = self.vwInstagram.center;
    if (self.vwFBLikeView.alpha == 1 && self.vwInstagram.alpha == 1) {
        fbCenter.x = width/4;
        instagrameCenter.x = 3*width/4-10;
    }else if (self.vwFBLikeView.alpha == 1){
        fbCenter.x = width/2;
        instagrameCenter.x = width/2;
        
    }else if (self.vwInstagram.alpha == 1){
        fbCenter.x = width/2;
        instagrameCenter.x = width/2;
    }
    self.vwFBLikeView.center = fbCenter;
    self.vwInstagram.center = instagrameCenter;
}
@end

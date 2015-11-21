//
//  AAAddHelper.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 17/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAAddHandler.h"

@implementation AAAddHandler
//static NSString* const APP_UNIT_ID = @"a152d9e5cd2c418";
@synthesize bannerView = bannerView_;
- (id)initWithPublisherId:(NSString*)publisherId
{
    self = [super init];
    if (self) {
        self.publisherId = publisherId;
        self.bannerAdded = NO;
        self.bannerHeight = kGADAdSizeBanner.size.height;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadBanner)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}




//Add add banner to the bottom of the containerView
-(void)addAdBannerWithContainerView : (UIView*)containerView
{
    self.containerView = containerView;
    [self setUpAddBanner];
     [bannerView_ loadRequest:[self createRequest]];
}

-(GADRequest*)createRequest
{
  
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for
    // the simulator as well as any devices you want to receive test ads.
      #ifdef DEV
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,@"a4f2b85d53cac5a5397f728cb88b3f18",
                           
                           nil];// Initiate a generic request to load it with an ad.
    #endif
    return request;
}

-(void)adViewDidReceiveAd:(GADBannerView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [bannerView_ removeFromSuperview];
        [self.containerView addSubview:bannerView_];
        CGPoint center = bannerView_.center;
        center.x = self.containerView.center.x;
        bannerView_.center = center;
        [self.delegate didReceiveAd];
        self.bannerAdded = YES;
    });
    
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    self.bannerAdded = NO;
    [self.bannerView removeFromSuperview];
    [self setUpAddBanner];
    [self.delegate didNotReceivedAd];
    double delayInSeconds = 5.0;
    __weak AAAddHandler* weakAddHelper = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //NSLog(@"Retrying to load request");
        if(weakAddHelper)
            [weakAddHelper.bannerView loadRequest:[weakAddHelper createRequest]];
    });
    

}



-(void)setUpAddBanner
{
    if(self.delegate!=nil)
    {
        CGPoint orign = CGPointMake(self.containerView.frame.size.height - kGADAdSizeBanner.size.width/2, self.containerView.frame.size.height - kGADAdSizeBanner.size.height);
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:orign];
        
        // Specify the ad unit ID.
        bannerView_.adUnitID = self.publisherId;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self.delegate;
        [bannerView_ setDelegate:self];
       
       
        [self.containerView addSubview:bannerView_];
        
    }
    else
    {
        //NSLog(@"Please set the delegate first before calling addAdBanner");
    }

}

-(void)reloadBanner
{
    if(!self.bannerAdded && self.containerView)
    {
        [self.bannerView removeFromSuperview];
        [self setUpAddBanner];
        [self.delegate didNotReceivedAd];
        double delayInSeconds = 5.0;
         __weak AAAddHandler* weakAddHelper = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //NSLog(@"Retrying to load request");
            if(weakAddHelper)
            [weakAddHelper.bannerView loadRequest:[weakAddHelper createRequest]];
        });
        
    }

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];

    self.bannerView.delegate = nil;

}
@end

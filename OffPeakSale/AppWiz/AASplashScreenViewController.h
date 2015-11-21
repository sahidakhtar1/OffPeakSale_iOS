//
//  AASplashScreenViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 22/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AASplashScreenViewControllerDelegate.h"
#import "UIImageView+WebCache.h"
@interface AASplashScreenViewController : AAChildBaseViewController
{
    
      
    
}
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (weak, nonatomic) IBOutlet UILabel *lblPoweredBy;
@property (nonatomic,weak) id<AASplashScreenViewControllerDelegate> splashScreenDelegate;
@property (nonatomic,strong) NSString* splashScreenImageURL;
@property (nonatomic) NSTimeInterval splashScreenInterval;
@property (weak, nonatomic) IBOutlet UILabel *lblRetailerPoweredBy;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSplashScreenImage;
@end

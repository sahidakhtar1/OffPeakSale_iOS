//
//  AAHomeViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AAHomePageHelper.h"
#import "AARetailer.h"
#import "AARetailerInfoHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AARetailerStoreMapViewController.h"
#import "AARootChildViewControllerDelegate.h"
#import "AAStoreInfoWindow.h"
#import "AAThemeGlossyButton.h"
@class AABannerView;
@class AAHeaderView;
@interface AAHomeViewController : AAChildBaseViewController <GMSMapViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) id<AARootChildViewControllerDelegate> rootViewControllerDelegate;
@property (weak, nonatomic) IBOutlet UIView *viewMediaContainer;
@property (weak, nonatomic) IBOutlet UIView *viewMapContainer;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong,nonatomic)   MPMoviePlayerController* moviePlayerController;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tgrMyLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnZoomMap;
@property (weak, nonatomic) IBOutlet UIView *viewMapHeadingContainer;
@property (strong, nonatomic) IBOutlet UIImageView *imgCompanyLogo;
@property (strong, nonatomic) IBOutlet UIView *vwBackDropContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackdropImage;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnLocateUs;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) AABannerView *banner;
- (IBAction)btnLocatUsTapped:(id)sender;

- (IBAction)tgrMyLocationTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *lblPoweredby;
@property (weak, nonatomic) IBOutlet UIView *vwpoweredBy;
@property (weak, nonatomic) IBOutlet UICollectionView *billBoardOne;
@property (weak, nonatomic) IBOutlet UICollectionView *billBoardTwo;
@property (nonatomic, strong) AAHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgPowerbyLogo;

@property (strong,nonatomic) AAMapView* mvStoreLocations;
- (IBAction)btnZoomMapTapped:(id)sender;
- (IBAction)btnPoweredByTapped:(id)sender;
@end

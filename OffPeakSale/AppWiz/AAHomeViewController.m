//
//  AAHomeViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAHomeViewController.h"
#import "ImageDownloader.h"
#import "AAConfig.h"
#import "AAMediaItem.h"
#import "AABannerView.h"
#import "AAHeaderView.h"
#import "AABillBoardCell.h"
#import "AAProductInformationViewController.h"
#import "UIViewController+AAShakeGestuew.h"
@interface AAHomeViewController ()
@property (nonatomic) CGFloat billBoardImageWidth;
@property (nonatomic,strong) NSMutableArray *arrBillBoardOne;
@property (nonatomic,strong) NSMutableArray *arrBillBoardTwo;
@end

@implementation AAHomeViewController
static NSInteger const PADDING = 10;
@synthesize imageDownloadsInProgress;
@synthesize banner;
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
         self.heading = @"HOME";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress= [[NSMutableDictionary alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    self.arrBillBoardOne = [[NSMutableArray alloc] init];
    self.arrBillBoardTwo = [[NSMutableArray alloc] init];
//    [AAStyleHelper addLightShadowToView:self.viewMediaContainer];
    
//    [AAStyleHelper addLightShadowToView:self.viewMapContainer];
   
    self.viewMapHeadingContainer.layer.cornerRadius = 5.0;
    self.mvStoreLocations = [[AAMapView alloc] initWithFrame:self.viewMapContainer.bounds];
    [ self.mvStoreLocations setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
	// Do any additional setup after loading the view.
  
    self.mvStoreLocations.mapView.delegate = self;
    self.mvStoreLocations.mapView.settings.myLocationButton = YES;
    [self.viewMapContainer setClipsToBounds:NO];
    [self.viewMapContainer addSubview:self.mvStoreLocations];
    [self.viewMapContainer insertSubview:self.mvStoreLocations belowSubview:self.viewMapHeadingContainer];
    self.tgrMyLocation.delegate = self;
    
    CGPoint btnLocausCente = self.btnLocateUs.center;
    btnLocausCente.x = [UIScreen mainScreen].bounds.size.width/2;
    self.btnLocateUs.center = btnLocausCente;
    
     self.headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:self.headerView];
    [self.headerView setTitle:[AAAppGlobals sharedInstance].retailer.retailerName];
    [self populateBillBoardItem];
    self.headerView.showCart = false;
    self.headerView.showBack = false;
    self.headerView.delegate = self;
    [self.headerView setMenuIcons];
    
    [self checkAppUpdateStatus];
}
-(void)checkAppUpdateStatus{
    @try {
        NSString *appVersion =  [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        if (![AAAppGlobals sharedInstance].appUpdateAlertShown &&
            [AAAppGlobals sharedInstance].retailer.iosVersion != nil &&
            ![[AAAppGlobals sharedInstance].retailer.iosVersion isEqualToString:appVersion]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"New version is available in Itunes. Do You want to download it now? " delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 1002;
            [alert show];
            [AAAppGlobals sharedInstance].appUpdateAlertShown = true;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1002) {
        if (buttonIndex ==  1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AAAppGlobals sharedInstance].appStoreUrl]];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self cat_viewDidAppear:YES];
    [super viewWillAppear:animated];
      [self adjustContainerHeights];
   
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:NOTIFICATION_LOCATION_UPDATED object:nil];
    
        [[self.viewMediaContainer subviews ] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    [self updateRetailerMaps];
    [self addRetailerViews];
    
    self.heading = [AAAppGlobals sharedInstance].retailer.retailerName;
    [self.rootViewControllerDelegate updateHeading];
    [AARetailerInfoHelper processRetailerInformationWithCompletionBlock:^{
         [[self.viewMediaContainer subviews ] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self updateRetailerMaps];
        [self addRetailerViews];
        [self.btnLocateUs.titleLabel setFont:[UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE]];
        self.heading = [AAAppGlobals sharedInstance].retailer.retailerName;
        [self.rootViewControllerDelegate updateHeading];
        [self populateBillBoardItem];
        [self getCurrencyCoversionValues];
        [self.headerView setMenuIcons];
        self.headerView.lblTitle.text = [AAAppGlobals sharedInstance].retailer.retailerName;
    } andFailure:^(NSString *error) {
        
    }];
    
    [self.banner startTimer];
    
    float centerX = self.view.center.x;
    CGRect frame = self.lblPoweredby.frame;
    frame.origin.x = centerX-frame.size.width;
    self.lblPoweredby.frame = frame;
    
    frame = self.imgPowerbyLogo.frame;
    frame.origin.x = centerX;
    self.imgPowerbyLogo.frame = frame;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(![self.moviePlayerController isFullscreen])
    {
        [[self.viewMediaContainer subviews ] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_LOCATION_UPDATED object:nil];
    [self.banner stopTime];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

-(void)adjustContainerHeights
{
    CGFloat containerHeight = (self.view.frame.size.height - 2*PADDING)/2;

    CGRect frameRetailerView = self.viewMediaContainer.frame;
    frameRetailerView.size.height = [self getMeadiHeight];
      CGRect frameMapContainer = self.viewMapContainer.frame;
    frameMapContainer.size.height = containerHeight;
    frameMapContainer.origin.y = frameRetailerView.size.height + 2*PADDING;
    self.viewMediaContainer.frame = frameRetailerView;
    self.viewMapContainer.frame = frameMapContainer;
    
    float billBoardHeight = 0;
    
    float availableheight = self.vwpoweredBy.frame.origin.y - (self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height);
    billBoardHeight = availableheight/2;
    
    CGRect billboardframe1 = self.billBoardOne.frame;
    billboardframe1.origin.y = self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height;
    billboardframe1.size.height = billBoardHeight;
    self.billBoardOne.frame = billboardframe1;
    
    CGRect billboardframe2 = self.billBoardTwo.frame;
    billboardframe2.origin.y = billboardframe1.origin.y + billboardframe1.size.height;
    billboardframe2.size.height = billBoardHeight;
    self.billBoardTwo.frame = billboardframe2;
    self.billBoardImageWidth = [self getBillBoardImageWidth:billBoardHeight-30];
    [self.billBoardOne reloadData];
    [self.billBoardTwo reloadData];
    if ([self.arrBillBoardTwo count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.arrBillBoardTwo count]-1 inSection:0];
        [self.billBoardTwo scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
    
    
    
}

-(void)addRetailerViews
{
//    if([[AAAppGlobals sharedInstance].retailer.retailerFileType isEqualToString:RETAILER_FILE_TYPE_IMAGE])
//    {
//        
//        // NSURL *url = [NSURL URLWithString:stringURL];
//        //NSString *path = [url path];
//        //NSString *extension = [path pathExtension];
//        NSLog(@"image frame %@",NSStringFromCGRect(self.viewMediaContainer.frame));
//        UIView* imgViewRetailerImage = [AAHomePageHelper getImageViewWithFrame:CGRectMake(0, 0, self.viewMediaContainer.frame.size.width, self.viewMediaContainer.frame.size.height) wtihImageUrl:[NSURL URLWithString:/*@"http://erian.ntu.edu.sg/Conference_Workshop/OREC%202013/PublishingImages/MarinaBaySands.jpg"]];*//*@"http://i.imgur.com/Ac7TGxF.gif"]];*/[AAAppGlobals sharedInstance].retailer.retailerFile ]];
//        [imgViewRetailerImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
//        imgViewRetailerImage.contentMode = UIViewContentModeScaleToFill;
//        [self.viewMediaContainer addSubview:imgViewRetailerImage];
//        
//    }
//    else if( [[AAAppGlobals sharedInstance].retailer.retailerFileType isEqualToString:RETAILER_FILE_TYPE_VIDEO])
//    {
//       
//        
//        NSURL *url = [NSURL URLWithString:[AAAppGlobals sharedInstance].retailer.retailerFile];//path for vid
//        
//       self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
//        //[self.moviePlayerController setScalingMode:MPMovieScalingModeAspectFill];
//        self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
//        self.moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
//        self.moviePlayerController.contentURL = url;
//        [self.moviePlayerController.view setFrame:self.viewMediaContainer.bounds];
//         self.moviePlayerController.shouldAutoplay = NO;
//        self.moviePlayerController.fullscreen = YES;
//        [self.moviePlayerController prepareToPlay];
//        [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
//        [self.viewMediaContainer addSubview:self.moviePlayerController.view];
//        [AAStyleHelper addLightShadowToView:self.moviePlayerController.view];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideControl)
//                                                     name:MPMoviePlayerLoadStateDidChangeNotification
//                                                   object:self.moviePlayerController];
//        
//       
//        
//      
//        
//    }
    
    AAMediaItem *mediaItem = [[AAMediaItem alloc] init];
    mediaItem.mediaUrl = [AAAppGlobals sharedInstance].retailer.retailerFile;
    mediaItem.mediaType = [AAAppGlobals sharedInstance].retailer.retailerFileType;
    
    AAMediaItem *mediaItem2 = [[AAMediaItem alloc] init];
    mediaItem2.mediaUrl = @"http://appwizlive.com/uploads/products/1_1417251956_li6.PNG";
    mediaItem2.mediaType = RETAILER_FILE_TYPE_IMAGE;
    
    self.banner = [[AABannerView alloc] initWithFrame:self.viewMediaContainer.bounds];
    self.banner.bannerItems = [[NSArray alloc] initWithArray:[AAAppGlobals sharedInstance].retailer.home_imgArray];
    [self.banner populateItems];
    [self.viewMediaContainer addSubview:self.banner];
    
//    if (![[AAAppGlobals sharedInstance].retailer.companyLogo isEqualToString:@""]) {
//        CGFloat maxHiehtforLogo = (self.btnLocateUs.frame.origin.y -5)-(self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height + 10);
//        maxHiehtforLogo -= 0;
//
//        NSLog(@"maxHiehtforLogo = %f",maxHiehtforLogo);
//        NSString *compLogoName = [[AAAppGlobals sharedInstance].retailer.companyLogo lastPathComponent];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *path = [paths objectAtIndex:0];
//        path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
//        NSFileManager* filemanager = [NSFileManager defaultManager];
//        UIImage *logoImage;
//        if ([filemanager fileExistsAtPath:path]) {
//            logoImage = [UIImage imageWithContentsOfFile:path];
//            [self updateCompLogoWithImage:logoImage];
//        }else{
//            [self startImageDownload:[AAAppGlobals sharedInstance].retailer.companyLogo forIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        }
//        
//    }
    
//    if ([[AAAppGlobals sharedInstance].retailer.backdropType isEqualToString:@"Image"]) {
//        NSString *compLogoName = [[AAAppGlobals sharedInstance].retailer.backdropFile lastPathComponent];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *path = [paths objectAtIndex:0];
//        path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
//        NSFileManager* filemanager = [NSFileManager defaultManager];
//        UIImage *logoImage;
//        if ([filemanager fileExistsAtPath:path]) {
//            logoImage = [UIImage imageWithContentsOfFile:path];
//            self.imgBackdropImage.image = logoImage;
//        }else{
//            [self startImageDownload:[AAAppGlobals sharedInstance].retailer.backdropFile forIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//        }
//        
//        self.imgBackdropImage.hidden = FALSE;
//        NSLog(@"backdrop = %@",NSStringFromCGRect(self.imgBackdropImage.frame));
//    }else{
//        self.imgBackdropImage.hidden = TRUE;
//        unsigned
//        int color1 = [AAUtils getHexFromHexString:[AAAppGlobals sharedInstance].retailer.backdropColor1];
//        UIColor *backdropcolo1 = UIColorFromRGB(color1);
//        
//        unsigned
//        int color2 = [AAUtils getHexFromHexString:[AAAppGlobals sharedInstance].retailer.backdropColor2];
//        UIColor *backdropcolo2 = UIColorFromRGB(color2);
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.vwBackDropContainerView.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[backdropcolo1 CGColor], (id)[backdropcolo2 CGColor], nil];
//        [self.vwBackDropContainerView.layer insertSublayer:gradient atIndex:0];
//    }
   // [self.btnLocateUs setBackgroundColor:[AAColor sharedInstance].retailerThemeBackgroundColor];
}
-(CGSize)calulateSize:(UIImage*)image withMaxHieght:(float)height{
    CGSize requiredSize = CGSizeZero;
    if (image == nil) {
        return requiredSize;
    }
    if (image.size.height <= height) {
        height = image.size.height;
    }
    if (height>100) {
        height = 100;
    }
    float imageWidth = image.size.width;
    float imageHight = image.size.height;
    
    float requiredWidth = height*imageWidth/imageHight;
    
    float requiredHeight = height;
    if (requiredWidth>260) {
        requiredWidth = 260;
        requiredHeight = imageHight*requiredWidth/imageWidth;
    }
    
    requiredSize = CGSizeMake(requiredWidth,requiredHeight);
    return requiredSize;
    
    
}

-(void)updateRetailerMaps
{
    
     [self.mvStoreLocations removeAllMarkers];
     [self updateUserLocation];
    [AAHomePageHelper updateStoresMap:self.mvStoreLocations];
    //[self.mvStoreLocations.mapView setMyLocationEnabled:YES];
    [self.mvStoreLocations fitMapToMarkers];
  
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    AARetailerStoreMapViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AARetailerStoreMapViewController"];
    
    if(marker == self.mvStoreLocations.markerCurrentLocation)
    {
        vcRetailerStore.currentLocationMarker = marker.copy;
    }
    else
    {
    vcRetailerStore.selectedRetailerMarker = marker.copy;
    }
    
    [self.navigationController pushViewController:vcRetailerStore animated:YES];
    return  YES;
}


- (void) mapView: (GMSMapView *) mapView  idleAtCameraPosition: (GMSCameraPosition *)   position
{
    if((position.target.latitude == [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.latitude) && (position.target.longitude == [AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate.longitude))
    {
       
      

    }
}

-(void)hideControl
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self     name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:self.moviePlayerController];
    [self.moviePlayerController setControlStyle:MPMovieControlStyleEmbedded];

}

- (void)updateUserLocation
{
    if(!self.mvStoreLocations.markerCurrentLocation.map)
    {
        if([AAAppGlobals sharedInstance].locationHandler.currentLocation)
        {
        [self.mvStoreLocations addCurrentLocationMarkerWithCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate withTitle:@"My Location" andIcon:[UIImage imageNamed:@"current_location_marker"]];
        }
        
    }
    else
    {
        if([AAAppGlobals sharedInstance].locationHandler.currentLocation)
        {
        [self.mvStoreLocations updateCurrentLocationMarkerCoordinate:[AAAppGlobals sharedInstance].locationHandler.currentLocation.coordinate];
        }
    }
    [self.mvStoreLocations fitMapToMarkers];
}

-(void)locationUpdated:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
  
        [self updateUserLocation];
    
    });
}
- (IBAction)btnZoomMapTapped:(id)sender {
    AARetailerStoreMapViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AARetailerStoreMapViewController"];
        
    [self.navigationController pushViewController:vcRetailerStore animated:YES];
}

- (IBAction)btnPoweredByTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AAAppGlobals sharedInstance].retailer.retailerPoweredBy]];
}
- (IBAction)btnLocatUsTapped:(id)sender {
    AARetailerStoreMapViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AARetailerStoreMapViewController"];
    
    [self.navigationController pushViewController:vcRetailerStore animated:YES];
}

- (IBAction)tgrMyLocationTap:(id)sender {
    AARetailerStoreMapViewController* vcRetailerStore = [self.storyboard instantiateViewControllerWithIdentifier:@"AARetailerStoreMapViewController"];
    
    
    vcRetailerStore.currentLocationMarker = self.mvStoreLocations.markerCurrentLocation.copy;
    
    [self.navigationController pushViewController:vcRetailerStore animated:YES];
}

#pragma mark - Tap gesture recognizer callbacks
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGRect frame =  CGRectMake(self.viewMapContainer.frame.size.width - 40 - 15, self.viewMapContainer.frame.size.height-40-10, 40, 40);
    
    CGPoint touchPoint = [touch locationInView:self.viewMapContainer];
    if(CGRectContainsPoint(frame, touchPoint))
    {
        return YES;
    }
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)updateCompLogoWithImage:(UIImage*)logoImage{
    CGFloat maxHiehtforLogo = (self.btnLocateUs.frame.origin.y -5)-(self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height + 5);
    CGFloat centerY = (self.btnLocateUs.frame.origin.y + 5) -(self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height)  ;
   // maxHiehtforLogo -= 20;
    CGSize imagesize = logoImage.size;
    CGSize requiredSize ;
    if (imagesize.width == imagesize.height) {
        requiredSize = [self calulateSize:logoImage withMaxHieght:maxHiehtforLogo];
    }else{
        if (imagesize.height> maxHiehtforLogo) {
            imagesize.height = maxHiehtforLogo;
        }
        if (imagesize.width > 300) {
            imagesize.width = 300;
        }
        requiredSize = [self calulateSize:logoImage withMaxHieght:maxHiehtforLogo];
    }
    
    //        if (requiredSize.height<100) {
    //            requiredSize.height = 100;
    //        }
    CGRect frame  = self.imgCompanyLogo.frame;
    
    frame.size = requiredSize;
    if (frame.size.height > maxHiehtforLogo) {
        frame.size.height = maxHiehtforLogo;
    }
    
    //frame.origin.y = self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height + 30;
    frame.origin.x = self.view.center.x - frame.size.width/2;
    self.imgCompanyLogo.frame = frame;
    CGPoint center = self.imgCompanyLogo.center;
    center.y = self.viewMediaContainer.frame.origin.y + self.viewMediaContainer.frame.size.height + centerY/2;
    self.imgCompanyLogo.center =  center;
    self.imgCompanyLogo.image = logoImage;
    //self.imgCompanyLogo.backgroundColor=[UIColor greenColor];
    NSLog(@"Logo size = %@",NSStringFromCGRect(self.imgCompanyLogo.frame));
}
//initiate download of image for a row
- (void)startImageDownload:(NSString *)imageUrl forIndexPath:(NSIndexPath *)indexPath {
    ImageDownloader *imageLoader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageLoader == nil) {
        imageLoader = [[ImageDownloader alloc] init];
        imageLoader.indexPathCurrentRow = indexPath;
        imageLoader.delegate = self;
        [imageDownloadsInProgress setObject:imageLoader forKey:indexPath];
		[imageLoader startImageDownload:imageUrl];
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDownloadComplete:(UIImage*)prodImage forIndex:(NSIndexPath*)indexPath{
    
	ImageDownloader *imageLoader = [imageDownloadsInProgress objectForKey:indexPath];
	
	if (imageLoader != nil) {
        if(indexPath.row == 1){
			
            NSString *compLogoName = [[AAAppGlobals sharedInstance].retailer.companyLogo lastPathComponent];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
            NSFileManager* filemanager = [NSFileManager defaultManager];
            if ([filemanager fileExistsAtPath:path]) {
                
            }else{
                NSData *imageData = UIImagePNGRepresentation(prodImage);
                [filemanager createFileAtPath:path contents:imageData attributes:nil];
            }
            
            [self updateCompLogoWithImage:prodImage];
        }else{
            NSString *compLogoName = [[AAAppGlobals sharedInstance].retailer.backdropFile lastPathComponent];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
            NSFileManager* filemanager = [NSFileManager defaultManager];
            if ([filemanager fileExistsAtPath:path]) {
                
            }else{
                NSData *imageData = UIImagePNGRepresentation(prodImage);
                [filemanager createFileAtPath:path contents:imageData attributes:nil];
            }
            self.imgBackdropImage.image = prodImage;
        }
    }
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}
-(CGFloat)getMeadiHeight{
    CGFloat height = 0;
    CGFloat width = self.view.frame.size.width;
    height = width/1.9f;
    return height;
}

-(CGFloat)getBillBoardImageWidth:(float)height{
    CGFloat width ;
    width = height*1.65f;
    return width;
}

-(void)populateBillBoardItem{
    [self.arrBillBoardOne removeAllObjects];
    [self.arrBillBoardTwo removeAllObjects];
    for (int i = 0; i<5 && i< [[AAAppGlobals sharedInstance].retailer.products count]; i++) {
        [self.arrBillBoardOne addObject:[[AAAppGlobals sharedInstance].retailer.products objectAtIndex:i]];
    }
    for (int i = 5; i< [[AAAppGlobals sharedInstance].retailer.products count]; i++) {
        [self.arrBillBoardTwo addObject:[[AAAppGlobals sharedInstance].retailer.products objectAtIndex:i]];
    }
    [self.billBoardOne reloadData];
    [self.billBoardTwo reloadData];
   
    if ([self.arrBillBoardTwo count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.arrBillBoardTwo count]-1 inSection:0];
         [self.billBoardTwo scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
   
}
#pragma mark - 
#pragma mark CollectionView Deleagte
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    if(collectionView.tag == 100){
        return  [self.arrBillBoardOne count];
    }else{
        return  [self.arrBillBoardTwo count];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier1 = @"AABillBoardCell1";
    static NSString *cellIdentifier2 = @"AABillBoardCell2";
    AABillBoardCell *cell;
    AAEShopProduct *product;
    if(collectionView.tag == 100){
        cell = (AABillBoardCell*)[collectionView
                                  dequeueReusableCellWithReuseIdentifier:cellIdentifier1
                                  forIndexPath:indexPath];
        product = [self.arrBillBoardOne objectAtIndex:indexPath.row];
    }else{
        cell = (AABillBoardCell*)[collectionView
                                  dequeueReusableCellWithReuseIdentifier:cellIdentifier2
                                  forIndexPath:indexPath];
        product = [self.arrBillBoardTwo objectAtIndex:indexPath.row];
    }
    cell.lblProdname.text = product.productShortDescription;
    cell.lblProdname.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:SHORTDESC_FONTSIZE];
    
    [cell.imgProd setImageWithURL:[NSURL URLWithString:product.product_img]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(self.billBoardImageWidth, self.billBoardOne.frame.size.height);
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AAEShopProduct *product;
    if ([collectionView tag]== 100) {
       product = [self.arrBillBoardOne objectAtIndex:indexPath.row];
    }else{
        product = [self.arrBillBoardTwo objectAtIndex:indexPath.row];
    }
    
    AAProductInformationViewController*  vcProductInformation = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProductInformationViewController"];
    vcProductInformation.product = product;
    [self.navigationController pushViewController:vcProductInformation animated:YES];
}

-(void)getCurrencyCoversionValues{
    NSMutableString *link = [NSMutableString stringWithFormat: @"http://finance.yahoo.com/d/quotes.csv?e=.json&f=c4l1&s="];
    NSString *default_curency = [AAAppGlobals sharedInstance].retailer.defaultCurrency;
    NSArray *allCurrencies = [[AAAppGlobals sharedInstance].retailer.allowedCurrencies componentsSeparatedByString:@","];
    for (int i = 0; i < [allCurrencies count]; i++) {
        NSString *curecny = [allCurrencies objectAtIndex:i];
//        link = [NSString stringWithFormat:@"%@%@%@=X,",link , default_curency , curecny];
        if ([curecny length]>0) {
            [link appendFormat:@"%@%@=X,",default_curency,curecny];
        }
        
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        NSData *date = [NSData dataWithContentsOfURL:[NSURL URLWithString:link]];
        NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:link]
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
        NSLog(@"Str = %@",str);
        if (str == nil || [str length] == 0) {
            return ;
        }
        NSArray *currencyComp = [str componentsSeparatedByString:@"\n"];
        [[AAAppGlobals sharedInstance].currecyDict removeAllObjects];
        for (int i = 0; i < [currencyComp count]; i++) {
            NSString *strComp = [currencyComp objectAtIndex:i];
            if (strComp != nil) {
                NSArray *arr =  [strComp componentsSeparatedByString:@","];
                if ([arr count]>= 2) {
                    NSString *key = [arr objectAtIndex:0];
                    key = [key stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSString *value = [arr objectAtIndex:1];
                    [[AAAppGlobals sharedInstance].currecyDict setObject:value forKey:key];
                }
            }
        }
        
    });
}
@end

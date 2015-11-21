//
//  AARetailerStoreMapViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 22/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AAChildNavigationControllerDelegate.h"
#import "AAHomePageHelper.h"
#import "AAStoreInfoWindow.h"
@interface AARetailerStoreMapViewController : AAChildBaseViewController <GMSMapViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)  AAMapView* mvRetailerStores;
@property (weak, nonatomic) IBOutlet UIView *viewStoreMapContainer;
@property (nonatomic,strong) GMSMarker* selectedRetailerMarker;
@property (nonatomic,strong) GMSMarker* currentLocationMarker;
@property (nonatomic,strong) UITapGestureRecognizer* phoneNumberTap;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (nonatomic,strong) CLLocationManager* locationManager;
@end
